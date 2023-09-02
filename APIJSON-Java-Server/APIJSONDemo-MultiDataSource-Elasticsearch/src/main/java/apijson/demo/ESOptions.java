package apijson.demo;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpHost;
import org.apache.http.impl.nio.client.HttpAsyncClientBuilder;
import org.elasticsearch.action.bulk.BulkItemResponse;
import org.elasticsearch.action.bulk.BulkRequestBuilder;
import org.elasticsearch.action.bulk.BulkResponse;
import org.elasticsearch.action.index.IndexRequestBuilder;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestClientBuilder;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.TransportAddress;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.index.reindex.BulkByScrollResponse;
import org.elasticsearch.index.reindex.UpdateByQueryRequest;
import org.elasticsearch.script.Script;
import org.elasticsearch.transport.client.PreBuiltTransportClient;
import org.elasticsearch.xcontent.XContentBuilder;
import org.elasticsearch.xcontent.XContentFactory;
import org.nlpcn.es4sql.SearchDao;
import org.nlpcn.es4sql.domain.Where;
import org.nlpcn.es4sql.parse.SqlParser;
import org.nlpcn.es4sql.parse.WhereParser;
import org.nlpcn.es4sql.query.ESActionFactory;
import org.nlpcn.es4sql.query.SqlElasticRequestBuilder;
import org.nlpcn.es4sql.query.maker.QueryMaker;

import com.alibaba.druid.sql.ast.statement.SQLDeleteStatement;
import com.alibaba.druid.sql.parser.SQLStatementParser;

import apijson.StringUtil;
import apijson.orm.SQLConfig;
import lombok.extern.log4j.Log4j2;

@Log4j2
public class ESOptions {

	public TransportClient getTransportClient(String dataSource) {
		try {
			String clusterName = DynamicJdbcDataSource.getDetail(dataSource).getClusterName();
			Settings settings = Settings.builder().put("cluster.name", clusterName).build();
//			Settings settings = Settings.builder()
//                    .put("cluster.name", clusterName)
//                    // 设置xpack权限用户
//                    .put("xpack.security.user", userName + ":" + password)
//                    .build();
			TransportAddress[] transportAddresss = DynamicJdbcDataSource.getDetail(dataSource).getTransportAddresss();
			TransportClient client = new PreBuiltTransportClient(settings);
			client.addTransportAddresses(transportAddresss); // 通讯端口 而不是服务端口
			return client;
		} catch (Exception e) {
			e.printStackTrace();
			throw new IllegalArgumentException("动态数据源配置错误 " + dataSource);
		}
	}

	private RestHighLevelClient getRestHighLevelClient(String dataSource) {
		try {
			HttpHost[] httpHosts = DynamicJdbcDataSource.getDetail(dataSource).getHttpHosts();
			// final CredentialsProvider credentialsProvider = new
			// BasicCredentialsProvider();
			// credentialsProvider.setCredentials(AuthScope.ANY, new
			// UsernamePasswordCredentials("", ""));
			RestClientBuilder builder = RestClient.builder(httpHosts).setHttpClientConfigCallback(new RestClientBuilder.HttpClientConfigCallback() {
				@Override
				public HttpAsyncClientBuilder customizeHttpClient(HttpAsyncClientBuilder httpClientBuilder) {
					// return httpClientBuilder.setDefaultCredentialsProvider(credentialsProvider);
					return httpClientBuilder;
				}
			});
			return new RestHighLevelClient(builder);
		} catch (Exception e) {
			e.printStackTrace();
			throw new IllegalArgumentException("动态数据源配置错误 " + dataSource);
		}
	}

	/***
	 * sql语句解析为dsl
	 * 支持 查询、删除, 不支持 新增、修改.
	 * 可以将sql语句转换一下
	 * @param dataSource
	 * @param sql
	 * @return
	 * @throws Exception
	 */
	private String explain(String dataSource, String sql) throws Exception {
		// 获取client
		TransportClient client = getTransportClient(dataSource);
		SearchDao searchDao = new SearchDao(client);
		SqlElasticRequestBuilder requestBuilder = searchDao.explain(sql).explain();
		return requestBuilder.explain();
	}
	
