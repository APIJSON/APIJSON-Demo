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
import java.util.Map;

import javax.sql.DataSource;

import com.alibaba.druid.pool.DruidDataSource;
import com.zaxxer.hikari.HikariDataSource;

import apijson.Log;
import apijson.boot.DemoApplication;
import apijson.framework.APIJSONSQLExecutor;
import apijson.orm.SQLConfig;


/**SQL 执行
 * @author Lemon
 */
public class DemoSQLExecutor extends APIJSONSQLExecutor {
	public static final String TAG = "DemoSQLExecutor";

	//  可重写以下方法，支持 Redis 等单机全局缓存或分布式缓存
	//	@Override
	//	public List<JSONObject> getCache(String sql, int type) {
	//		return super.getCache(sql, type);
	//	}
	//	@Override
	//	public synchronized void putCache(String sql, List<JSONObject> list, int type) {
	//		super.putCache(sql, list, type);
	//	}
	//	@Override
	//	public synchronized void removeCache(String sql, int type) {
	//		super.removeCache(sql, type);
	//	}

	// 适配连接池，如果这里能拿到连接池的有效 Connection，则 SQLConfig 不需要配置 dbVersion, dbUri, dbAccount, dbPassword
	@Override
	public Connection getConnection(SQLConfig config) throws Exception {
		String datasource = config.getDatasource();
		Log.d(TAG, "getConnection  config.getDatasource() = " + datasource);

		String key = datasource + "-" + config.getDatabase();
		Connection c = connectionMap.get(key);
		if (datasource != null && (c == null || c.isClosed())) {
			try {
				DataSource ds;
				switch (datasource) {
				case "HIKARICP":
					ds = DemoApplication.getApplicationContext().getBean(HikariDataSource.class);
					// 另一种方式是 DemoDataSourceConfig 初始化获取到 DataSource 后给静态变量 DATA_SOURCE_HIKARICP 赋值： ds = DemoDataSourceConfig.DATA_SOURCE_HIKARICP.getConnection();
					break;
				default:
					Map<String, DruidDataSource> dsMap = DemoApplication.getApplicationContext().getBeansOfType(DruidDataSource.class);
					// 另一种方式是 DemoDataSourceConfig 初始化获取到 DataSource 后给静态变量 DATA_SOURCE_DRUID 赋值： ds = DemoDataSourceConfig.DATA_SOURCE_DRUID.getConnection();
					switch (datasource) {
					case "DRUID-TEST":
						ds = dsMap.get("druidTestDataSource");
						break;
					case "DRUID-ONLINE":
						ds = dsMap.get("druidOnlineDataSource");
						break;
					case "DRUID":
						ds = dsMap.get("druidDataSource");
						break;
					default:
						ds = null;
						break;
					}
					break;
				}

				connectionMap.put(key, ds == null ? null : ds.getConnection());
			} catch (Exception e) {
				Log.e(TAG, "getConnection   try { "
						+ "DataSource ds = DemoApplication.getApplicationContext().getBean(DataSource.class); .."
						+ "} catch (Exception e) = " + e.getMessage());
			}
		}

		// 必须最后执行 super 方法，因为里面还有事务相关处理。
		// 如果这里是 return c，则会导致 增删改 多个对象时只有第一个会 commit，即只有第一个对象成功插入数据库表
		return super.getConnection(config);
	}


	// 取消注释支持 !key 反选字段 和 字段名映射，需要先依赖插件 https://github.com/APIJSON/apijson-column
	//	@Override
	//	protected String getKey(SQLConfig config, ResultSet rs, ResultSetMetaData rsmd, int tablePosition, JSONObject table,
	//			int columnIndex, Map<String, JSONObject> childMap) throws Exception {
	//		return ColumnUtil.compatOutputKey(super.getKey(config, rs, rsmd, tablePosition, table, columnIndex, childMap), config.getTable(), config.getMethod());
	//	}

	// 不需要隐藏字段这个功能时，取消注释来提升性能
	//	@Override
	//	protected boolean isHideColumn(SQLConfig config, ResultSet rs, ResultSetMetaData rsmd, int tablePosition,
	//			JSONObject table, int columnIndex, Map<String, JSONObject> childMap) throws SQLException {
	//		return false;
	//	}

}
