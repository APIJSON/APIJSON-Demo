package apijson.demo.redis;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

public class RedisSingleExecutor extends AbstractRedisExecutor {
	private JedisPool jedisPool;

	@Override
	public void init(RedisDataSource redisDataSource) {
		jedisPool = redisDataSource.getJedisPool();
	}

	@Override
	public Jedis getJedis(String key) {
		return this.jedisPool.getResource();
	}

	@Override
	public RedisClusterModelEnum getClusterModel() {
		return RedisClusterModelEnum.SINGLE;
	}

	@Override
	public void closePool() {
		if (this.jedisPool != null) {
			this.jedisPool.close();
		}
	}
}
