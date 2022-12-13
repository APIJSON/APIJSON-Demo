package apijson.demo;

import static com.alibaba.druid.pool.DruidDataSourceFactory.PROP_CONNECTIONPROPERTIES;
import static com.alibaba.druid.pool.DruidDataSourceFactory.PROP_URL;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Properties;

import javax.sql.DataSource;

import org.apache.http.HttpHost;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.nio.client.HttpAsyncClientBuilder;
import org.elasticsearch.action.admin.cluster.node.info.NodesInfoResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestClientBuilder;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.TransportAddress;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.index.query.WrapperQueryBuilder;
import org.elasticsearch.index.reindex.BulkByScrollResponse;
import org.elasticsearch.index.reindex.DeleteByQueryAction;
import org.elasticsearch.index.reindex.DeleteByQueryRequestBuilder;
import org.elasticsearch.index.reindex.UpdateByQueryRequest;
import org.elasticsearch.script.Script;
import org.elasticsearch.transport.client.PreBuiltTransportClient;
import org.elasticsearch.xpack.client.PreBuiltXPackTransportClient;
import org.junit.Test;
import org.nlpcn.es4sql.SearchDao;
import org.nlpcn.es4sql.domain.Where;
import org.nlpcn.es4sql.exception.SqlParseException;
import org.nlpcn.es4sql.parse.SqlParser;
import org.nlpcn.es4sql.parse.WhereParser;
import org.nlpcn.es4sql.query.ESActionFactory;
import org.nlpcn.es4sql.query.SqlElasticRequestBuilder;
import org.nlpcn.es4sql.query.maker.QueryMaker;

import com.alibaba.druid.pool.DruidDataSource;
import com.alibaba.druid.pool.ElasticSearchDruidDataSourceFactory;
import com.alibaba.druid.sql.ast.statement.SQLDeleteStatement;
import com.alibaba.druid.sql.parser.SQLStatementParser;
import com.alibaba.fastjson.JSONObject;

import apijson.StringUtil;
import lombok.extern.slf4j.Slf4j;

/***
 * 
 * @author xy
 *
 */
@Slf4j
public class ElasticSearchSqlTest {

	public static void main(String[] args) throws Exception {
		Properties properties = new Properties();
		properties.put(PROP_URL, "jdbc:elasticsearch://47.108.49.213:9302");
		properties.put(PROP_CONNECTIONPROPERTIES, "client.transport.ignore_cluster_name=true");
		DruidDataSource dds = (DruidDataSource) ElasticSearchDruidDataSourceFactory.createDataSource(properties);
		Connection connection = dds.getConnection();
		// SELECT count(*) as count FROM es_blog
		PreparedStatement ps = connection.prepareStatement("SELECT count, count(*) as total FROM es_blog/dd group by count");
		ResultSet resultSet = ps.executeQuery();
		while (resultSet.next()) {
			System.out.println(resultSet.getObject("count") + ";" + resultSet.getObject("total"));
		}

		ps.close();
		connection.close();
		dds.close();
	}

	/**
	 * 将sql语句转换未dsl语句
	 * 
	 * @throws Exception
	 * @throws SqlParseException
	 */
	@Test
	public void sqlExplainTest() throws Exception, SqlParseException {
		String sql = "SELECT count, count(*) as total FROM es_blog group by count";
		String explain = explain(sql);
		log.info("explain:{}", explain);
	}

	private String explain(String sql) throws Exception {
		// 获取client
		Settings settings = Settings.builder().put("cluster.name", "docker-cluster").build();
		TransportClient transportClient = new PreBuiltTransportClient(settings);
		transportClient.addTransportAddress(getTransportAddress());
		SearchDao searchDao = new SearchDao(transportClient);
		SqlElasticRequestBuilder requestBuilder = searchDao.explain(sql).explain();
		return requestBuilder.explain();
	}

	String TEST_INDEX = "es_blog";

	/***
	 * 非jdbc方式 实现delete
	 * 
	 * @throws Exception
	 * @throws SqlParseException
	 */
	@Test
	public void deleteTest() throws Exception, SqlParseException {
		// String deleteStatement = "delete from " + TEST_INDEX +" where title.keyword =
		// \"Linux安装\"";
		String deleteStatement = "DELETE FROM es_blog WHERE id IN ('c7890a84-1b3c-464d-9c40-9d2cf5a1d292','322323') ";
		// String deleteStatement = "DELETE FROM es_blog WHERE title.keyword = 'test-3'
		// and count = 3";
//		String deleteStatement = "DELETE FROM es_blog WHERE title.keyword like 'test%'";
		// 获取client
		Settings settings = Settings.builder().put("client.transport.ignore_cluster_name", true).build();
		TransportClient client = new PreBuiltTransportClient(settings).addTransportAddress(getTransportAddress());
		NodesInfoResponse nodeInfos = client.admin().cluster().prepareNodesInfo().get();
		String clusterName = nodeInfos.getClusterName().value();
		log.info(String.format("Found cluster... cluster name: %s", clusterName));
		SearchDao searchDao = new SearchDao(client);
		client.admin().indices().prepareRefresh(TEST_INDEX + "*").get();

		// searchDao.explain(deleteStatement).explain().get();

		SqlElasticRequestBuilder requestBuilder = searchDao.explain(deleteStatement).explain();
		log.info("sql explain: {}", requestBuilder.explain());
		BulkByScrollResponse reponse = (BulkByScrollResponse) requestBuilder.get();
		searchDao.getClient().admin().indices().prepareRefresh(TEST_INDEX).get();
	}

