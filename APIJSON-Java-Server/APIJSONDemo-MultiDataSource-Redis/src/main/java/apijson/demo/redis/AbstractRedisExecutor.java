package apijson.demo.redis;

import java.util.List;
import java.util.Map;
import java.util.Set;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.ListPosition;
import redis.clients.jedis.ScanParams;
import redis.clients.jedis.ScanResult;
import redis.clients.jedis.Tuple;

public abstract class AbstractRedisExecutor implements RedisExecutor {

	@Override
	public void close(Jedis jedis) {
		if (jedis != null) {
			jedis.close();
		}
	}

	private String ok_returns(RediSQLCommand.ModuleCommand cmd, String... args) {
		Jedis jedis = null;
		try {
			jedis = getJedis(args[0]);
			jedis.getClient().sendCommand(cmd, args);
			return jedis.getClient().getBulkReply();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	private List<Object> list_returns(RediSQLCommand.ModuleCommand cmd, String... args) {
		Jedis jedis = null;
		try {
			jedis = getJedis(args[0]);
			jedis.getClient().sendCommand(cmd, args);
			return jedis.getClient().getObjectMultiBulkReply();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	@Override
	public void delDB(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			jedis.del(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
	}

	@Override
	public String create_db(String db) {
		return ok_returns(RediSQLCommand.ModuleCommand.CREATE_DB, db);
	}

	@Override
	public String create_db(String db, String file_path) {
		return ok_returns(RediSQLCommand.ModuleCommand.CREATE_DB, db, file_path);
	}

	@Override
	public List<Object> exec(String db, String query) {
		return list_returns(RediSQLCommand.ModuleCommand.EXEC, db, query);
	}

	@Override
	public List<Object> exec_now(String db, String query) {
		return list_returns(RediSQLCommand.ModuleCommand.EXEC_NOW, db, query);
	}

	@Override
	public List<Object> query(String db, String query) {
		return list_returns(RediSQLCommand.ModuleCommand.QUERY, db, query);
	}

	@Override
	public List<Object> query_now(String db, String query) {
		return list_returns(RediSQLCommand.ModuleCommand.QUERY_NOW, db, query);
	}

	@Override
	public List<Object> query_into(String stream, String db, String query) {
		return list_returns(RediSQLCommand.ModuleCommand.QUERY_INTO, stream, db, query);
	}

	@Override
	public List<Object> query_into_now(String stream, String db, String query) {
		return list_returns(RediSQLCommand.ModuleCommand.QUERY_INTO_NOW, stream, db, query);
	}

	@Override
	public String create_statement(String db, String stmt_name, String stmt_query) {
		return ok_returns(RediSQLCommand.ModuleCommand.CREATE_STATEMENT, db, stmt_name, stmt_query);
	}

	@Override
	public String create_statement_now(String db, String stmt_name, String stmt_query) {
		return ok_returns(RediSQLCommand.ModuleCommand.CREATE_STATEMENT_NOW, db, stmt_name, stmt_query);
	}

	@Override
	public List<Object> exec_statement(String... args) {
		return list_returns(RediSQLCommand.ModuleCommand.EXEC_STATEMENT, args);
	}

	@Override
	public List<Object> exec_statement_now(String... args) {
		return list_returns(RediSQLCommand.ModuleCommand.EXEC_STATEMENT_NOW, args);
	}

	@Override
	public List<Object> query_statement(String... args) {
		return list_returns(RediSQLCommand.ModuleCommand.QUERY_STATEMENT, args);
	}

	@Override
	public List<Object> query_statement_now(String... args) {
		return list_returns(RediSQLCommand.ModuleCommand.QUERY_STATEMENT_NOW, args);
	}

	@Override
	public List<Object> query_statement_into(String... args) {
		return list_returns(RediSQLCommand.ModuleCommand.QUERY_STATEMENT_INTO, args);
	}

	@Override
	public List<Object> query_statement_into_now(String... args) {
		return list_returns(RediSQLCommand.ModuleCommand.QUERY_STATEMENT_INTO_NOW, args);
	}

	@Override
	public String delete_statement(String db, String stmt_name) {
		return ok_returns(RediSQLCommand.ModuleCommand.DELETE_STATEMENT, db, stmt_name);
	}

	@Override
	public String delete_statement_now(String db, String stmt_name) {
		return ok_returns(RediSQLCommand.ModuleCommand.DELETE_STATEMENT_NOW, db, stmt_name);
	}

	@Override
	public String update_statement(String db, String stmt_name, String stmt_query) {
		return ok_returns(RediSQLCommand.ModuleCommand.UPDATE_STATEMENT, db, stmt_name, stmt_query);
	}

	@Override
	public String update_statement_now(String db, String stmt_name, String stmt_query) {
		return ok_returns(RediSQLCommand.ModuleCommand.UPDATE_STATEMENT_NOW, db, stmt_name, stmt_query);
	}

	@Override
	public String copy(String db1, String db2) {
		return ok_returns(RediSQLCommand.ModuleCommand.COPY, db1, db2);
	}

	@Override
	public String copy_now(String db1, String db2) {
		return ok_returns(RediSQLCommand.ModuleCommand.COPY_NOW, db1, db2);
	}

	@Override
	public List<Object> statistics() {
		return list_returns(RediSQLCommand.ModuleCommand.STATISTICS);
	}

	@Override
	public String version() {
		return ok_returns(RediSQLCommand.ModuleCommand.VERSION);
	}

	@Override
	public List<Object> crudBySearch(String db, String sql) throws Exception {
		return exec(db, sql);
	}

	@Override
	public Long crudByUpdate(String db, String sql) throws Exception {
		List<Object> retObj = exec(db, sql);
		return ParseRediSQLReply.how_many_done(retObj);
	}

	/* ######################## key的操作 ################################ */

	/**
	 * 根据pattern返回当前库中的key
	 *
	 * @param pattern
	 * @return
	 */
	@Override
	public Set<String> keys(String pattern) {
		Jedis jedis = null;
		try {
			jedis = getJedis(null);
			return jedis.keys(pattern);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 删除一个或多个key
	 *
	 * @param key 一个或多个key
	 */
	@Override
	public Long del(String... key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key[0]);
			return jedis.del(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 判断某个key是否存在
	 *
	 * @param key key
	 * @return
	 */
	@Override
	public Boolean exists(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.exists(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 设置某个key的过期时间，单位秒
	 *
	 * @param key     key
	 * @param seconds 过期时间秒
	 */
	@Override
	public Long expire(String key, Long seconds) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.expire(key, seconds);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/***
	 * 移除给定 key 的过期时间，使得 key 永不过期
	 * 
	 * @param key
	 * @return
	 */
	@Override
	public Long persist(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.persist(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 查看某个key还有几秒过期，-1表示永不过期 ，-2表示已过期
	 *
	 * @param key key
	 * @return
	 */
	@Override
	public Long timeToLive(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.ttl(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	@Override
	public String rename(String key, String newKey) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.rename(key, newKey);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 查看某个key对应的value的类型
	 *
	 * @param key
	 * @return
	 */
	@Override
	public String type(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.type(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	@Override
	public ScanResult<String> scan(String cursor, ScanParams scanParams) {
		Jedis jedis = null;
		try {
			jedis = getJedis(null);
			return jedis.scan(cursor, scanParams);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/* ######################## string(字符串)的操作 #################### */

	/**
	 * 获取某个key的value，类型要对，只能value是string的才能获取
	 *
	 * @param key
	 * @return
	 */
	@Override
	public String get(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.get(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 获取多个key的value，类型要对，只能value是string的才能获取
	 *
	 * @param key
	 * @return
	 */
	@Override
	public List<String> mget(String... key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key[0]);
			return jedis.mget(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 设置某个key的value
	 *
	 * @param key
	 * @param value
	 */
	@Override
	public String set(String key, String value) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.set(key, value);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	@Override
	public String mset(String... keysvalues) {
		Jedis jedis = null;
		try {
			jedis = getJedis(keysvalues[0]);
			return jedis.mset(keysvalues);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	@Override
	public String msetnx(String... keysvalues) {
		Jedis jedis = null;
		try {
			jedis = getJedis(keysvalues[0]);
			return jedis.mset(keysvalues);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 字符串后追加内容
	 *
	 * @param key           key
	 * @param appendContent 要追加的内容
	 */
	@Override
	public Long append(String key, String appendContent) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.append(key, appendContent);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 返回key的value的长度
	 *
	 * @param key
	 * @return
	 */
	@Override
	public Long strlen(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.strlen(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * value 加1 必 须是字符型数字
	 * 
	 * @param key
	 * @return 增加后的值
	 */
	@Override
	public Long incr(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.incr(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * value 减1 必须是字符型数字
	 *
	 * @param key
	 * @return
	 */
	@Override
	public Long decr(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.decr(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * value 加increment
	 *
	 * @param key       key
	 * @param increment 加几
	 * @return
	 */
	@Override
	public Long incrby(String key, int increment) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.incrBy(key, increment);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * value 减increment
	 *
	 * @param key
	 * @param increment
	 * @return
	 */
	@Override
	public Long decrby(String key, int increment) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.decrBy(key, increment);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 给某个key设置过期时间和value，成功返回OK
	 *
	 * @param key     key
	 * @param seconds 过期时间秒
	 * @param value   设置的值
	 * @return
	 */
	@Override
	public String setex(String key, int seconds, String value) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.setex(key, seconds, value);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/* ######################## list(列表)的操作 ####################### */
	// lpush rpush lpop rpop lrange lindex llen lset lrem

	/**
	 * 从左边向列表中添加值
	 *
	 * @param key key
	 * @param str 要添加的值
	 */
	@Override
	public Long lpush(String key, String... str) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.lpush(key, str);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 从右边向列表中添加值
	 *
	 * @param key key
	 * @param str 要添加的值
	 */
	@Override
	public Long rpush(String key, String... str) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.rpush(key, str);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 从左边取出一个列表中的值
	 *
	 * @param key
	 * @return
	 */
	@Override
	public String lpop(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.lpop(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 从右边取出一个列表中的值
	 *
	 * @param key
	 * @return
	 */
	@Override
	public String rpop(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.rpop(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 取出列表中指定范围内的值，0 到 -1 表示全部
	 *
	 * @param key
	 * @param startIndex
	 * @param endIndex
	 * @return
	 */
	@Override
	public List<String> lrange(String key, int startIndex, int endIndex) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.lrange(key, startIndex, endIndex);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 返回某列表指定索引位置的值
	 *
	 * @param key   列表key
	 * @param index 索引位置
	 * @return
	 */
	@Override
	public String lindex(String key, int index) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.lindex(key, index);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 返回某列表的长度
	 *
	 * @param key
	 * @return
	 */
	@Override
	public Long llen(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.llen(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 给某列表指定位置设置为指定的值
	 *
	 * @param key
	 * @param index
	 * @param str
	 */
	@Override
	public String lset(String key, Long index, String str) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.lset(key, index, str);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	@Override
	public Long linsert(final String key, final ListPosition where, final String pivot, final String value) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.linsert(key, where, pivot, value);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 对列表进行剪裁，保留指定闭区间的元素(索引位置也会重排)
	 * 
	 * @param key        列表key
	 * @param startIndex 开始索引位置
	 * @param endIndex   结束索引位置
	 */
	@Override
	public String ltrim(String key, Integer startIndex, Integer endIndex) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.ltrim(key, startIndex, endIndex);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 从列表的左边阻塞弹出一个元素
	 * 
	 * @param key     列表的key
	 * @param timeout 阻塞超时时间，0表示若没有元素就永久阻塞
	 * @return
	 */
	@Override
	public List<String> blpop(String key, Integer timeout) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.blpop(timeout, key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 从列表的右边阻塞弹出一个元素
	 * 
	 * @param key     列表的key
	 * @param timeout 阻塞超时时间，0表示若没有元素就永久阻塞
	 * @return
	 */
	@Override
	public List<String> brpop(String key, Integer timeout) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.brpop(timeout, key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 移除列表元素
	 * 
	 * @param key
	 * @param index
	 * @param str
	 */
	@Override
	public Long lrem(String key, Long count, String value) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.lrem(key, count, value);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/* ######################## hash(哈希表)的操作 ####################### */
	// hset hget hmset hmget hgetall hdel hkeys hvals hexists hincrby

	/**
	 * 给某个hash表设置一个键值对
	 *
	 * @param key
	 * @param field
	 * @param value
	 */
	@Override
	public Long hset(String key, String field, String value) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.hset(key, field, value);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	@Override
	public Long hsetnx(String key, String field, String value) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.hsetnx(key, field, value);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 取出某个hash表中某个field对应的value
	 *
	 * @param key   key
	 * @param field field
	 * @return
	 */
	@Override
	public String hget(String key, String field) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.hget(key, field);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 某个hash表设置一个或多个键值对
	 * 
	 * @param key
	 * @param kvMap
	 */
	@Override
	public String hmset(String key, Map<String, String> kvMap) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.hmset(key, kvMap);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 取出某个hash表中任意多个key对应的value的集合
	 *
	 * @param key
	 * @param fields
	 * @return
	 */
	@Override
	public List<String> hmget(String key, String... fields) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.hmget(key, fields);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 取出某个hash表中所有的键值对
	 *
	 * @param key
	 * @return
	 */
	@Override
	public Map<String, String> hgetall(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.hgetAll(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 判断某个hash表中的某个key是否存在
	 *
	 * @param key
	 * @param field
	 * @return
	 */
	@Override
	public Boolean hexists(String key, String field) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.hexists(key, field);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 返回某个hash表中所有的key
	 *
	 * @param key
	 * @return
	 */
	@Override
	public Set<String> hkeys(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.hkeys(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 返回某个hash表中所有的value
	 *
	 * @param key
	 * @return
	 */
	@Override
	public List<String> hvals(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.hvals(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	@Override
	public Long hlen(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.hlen(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 删除某个hash表中的一个或多个键值对
	 *
	 * @param key
	 * @param fields
	 */
	@Override
	public Long hdel(String key, String... fields) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.hdel(key, fields);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 给某个hash表中的某个field的value增加多少
	 *
	 * @param key       hash表的key
	 * @param field     表中的某个field
	 * @param increment 增加多少
	 * @return
	 */
	@Override
	public Long hincrby(String key, String field, Long increment) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.hincrBy(key, field, increment);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	@Override
	public ScanResult<Map.Entry<String,String>> hscan(String key, String cursor) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.hscan(key, cursor);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}
	
	/* ######################## set(集合)的操作 ########################### */

	/**
	 * 往set集合中添加一个或多个元素
	 * 
	 * @param key     key
	 * @param members 要添加的元素
	 * @return 添加成功的元素个数
	 */
	@Override
	public Long sadd(String key, String... members) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.sadd(key, members);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 返回set集合中的所有元素，顺序与加入时的顺序一致
	 * 
	 * @param key key
	 * @return
	 */
	@Override
	public Set<String> smembers(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.smembers(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 判断集合中是否存在某个元素
	 * 
	 * @param key    key
	 * @param member 某个元素
	 * @return true存在，false不存在
	 */
	@Override
	public Boolean sismember(String key, String member) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.sismember(key, member);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 返回set集合的长度
	 * 
	 * @param key key
	 * @return
	 */
	@Override
	public Long scard(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.scard(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 删除set集合中指定的一个或多个元素
	 * 
	 * @param key
	 * @param members 要删除的元素
	 * @return 删除成功的元素个数
	 */
	@Override
	public Long srem(String key, String... members) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.srem(key, members);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 将key1中的元素key1Member移动到key2中
	 * 
	 * @param key1       来源集合key
	 * @param key2       目的地集合key
	 * @param key1Member key1中的元素
	 * @return 1成功，0失败
	 */
	@Override
	public Long smove(String key1, String key2, String key1Member) {
		Jedis jedis = null;
		try {
			jedis = getJedis(null);
			return jedis.smove(key1, key2, key1Member);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 随机查询返回集合中的指定个数的元素（若count为负数，返回的元素可能会重复）
	 * 
	 * @param key   key
	 * @param count 要查询返回的元素个数
	 * @return 元素list集合
	 */
	@Override
	public List<String> srandmember(String key, int count) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.srandmember(key, count);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 从set集合中随机弹出指定个数个元素
	 * 
	 * @param key   key
	 * @param count 要弹出的个数
	 * @return 随机弹出的元素
	 */
	@Override
	public Set<String> spop(String key, int count) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.spop(key, count);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 求交集，返回多个set集合相交的部分
	 * 
	 * @param setKeys 多个set集合的key
	 * @return 相交的元素集合
	 */
	@Override
	public Set<String> sinter(String... setKeys) {
		Jedis jedis = null;
		try {
			jedis = getJedis(null);
			return jedis.sinter(setKeys);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 求并集，求几个set集合的并集（因为set中不会有重复的元素，合并后的集合也不会有重复的元素）
	 * 
	 * @param setKeys 多个set的key
	 * @return 合并后的集合
	 */
	@Override
	public Set<String> sunion(String... setKeys) {
		Jedis jedis = null;
		try {
			jedis = getJedis(null);
			return jedis.sunion(setKeys);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 求差集，求几个集合之间的差集
	 * 
	 * @param setKeys 多个set的key
	 * @return 差集
	 */
	@Override
	public Set<String> sdiff(String... setKeys) {
		Jedis jedis = null;
		try {
			jedis = getJedis(null);
			return jedis.sdiff(setKeys);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}
	
	@Override
	public ScanResult<String> sscan(String key, String cursor) {
		Jedis jedis = null;
		try {
			jedis = getJedis(null);
			return jedis.sscan(key, cursor);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}
	/* ######################## zset(有序集合)的操作 ####################### */

	/**
	 * 添加一个元素到zset
	 * 
	 * @param key    key
	 * @param score  元素的分数
	 * @param member 元素
	 * @return 成功添加的元素个数
	 */
	@Override
	public Long zadd(String key, double score, String member) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zadd(key, score, member);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	@Override
	public Long zadd(String key, Map<String, Double> scoreMembers) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zadd(key, scoreMembers);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 获取有序集合的成员数
	 * 
	 * @param key key
	 * @return
	 */
	@Override
	public Long zcard(String key) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zcard(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 计算在有序集合中指定区间分数的成员数
	 * 
	 * @param key
	 * @param min
	 * @param max
	 * @return
	 */
	@Override
	public Long zcount(String key, double min, double max) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zcount(key, min, max);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 有序集合中对指定成员的分数加上增量 increment
	 * 
	 * @param key
	 * @param increment
	 * @param member
	 * @return
	 */
	@Override
	public Double zincrby(String key, double increment, String member) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zincrby(key, increment, member);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 计算给定的一个或多个有序集的交集并将结果集存储在新的有序集合 destination 中
	 * 
	 * @param dstkey
	 * @param sets
	 * @return
	 */
	@Override
	public Long zinterstore(String dstkey, String... sets) {
		Jedis jedis = null;
		try {
			jedis = getJedis(null);
			return jedis.zinterstore(dstkey, sets);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 在有序集合中计算指定字典区间内成员数量
	 * 
	 * @param key
	 * @param min
	 * @param max
	 * @return
	 */
	@Override
	public Long zlexcount(String key, String min, String max) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zlexcount(key, min, max);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 通过索引区间返回有序集合指定区间内的成员
	 * 
	 * @param key
	 * @param min
	 * @param max
	 * @return
	 */
	@Override
	public Set<String> zrange(String key, Long start, Long stop) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zrange(key, start, stop);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 通过索引区间返回有序集合指定区间内的成员
	 * 
	 * @param key
	 * @param min
	 * @param max
	 * @return
	 */
	@Override
	public Set<String> zrangeByScore(String key, double min, double max) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zrangeByScore(key, min, max);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/***
	 * 通过字典区间返回有序集合的成员
	 * 
	 * @param key
	 * @param min
	 * @param max
	 * @return
	 */
	@Override
	public Set<String> zrangeByLex(String key, String min, String max) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zrangeByLex(key, min, max);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 返回有序集合中指定成员的索引
	 * 
	 * @param key
	 * @param member
	 * @return
	 */
	@Override
	public Long zrank(String key, String member) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zrank(key, member);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 
	 * @param key
	 * @param values
	 * @return
	 */
	@Override
	public Long zrem(String key, String... members) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zrem(key, members);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 移除有序集合中给定的字典区间的所有成员
	 * 
	 * @param key
	 * @param min
	 * @param max
	 * @return
	 */
	@Override
	public Long zremrangeByLex(String key, String min, String max) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zremrangeByLex(key, min, max);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 移除有序集合中给定的排名区间的所有成员
	 * 
	 * @param key
	 * @param start
	 * @param stop
	 * @return
	 */
	@Override
	public Long zremrangeByRank(String key, Long start, Long stop) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zremrangeByRank(key, start, stop);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 移除有序集合中给定的分数区间的所有成员
	 * 
	 * @param key
	 * @param min
	 * @param max
	 * @return
	 */
	@Override
	public Long zremrangebyscore(String key, double min, double max) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zremrangeByScore(key, min, max);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 返回有序集中指定区间内的成员，通过索引，分数从高到低
	 * 
	 * @param key
	 * @param start
	 * @param stop
	 * @return
	 */
	@Override
	public Set<String> zrevrange(String key, Long start, Long stop) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zrevrange(key, start, stop);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 返回有序集中指定分数区间内的成员，分数从高到低排序
	 * 
	 * @param key
	 * @param min
	 * @param max
	 * @return
	 */
	@Override
	public Set<String> zrevrangeByScore(String key, double min, double max) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zrevrangeByScore(key, min, max);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 返回有序集合中指定成员的排名，有序集成员按分数值递减(从大到小)排序
	 * 
	 * @param key
	 * @param member
	 * @return
	 */
	@Override
	public Long zrevrank(String key, String member) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zrevrank(key, member);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 返回有序集中，成员的分数值
	 * 
	 * @param key
	 * @param value
	 * @return
	 */
	@Override
	public Double zscore(String key, String value) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zscore(key, value);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 计算给定的一个或多个有序集的并集，并存储在新的 key 中
	 * 
	 * @param dstkey
	 * @param sets
	 * @return
	 */
	@Override
	public Long zunionstore(String dstkey, String... sets) {
		Jedis jedis = null;
		try {
			jedis = getJedis(null);
			return jedis.zunionstore(dstkey, sets);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 迭代有序集合中的元素（包括元素成员和元素分值）
	 * 
	 * @param key
	 * @param cursor
	 * @return
	 */
	@Override
	public ScanResult<Tuple> zscan(String key, String cursor) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.zscan(key, cursor);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}

	/**
	 * 在指定的 key 不存在时，为 key 设置指定的值。
	 *
	 * @param key
	 * @param value
	 * @return
	 */
	@Override
	public Long setnx(String key, String value) {
		Jedis jedis = null;
		try {
			jedis = getJedis(key);
			return jedis.setnx(key, value);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(jedis);
		}
		return null;
	}
}
