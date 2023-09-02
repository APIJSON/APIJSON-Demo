package apijson.demo.redis;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import redis.clients.jedis.HostAndPort;
import redis.clients.jedis.JedisCluster;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;
import redis.clients.jedis.JedisSentinelPool;

@Data
@Slf4j
public class RedisDataSource {
	private JedisCluster jedisCluster;
	private JedisPool jedisPool;
	private JedisSentinelPool sentinelPool;
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
	private static Boolean BLOCK_WHEN_EXHAUSTED = true;
	private static Integer TIME_BETWEEN_EVICTION_RUNS_MILLIS = 30000;
	private static Integer MIN_EVICTABLE_IDLE_TIMEMILLIS = 60000;

	public void createSingle() {
		// 创建Jedis配置对象
		String host = "127.0.0.1";
		String password = "";
		Integer port = 6379;
		JedisPoolConfig config = new JedisPoolConfig();
		config.setMaxTotal(MAX_TOTAL);
		config.setMaxIdle(MAX_IDLE);
		config.setMaxWaitMillis(MAX_WAIT_MILLIS);
		config.setTestOnBorrow(TEST_ON_BORROW);
		config.setTestWhileIdle(TEST_WHILE_IDLE);
		config.setTestOnReturn(TEST_ON_RETURN);
		config.setBlockWhenExhausted(BLOCK_WHEN_EXHAUSTED);
		config.setTimeBetweenEvictionRunsMillis(TIME_BETWEEN_EVICTION_RUNS_MILLIS);
		config.setMinEvictableIdleTimeMillis(MIN_EVICTABLE_IDLE_TIMEMILLIS);
		// 初始化
		jedisPool = new JedisPool(config, host, port, TIMEOUT, password);
	}
	
	public void createSentinel() {
		Set<String> sentinels = new HashSet<String>(Arrays.asList("xxx:26379", "xxx:26380", "xxx:26381"));
		// 创建Jedis配置对象
		String password = "";
		Integer port = 6379;
		JedisPoolConfig poolConfig = new JedisPoolConfig();
		poolConfig.setMaxTotal(MAX_TOTAL);
		poolConfig.setMaxIdle(MAX_IDLE);
		poolConfig.setMaxWaitMillis(MAX_WAIT_MILLIS);
		poolConfig.setTestOnBorrow(TEST_ON_BORROW);
		poolConfig.setTestWhileIdle(TEST_WHILE_IDLE);
		poolConfig.setTestOnReturn(TEST_ON_RETURN);
		String masterName = "mymaster";
		// 初始化
		sentinelPool = new JedisSentinelPool(masterName, sentinels, poolConfig, TIMEOUT, password);
	}

	/**
	 * 创建连接池
	 */
	public void createCluster() {
		Set<HostAndPort> jedisClusterNode = new HashSet<HostAndPort>();
		String password = "apijson";
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
		jedisCluster = new JedisCluster(jedisClusterNode, connectionTimeout, soTimeout, maxAttempts, password, poolConfig);
		log.info("节点信息:{}", jedisCluster.getClusterNodes().keySet());
	}

	
}
