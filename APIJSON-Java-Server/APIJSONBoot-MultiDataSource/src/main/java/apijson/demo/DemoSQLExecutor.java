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

import apijson.*;
import apijson.boot.DemoApplication;
//import apijson.cassandra.CassandraUtil;
import apijson.framework.APIJSONSQLExecutor;
//import apijson.influxdb.InfluxDBUtil;
//import apijson.milvus.MilvusUtil;
//import apijson.mongodb.MongoUtil;
//import apijson.iotdb.IoTDBUtil;
import apijson.orm.SQLConfig;
//import apijson.surrealdb.SurrealDBUtil;
import com.alibaba.druid.pool.DruidDataSource;
import com.alibaba.fastjson.JSONObject;
//import org.duckdb.JsonNode;
import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericToStringSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;

import javax.sql.DataSource;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import static apijson.demo.DemoSQLConfig.DATABASE_MILVUS;
import static apijson.framework.APIJSONConstant.PRIVACY_;
import static apijson.framework.APIJSONConstant.USER_;


/**
 * SQL 执行器，支持连接池及多数据源
 * 具体见 https://github.com/Tencent/APIJSON/issues/151
 *
 * @author Lemon
 */
public class DemoSQLExecutor extends APIJSONSQLExecutor<Long> {
    public static final String TAG = "DemoSQLExecutor";

