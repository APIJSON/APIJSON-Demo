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

import static apijson.framework.APIJSONConstant.ID;
import static apijson.framework.APIJSONConstant.PRIVACY_;
import static apijson.framework.APIJSONConstant.USER_;
import static apijson.framework.APIJSONConstant.USER_ID;

import java.text.SimpleDateFormat;
import java.util.*;

import apijson.*;
//import apijson.influxdb.InfluxDBUtil;
//import apijson.iotdb.IoTDBUtil;
import apijson.orm.AbstractParser;
import apijson.orm.AbstractSQLConfig;
import apijson.orm.Parser;
//import apijson.surrealdb.SurrealDBUtil;
import com.alibaba.fastjson.annotation.JSONField;

import apijson.column.ColumnUtil;
import apijson.framework.APIJSONSQLConfig;
import apijson.orm.Join;
import apijson.orm.Join.On;
//import org.influxdb.InfluxDB;


/**SQL配置
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
		DEFAULT_DATABASE = DATABASE_MYSQL;  //TODO 默认数据库类型，改成你自己的。TiDB, MariaDB, OceanBase 这类兼容 MySQL 的可当做 MySQL 使用
		//	DEFAULT_NAMESPACE = "root"; //TODO 默认数据库名/模式，改成你自己的，仅对 SurrealDB: root 等数据库有效
		//	DEFAULT_CATALOG = "postgres"; //TODO 默认数据库名/模式，改成你自己的，仅对 PostgreSQL: posgres 等数据库有效
		DEFAULT_SCHEMA = "sys"; // "apijson";  //TODO 默认数据库名/模式，改成你自己的，默认情况是 MySQL: sys, PostgreSQL: sys, SQL Server: dbo, Oracle:

		// 表名和数据库不一致的，需要配置映射关系。只使用 APIJSONORM 时才需要；
		// 这个 Demo 用了 apijson-framework 且调用了 APIJSONApplication.init 则不需要
		// (间接调用 DemoVerifier.init 方法读取数据库 Access 表来替代手动输入配置)。
		// 但如果 Access 这张表的对外表名与数据库实际表名不一致，仍然需要这里注册。例如
		//		TABLE_KEY_MAP.put(Access.class.getSimpleName(), "access");

		// 表名映射，隐藏真实表名，对安全要求很高的表可以这么做
		//		TABLE_KEY_MAP.put(User.class.getSimpleName(), "apijson_user");
		//		TABLE_KEY_MAP.put(Privacy.class.getSimpleName(), "apijson_privacy");

		// 主键名映射
		SIMPLE_CALLBACK = new SimpleCallback<Long>() {

			@Override
			public AbstractSQLConfig<Long> getSQLConfig(RequestMethod method, String database, String schema, String datasource, String table) {
				return new DemoSQLConfig(method, table);
			}

			//取消注释来实现自定义各个表的主键名
			//			@Override
			//			public String getIdKey(String database, String schema, String datasource, String table) {
			//				//	return "_id"; // SurrealDB 强制用 id 作为主键名，surrealdb.java 查不到也改不了，所以需要另外加主键
			//				return StringUtil.firstCase(table + "Id");  // userId, comemntId ...
			//				//	return StringUtil.toLowerCase(t) + "_id";  // user_id, comemnt_id ...
			//				//	return StringUtil.toUpperCase(t) + "_ID";  // USER_ID, COMMENT_ID ...
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
		RAW_MAP.put("Comment:to.momentId", "`Comment__to`.`momentId`");  // 最终以 `Comment__to`.`userId` 拼接 SQL，相比以上写法可以让前端写起来更简单
		RAW_MAP.put("(`Comment`.`userId`=`to`.`userId`)", "");  // 已经是一个条件表达式了，用 () 包裹是为了避免 JSON 中的 key 拼接在前面导致 SQL 出错
		RAW_MAP.put("sum(if(userId%2=0,1,0))", "");  // 超过单个函数的 SQL 表达式
		RAW_MAP.put("sumUserIdIsEven", "sum(if(`userId`%2=0,1,0)) AS sumUserIdIsEven");  // 简化前端传参
		RAW_MAP.put("substring_index(substring_index(content,',',1),',',-1)", "");  // APIAuto 不支持 '，可以用 Postman 测
		RAW_MAP.put("substring_index(substring_index(content,'.',1),'.',-1) AS subContent", "");  // APIAuto 不支持 '，可以用 Postman 测
		RAW_MAP.put("commentWhereItem1","(`Comment`.`userId` = 38710 AND `Comment`.`momentId` = 470)");
		RAW_MAP.put("to_days(now())-to_days(`date`)<=7", "");  // 给 @having 使用
		RAW_MAP.put("sexShowStr", "CASE sex WHEN 0 THEN '男' WHEN 1 THEN '女' ELSE '其它' END");  // 给 @having 使用

		RAW_MAP.put("length(url)", "");  // APIAuto 获取分组
		RAW_MAP.put("length(substring_index(url,'/',-1))", "");  // APIAuto 获取分组
		RAW_MAP.put("length(url)-length(substring_index(url,'/',-1))-1", "");  // APIAuto 获取分组
		RAW_MAP.put("length(url) - length(substring_index(url,'/',-1)) - 1", "");  // APIAuto 获取分组
		RAW_MAP.put("substr(url,1,length(url)-length(substring_index(url,'/',-1))-1)", "");  // APIAuto 获取分组
		RAW_MAP.put("substr(url,1,length(url) - length(substring_index(url,'/',-1)) - 1)", "");  // APIAuto 获取分组
		RAW_MAP.put("substr(url,1,length(url)-length(substring_index(url,'/',-1))-1) url", "");  // APIAuto 获取分组
		RAW_MAP.put("substr(url,1,length(url) - length(substring_index(url,'/',-1)) - 1) url", "");  // APIAuto 获取分组
		RAW_MAP.put("length(substr(url,1,length(url)-length(substring_index(url,'/',-1))-1))", "");  // APIAuto 获取分组
		RAW_MAP.put("substr(url,1,length(url)-length(substring_index(url,'/',-1))-1):groupUrl", "substr(url,1,length(url)-length(substring_index(url,'/',-1))-1) `groupUrl`");  // APIAuto 获取分组
		RAW_MAP.put("ifnull(`group`,'-')", "");  // APIAuto 获取分组
		RAW_MAP.put("any_value(ifnull(`group`,'-'))", "");  // APIAuto 获取分组
		RAW_MAP.put("length(`group`)", "");  // APIAuto 获取分组
		RAW_MAP.put("length(`group`) > 0", "");  // APIAuto 获取分组
		RAW_MAP.put("CASE WHEN length(`group`) > 0 THEN `group` ELSE '-' END", "");  // APIAuto 获取分组
		RAW_MAP.put("(CASE WHEN length(`group`) > 0 THEN `group` ELSE '-' END)", "");  // APIAuto 获取分组
		RAW_MAP.put("(CASE WHEN length(`group`) > 0 THEN `group` ELSE '-' END) `name`", "");  // APIAuto 获取分组
		RAW_MAP.put("(CASE WHEN length(`group`) > 0 THEN `group` ELSE '-' END):groupName`", "(CASE WHEN length(`group`) > 0 THEN `group` ELSE '-' END) `groupName`");  // APIAuto 获取分组
		RAW_MAP.put("LIKE", "");  // UnitAuto 获取分组
		RAW_MAP.put("substr(package,2)", "");  // UnitAuto 获取分组
		RAW_MAP.put("CASE WHEN package LIKE '*%' THEN substr(package,2) ELSE package END", "");  // UnitAuto 获取分组
		RAW_MAP.put("(CASE WHEN package LIKE '*%' THEN substr(package,2) ELSE package END) `url`", "");  // UnitAuto 获取分组
		RAW_MAP.put("(CASE WHEN package LIKE '*%' THEN substr(package,2) ELSE package END) `groupUrl`", "");  // UnitAuto 获取分组
		RAW_MAP.put("(CASE WHEN package LIKE '*%' THEN substr(package,2) ELSE package END):groupUrl", "(CASE WHEN package LIKE '*%' THEN substr(package,2) ELSE package END) `groupUrl`");  // UnitAuto 获取分组
	}


	// 如果 DemoSQLExecutor.getConnection 能拿到连接池的有效 Connection，则这里不需要配置 dbVersion, dbUri, dbAccount, dbPassword

	@Override
	public String getDBVersion() {
		if (isMySQL()) {
//			return "5.7.22"; //
            return "8.0.11"; //TODO 改成你自己的 MySQL 或 PostgreSQL 数据库版本号 //MYSQL 8 和 7 使用的 JDBC 配置不一样
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
        //	if (isSQLite()) {
        //  	return "3.39.3"; //TODO 改成你自己的
        //	}
		if (isDameng()) {
			return "8.1.2.141"; //TODO 改成你自己的
		}
		if (isTDengine()) {
			return "2.6.0.8"; //TODO 改成你自己的
		}
		if (isMilvus()) {
			return "2.3.4"; //TODO 改成你自己的
		}
		//	if (isIoTDB()) {
		//		return "1.3.1"; //TODO 改成你自己的
		//	}
		if (isMongoDB()) {
			return "6.0.12"; //TODO 改成你自己的
		}
		if (isCassandra()) {
			return "4.0.1"; //TODO 改成你自己的
		}
		//	if (isDuckDB()) {
		//		return "1.1.3"; //TODO 改成你自己的
		//	}
		//	if (isSurrealDB()) {
		//		return "2.0.0"; //TODO 改成你自己的
		//	}
		//  if (isOpenGauss()) {
		// 	    return "5.0.0"; //TODO 改成你自己的
		//  }

		return null;
	}

	private String dbUri;
	public DemoSQLConfig setDBUri(String dbUri) {
		this.dbUri = dbUri;
		return this;
	}
	@JSONField(serialize = false)  // 不在日志打印 账号/密码 等敏感信息，用了 UnitAuto 则一定要加
	@Override
	public String getDBUri() {
		if (StringUtil.isNotEmpty(dbUri)) {
			return dbUri;
		}

		if (isMySQL()) {
			// 这个是 MySQL 8.0 及以上，要加 userSSL=false
//			 return "jdbc:mysql://47.122.25.116:3306?userSSL=false&serverTimezone=GMT%2B8&useUnicode=true&characterEncoding=UTF-8";
			// 以下是 MySQL 5.7 及以下
			return "jdbc:mysql://localhost:3306?serverTimezone=GMT%2B8&useUnicode=true&characterEncoding=UTF-8"; //TODO 改成你自己的，TiDB 可以当成 MySQL 使用，默认端口为 4000
		}
		if (isPostgreSQL()) { // PG JDBC 必须在 URI 传 catalog
			return "jdbc:postgresql://localhost:5432/postgres?stringtype=unspecified"; //TODO 改成你自己的
		}
		//if (isCockroachDB()) { // PG JDBC 必须在 URI 传 catalog
		//	return "jdbc:postgresql://localhost:26257/movr?sslmode=require"; //TODO 改成你自己的 brew install cockroachdb/tap/cockroach && cockroach demo
		//	//return "jdbc:postgresql://localhost:26258/postgres?sslmode=disable"; //TODO 改成你自己的 brew install cockroachdb/tap/cockroach # && start 3 nodes and init cluster
		//}
		if (isSQLServer()) {
			return "jdbc:jtds:sqlserver://localhost:1433/pubs;instance=SQLEXPRESS"; //TODO 改成你自己的
		}
		if (isOracle()) {
			return "jdbc:oracle:thin:@localhost:1521:orcl"; //TODO 改成你自己的
		}
		if (isDb2()) {
			return "jdbc:db2://localhost:50000/BLUDB"; //TODO 改成你自己的
		}
        //if (isSQLite()) {
        //    return "jdbc:sqlite:sample.db"; //TODO 改成你自己的
        //}
		if (isDameng()) {
			return "jdbc:dm://localhost:5236"; //TODO 改成你自己的
		}
		if (isTDengine()) {
			//      return "jdbc:TAOS://localhost:6030"; //TODO 改成你自己的
			return "jdbc:TAOS-RS://localhost:6041"; //TODO 改成你自己的
		}
		if (isInfluxDB()) {
			return "http://203.189.6.3:8086"; //TODO 改成你自己的
		}
		if (isMilvus()) {
			return "http://localhost:19530"; //TODO 改成你自己的
		}
		//if (isManticore()) {
		//	return "jdbc:mysql://localhost:3306?characterEncoding=utf8&maxAllowedPacket=512000"; //TODO 改成你自己的
		//}
		//	if (isIoTDB()) {
		//		return "jdbc:iotdb://localhost:6667"; // ?charset=GB18030 加参数会报错 URI 格式错误 //TODO 改成你自己的
		//	}
		if (isMongoDB()) {
			return "jdbc:mongodb://atlas-sql-6593c65c296c5865121e6ebe-xxskv.a.query.mongodb.net/myVirtualDatabase?ssl=true&authSource=admin"; //TODO 改成你自己的
		}
		if (isCassandra()) {
			return "http://localhost:7001"; //TODO 改成你自己的
		}
		//	if (isDuckDB()) {
		//		return "jdbc:duckdb:/Users/tommylemon/my_database.duckdb"; //TODO 改成你自己的
		//	}
		//	if (isSurrealDB()) {
		//		//	return "memory"; //TODO 改成你自己的
		//		//	return "surrealkv://localhost:8000"; //TODO 改成你自己的
		//		return "ws://localhost:8000"; //TODO 改成你自己的
		//	}
		//  if (isOpenGauss()) {
		//	    return "jdbc:opengauss://127.0.0.1:5432/postgres?currentSchema=" + DEFAULT_SCHEMA; //TODO 改成你自己的
		//  }

		return null;
	}

	private String dbAccount;
	public DemoSQLConfig setDBAccount(String dbAccount) {
		this.dbAccount = dbAccount;
		return this;
	}
	@JSONField(serialize = false)  // 不在日志打印 账号/密码 等敏感信息，用了 UnitAuto 则一定要加
	@Override
	public String getDBAccount() {
		if (StringUtil.isNotEmpty(dbAccount)) {
			return dbAccount;
		}

		if (isMySQL()) {
			return "root"; // ""apijson";  //TODO 改成你自己的
		}
		if (isPostgreSQL()) {
			return "postgres";  //TODO 改成你自己的
		}
		//if (isCockroachDB()) { // PG JDBC 必须在 URI 传 catalog
		//	return "demo"; //TODO 改成你自己的
		//	//return "postgres"; //TODO 改成你自己的
		//}
		if (isSQLServer()) {
			return "sa";  //TODO 改成你自己的
		}
		if (isOracle()) {
			return "scott";  //TODO 改成你自己的
		}
		if (isDb2()) {
			return "db2admin"; //TODO 改成你自己的
		}
        //if (isSQLite()) {
        //    return "root"; //TODO 改成你自己的
        //}
		if (isDameng()) {
			return "SYSDBA";
		}
		if (isTDengine()) {
			return "root"; //TODO 改成你自己的
		}
		if (isInfluxDB()) {
			return "iotos";
		}
		if (isMilvus()) {
			return "root";
		}
		//if (isManticore()) {
		//	return "root";
		//}
		//	if (isIoTDB()) {
		//		return "root";
		//	}
		if (isMongoDB()) {
			return "root"; //TODO 改成你自己的
		}
		if (isCassandra()) {
			return "root"; //TODO 改成你自己的
		}
		//	if (isDuckDB()) {
		//		return "root"; //TODO 改成你自己的
		//	}
		//	if (isSurrealDB()) {
		//		return "root"; //TODO 改成你自己的
		//	}
		//  if (isOpenGauss()) {
		//      return "postgres"; //TODO 改成你自己的
		// 	    // 不允许用初始账号，需要 CREATE USER 创建新账号并 GRANT 授权 return "opengauss"; //TODO 改成你自己的
		//  }

		return null;
	}

	private String dbPassword;
	public DemoSQLConfig setDBPassword(String dbPassword) {
		this.dbPassword = dbPassword;
		return this;
	}
	@JSONField(serialize = false)  // 不在日志打印 账号/密码 等敏感信息，用了 UnitAuto 则一定要加
	@Override
	public String getDBPassword() {
		if (StringUtil.isNotEmpty(dbPassword)) {
			return dbPassword;
		}

		if (isMySQL()) {
			return "apijson";  //TODO 改成你自己的，TiDB 可以当成 MySQL 使用， 默认密码为空字符串 ""
		}
		if (isPostgreSQL()) {
			return null;  //TODO 改成你自己的
		}
		//if (isCockroachDB()) { // PG JDBC 必须在 URI 传 catalog
		//	return "demo39865";  //TODO 改成你自己的
		//	//return null;  //TODO 改成你自己的
		//}
		if (isSQLServer()) {
			return "apijson@123";  //TODO 改成你自己的
		}
		if (isOracle()) {
			return "tiger";  //TODO 改成你自己的
		}
		if (isDb2()) {
			return "123"; //TODO 改成你自己的
		}
        //	if (isSQLite()) {
        //  	return "apijson"; //TODO 改成你自己的
        //	}
		if (isDameng()) {
			return "SYSDBA";
		}
		if (isTDengine()) {
			return "taosdata"; //TODO 改成你自己的
		}
		if (isInfluxDB()) {
			return "apijson@123"; //TODO 改成你自己的
		}
		if (isMilvus()) {
			return "apijson"; //TODO 改成你自己的
		}
		//if (isManticore()) {
		//	return null;
		//}
		//	if (isIoTDB()) {
		//		return "root";
		//	}
		if (isMongoDB()) {
			return "apijson";  //TODO 改成你自己的
		}
		if (isCassandra()) {
			return "apijson";  //TODO 改成你自己的
		}
		//	if (isDuckDB()) {
		//		return ""; //TODO 改成你自己的
		//	}
		//	if (isSurrealDB()) {
		//		return "root"; //TODO 改成你自己的
		//	}
		//  if (isOpenGauss()) {
		// 	    return "openGauss@123"; //TODO 改成你自己的
		//  }

		return null;
	}

	private String sql;
	public String getSQL() throws Exception {
		return getSQL(isPrepared());
	}
	@Override
	public String getSQL(boolean prepared) throws Exception {
		if (StringUtil.isNotEmpty(sql)) {
			return sql;
		}
		return super.getSQL(prepared);
	}

	public void setSql(String sql) {
		this.sql = sql;
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
	//
	//  其它数据库 ...


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
	protected void onGetCrossJoinString(Join join) throws UnsupportedOperationException {
		// 开启 CROSS JOIN 笛卡尔积联表  	super.onGetCrossJoinString(join);
	}
	@Override
	protected void onJoinNotRelation(String sql, String quote, Join join, String table, List<On> onList, On on) {
		// 开启 JOIN	ON t1.c1 != t2.c2 等不等式关联 	super.onJoinNotRelation(sql, quote, join, table, onList, on);
	}
	@Override
	protected void onJoinComplexRelation(String sql, String quote, Join join, String table, List<On> onList, On on) {
		// 开启 JOIN	ON t1.c1 LIKE concat('%', t2.c2, '%') 等复杂关联		super.onJoinComplexRelation(sql, quote, join, table, onList, on);
	}


	@Override
	protected int getMaxCombineCount() {
		return 10;
	}

	//	@Override
	//	public String getNamespace() {
	//		return SurrealDBUtil.getNamespace(super.getNamespace(), DEFAULT_NAMESPACE, isSurrealDB());
	//	}
	//
	//	@Override
	//	public String getSQLNamespace() {
	//		return SurrealDBUtil.getSQLNamespace(super.getSQLNamespace(), isSurrealDB());
	//	}
	//
	//	@Override
	//	public String getSchema() {
	//		return SurrealDBUtil.getSchema(super.getSchema(), DEFAULT_SCHEMA, isSurrealDB());
	////		return InfluxDBUtil.getSchema(super.getSchema(), DEFAULT_SCHEMA, isIoTDB());
	////		return IoTDBUtil.getSchema(super.getSchema(), DEFAULT_SCHEMA, isIoTDB());
	//	}
	//
	//	@Override
	//	public String getSQLSchema() {
	//		return isOpenGauss() ? "public" : super.getSQLSchema();
	//		// return SurrealDBUtil.getSQLSchema(super.getSQLSchema(), isSurrealDB());
	////		return InfluxDBUtil.getSQLSchema(super.getSQLSchema(), isIoTDB());
	////		return IoTDBUtil.getSQLSchema(super.getSQLSchema().replaceAll("-", "."), isIoTDB());
	//	}

	@Override
	public String getSQLTable() {
		String t = super.getSQLTable();
		return isInfluxDB() ? t.toLowerCase() : t;
		//	return isInfluxDB() || isIoTDB() ? t.toLowerCase() : t;
		//	return isInfluxDB() ? t.toLowerCase() : StringUtil.firstCase(JSONRequest.recoverUnderline(t, false), false);
	}

	//	@Override
	//	public String getTablePath() {
	//		return IoTDBUtil.getTablePath(super.getTablePath(), isIoTDB());
	//	}

	// 取消注释可将前端传参驼峰命名转为蛇形命名 aBCdEfg => upper ? A_B_CD_EFG : a_b_cd_efg
	//	@Override
	//	public String getSQLKey(String key) {
	//		if (DemoVerifier.SYSTEM_ACCESS_MAP.containsKey(getTable())) {
	//			return key;
	//		}
	//		return super.getSQLKey(StringUtil.firstCase(JSONRequest.recoverUnderline(key, false), false));
	//	}

}
