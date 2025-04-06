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

import static apijson.framework.javax.APIJSONConstant.ID;
import static apijson.framework.javax.APIJSONConstant.PRIVACY_;
import static apijson.framework.javax.APIJSONConstant.USER_;
import static apijson.framework.javax.APIJSONConstant.USER_ID;

import java.util.List;

import apijson.RequestMethod;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.annotation.JSONField;

import apijson.framework.javax.APIJSONSQLConfig;
import apijson.orm.AbstractSQLConfig;
import apijson.orm.Join;
import apijson.orm.Join.On;


/**SQL配置
 * TiDB 用法和 MySQL 一致
 * 具体见详细的说明文档 C.开发说明 C-1-1.修改数据库链接
 * https://github.com/Tencent/APIJSON/blob/master/%E8%AF%A6%E7%BB%86%E7%9A%84%E8%AF%B4%E6%98%8E%E6%96%87%E6%A1%A3.md#c-1-1%E4%BF%AE%E6%94%B9%E6%95%B0%E6%8D%AE%E5%BA%93%E9%93%BE%E6%8E%A5
 * @author Lemon
 */
public class DemoSQLConfig extends APIJSONSQLConfig<Long, JSONObject, JSONArray> {

	public DemoSQLConfig() {
		super();
	}
	public DemoSQLConfig(RequestMethod method, String table) {
		super(method, table);
	}

	static {
		DEFAULT_DATABASE = DATABASE_MYSQL;  //TODO 默认数据库类型，改成你自己的。TiDB, MariaDB, OceanBase 这类兼容 MySQL 的可当做 MySQL 使用
		DEFAULT_SCHEMA = "sys";  //TODO 默认数据库名/模式，改成你自己的，默认情况是 MySQL: sys, PostgreSQL: sys, SQL Server: dbo, Oracle:

        // 表名和数据库不一致的，需要配置映射关系。只使用 APIJSONORM 时才需要；
        // 如果用了 apijson-framework 且调用了 APIJSONApplication.init 则不需要
        // (间接调用 DemoVerifier.init 方法读取数据库 Access 表来替代手动输入配置)。
        // 但如果 Access 这张表的对外表名与数据库实际表名不一致，仍然需要这里注册。例如
        //		TABLE_KEY_MAP.put(Access.class.getSimpleName(), "access");

		// 表名映射，隐藏真实表名，对安全要求很高的表可以这么做
		//		TABLE_KEY_MAP.put(User.class.getSimpleName(), "apijson_user");
		//		TABLE_KEY_MAP.put(Privacy.class.getSimpleName(), "apijson_privacy");

		// 主键名映射
		SIMPLE_CALLBACK = new SimpleCallback<Long, JSONObject, JSONArray>() {

			@Override
			public AbstractSQLConfig<Long, JSONObject, JSONArray> getSQLConfig(RequestMethod method, String database, String schema, String datasource, String table) {
				return new DemoSQLConfig(method, table);
			}

			//取消注释来实现自定义各个表的主键名
			//			@Override
			//			public String getIdKey(String database, String schema, String datasource, String table) {
			//				return StringUtil.firstCase(table + "Id");  // userId, comemntId ...
			//				//		return StringUtil.toLowerCase(t) + "_id";  // user_id, comemnt_id ...
			//				//		return StringUtil.toUpperCase(t) + "_ID";  // USER_ID, COMMENT_ID ...
			//			}

			@Override
			public String getUserIdKey(String database, String schema, String datasource, String table) {
				return USER_.equals(table) || PRIVACY_.equals(table) ? ID : USER_ID; // id / userId
			}

			// 取消注释来实现数据库自增 id
			//			@Override
			//			public Long newId(RequestMethod method, String database, String schema, String datasource, String table) {
			//				return null; // return null 则不生成 id，一般用于数据库自增 id
			//			}

			//			@Override
			//			public void onMissingKey4Combine(String name, JSONObject request, String combine, String item, String key) throws Exception {
			////				super.onMissingKey4Combine(name, request, combine, item, key);
			//			}
		};

		// 自定义原始 SQL 片段，其它功能满足不了时才用它，只有 RAW_MAP 配置了的 key 才允许前端传
		RAW_MAP.put("`to`.`id`", "");  // 空字符串 "" 表示用 key 的值 `to`.`id`
		RAW_MAP.put("toDate", "");  // "@column": "date;date_format('2020-01-01','%Y-%m-%d'):toDate", "@having": "(date > toDate)", "@raw": "@column,@having"
		RAW_MAP.put("to.momentId", "`to`.`momentId`");  // 最终以 `to`.`userId` 拼接 SQL，相比以上写法可以让前端写起来更简单
		RAW_MAP.put("(`Comment`.`userId`=`to`.`userId`)", "");  // 已经是一个条件表达式了，用 () 包裹是为了避免 JSON 中的 key 拼接在前面导致 SQL 出错
		RAW_MAP.put("sum(if(userId%2=0,1,0))", "");  // 超过单个函数的 SQL 表达式
		RAW_MAP.put("sumUserIdIsEven", "sum(if(`userId`%2=0,1,0)) AS sumUserIdIsEven");  // 简化前端传参
		RAW_MAP.put("substring_index(substring_index(content,',',1),',',-1)", "");  // APIAuto 不支持 '，可以用 Postman 测
		RAW_MAP.put("substring_index(substring_index(content,'.',1),'.',-1) AS subContent", "");  // APIAuto 不支持 '，可以用 Postman 测
		RAW_MAP.put("commentWhereItem1","(`Comment`.`userId` = 38710 AND `Comment`.`momentId` = 470)");
		RAW_MAP.put("to_days(now())-to_days(`date`)<=7", "");  // 给 @having 使用
		RAW_MAP.put("sexShowStr", "CASE sex WHEN 0 THEN '男' WHEN 1 THEN '女' ELSE '其它' END");  // 给 @having 使用

	}