    // Redis 缓存 <<<<<<<<<<<<<<<<<<<<<<<
    public static final RedisTemplate<String, String> REDIS_TEMPLATE;
    static {
        REDIS_TEMPLATE = new RedisTemplate<>();
        try {
            REDIS_TEMPLATE.setConnectionFactory(new JedisConnectionFactory(new RedisStandaloneConfiguration("127.0.0.1", 6379)));
            REDIS_TEMPLATE.setKeySerializer(new StringRedisSerializer());
            REDIS_TEMPLATE.setHashValueSerializer(new GenericToStringSerializer<>(Serializable.class));
            REDIS_TEMPLATE.setValueSerializer(new GenericToStringSerializer<>(Serializable.class));
            //    REDIS_TEMPLATE.setValueSerializer(new FastJsonRedisSerializer<List<JSONObject>>(List.class));
            REDIS_TEMPLATE.afterPropertiesSet();
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    //  可重写以下方法，支持 Redis 等单机全局缓存或分布式缓存
    @Override
    public List<JSONObject> getCache(String sql, SQLConfig<Long> config) {
        List<JSONObject> list = super.getCache(sql, config);
        if (list == null) {
            try {
                list = JSON.parseArray(REDIS_TEMPLATE.opsForValue().get(sql), JSONObject.class);
            } catch (Throwable e) {
                e.printStackTrace();
            }
        }
        return list;
    }

    @Override
    public synchronized void putCache(String sql, List<JSONObject> list, SQLConfig<Long> config) {
        super.putCache(sql, list, config);

        String table = config != null && config.isMain() ? config.getTable() : null;
        if (table != null && ! DemoSQLConfig.CONFIG_TABLE_LIST.contains(table)) {
            try {
                if (config.isExplain() || RequestMethod.isHeadMethod(config.getMethod(), true)) {
                    REDIS_TEMPLATE.opsForValue().set(sql, JSON.toJSONString(list), 10 * 60, TimeUnit.SECONDS);
                } else {
                    REDIS_TEMPLATE.opsForValue().set(sql, JSON.toJSONString(list), USER_.equals(table) || PRIVACY_.equals(table) ? 10 * 60 : 60, TimeUnit.SECONDS);
                }
            } catch (Throwable e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public synchronized void removeCache(String sql, SQLConfig<Long> config) {
        super.removeCache(sql, config);
        try {
            if (config.getMethod() == RequestMethod.DELETE) { // 避免缓存击穿
                REDIS_TEMPLATE.expire(sql, 60, TimeUnit.SECONDS);
            } else {
                REDIS_TEMPLATE.delete(sql);
            }
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    // Redis 缓存 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    public static final String DATABASE_NEBULA = "NEBULA";

    // 适配连接池，如果这里能拿到连接池的有效 Connection，则 SQLConfig<Long> 不需要配置 dbVersion, dbUri, dbAccount, dbPassword
    @Override
    public Connection getConnection(SQLConfig<Long> config) throws Exception {
//        if (DATABASE_NEBULA.equals(config.getDatabase())) {  // 3.0.0 及以下要这样连接
//            String uri = config.getDBUri();
//
//            int start = uri.indexOf("://");
//            String prefix = uri.substring(0, start);
//
//            uri = uri.substring(start + "://".length());
//            int end = uri.indexOf("/");
//            String space = uri.substring(end + 1);
//
//            Properties props = new Properties();
//            props.put("url", prefix + "://" + space);
//            props.put("graphSpace", space);
//
//            NebulaDriver driver = new NebulaDriver(uri.substring(0, end));
//            return driver.connect(prefix + "://" + space, props);
//            //    return DriverManager.getConnection("jdbc:nebula://JDBC_TEST_SPACE", "root", "nebula");
//        }

        String datasource = config.getDatasource();
        Log.d(TAG, "getConnection  config.getDatasource() = " + datasource);

        String key = datasource + "-" + config.getDatabase();
        Connection c = connectionMap.get(key);
        if (datasource != null && (c == null || c.isClosed())) {
            try {
                DataSource ds;
                switch (datasource) {
//                    case "HIKARICP":
//                        ds = DemoApplication.getApplicationContext().getBean(HikariDataSource.class);
//                        // 另一种方式是 DemoDataSourceConfig 初始化获取到 DataSource 后给静态变量 DATA_SOURCE_HIKARICP 赋值： ds = DemoDataSourceConfig.DATA_SOURCE_HIKARICP.getConnection();
//                        break;
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

    @Override
    public JSONObject execute(@NotNull SQLConfig<Long> config, boolean unknownType) throws Exception {
        boolean isMilvus = config.isMilvus(); // DATABASE_MILVUS.equals(config.getDatabase()); // APIJSON 6.4.0+ 可用 config.isMilvus();
        boolean isCassandra = config.isCassandra(); // DemoSQLConfig.DATABASE_CASSANDRA.equals(config.getDatabase());
        boolean isInfluxDB = config.isInfluxDB(); // DemoSQLConfig.DATABASE_INFLUXDB.equals(config.getDatabase());
        // boolean isIoTDB = config.isIoTDB(); // DemoSQLConfig.DATABASE_IOTDB.equals(config.getDatabase());
        // boolean isSurrealDB = config.isSurrealDB(); // DemoSQLConfig.DATABASE_SURREALDB.equals(config.getDatabase());

        if (isMilvus || isCassandra || isInfluxDB) { // || isIoTDB || isSurrealDB) {
            // TODO 把 execute 内与缓存无关只与数据库读写逻辑相关的代码抽取到 executeSQL 函数
            String sql = config.getSQL(false); // config.isPrepared());
            if (sql != null && config.getMethod() == null) {
                String trimmedSQL = sql.trim();
                String sqlPrefix = trimmedSQL.length() < 7 ? "" : trimmedSQL.substring(0, 7).toUpperCase();
                if (sqlPrefix.startsWith("INSERT ")) {
                    config.setMethod(RequestMethod.POST);
                }
                else if (sqlPrefix.startsWith("UPDATE ")) {
                    config.setMethod(RequestMethod.PUT);
                }
                else if (sqlPrefix.startsWith("DELETE ")) {
                    config.setMethod(RequestMethod.DELETE);
                }
            }

            boolean isWrite = ! RequestMethod.isQueryMethod(config.getMethod());

            List<JSONObject> cache = isWrite ? null : getCache(sql, config);
            int position = config.getPosition();
            JSONObject result = getCacheItem(cache, position, config);
            if (result != null) {
                if (position == 0 && cache != null && cache.size() > 1) {
                    result.put(KEY_RAW_LIST, cache);
                }
                return result;
            }


            List<JSONObject> resultList = new ArrayList<>();

//            if (isMilvus) {
//                if (isWrite) {
//                    return MilvusUtil.executeUpdate(config, sql);
//                }
//
//                resultList = MilvusUtil.executeQuery(config, sql, unknownType);
//            }
//            else if (isCassandra) {
//                if (isWrite) {
//                    return CassandraUtil.executeUpdate(config, sql);
//                }
//
//                resultList = CassandraUtil.executeQuery(config, sql, unknownType);
//            }
//            else if (isInfluxDB) {
//                if (isWrite) {
//                    return InfluxDBUtil.executeUpdate(config, sql);
//                }
//
//                resultList = InfluxDBUtil.executeQuery(config, sql, unknownType);
//            }
//            else if (isIoTDB) {
//                if (isWrite) {
//                    return IoTDBUtil.executeUpdate(config, sql);
//                }
//
//                resultList = IoTDBUtil.executeQuery(config, sql, unknownType);
//            }
//            else if (isSurrealDB) {
//                if (isWrite) {
//                    return SurrealDBUtil.executeUpdate(config, sql);
//                }
//
//                resultList = SurrealDBUtil.executeQuery(config, sql, unknownType);
//            }

            // TODO 把 execute 内与缓存无关只与数据库读写逻辑相关的代码抽取到 executeSQL 函数
            result = resultList.isEmpty() ? new JSONObject() : resultList.get(0);
            if (resultList.size() > 1) {
                result.put(KEY_RAW_LIST, resultList);
            }

            putCache(sql, resultList, config);

            return result;
        }

        return super.execute(config, unknownType);
    }

    @Override
    public void close() {
        super.close();

//        MilvusUtil.closeAllClient();
//        CassandraUtil.closeAllSession();
//        InfluxDBUtil.closeAllClient();
    }

    // 不需要隐藏字段这个功能时，取消注释来提升性能
    //	@Override
    //	protected boolean isHideColumn(SQLConfig<Long> config, java.sql.ResultSet rs, ResultSetMetaData rsmd, int tablePosition,
    //			JSONObject table, int columnIndex, Map<String, JSONObject> childMap) throws SQLException {
    //		return false;
    //	}

    // 取消注释可将前端传参驼峰命名转为蛇形命名 aBCdEfg => upper ? A_B_CD_EFG : a_b_cd_efg
    //    @Override
    //    protected String getKey(SQLConfig<Long> config, java.sql.ResultSet rs, ResultSetMetaData rsmd, int tablePosition, JSONObject table, int columnIndex, Map<String, JSONObject> childMap) throws Exception {
    //        String key = super.getKey(config, rs, rsmd, tablePosition, table, columnIndex, childMap);
    //        String tbl = StringUtil.firstCase(JSONResponse.formatUnderline(rsmd.getTableName(columnIndex), true), true);
    //        if (DemoVerifier.SYSTEM_ACCESS_MAP.containsKey(tbl)) {
    //            return key;
    //        }
    //        return StringUtil.firstCase(JSONResponse.formatUnderline(key, true), false);
    //    }


//    @Override
//    protected Object getValue(SQLConfig<Long> config, ResultSet rs, ResultSetMetaData rsmd, int tablePosition, JSONObject table, int columnIndex, String lable, Map<String, JSONObject> childMap) throws Exception {
//        Object v = super.getValue(config, rs, rsmd, tablePosition, table, columnIndex, lable, childMap);
////        if (v instanceof JsonNode) { // DuckDB json 类型需要转换
////            JsonNode jn = (JsonNode) v;
////            v = jn.isNull() ? null : JSON.parse(jn.toString());
////        }
//        return v; // MongoUtil.getValue(v);
//    }
}
