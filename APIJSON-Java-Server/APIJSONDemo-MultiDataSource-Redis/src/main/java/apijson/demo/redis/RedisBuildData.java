package apijson.demo.redis;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import apijson.JSONObject;
import apijson.NotNull;
import apijson.orm.SQLConfig;
import org.apache.commons.lang.StringUtils;

/***
 * 构建数据
 *
 */
public class RedisBuildData {
	//redis data type
	public static final String REDIS_TABLE_KEY = "REDIS_TABLE_"; // rediSql table prefix
	public static final String REDIS_STRING_KEY = "REDIS_STRING";
	public static final String REDIS_HASH_KEY = "REDIS_HASH";
	public static final String REDIS_LIST_KEY = "REDIS_LIST";
	public static final String REDIS_SET_KEY = "REDIS_SET";
	public static final String REDIS_ZSET_KEY = "REDIS_ZSET";
	//https://www.runoob.com/redis/redis-keys.html
	public static final String REDIS_KEYS = "REDIS_KEYS";
	
	//apijson 字段名
	//varchar
	public static final String COLUMN_KEY = "key"; // Redis的key
	//varchar
	public static final String COLUMN_VALUE = "value"; // 对应数据类型的value值
	//double
	public static final String COLUMN_SCORE = "score"; // 表示SortedSet的分值，其他数据类型为null
	//bigint
	public static final String COLUMN_EXPIRE_TIME = "expire_time"; // 跟Redis的ttl命令一致，表示数据离过期的剩余秒数
	//varchar
	public static final String OPTION_METHOD = "option_method"; // 操作方法
	//当数据是string/set类型时，这个字段没有太大意义；当数据是list/zset时，该字段表示该数据类型的下标；当数据是hash类型时，该字段表示hash数据内的key值。
	public static final String COLUMN_INDEX = "index"; 
	
	//操作方法
	//POST
	//REDIS_STRING_KEY
	public static final String OPTION_METHOD_SET = "set";
	public static final String OPTION_METHOD_MSET = "mset";
	public static final String OPTION_METHOD_MSETNX = "msetnx";
	//REDIS_LIST_KEY
	public static final String OPTION_METHOD_LPUSH = "lpush";
	public static final String OPTION_METHOD_RPUSH = "rpush";
	public static final String OPTION_METHOD_LSET = "lset";
	public static final String OPTION_METHOD_LINSERT = "linsert";
	//REDIS_HASH_KEY
	public static final String OPTION_METHOD_HSET = "hset";
	public static final String OPTION_METHOD_HSETNX = "hsetnx";
	public static final String OPTION_METHOD_HMSET = "hmset";
	
	//REDIS_SET_KEY
	public static final String OPTION_METHOD_SADD = "sadd";
	
	//REDIS_ZSET_KEY
	public static final String OPTION_METHOD_ZADD = "zadd";
	public static final String OPTION_METHOD_ZINTERSTORE = "zinterstore";
	public static final String OPTION_METHOD_ZUNIONSTORE = "zunionstore";
	
	//REDIS_KEYS
	public static final String OPTION_METHOD_EXPIRE = "expire";
	
	
	//PUT
	//REDIS_STRING_KEY
	public static final String OPTION_METHOD_APPEND = "append";
	
	//REDIS_LIST_KEY
	public static final String OPTION_METHOD_LTRIM = "ltrim";
	//REDIS_SET_KEY
	public static final String OPTION_METHOD_SMOVE = "smove";
	
	public static final String OPTION_METHOD_PERSIST = "persist";
	
	public static final String OPTION_METHOD_RENAME = "rename";
	
	//DELETE
	//REDIS_STRING_KEY
	public static final String OPTION_METHOD_DEL = "del";
	
	//REDIS_LIST_KEY
	public static final String OPTION_METHOD_LREM = "lrem";
		
	//REDIS_HASH_KEY
	public static final String OPTION_METHOD_HDEL = "hdel";
	public static final String OPTION_METHOD_HINCRBY = "hincrby";
	
	//REDIS_SET_KEY
	public static final String OPTION_METHOD_SREM = "srem";
	//REDIS_ZSET_KEY
	public static final String OPTION_METHOD_ZINCRBY = "zincrby";
	public static final String OPTION_METHOD_ZREM = "zrem";
	public static final String OPTION_METHOD_ZREMRANGEBYLEX = "zremrangeByLex";
	public static final String OPTION_METHOD_ZREMRANGEBYRANK = "zremrangeByRank";
	public static final String OPTION_METHOD_ZREMRANGEBYSCORE = "zremrangebyscore";
	
