package apijson.demo;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.redbeardlab.redisql.client.ParseRediSQLReply;
import com.redbeardlab.redisql.client.RediSQLCommand;

import lombok.extern.slf4j.Slf4j;
import redis.clients.jedis.HostAndPort;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisCluster;
import redis.clients.jedis.JedisPoolConfig;
import redis.clients.jedis.ListPosition;
import redis.clients.jedis.ScanResult;
import redis.clients.jedis.Tuple;
import redis.clients.jedis.util.JedisClusterCRC16;

/***
 * cluster模式 https://cloud.tencent.com/developer/article/1985822
 */
@Slf4j
public class JedisClusterUtil {
	private JedisCluster jedisCluster;
	public static final String DB = "DB";
	ParseRediSQLReply parser = new ParseRediSQLReply();
	private Jedis jedis;
	// 可用连接实例的最大数目，默认为8；
	// 如果赋值为-1，则表示不限制，如果sentinelPool已经分配了maxActive个jedis实例，则此时sentinelPool的状态为exhausted(耗尽)
	private static Integer MAX_TOTAL = 1024;
	// 控制一个sentinelPool最多有多少个状态为idle(空闲)的jedis实例，默认值是8
	private static Integer MAX_IDLE = 200;
	// 等待可用连接的最大时间，单位是毫秒，默认值为-1，表示永不超时。
	// 如果超过等待时间，则直接抛出JedisConnectionException
	private static Integer MAX_WAIT_MILLIS = 10000;
	// 客户端超时时间配置
	private static Integer TIMEOUT = 10000;
	// 在borrow(用)一个jedis实例时，是否提前进行validate(验证)操作；
	// 如果为true，则得到的jedis实例均是可用的
	private static Boolean TEST_ON_BORROW = true;
	// 在空闲时检查有效性, 默认false
	private static Boolean TEST_WHILE_IDLE = true;
	// 是否进行有效性检查
	private static Boolean TEST_ON_RETURN = true;
	private static String PASSWORD = "";

	/**
	 * 创建连接池
	 */
	public void createJedisPool() {
		Set<HostAndPort> jedisClusterNode = new HashSet<HostAndPort>();
		jedisClusterNode.add(new HostAndPort("127.0.0.1", 6371));
		jedisClusterNode.add(new HostAndPort("127.0.0.1", 6372));
		jedisClusterNode.add(new HostAndPort("127.0.0.1", 6373));
		jedisClusterNode.add(new HostAndPort("127.0.0.1", 6374));
		jedisClusterNode.add(new HostAndPort("127.0.0.1", 6375));
		jedisClusterNode.add(new HostAndPort("127.0.0.1", 6376));
		JedisPoolConfig poolConfig = new JedisPoolConfig();
		/*
		 * 注意： 在高版本的jedis jar包，比如本版本2.9.0，JedisPoolConfig没有setMaxActive和setMaxWait属性了
		 * 这是因为高版本中官方废弃了此方法，用以下两个属性替换。 maxActive ==> maxTotal maxWait==> maxWaitMillis
		 */
		poolConfig.setMaxTotal(MAX_TOTAL);
		poolConfig.setMaxIdle(MAX_IDLE);
		poolConfig.setMaxWaitMillis(MAX_WAIT_MILLIS);
		poolConfig.setTestOnBorrow(TEST_ON_BORROW);
		poolConfig.setTestWhileIdle(TEST_WHILE_IDLE);
		poolConfig.setTestOnReturn(TEST_ON_RETURN);
		int connectionTimeout = 3000;
		int soTimeout = 3000;
		int maxAttempts = 5;
		// JedisCluster jc = new JedisCluster(jedisClusterNode, DEFAULT_TIMEOUT,
		// DEFAULT_TIMEOUT, DEFAULT_REDIRECTIONS, "cluster", DEFAULT_CONFIG);
		jedisCluster = new JedisCluster(jedisClusterNode, connectionTimeout, soTimeout, maxAttempts, PASSWORD, poolConfig);
		log.info("节点信息:{}", jedisCluster.getClusterNodes().keySet());
	}

	public void closePool() {
		if (jedisCluster != null) {
			jedisCluster.close();
		}
	}

	// 获取连接
	public void setJedis(String db) {
		int slot = JedisClusterCRC16.getSlot(db);
		jedis = jedisCluster.getConnectionFromSlot(slot);
	}

	public Jedis getJedis(String key) {
		int slot = JedisClusterCRC16.getSlot(key);
		return jedisCluster.getConnectionFromSlot(slot);

	}

