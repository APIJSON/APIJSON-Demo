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
import javax.sql.DataSource;
import apijson.Log;
import apijson.NotNull;
import apijson.StringUtil;
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

	@SuppressWarnings("incomplete-switch")
	@Override
	public int executeUpdate(@NotNull SQLConfig config, String sql) throws Exception {
		if (config.getDatasource() != null && StringUtil.equals(config.getDatabase(), SQLConfig.DATABASE_ELASTICSEARCH)) {
			// TODO 调用 非 jdbc数据源,执行相关语句
			ESOptions esOptions = new ESOptions();
			switch (config.getMethod()) {
			case POST:
				return esOptions.insert(config, config.getDatasource());
			case PUT:
				return esOptions.updateBySql(config, config.getDatasource(), sql);
			case DELETE:
				return esOptions.deleteBySql(config, config.getDatasource(), sql);
			}
		}
		return super.executeUpdate(config, sql);
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
