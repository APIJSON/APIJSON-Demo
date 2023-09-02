/*Copyright ©2016 TommyLemon(https://github.com/TommyLemon/APIJSON)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.*/

package apijson.demo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;
import com.redbeardlab.redisql.client.ParseRediSQLReply;
import apijson.Log;
import apijson.NotNull;
import apijson.StringUtil;
import apijson.demo.resultSet.DataBuildResultSet;
import apijson.framework.APIJSONSQLExecutor;
import apijson.orm.SQLConfig;
import lombok.extern.log4j.Log4j2;

/**
 * SQL 执行器，支持连接池及多数据源 具体见 https://github.com/Tencent/APIJSON/issues/151
 * 
 * @author Lemon
 */
@Log4j2
public class DemoSQLExecutor extends APIJSONSQLExecutor<Long> {
	public static final String TAG = "DemoSQLExecutor";

	// 适配连接池，如果这里能拿到连接池的有效 Connection，则 SQLConfig 不需要配置 dbVersion, dbUri, dbAccount,
	// dbPassword
	@Override
	public Connection getConnection(SQLConfig config) throws Exception {
		String datasource = config.getDatasource();
		Log.d(TAG, "getConnection  config.getDatasource() = " + datasource);

		String key = datasource + "-" + config.getDatabase();
		Connection conn = connectionMap.get(key);
		if (conn == null || conn.isClosed()) {
			DataSource dataSource = DataBaseUtil.getDataSource(datasource);
			connectionMap.put(key, dataSource == null ? null : dataSource.getConnection());
		}
		return super.getConnection(config);
	}

	@Override
	public ResultSet executeQuery(@NotNull SQLConfig config, String sql) throws Exception {
		if (config.isRedis()) {
			return redisExecuteQuery(config, sql);
		}
		return super.executeQuery(config, sql);
	}
	
	@SuppressWarnings("unchecked")
	public ResultSet redisExecuteQuery(@NotNull SQLConfig config, String sql) throws Exception {
		List<List<Object>> rsData = new ArrayList<>();
		List<String> headers = new ArrayList<>();
		// redis不支持explain 查询
		if (config.isExplain()) {
			// 没有查询到数据
			return new DataBuildResultSet(null, headers, rsData);
		}
		
		if (config.getColumn() != null) {
			headers = config.getColumn();
		}

		if (config.getTable().startsWith(JedisBuildData.REDIS_TABLE_KEY)) {
			if (config.getColumn() != null) {
				headers = config.getColumn();
			} else {
				// redisql不支持返回字段名, select * 请把字段填充进去
				throw new IllegalArgumentException("redis table 查询必须指定 column !");
			}
			sql = StringUtil.isEmpty(sql) ? config.getSQL(false) : sql;
			switch (config.getMethod()) {
			case GET:
			case HEAD:
				List<Object> retObj = DynamicDataSource.getDetail(config.getDatasource()).getJedisClusterUtil().crudBySearch(JedisClusterUtil.DB, sql);
				if (ParseRediSQLReply.done_reply(retObj)) {
					return new DataBuildResultSet(null, headers, rsData);
				} else {
					for (Object obj : retObj) {
						List<Object> rowList = (List<Object>) obj;
						List<Object> retData = new ArrayList<>();
						for (Object objData : rowList) {
							if (objData instanceof Number) {
								retData.add(objData);
							} else {
								// 字段值不存在
								if (objData == null) {
									retData.add(null);
								} else {
									retData.add(ParseRediSQLReply.get_string(objData));
								}
							}
						}
						rsData.add(retData);
					}
					return new DataBuildResultSet(null, headers, rsData);
				}
			default:
				return new DataBuildResultSet(null, headers, rsData);
			}
		}
		return null;
	}
	@Override
	public int executeUpdate(@NotNull SQLConfig config, String sql) throws Exception {
		if (config.isRedis()) {
			return redisExecuteUpdate(config, sql);
		}
		return super.executeUpdate(config, sql);
	}
	