	protected static TransportAddress getTransportAddress() throws UnknownHostException {
		String host = "47.108.49.213";
		String port = "9301";
		return new TransportAddress(InetAddress.getByName(host), Integer.parseInt(port));
	}

	protected static TransportAddress getHttpTransportAddress() throws UnknownHostException {
		String host = "47.108.49.213";
		String port = "9201";
		return new TransportAddress(InetAddress.getByName(host), Integer.parseInt(port));
	}

	
	@Test
	public void delete() throws Exception {
		deleteQuery(TEST_INDEX, null);
	}

	public static void deleteQuery(String indexName, String typeName) throws Exception {
		// 获取client
//		Settings settings = Settings.builder().put("cluster.name", "docker-cluster").build();
//		TransportClient client = new PreBuiltTransportClient(settings);
		Settings settings = Settings.builder().put("cluster.name", "docker-cluster")
				// 设置xpack权限用户
				.put("xpack.security.user", "elastic:ztzh@smart666")
                .put("xpack.security.transport.ssl.enabled",false)//设置xpack权限用户
				.put("client.transport.sniff", true)
				.build();
		TransportClient client = new PreBuiltXPackTransportClient(settings);
		client.addTransportAddress(getTransportAddress());
		DeleteByQueryRequestBuilder deleteQueryBuilder = new DeleteByQueryRequestBuilder(client, DeleteByQueryAction.INSTANCE);
		deleteQueryBuilder.filter(QueryBuilders.matchQuery("title.keyword", "u-test-1")).source(indexName);
		if (typeName != null) {
			deleteQueryBuilder.request().getSearchRequest().types(typeName);
		}
		deleteQueryBuilder.get();
		// deleteQueryBuilder.filter(QueryBuilders.matchAllQuery()).get();
		System.out.println(String.format("Deleted index %s and type %s", indexName, typeName));
	}

	private RestHighLevelClient buildClient() {
		final CredentialsProvider credentialsProvider = new BasicCredentialsProvider();
		credentialsProvider.setCredentials(AuthScope.ANY, new UsernamePasswordCredentials("elastic", "ztzh@smart666"));
		RestClientBuilder builder = RestClient.builder(new HttpHost("47.108.49.213", 9201)).setHttpClientConfigCallback(new RestClientBuilder.HttpClientConfigCallback() {
			@Override
			public HttpAsyncClientBuilder customizeHttpClient(HttpAsyncClientBuilder httpClientBuilder) {
				return httpClientBuilder.setDefaultCredentialsProvider(credentialsProvider);
//				return httpClientBuilder;
			}
		});

		RestHighLevelClient restHighLevelClient = new RestHighLevelClient(builder);
		return restHighLevelClient;
	}

	/***
	 * 沿用 elastic-sql实现
	 * 
	 * @throws Exception
	 */
	@Test
	public void update() throws Exception {
		// 获取client
		RestHighLevelClient restHighLevelClient = buildClient();
		String updateSql = "UPDATE  es_blog set title = 'u-test-2' WHERE id = '82f812fb-72e2-491e-865a-1bfbd251e5cd'";
		int index = updateSql.indexOf("WHERE");
		if (index > 0) {
			String tmpSearchSql = "DELETE from es_blog " + updateSql.substring(index);
			UpdateByQueryRequest request = new UpdateByQueryRequest("es_blog");
			SQLStatementParser parser = ESActionFactory.createSqlStatementParser(tmpSearchSql);
			SQLDeleteStatement deleteStatement = parser.parseDeleteStatement();
			WhereParser whereParser = new WhereParser(new SqlParser(), deleteStatement);
			Where where = whereParser.findWhere();
			if (where != null) {
				QueryBuilder whereQuery = QueryMaker.explan(where);
				request.setQuery(whereQuery);
			} else {
				request.setQuery(QueryBuilders.matchAllQuery());
			}
			request.setScript(new Script("ctx._source['title'] = 'test-2'"));
			restHighLevelClient.updateByQuery(request, RequestOptions.DEFAULT);
			restHighLevelClient.close();
		}
	}

	@Test
	public void testClusterName() throws Exception {
		Settings settings = Settings.builder().put("client.transport.ignore_cluster_name", true).build();
		TransportClient client = new PreBuiltXPackTransportClient(settings).addTransportAddress(getTransportAddress());
		NodesInfoResponse nodeInfos = client.admin().cluster().prepareNodesInfo().get();
		String clusterName = nodeInfos.getClusterName().value();
		log.info(clusterName);
	}
}
