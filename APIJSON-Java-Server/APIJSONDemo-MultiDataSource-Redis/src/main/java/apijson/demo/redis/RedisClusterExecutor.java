package apijson.demo.redis;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisCluster;
import redis.clients.jedis.util.JedisClusterCRC16;

public class RedisClusterExecutor extends AbstractRedisExecutor {
	private JedisCluster jedisCluster;

	@Override
	public void init(RedisDataSource redisDataSource) {
		jedisCluster = redisDataSource.getJedisCluster();
	}

	// 获取连接
	@Override
	public Jedis getJedis(String key) {
		int slot = JedisClusterCRC16.getSlot(key);
		return jedisCluster.getConnectionFromSlot(slot);
	}

	@Override
	public RedisClusterModelEnum getClusterModel() {
		return RedisClusterModelEnum.CLUSTER;
	}

	@Override
	public void closePool() {
		if (this.jedisCluster != null) {
			this.jedisCluster.close();
		}
	}
}