	private String ok_returns(RediSQLCommand.ModuleCommand cmd, String... args) {
		try {
			jedis.getClient().sendCommand(cmd, args);
			return jedis.getClient().getBulkReply();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (jedis != null) {
				jedis.close();
			}
		}
		return null;
	}

	private List<Object> list_returns(RediSQLCommand.ModuleCommand cmd, String... args) {
		try {
			jedis.getClient().sendCommand(cmd, args);
			return jedis.getClient().getObjectMultiBulkReply();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (jedis != null) {
				jedis.close();
			}
		}
		return null;
	}

	public void delDB(String key) {
		try {
			jedis.del(key);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (jedis != null) {
				jedis.close();
			}
		}
	}

	public String create_db(String db) {
		return ok_returns(RediSQLCommand.ModuleCommand.CREATE_DB, db);
	}

	public String create_db(String db, String file_path) {
		return ok_returns(RediSQLCommand.ModuleCommand.CREATE_DB, db, file_path);
	}

	public List<Object> exec(String db, String query) {
		return list_returns(RediSQLCommand.ModuleCommand.EXEC, db, query);
	}

	public List<Object> exec_now(String db, String query) {
		return list_returns(RediSQLCommand.ModuleCommand.EXEC_NOW, db, query);
	}

	public List<Object> query(String db, String query) {
		return list_returns(RediSQLCommand.ModuleCommand.QUERY, db, query);
	}

	public List<Object> query_now(String db, String query) {
		return list_returns(RediSQLCommand.ModuleCommand.QUERY_NOW, db, query);
	}

	public List<Object> query_into(String stream, String db, String query) {
		return list_returns(RediSQLCommand.ModuleCommand.QUERY_INTO, stream, db, query);
	}

	public List<Object> query_into_now(String stream, String db, String query) {
		return list_returns(RediSQLCommand.ModuleCommand.QUERY_INTO_NOW, stream, db, query);
	}

	public String create_statement(String db, String stmt_name, String stmt_query) {
		return ok_returns(RediSQLCommand.ModuleCommand.CREATE_STATEMENT, db, stmt_name, stmt_query);
	}

	public String create_statement_now(String db, String stmt_name, String stmt_query) {
		return ok_returns(RediSQLCommand.ModuleCommand.CREATE_STATEMENT_NOW, db, stmt_name, stmt_query);
	}

	public List<Object> exec_statement(String... args) {
		return list_returns(RediSQLCommand.ModuleCommand.EXEC_STATEMENT, args);
	}

	public List<Object> exec_statement_now(String... args) {
		return list_returns(RediSQLCommand.ModuleCommand.EXEC_STATEMENT_NOW, args);
	}

	public List<Object> query_statement(String... args) {
		return list_returns(RediSQLCommand.ModuleCommand.QUERY_STATEMENT, args);
	}

	public List<Object> query_statement_now(String... args) {
		return list_returns(RediSQLCommand.ModuleCommand.QUERY_STATEMENT_NOW, args);
	}

	public List<Object> query_statement_into(String... args) {
		return list_returns(RediSQLCommand.ModuleCommand.QUERY_STATEMENT_INTO, args);
	}

	public List<Object> query_statement_into_now(String... args) {
		return list_returns(RediSQLCommand.ModuleCommand.QUERY_STATEMENT_INTO_NOW, args);
	}

	public String delete_statement(String db, String stmt_name) {
		return ok_returns(RediSQLCommand.ModuleCommand.DELETE_STATEMENT, db, stmt_name);
	}

	public String delete_statement_now(String db, String stmt_name) {
		return ok_returns(RediSQLCommand.ModuleCommand.DELETE_STATEMENT_NOW, db, stmt_name);
	}

	public String update_statement(String db, String stmt_name, String stmt_query) {
		return ok_returns(RediSQLCommand.ModuleCommand.UPDATE_STATEMENT, db, stmt_name, stmt_query);
	}

	public String update_statement_now(String db, String stmt_name, String stmt_query) {
		return ok_returns(RediSQLCommand.ModuleCommand.UPDATE_STATEMENT_NOW, db, stmt_name, stmt_query);
	}

	public String copy(String db1, String db2) {
		return ok_returns(RediSQLCommand.ModuleCommand.COPY, db1, db2);
	}

	public String copy_now(String db1, String db2) {
		return ok_returns(RediSQLCommand.ModuleCommand.COPY_NOW, db1, db2);
	}

