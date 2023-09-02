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

import apijson.framework.APIJSONSQLExecutor;
import apijson.orm.SQLConfig;


/**SQL 执行器，支持连接池及多数据源
 * 具体见 https://github.com/Tencent/APIJSON/issues/151
 * @author Lemon
 */
public class DemoSQLExecutor extends APIJSONSQLExecutor<Long> {
	public static final String TAG = "DemoSQLExecutor";

	// 适配连接池，如果这里能拿到连接池的有效 Connection，则 SQLConfig 不需要配置 dbVersion, dbUri, dbAccount, dbPassword
	@Override
	public Connection getConnection(SQLConfig config) throws Exception {
		//		Log.d(TAG, "getConnection  config.getDatasource() = " + config.getDatasource());

		String key = config.getDatasource() + "-" + config.getDatabase();
		Connection c = connectionMap.get(key);
		if (c == null || c.isClosed()) {
			DataSource ds = DemoApplication.getApplicationContext().getBean(DataSource.class);
			// 另一种方式是 DemoDataSourceConfig 初始化获取到 Datasource 后给静态变量 DATA_SOURCE 赋值： ds = DemoDataSourceConfig.DATA_SOURCE.getConnection();
			connectionMap.put(key, ds == null ? null : ds.getConnection());
		}

		// 必须最后执行 super 方法，因为里面还有事务相关处理。
		// 如果这里是 return c，则会导致 增删改 多个对象时只有第一个会 commit，即只有第一个对象成功插入数据库表
		return super.getConnection(config);
	}

}