	@SuppressWarnings("deprecation")
	public int updateBySql(SQLConfig config, String dataSource, String sql) {
		// 获取client
		RestHighLevelClient restHighLevelClient = getRestHighLevelClient(dataSource);
		try {
			sql = StringUtil.isEmpty(sql) ? config.getSQL(false) : sql;
			String sqlTable = config.getSQLTable(); // 截取
			int index = sqlTable.indexOf("/");
			String indexName = null;
			String type = null;
			if (index > 0) {
				indexName = sqlTable.substring(0, index);
				type = sqlTable.substring(index + 1);
			} else {
				indexName = sqlTable;
			}

			index = sql.indexOf("WHERE");
			UpdateByQueryRequest updateByQuery = new UpdateByQueryRequest(indexName);
			if (index > 0) {
				String whereSql = sql.substring(index);
				index = whereSql.indexOf("RLIKE");
				if(index > 0) {
					whereSql = whereSql.replace("RLIKE", "=");
				}
				String tmpSearchSql = "DELETE from " + indexName + " " + whereSql;
				// 获取sql 转换为 elasticSearch api 某一部分,比如where查询等等
				SQLStatementParser parser = ESActionFactory.createSqlStatementParser(tmpSearchSql);
				SQLDeleteStatement deleteStatement = parser.parseDeleteStatement();
				WhereParser whereParser = new WhereParser(new SqlParser(), deleteStatement);
				Where where = whereParser.findWhere();
				if (where != null) {
					QueryBuilder whereQuery = QueryMaker.explan(where);
					updateByQuery.setQuery(whereQuery);
				} else {
					updateByQuery.setQuery(QueryBuilders.matchAllQuery());
				}
			}
			if(StringUtil.isNotEmpty(type)) {
				updateByQuery.setDocTypes(type);
			}
			// 设置版本冲突时继续执行
			updateByQuery.setConflicts("proceed");
			// 设置更新完成后刷新索引 ps很重要如果不加可能数据不会实时刷新
			updateByQuery.setRefresh(true);

			StringBuffer sb = new StringBuffer();
			Map<String, Object> content = config.getContent();
			for (String column : content.keySet()) {
				Object value = content.get(column);
				// 最后多一个;不会影响,elasticsearch能正确解析
				if(StringUtil.isNumer(value.toString())) {
					sb.append("ctx._source['" + column + "'] = " + value + ";");
				}else {
					sb.append("ctx._source['" + column + "'] = '" + value + "';");
				}
			}
			updateByQuery.setScript(new Script(sb.toString()));
			BulkByScrollResponse response = restHighLevelClient.updateByQuery(updateByQuery, RequestOptions.DEFAULT);
			return response.getStatus().getUpdated() > 0 ? (int)response.getStatus().getUpdated() : 0;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (restHighLevelClient != null) {
				try {
					restHighLevelClient.close();
				} catch (IOException e) {
				}
			}
		}
		return 0;
	}

	/***
	 * sql语句转换为dsl执行
	 * 
	 * @param config
	 * @param dataSource
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public int deleteBySql(SQLConfig config, String dataSource, String sql) {
		TransportClient client = getTransportClient(dataSource);
		try {
			sql = StringUtil.isEmpty(sql) ? config.getSQL(false) : sql;
			String sqlTable = config.getSQLTable(); // 截取
			int index = sqlTable.indexOf("/");
			String indexName = null;
			if (index > 0) {
				indexName = sqlTable.substring(0, index);
			} else {
				indexName = sqlTable;
			}

			SearchDao searchDao = new SearchDao(client);
			client.admin().indices().prepareRefresh(indexName).get();
			SqlElasticRequestBuilder requestBuilder = searchDao.explain(sql).explain();
			log.info("sql explain: {}", requestBuilder.explain()); // 线上去掉
			BulkByScrollResponse response = (BulkByScrollResponse) requestBuilder.get();
			if (response.getStatus().getDeleted() > 0) {
				searchDao.getClient().admin().indices().prepareRefresh(indexName).get();
				return (int)response.getStatus().getDeleted();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (client != null) {
				client.close();
			}
		}
		return 0;
	}

	/**
	 * 支持批量插入,apijson框架目前还未放开批量操作
	 * @param config
	 * @param dataSource
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public int insert(SQLConfig config, String dataSource) {
		TransportClient client = getTransportClient(dataSource);
		StringBuffer errorMsg = new StringBuffer();
		try {
			BulkRequestBuilder builder = client.prepareBulk();
			String sqlTable = config.getSQLTable(); // 截取
			int index = sqlTable.indexOf("/");
			String indexName = null;
			String type = null;
			if (index > 0) {
				indexName = sqlTable.substring(0, index);
				type = sqlTable.substring(index + 1);
			} else {
				indexName = sqlTable;
			}
			// 支持批量插入[[],[]]
			List<List<Object>> valuess = config.getValues();
			List<String> column = config.getColumn();
			for (int i = 0; i < valuess.size(); i++) {
				List<Object> values = valuess.get(i);
				XContentBuilder xContentBuilder = XContentFactory.jsonBuilder().startObject();
				for (int j = 0; j < values.size(); j++) {
					xContentBuilder.field(column.get(j), values.get(j));
				}
				if (values.size() > 0) {
					xContentBuilder.endObject();
					IndexRequestBuilder request = client.prepareIndex(indexName, type, config.getId().toString()).setSource(xContentBuilder);
					builder.add(request);
				}
			}
			BulkResponse response = builder.get();
			if (response.hasFailures()) {
				for (BulkItemResponse br : response.getItems()) {
					errorMsg.append(br.getId() + ";" + br.getFailureMessage() + "\n");
				}
				log.error("数据源 {}, 插入操作失败:{}", dataSource, errorMsg);
			} else {
				// 立刻刷新索引
				client.admin().indices().prepareRefresh(indexName).get();
				return 1;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (client != null) {
				client.close();
			}
		}

		if (errorMsg.length() > 0) {
			throw new IllegalArgumentException("数据源 " + dataSource + ", 插入操作失败 ! " + errorMsg);
		}
		return 0;
	}

}