	public List<Object> statistics() {
		return list_returns(RediSQLCommand.ModuleCommand.STATISTICS);
	}

	public String version(String db1, String db2) {
		return ok_returns(RediSQLCommand.ModuleCommand.VERSION);
	}

	public List<Object> crudBySearch(String db, String sql) throws Exception {
		return exec(db, sql);
	}

	public int crudByUpdate(String db, String sql) throws Exception {
		List<Object> retObj = exec(db, sql);
		return ParseRediSQLReply.how_many_done(retObj).intValue();
	}

	/* ######################## key的操作 ################################ */

	/**
	 * 根据pattern返回当前库中的key
	 *
	 * @param pattern
	 * @return
	 */
	public Set<String> keys(String pattern) {
		return jedisCluster.keys(pattern);
	}

	/**
	 * 删除一个或多个key
	 *
	 * @param key 一个或多个key
	 */
	public long del(String... key) {
		return jedisCluster.del(key);
	}

	/**
	 * 判断某个key是否还存在
	 *
	 * @param key key
	 * @return
	 */
	public Boolean exists(String key) {
		return jedisCluster.exists(key);
	}

	/**
	 * 设置某个key的过期时间，单位秒
	 *
	 * @param key     key
	 * @param seconds 过期时间秒
	 */
	public void expire(String key, long seconds) {
		jedisCluster.expire(key, seconds);
	}

	/**
	 * 查看某个key还有几秒过期，-1表示永不过期 ，-2表示已过期
	 *
	 * @param key key
	 * @return
	 */
	public long timeToLive(String key) {
		return jedisCluster.ttl(key);
	}

	/**
	 * 查看某个key对应的value的类型
	 *
	 * @param key
	 * @return
	 */
	public String type(String key) {
		return jedisCluster.type(key);
	}

	/* ######################## string(字符串)的操作 #################### */

	/**
	 * 获取某个key的value，类型要对，只能value是string的才能获取
	 *
	 * @param key
	 * @return
	 */
	public String get(String key) {
		return jedisCluster.get(key);
	}

	/**
	 * 设置某个key的value
	 *
	 * @param key
	 * @param value
	 */
	public void set(String key, String value) {
		jedisCluster.set(key, value);
	}

	/**
	 * 字符串后追加内容
	 *
	 * @param key           key
	 * @param appendContent 要追加的内容
	 */
	public void append(String key, String appendContent) {
		jedisCluster.append(key, appendContent);
	}

	/**
	 * 返回key的value的长度
	 *
	 * @param key
	 * @return
	 */
	public long strlen(String key) {
		return jedisCluster.strlen(key);
	}

	/**
	 * value 加1 必 须是字符型数字
	 * 
	 * @param key
	 * @return 增加后的值
	 */
	public long incr(String key) {
		return jedisCluster.incr(key);
	}

	/**
	 * value 减1 必须是字符型数字
	 *
	 * @param key
	 * @return
	 */
	public long decr(String key) {
		return jedisCluster.decr(key);
	}

	/**
	 * value 加increment
	 *
	 * @param key       key
	 * @param increment 加几
	 * @return
	 */
	public long incrby(String key, int increment) {
		return jedisCluster.incrBy(key, increment);
	}

	/**
	 * value 减increment
	 *
	 * @param key
	 * @param increment
	 * @return
	 */
	public long decrby(String key, int increment) {
		return jedisCluster.decrBy(key, increment);
	}

	/**
	 * 给某个key设置过期时间和value，成功返回OK
	 *
	 * @param key     key
	 * @param seconds 过期时间秒
	 * @param value   设置的值
	 * @return
	 */
	public String setex(String key, int seconds, String value) {
		return jedisCluster.setex(key, seconds, value);
	}

	/* ######################## list(列表)的操作 ####################### */
	// lpush rpush lpop rpop lrange lindex llen lset lrem

	/**
	 * 从左边向列表中添加值
	 *
	 * @param key key
	 * @param str 要添加的值
	 */
	public void lpush(String key, String str) {
		jedisCluster.lpush(key, str);
	}

	/**
	 * 从右边向列表中添加值
	 *
	 * @param key key
	 * @param str 要添加的值
	 */
	public void rpush(String key, String str) {
		jedisCluster.rpush(key, str);
	}

	/**
	 * 从左边取出一个列表中的值
	 *
	 * @param key
	 * @return
	 */
	public String lpop(String key) {
		return jedisCluster.lpop(key);
	}

