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

import java.util.UUID;

import com.alibaba.fastjson.annotation.JSONField;

import apijson.RequestMethod;
import apijson.framework.APIJSONSQLConfig;
import apijson.orm.AbstractSQLConfig;


/**SQL 配置
 * TiDB 用法和 MySQL 一致
 * 具体见详细的说明文档 C.开发说明 C-1-1.修改数据库链接  
 * https://github.com/Tencent/APIJSON/blob/master/%E8%AF%A6%E7%BB%86%E7%9A%84%E8%AF%B4%E6%98%8E%E6%96%87%E6%A1%A3.md#c-1-1%E4%BF%AE%E6%94%B9%E6%95%B0%E6%8D%AE%E5%BA%93%E9%93%BE%E6%8E%A5
 * @author Lemon
 */
public class DemoSQLConfig extends APIJSONSQLConfig<Long> {

	public DemoSQLConfig() {
		super();
	}

	public DemoSQLConfig(RequestMethod method, String table) {
		super(method, table);
	}
	
    static {
//        DEFAULT_DATABASE = DATABASE_ELASTICSEARCH;  // TODO 默认数据库类型，改成你自己的
//        DEFAULT_SCHEMA = "sys";  // TODO 默认数据库名/模式，改成你自己的，默认情况是 MySQL: sys, PostgreSQL: public, SQL Server: dbo, Oracle:

        // 表名和数据库不一致的，需要配置映射关系。只使用 APIJSONORM 时才需要；
        // 如果用了 apijson-framework 且调用了 APIJSONApplication.init 则不需要
        // (间接调用 DemoVerifier.init 方法读取数据库 Access 表来替代手动输入配置)。
        // 但如果 Access 这张表的对外表名与数据库实际表名不一致，仍然需要这里注册。例如
        //		TABLE_KEY_MAP.put(Access.class.getSimpleName(), "access");

        SIMPLE_CALLBACK = new SimpleCallback<String>() {

			@Override
			public AbstractSQLConfig getSQLConfig(RequestMethod method, String database, String schema,
					String datasource, String table) {
				return new DemoSQLConfig(method, table);
			}

			// 取消注释来实现数据库自增 id
			@Override
			public String newId(RequestMethod method, String database, String schema, String datasource, String table) {
				if(table.equals("Access") || table.equals("Request") || table.equals("Function")){
					return null;
				}
				return UUID.randomUUID().toString(); // return null 则不生成 id，一般用于数据库自增 id
			}
		};
    }

    @JSONField(serialize = false)  // 不在日志打印 账号/密码 等敏感信息，用了 UnitAuto 则一定要加
	@Override
	public String getDBVersion() {
		return DynamicDataSource.getDetail(this.getDatasource()).getDbVersion();
	}

	@JSONField(serialize = false) // 不在日志打印 账号/密码 等敏感信息，用了 UnitAuto 则一定要加
	@Override
	public String getDatabase() {
		if (super.getDatabase() != null) {
			return super.getDatabase();
		}
		try {
			return DynamicDataSource.getDetail(this.getDatasource()).getDatabase();
		} catch (Exception e) {
			throw new IllegalArgumentException("动态数据源配置错误 " + this.getDatasource());
		}
	}

	@JSONField(serialize = false) // 不在日志打印 账号/密码 等敏感信息，用了 UnitAuto 则一定要加
	@Override
	public String getSchema() {
		if (super.getSchema() != null) {
			return super.getSchema();
		}
		try {
			return DynamicDataSource.getDetail(this.getDatasource()).getSchema();
		} catch (Exception e) {
			throw new IllegalArgumentException("动态数据源配置错误 " + this.getDatasource());
		}
	}

	@JSONField(serialize = false)  // 不在日志打印 账号/密码 等敏感信息，用了 UnitAuto 则一定要加
	@Override
	public String getDBUri() {
		try {
			return DynamicDataSource.getDetail(this.getDatasource()).getUrl(); // 数据库连接url
		} catch (Exception e) {
			throw new IllegalArgumentException("动态数据源配置错误 " + this.getDatasource());
		}
	}

	@JSONField(serialize = false)  // 不在日志打印 账号/密码 等敏感信息，用了 UnitAuto 则一定要加
	@Override
	public String getDBAccount() {
		try {
			return DynamicDataSource.getDetail(this.getDatasource()).getDbAccount();
		} catch (Exception e) {
			throw new IllegalArgumentException("动态数据源配置错误 " + this.getDatasource());
		}
	}

	@JSONField(serialize = false)  // 不在日志打印 账号/密码 等敏感信息，用了 UnitAuto 则一定要加
	@Override
	public String getDBPassword() {
		try {
			return DynamicDataSource.getDetail(this.getDatasource()).getDbPassword();
		} catch (Exception e) {
			throw new IllegalArgumentException("动态数据源配置错误 " + this.getDatasource());
		}
	}

}
