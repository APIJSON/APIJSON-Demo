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
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

import javax.sql.DataSource;

import apijson.NotNull;
import apijson.StringUtil;
import apijson.framework.APIJSONSQLExecutor;
import apijson.orm.SQLConfig;


/**SQL 执行器，支持连接池及多数据源
 * 具体见 https://github.com/Tencent/APIJSON/issues/151
 * @author Lemon
 */
public class DemoSQLExecutor extends APIJSONSQLExecutor {
    public static final String TAG = "DemoSQLExecutor";

    // 适配 PrestoDB 的 JDBC
    @Override
    public Connection getConnection(SQLConfig config) throws Exception {
        if (config.isPresto()) {
            return DriverManager.getConnection("jdbc:presto://localhost:8099/mysql?user=root&SSL=false");
        }
        if (config.isTrino()) {
            return DriverManager.getConnection("jdbc:trino://localhost:8098/postgres?user=root&SSL=false");
        }
        return super.getConnection(config);
    }
}