	private int redisExecuteUpdate(@NotNull SQLConfig config, String sql) throws Exception {
		// 数据库类型, 数据源 区分
		// 也可以通过表前缀区分
		// 操作类型, 约定redis表名前缀, 避免对值进行解析
		if (config.getTable().startsWith(JedisBuildData.REDIS_TABLE_KEY)) {
			sql = StringUtil.isEmpty(sql) ? config.getSQL(false) : sql;
			switch (config.getMethod()) {
			case POST:
				return DynamicDataSource.getDetail(config.getDatasource()).getJedisClusterUtil().crudByUpdate(JedisClusterUtil.DB, sql);
			case PUT:
			case DELETE:
				// 后面有需要,直接修改apijson sql 生成语句
				// AbstractSQLConfig
				int index = sql.indexOf("REGEXP BINARY");
				if (index > 0) {
					sql = sql.replace("REGEXP BINARY", "=");
				} else {
					index = sql.indexOf("REGEXP");
					if (index > 0) {
						sql = sql.replace("REGEXP", "=");
					}
				}
				return DynamicDataSource.getDetail(config.getDatasource()).getJedisClusterUtil().crudByUpdate(JedisClusterUtil.DB, sql);
			default:
				return 0;
			}
		}
		return 0;
	}
	/***
	 * 查询返回字段值进行二次处理
	 */
//	@Override
//	protected JSONObject onPutColumn(@NotNull SQLConfig config, @NotNull ResultSet rs, @NotNull ResultSetMetaData rsmd
//			, final int tablePosition, @NotNull JSONObject table, final int columnIndex, Join join, Map<String, JSONObject> childMap) throws Exception {
//		if (table == null) {  // 对应副表 viceSql 不能生成正常 SQL， 或者是 ! - Outer, ( - ANTI JOIN 的副表这种不需要缓存及返回的数据
//			Log.i(TAG, "onPutColumn table == null >> return table;");
//			return table;
//		}
//
//		if (isHideColumn(config, rs, rsmd, tablePosition, table, columnIndex, childMap)) {
//			Log.i(TAG, "onPutColumn isHideColumn(config, rs, rsmd, tablePosition, table, columnIndex, childMap) >> return table;");
//			return table;
//		}
//
//		String label = getKey(config, rs, rsmd, tablePosition, table, columnIndex, childMap);
//		Object value = getValue(config, rs, rsmd, tablePosition, table, columnIndex, label, childMap);
//		
//		// TODO
//		if(StringUtils.equals(config.getTable(), "User") && StringUtils.equals(label, "addr_id")) {
//			value = "1-1-1";
//		}
//		// 主表必须 put 至少一个 null 进去，否则全部字段为 null 都不 put 会导致中断后续正常返回值
//		if (value != null || (join == null && table.isEmpty())) {
//			table.put(label, value);
//		}
//
//		return table;
//	}

	// 取消注释支持 !key 反选字段 和 字段名映射，需要先依赖插件 https://github.com/APIJSON/apijson-column
	// @Override
	// protected String getKey(SQLConfig config, ResultSet rs, ResultSetMetaData
	// rsmd, int tablePosition, JSONObject table,
	// int columnIndex, Map<String, JSONObject> childMap) throws Exception {
	// return ColumnUtil.compatOutputKey(super.getKey(config, rs, rsmd,
	// tablePosition, table, columnIndex, childMap), config.getTable(),
	// config.getMethod());
	// }

	// 不需要隐藏字段这个功能时，取消注释来提升性能
	// @Override
	// protected boolean isHideColumn(SQLConfig config, ResultSet rs,
	// ResultSetMetaData rsmd, int tablePosition,
	// JSONObject table, int columnIndex, Map<String, JSONObject> childMap) throws
	// SQLException {
	// return false;
	// }

}