	//GET
	//REDIS_KEYS
	public static final String OPTION_METHOD_EXISTS = "exists";
	public static final String OPTION_METHOD_KEYS = "keys";
	public static final String OPTION_METHOD_TIMETOLIVE = "timeToLive";
	public static final String OPTION_METHOD_TYPE = "type";
	public static final String OPTION_METHOD_STRLEN = "strlen";
	public static final String OPTION_METHOD_SCAN = "scan";
	
	//REDIS_STRING_KEY
	public static final String OPTION_METHOD_GET = "get";
	public static final String OPTION_METHOD_INCR = "incr";
	public static final String OPTION_METHOD_DECR = "decr";
	public static final String OPTION_METHOD_INCRBY = "incrby";
	public static final String OPTION_METHOD_DECRBY = "decrby";
	public static final String OPTION_METHOD_SETEX = "setex";
	public static final String OPTION_METHOD_SETNX ="setnx";
	public static final String OPTION_METHOD_MGET = "mget";
	
	//REDIS_LIST_KEY
	public static final String OPTION_METHOD_LPOP = "lpop";
	public static final String OPTION_METHOD_RPOP = "rpop";
	public static final String OPTION_METHOD_LRANGE = "lrange";
	public static final String OPTION_METHOD_LINDEX = "lindex";
	public static final String OPTION_METHOD_LLEN = "llen";
	public static final String OPTION_METHOD_BLPOP =  "blpop";
	public static final String OPTION_METHOD_BRPOP = "brpop";
	
	//REDIS_HASH_KEY
	public static final String OPTION_METHOD_HGET = "hget";
	public static final String OPTION_METHOD_HMGET = "hmget";
	public static final String OPTION_METHOD_HGETALL = "hgetall";
	public static final String OPTION_METHOD_HEXISTS = "hexists";
	public static final String OPTION_METHOD_HKEYS = "hkeys";
	public static final String OPTION_METHOD_HVALS = "hvals";
	public static final String OPTION_METHOD_HLEN = "hlen";
	public static final String OPTION_METHOD_HSCAN = "hscan";
	
	//REDIS_SET_KEY
	public static final String OPTION_METHOD_SMEMBERS = "smembers";
	public static final String OPTION_METHOD_SISMEMBER =  "sismember";
	public static final String OPTION_METHOD_SCARD = "scard";
	public static final String OPTION_METHOD_SRANDMEMBER = "srandmember";
	public static final String OPTION_METHOD_SPOP = "spop";
	public static final String OPTION_METHOD_SINTER = "sinter";
	public static final String OPTION_METHOD_SUNION = "sunion";
	public static final String OPTION_METHOD_SDIFF = "sdiff";
	public static final String OPTION_METHOD_SSCAN = "sscan";
	
	//REDIS_ZSET_KEY
	public static final String OPTION_METHOD_ZCARD = "zcard";
	public static final String OPTION_METHOD_ZCOUNT = "zcount";
	public static final String OPTION_METHOD_ZLEXCOUNT = "zlexcount";
	public static final String OPTION_METHOD_ZRANGE = "zrange";
	public static final String OPTION_METHOD_ZRANGEBYSCORE = "zrangeByScore";
	public static final String OPTION_METHOD_ZRANGEBYLEX = "zrangeByLex";
	public static final String OPTION_METHOD_ZRANK = "zrank";
	public static final String OPTION_METHOD_ZREVRANGE = "zrevrange";
	public static final String OPTION_METHOD_ZREVRANGEBYSCORE = "zrevrangeByScore";
	public static final String OPTION_METHOD_ZREVRANK = "zrevrank";
	public static final String OPTION_METHOD_ZSCORE = "zscore";
	public static final String OPTION_METHOD_ZSCAN = "zscan";
	
	
	public static Map<String, Object> buidData(@NotNull SQLConfig config) {
		Map<String, Object> dataMap = new HashMap<>();
		switch (config.getMethod()) {
		case POST:
			List<String> column = config.getColumn();
			for (int i = 0; i < column.size(); i++) {
				String col = column.get(i);
				List<List<Object>> values = config.getValues();
				for (List<Object> list : values) {
					Object data = list.get(i);
					dataMap.put(col, data);
				}
			}
			return dataMap;
		case PUT:
			dataMap.putAll(config.getContent());
			dataMap.putAll(config.getWhere());
			return dataMap;
		case DELETE:
			return config.getWhere();
		default:
			return dataMap;
		}
	}

	@SuppressWarnings("unchecked")
	public <T> T getStringData(Class<T> clazz,String json){
		if (StringUtils.isBlank(json)){
			return null;
		}
		if (clazz.equals(String.class) || clazz.equals(Object.class)){
			return (T) json;
		}
		return JSONObject.parseObject(json, clazz);
	}
}
