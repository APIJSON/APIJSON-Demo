package apijson.demo.redis;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisSentinelPool;

public class RedisSentinelExecutor extends AbstractRedisExecutor {
	private JedisSentinelPool sentinelPool;

	@Override
	public void init(RedisDataSource redisDataSource) {
		sentinelPool = redisDataSource.getSentinelPool();
	}

	@Override
	public Jedis getJedis(String key) {
		return sentinelPool.getResource();
	}

	@Override
	public RedisClusterModelEnum getClusterModel() {
		return RedisClusterModelEnum.SENTINEL;
	}

	@Override
	public void closePool() {
		if (this.sentinelPool != null) {
			this.sentinelPool.close();
		}
	}

}
