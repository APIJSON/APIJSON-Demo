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

import apijson.Log;
import apijson.orm.AbstractSQLExecutor;

/**
 * SQL 执行器，支持连接池及多数据源
 * 具体见 https://github.com/Tencent/APIJSON/issues/151
 *
 * @author Lemon
 */
public class DemoSQLExecutor extends AbstractSQLExecutor<Long> {
    private static final String TAG = "DemoSQLExecutor";

    static {
        try { //加载驱动程序
            Log.d(TAG, "尝试加载 MySQL 8 驱动 <<<<<<<<<<<<<<<<<<<<< ");
            Class.forName("com.mysql.cj.jdbc.Driver");
            Log.d(TAG, "成功加载 MySQL 8 驱动！>>>>>>>>>>>>>>>>>>>>>");
        }
        catch (ClassNotFoundException e) {
            Log.e(TAG, "加载 MySQL 8 驱动失败，请检查 pom.xml 中 mysql-connector-java 版本是否存在以及可用 ！！！");
            e.printStackTrace();

            try { //加载驱动程序
                Log.d(TAG, "尝试加载 MySQL 7 及以下版本的 驱动 <<<<<<<<<<<<<<<<<<<<< ");
                Class.forName("com.mysql.jdbc.Driver");
                Log.d(TAG, "成功加载 MySQL 7 及以下版本的 驱动！>>>>>>>>>>>>>>>>>>>>> ");
            }
            catch (ClassNotFoundException e2) {
                Log.e(TAG, "加载 MySQL 7 及以下版本的 驱动失败，请检查 pom.xml 中 mysql-connector-java 版本是否存在以及可用 ！！！");
                e2.printStackTrace();
            }
        }

    }

}
