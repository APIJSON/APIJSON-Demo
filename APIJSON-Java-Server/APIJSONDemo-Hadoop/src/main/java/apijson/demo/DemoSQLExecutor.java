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

import com.alibaba.fastjson.JSONObject;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Map;
import java.util.regex.Pattern;

import apijson.Log;
import apijson.RequestMethod;
import apijson.framework.APIJSONSQLConfig;
import apijson.framework.APIJSONSQLExecutor;
import apijson.orm.SQLConfig;


/**SQL 执行
 * @author Lemon
 */
public class DemoSQLExecutor extends APIJSONSQLExecutor<Long> {
	public static final String TAG = "DemoSQLExecutor";

	@Override
	protected String getKey(SQLConfig config, ResultSet rs, ResultSetMetaData rsmd, int tablePosition, JSONObject table, int columnIndex, Map<String, JSONObject> childMap) throws Exception {
		String key = super.getKey(config, rs, rsmd, tablePosition, table, columnIndex, childMap);
		String table_name = config.getTable();
		if(APIJSONSQLConfig.TABLE_KEY_MAP.containsKey(table_name)) table_name = APIJSONSQLConfig.TABLE_KEY_MAP.get(table_name);
		String pattern = "^" + table_name + "\\." + "[a-zA-Z]+$";
		boolean isMatch = Pattern.matches(pattern, key);
		if(isMatch) key = key.split("\\.")[1];
		return key;
	}


	@Override
	public int executeUpdate(SQLConfig config) throws Exception {
		PreparedStatement s = this.getStatement(config);
		int count = 1;
		if (config.getMethod() == RequestMethod.POST && config.getId() == null) {
			ResultSet rs = s.getGeneratedKeys();
			if (rs != null && rs.next()) {
				config.setId(rs.getLong(1));
			}
		}

		return count;
	}

	@Override
	public void begin(int transactionIsolation) throws SQLException {
		super.begin(transactionIsolation);
		this.connection.setAutoCommit(true);
	}

	@Override
	public void commit() throws SQLException {
		Log.d("\n\nAbstractSQLExecutor", "<<<<<<<<<<<<<< TRANSACTION commit >>>>>>>>>>>>>>>>>>>>>>> \n\n");
	}

}