	/**
	 * 从右边取出一个列表中的值
	 *
	 * @param key
	 * @return
	 */
	public String rpop(String key) {
		return jedisCluster.rpop(key);
	}

	/**
	 * 取出列表中指定范围内的值，0 到 -1 表示全部
	 *
	 * @param key
	 * @param startIndex
	 * @param endIndex
	 * @return
	 */
	public List<String> lrange(String key, int startIndex, int endIndex) {
		return jedisCluster.lrange(key, startIndex, endIndex);
	}

	/**
	 * 返回某列表指定索引位置的值
	 *
	 * @param key   列表key
	 * @param index 索引位置
	 * @return
	 */
	public String lindex(String key, int index) {
		return jedisCluster.lindex(key, index);
	}

	/**
	 * 返回某列表的长度
	 *
	 * @param key
	 * @return
	 */
	public long llen(String key) {
		return jedisCluster.llen(key);
	}

	/**
	 * 给某列表指定位置设置为指定的值
	 *
	 * @param key
	 * @param index
	 * @param str
	 */
	public void lset(String key, long index, String str) {
		jedisCluster.lset(key, index, str);
	}

	public void linsert(final String key, final ListPosition where, final String pivot, final String value) {
		jedisCluster.linsert(key, where, pivot, value);
	}

	/**
	 * 对列表进行剪裁，保留指定闭区间的元素(索引位置也会重排)
	 * 
	 * @param key        列表key
	 * @param startIndex 开始索引位置
	 * @param endIndex   结束索引位置
	 */
	public void ltrim(String key, Integer startIndex, Integer endIndex) {
		jedisCluster.ltrim(key, startIndex, endIndex);
	}

	/**
	 * 从列表的左边阻塞弹出一个元素
	 * 
	 * @param key     列表的key
	 * @param timeout 阻塞超时时间，0表示若没有元素就永久阻塞
	 * @return
	 */
	public List<String> blpop(String key, Integer timeout) {
		return jedisCluster.blpop(timeout, key);
	}

	/**
	 * 从列表的右边阻塞弹出一个元素
	 * 
	 * @param key     列表的key
	 * @param timeout 阻塞超时时间，0表示若没有元素就永久阻塞
	 * @return
	 */
	public List<String> brpop(String key, Integer timeout) {
		return jedisCluster.brpop(timeout, key);
	}