	// 如果 DemoSQLExecutor.getConnection 能拿到连接池的有效 Connection，则这里不需要配置 dbVersion, dbUri, dbAccount, dbPassword

	@Override
	public String gainDBVersion() {
		if (isMySQL()) {
			return "5.7.22"; //"8.0.11"; //TODO 改成你自己的 MySQL 或 PostgreSQL 数据库版本号 //MYSQL 8 和 7 使用的 JDBC 配置不一样
		}
		if (isPostgreSQL()) {
			return "9.6.15"; //TODO 改成你自己的
		}
		if (isSQLServer()) {
			return "2016"; //TODO 改成你自己的
		}
		if (isOracle()) {
			return "18c"; //TODO 改成你自己的
		}
		if (isDb2()) {
			return "11.5"; //TODO 改成你自己的
		}
		if (isTDengine()) {
			return "2.6.0.8"; //TODO 改成你自己的
		}
		return null;
	}

	@JSONField(serialize = false)  // 不在日志打印 账号/密码 等敏感信息，用了 UnitAuto 则一定要加
	@Override
	public String gainDBUri() {
		if (isMySQL()) {
			// 这个是 MySQL 8.0 及以上，要加 userSSL=false  return "jdbc:mysql://localhost:3306?userSSL=false&serverTimezone=GMT%2B8&useUnicode=true&characterEncoding=UTF-8";
			// 以下是 MySQL 5.7 及以下
			return "jdbc:mysql://localhost:3306?serverTimezone=GMT%2B8&useUnicode=true&characterEncoding=UTF-8"; //TODO 改成你自己的，TiDB 可以当成 MySQL 使用，默认端口为 4000
		}
		if (isPostgreSQL()) {
			return "jdbc:postgresql://localhost:5432/postgres?stringtype=unspecified"; //TODO 改成你自己的
		}
		if (isSQLServer()) {
			return "jdbc:jtds:sqlserver://localhost:1433/pubs;instance=SQLEXPRESS"; //TODO 改成你自己的
		}
		if (isOracle()) {
			return "jdbc:oracle:thin:@localhost:1521:orcl"; //TODO 改成你自己的
		}
		if (isDb2()) {
			return "jdbc:db2://localhost:50000/BLUDB"; //TODO 改成你自己的
		}
		if (isTDengine()) {
			//      return "jdbc:TAOS://localhost:6030"; //TODO 改成你自己的
			return "jdbc:TAOS-RS://localhost:6041"; //TODO 改成你自己的
		}
		return null;
	}

	@JSONField(serialize = false)  // 不在日志打印 账号/密码 等敏感信息，用了 UnitAuto 则一定要加
	@Override
	public String gainDBAccount() {
		if (isMySQL()) {
			return "root";  //TODO 改成你自己的
		}
		if (isPostgreSQL()) {
			return "postgres";  //TODO 改成你自己的
		}
		if (isSQLServer()) {
			return "sa";  //TODO 改成你自己的
		}
		if (isOracle()) {
			return "scott";  //TODO 改成你自己的
		}
		if (isDb2()) {
			return "db2admin"; //TODO 改成你自己的
		}
		if (isTDengine()) {
			return "root"; //TODO 改成你自己的
		}
		return null;
	}

