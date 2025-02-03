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

package com.example.apijsondemo;

import java.math.BigInteger;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.Map;

import javax.sql.DataSource;

import com.alibaba.fastjson.JSONObject;
import apijson.Log;
import apijson.framework.javax.APIJSONSQLExecutor;
import apijson.orm.SQLConfig;

/**
 * SQL 执行器，支持连接池及多数据源
 * 具体见 https://github.com/Tencent/APIJSON/issues/151
 * 
 * @author Lemon
 */
public class DemoSQLExecutor extends APIJSONSQLExecutor<Long> {
	public static final String TAG = "SQL执行器";

	// 解决 id 精度丢失 问题
	protected Object getValue(SQLConfig<Long> config, ResultSet rs, ResultSetMetaData rsmd, int tablePosition,
			JSONObject table, int columnIndex, String lable, Map<String, JSONObject> childMap) throws Exception {

		Object value = super.getValue(config, rs, rsmd, tablePosition, table, columnIndex, lable, childMap);

		// 数据库中 bigint unsigned 类型会丢失精度，转为 string
		if (value instanceof BigInteger) {
			return value.toString();
		}

		// 数据库中 bigint 类型 大于15位会丢失精度，转为 string
		if (value instanceof Long) {
			int length = ((Long) value).toString().length();

			if (length > 15) {
				return value.toString();
			}
		}
		return value;
	}

	// 适配连接池，如果这里能拿到连接池的有效 Connection，则 SQLConfig 不需要配置 dbVersion, dbUri, dbAccount,
	@Override
	public Connection getConnection(SQLConfig<Long> config) throws Exception {
		String datasource = config.getDatasource();

		Log.d(TAG, "getConnection  config.getDatasource() = " + datasource);

		String key = datasource + "-" + config.getDatabase();

		Connection c = connectionMap.get(key);
		if (c == null || c.isClosed()) {
			DataSource ds;

			try {
				// 未输入数据源，就选择默认数据源
				if (datasource == null) {
					ds = ApijsonDemoApplication.getApplicationContext().getBean(DataSource.class);
				} else {
					switch (datasource) {
						case "db1":
							ds = ApijsonDemoApplication.getApplicationContext().getBean("db1DataSource",
									DataSource.class);
							break;
						case "db2":
							ds = ApijsonDemoApplication.getApplicationContext().getBean("db2DataSource",
									DataSource.class);
							break;
						default:
							ds = null;
							break;
					}
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

}