	/**
	 * 移除列表元素
	 * 
	 * @param key
	 * @param index
	 * @param str
	 */
	public void lrem(String key, long count, String value) {
		jedisCluster.lrem(key, count, value);
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
	public void hset(String key, String field, String value) {
		jedisCluster.hset(key, field, value);
	}

	/**
	 * 取出某个hash表中某个field对应的value
	 *
	 * @param key   key
	 * @param field field
	 * @return
	 */
	public String hget(String key, String field) {
		return jedisCluster.hget(key, field);
	}

	/**
	 * 某个hash表设置一个或多个键值对
	 * 
	 * @param key
	 * @param kvMap
	 */
	public void hmset(String key, Map<String, String> kvMap) {
		jedisCluster.hmset(key, kvMap);
	}

	/**
	 * 取出某个hash表中任意多个key对应的value的集合
	 *
	 * @param key
	 * @param fields
	 * @return
	 */
	public List<String> hmget(String key, String... fields) {
		return jedisCluster.hmget(key, fields);
	}

	/**
	 * 取出某个hash表中所有的键值对
	 *
	 * @param key
	 * @return
	 */
	public Map<String, String> hgetall(String key) {
		return jedisCluster.hgetAll(key);
	}

	/**
	 * 判断某个hash表中的某个key是否存在
	 *
	 * @param key
	 * @param field
	 * @return
	 */
	public Boolean hexists(String key, String field) {
		return jedisCluster.hexists(key, field);
	}

	/**
	 * 返回某个hash表中所有的key
	 *
	 * @param key
	 * @return
	 */
	public Set<String> hkeys(String key) {
		return jedisCluster.hkeys(key);
	}

	/**
	 * 返回某个hash表中所有的value
	 *
	 * @param key
	 * @return
	 */
	public List<String> hvals(String key) {
		return jedisCluster.hvals(key);
	}

	/**
	 * 删除某个hash表中的一个或多个键值对
	 *
	 * @param key
	 * @param fields
	 */
	public void hdel(String key, String... fields) {
		jedisCluster.hdel(key, fields);
	}

	/**
	 * 给某个hash表中的某个field的value增加多少
	 *
	 * @param key       hash表的key
	 * @param field     表中的某个field
	 * @param increment 增加多少
	 * @return
	 */
	public long hincrby(String key, String field, long increment) {
		return jedisCluster.hincrBy(key, field, increment);
	}

	/* ######################## set(集合)的操作 ########################### */

	/**
	 * 往set集合中添加一个或多个元素
	 * 
	 * @param key     key
	 * @param members 要添加的元素
	 * @return 添加成功的元素个数
	 */
	public long sadd(String key, String... members) {
		return jedisCluster.sadd(key, members);
	}

	/**
	 * 返回set集合中的所有元素，顺序与加入时的顺序一致
	 * 
	 * @param key key
	 * @return
	 */
	public Set<String> smembers(String key) {
		return jedisCluster.smembers(key);
	}

	/**
	 * 判断集合中是否存在某个元素
	 * 
	 * @param key    key
	 * @param member 某个元素
	 * @return true存在，false不存在
	 */
	public Boolean sismember(String key, String member) {
		return jedisCluster.sismember(key, member);
	}

	/**
	 * 返回set集合的长度
	 * 
	 * @param key key
	 * @return
	 */
	public long scard(String key) {
		return jedisCluster.scard(key);
	}

	/**
	 * 删除set集合中指定的一个或多个元素
	 * 
	 * @param key
	 * @param members 要删除的元素
	 * @return 删除成功的元素个数
	 */
	public long srem(String key, String... members) {
		return jedisCluster.srem(key, members);
	}

	/**
	 * 将key1中的元素key1Member移动到key2中
	 * 
	 * @param key1       来源集合key
	 * @param key2       目的地集合key
	 * @param key1Member key1中的元素
	 * @return 1成功，0失败
	 */
	public long smove(String key1, String key2, String key1Member) {
		return jedisCluster.smove(key1, key2, key1Member);
	}

	/**
	 * 随机查询返回集合中的指定个数的元素（若count为负数，返回的元素可能会重复）
	 * 
	 * @param key   key
	 * @param count 要查询返回的元素个数
	 * @return 元素list集合
	 */
	public List<String> srandmember(String key, int count) {
		return jedisCluster.srandmember(key, count);
	}

	/**
	 * 从set集合中随机弹出指定个数个元素
	 * 
	 * @param key   key
	 * @param count 要弹出的个数
	 * @return 随机弹出的元素
	 */
	public Set<String> spop(String key, int count) {
		return jedisCluster.spop(key, count);
	}

	/**
	 * 求交集，返回多个set集合相交的部分
	 * 
	 * @param setKeys 多个set集合的key
	 * @return 相交的元素集合
	 */
	public Set<String> sinter(String... setKeys) {
		return jedisCluster.sinter(setKeys);
	}

	/**
	 * 求并集，求几个set集合的并集（因为set中不会有重复的元素，合并后的集合也不会有重复的元素）
	 * 
	 * @param setKeys 多个set的key
	 * @return 合并后的集合
	 */
	public Set<String> sunion(String... setKeys) {
		return jedisCluster.sunion(setKeys);
	}

	/**
	 * 求差集，求几个集合之间的差集
	 * 
	 * @param setKeys 多个set的key
	 * @return 差集
	 */
	public Set<String> sdiff(String... setKeys) {
		return jedisCluster.sdiff(setKeys);
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
	public long zadd(String key, double score, String member) {
		return jedisCluster.zadd(key, score, member);
	}

	public long zadd(String key, Map<String, Double> scoreMembers) {
		return jedisCluster.zadd(key, scoreMembers);
	}

	/**
	 * 获取有序集合的成员数
	 * 
	 * @param key key
	 * @return
	 */
	public long zcard(String key) {
		return jedisCluster.zcard(key);
	}

	/**
	 * 计算在有序集合中指定区间分数的成员数
	 * 
	 * @param key
	 * @param min
	 * @param max
	 * @return
	 */
	public long zcount(String key, double min, double max) {
		return jedisCluster.zcount(key, min, max);
	}

	/**
	 * 有序集合中对指定成员的分数加上增量 increment
	 * 
	 * @param key
	 * @param increment
	 * @param member
	 * @return
	 */
	public Double zincrby(String key, double increment, String member) {
		return jedisCluster.zincrby(key, increment, member);
	}

	/**
	 * 计算给定的一个或多个有序集的交集并将结果集存储在新的有序集合 destination 中
	 * 
	 * @param dstkey
	 * @param sets
	 * @return
	 */
	public long zinterstore(String dstkey, String... sets) {
		return jedisCluster.zinterstore(dstkey, sets);
	}

	/**
	 * 在有序集合中计算指定字典区间内成员数量
	 * 
	 * @param key
	 * @param min
	 * @param max
	 * @return
	 */
	public long zlexcount(String key, String min, String max) {
		return jedisCluster.zlexcount(key, min, max);
	}

	/**
	 * 通过索引区间返回有序集合指定区间内的成员
	 * 
	 * @param key
	 * @param min
	 * @param max
	 * @return
	 */
	public Set<String> zrange(String key, long start, long stop) {
		return jedisCluster.zrange(key, start, stop);
	}

	/**
	 * 通过索引区间返回有序集合指定区间内的成员
	 * 
	 * @param key
	 * @param min
	 * @param max
	 * @return
	 */
	public Set<String> zrangeByScore(String key, double min, double max) {
		return jedisCluster.zrangeByScore(key, min, max);
	}

	/***
	 * 通过字典区间返回有序集合的成员
	 * 
	 * @param key
	 * @param min
	 * @param max
	 * @return
	 */
	public Set<String> zrangeByLex(String key, String min, String max) {
		return jedisCluster.zrangeByLex(key, min, max);
	}

	/**
	 * 返回有序集合中指定成员的索引
	 * 
	 * @param key
	 * @param member
	 * @return
	 */
	public long zrank(String key, String member) {
		return jedisCluster.zrank(key, member);
	}

	/**
	 * 
	 * @param key
	 * @param values
	 * @return
	 */
	public long zrem(String key, String... members) {
		return jedisCluster.zrem(key, members);
	}

	/**
	 * 移除有序集合中给定的字典区间的所有成员
	 * 
	 * @param key
	 * @param min
	 * @param max
	 * @return
	 */
	public long zremrangeByLex(String key, String min, String max) {
		return jedisCluster.zremrangeByLex(key, min, max);
	}

	/**
	 * 移除有序集合中给定的排名区间的所有成员
	 * 
	 * @param key
	 * @param start
	 * @param stop
	 * @return
	 */
	public long zremrangeByRank(String key, long start, long stop) {
		return jedisCluster.zremrangeByRank(key, start, stop);
	}

	/**
	 * 移除有序集合中给定的分数区间的所有成员
	 * 
	 * @param key
	 * @param min
	 * @param max
	 * @return
	 */
	public long zremrangebyscore(String key, double min, double max) {
		return jedisCluster.zremrangeByScore(key, min, max);
	}

	/**
	 * 返回有序集中指定区间内的成员，通过索引，分数从高到低
	 * 
	 * @param key
	 * @param start
	 * @param stop
	 * @return
	 */
	public Set<String> zrevrange(String key, long start, long stop) {
		return jedisCluster.zrevrange(key, start, stop);
	}

	/**
	 * 返回有序集中指定分数区间内的成员，分数从高到低排序
	 * 
	 * @param key
	 * @param min
	 * @param max
	 * @return
	 */
	public Set<String> zrevrangeByScore(String key, double min, double max) {
		return jedisCluster.zrevrangeByScore(key, min, max);
	}

	/**
	 * 返回有序集合中指定成员的排名，有序集成员按分数值递减(从大到小)排序
	 * 
	 * @param key
	 * @param member
	 * @return
	 */
	public long zrevrank(String key, String member) {
		return jedisCluster.zrevrank(key, member);
	}

	/**
	 * 返回有序集中，成员的分数值
	 * 
	 * @param key
	 * @param value
	 * @return
	 */
	public double zscore(String key, String value) {
		return jedisCluster.zscore(key, value);
	}

	/**
	 * 计算给定的一个或多个有序集的并集，并存储在新的 key 中
	 * 
	 * @param dstkey
	 * @param sets
	 * @return
	 */
	public long zunionstore(String dstkey, String... sets) {
		return jedisCluster.zunionstore(dstkey, sets);
	}

	/**
	 * 迭代有序集合中的元素（包括元素成员和元素分值）
	 * 
	 * @param key
	 * @param cursor
	 * @return
	 */
	public ScanResult<Tuple> zscan(String key, String cursor) {
		return jedisCluster.zscan(key, cursor);
	}


	/**
	 * 在指定的 key 不存在时，为 key 设置指定的值。
	 *
	 * @param key
	 * @param value
	 * @return
	 */
	public Long setnx(String key,String value) {
		return jedisCluster.setnx(key,value);
	}
}