	@JSONField(serialize = false)  // 不在日志打印 账号/密码 等敏感信息，用了 UnitAuto 则一定要加
	@Override
	public String gainDBPassword() {
		if (isMySQL()) {
			return "apijson";  //TODO 改成你自己的，TiDB 可以当成 MySQL 使用， 默认密码为空字符串 ""
		}
		if (isPostgreSQL()) {
			return null;  //TODO 改成你自己的
		}
		if (isSQLServer()) {
			return "apijson@123";  //TODO 改成你自己的
		}
		if (isOracle()) {
			return "tiger";  //TODO 改成你自己的
		}
		if (isDb2()) {
			return "123"; //TODO 改成你自己的
		}
		if (isTDengine()) {
			return "taosdata"; //TODO 改成你自己的
		}
		return null;
	}

	// 取消注释后，默认的 APIJSON 配置表会由业务表所在 数据库类型 database 和 数据库模式 schema 改为自定义的
	//	@Override
	//	public String getConfigDatabase() {
	//		return DATABASE_POSTGRESQL;
	//	}
	//	@Override
	//	public String getConfigSchema() {
	//		return "apijson";
	//	}

	// 取消注释后，默认的数据库类型会由 MySQL 改为 PostgreSQL
	//	@Override
	//	public String getDatabase() {
	//		String db = super.getDatabase();
	//		return db == null ? DATABASE_POSTGRESQL : db;
	//	}

	// 如果确定只用一种数据库，可以重写方法，这种数据库直接 return true，其它数据库直接 return false，来减少判断，提高性能
	//	@Override
	//	public boolean isMySQL() {
	//		return true;
	//	}
	//	@Override
	//	public boolean isPostgreSQL() {
	//		return false;
	//	}
	//	@Override
	//	public boolean isSQLServer() {
	//		return false;
	//	}
	//	@Override
	//	public boolean isOracle() {
	//		return false;
	//	}
	//	@Override
	//	public boolean isDb2() {
	//		return false;
	//	}


	// 取消注释支持 !key 反选字段 和 字段名映射，需要先依赖插件 https://github.com/APIJSON/apijson-column
	//	@Override
	//	public AbstractSQLConfig setColumn(List<String> column) {
	//		return super.setColumn(ColumnUtil.compatInputColumn(column, getTable(), getMethod()));
	//	}
	//	@Override
	//	public String getKey(String key) {
	//		return super.getKey(ColumnUtil.compatInputKey(key, getTable(), getMethod()));
	//	}

	// 取消注释来兼容 Oracle DATETIME, TIMESTAMP 等日期时间类型的值来写库。5.0.0+ 重写以下方法，4.9.1 及以下改为重写 getValue(String)
	//	@Override // 如果是查询，可以把 if 内 isQueryMethod 的判断去掉或者 boolean 值取反。
	//	protected Object getValue(String key, String column, Object value) {
	//		if (isOracle() && RequestMethod.isQueryMethod(getMethod()) == false && value instanceof String) {
	//			try {
	//				SimpleDateFormat parser = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	//				parser.parse((String) value);
	//				if (isPrepared()) {
	//					preparedValueList.add(value);
	//				}
	//				return "to_date(" + (isPrepared() ? "?" : getSQLValue(value)) + ",'yyyy-mm-dd hh24:mi:ss')";
	//			}
	//			catch (Throwable e) {
	//				if (Log.DEBUG) {
	//					e.printStackTrace();
	//				}
	//			}
	//		}
	//		return super.getValue(key, column, value);
	//	}


	@Override
	protected void onGainCrossJoinString(Join<Long, JSONObject, JSONArray> join) throws UnsupportedOperationException {
		// 开启 CROSS JOIN 笛卡尔积联表  	super.onGetCrossJoinString(join);
	}
	@Override
	protected void onJoinNotRelation(String sql, String quote, Join<Long, JSONObject, JSONArray> join, String jt, List<On> onList, On on) {
		// 开启 JOIN	ON t1.c1 != t2.c2 等不等式关联 	super.onJoinNotRelation(sql, quote, join, jt, onList, on);
	}
	@Override
	protected void onJoinComplexRelation(String sql, String quote, Join<Long, JSONObject, JSONArray> join, String jt, List<On> onList, On on) {
		// 开启 JOIN	ON t1.c1 LIKE concat('%', t2.c2, '%') 等复杂关联		super.onJoinComplexRelation(sql, quote, join, jt, onList, on);
	}

}
