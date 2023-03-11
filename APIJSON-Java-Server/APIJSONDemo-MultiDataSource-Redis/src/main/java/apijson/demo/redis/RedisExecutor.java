package apijson.demo.redis;

import java.util.List;
import java.util.Map;
import java.util.Set;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.ListPosition;
import redis.clients.jedis.ScanParams;
import redis.clients.jedis.ScanResult;
import redis.clients.jedis.Tuple;

public interface RedisExecutor {

	void init(RedisDataSource redisDataSource);

	Jedis getJedis(String key);

	void close(Jedis jedis);
	
	RedisClusterModelEnum getClusterModel();

	void closePool();
	
	void delDB(String key);
	
	String create_db(String db);
	
	String create_db(String db, String file_path);
	
	List<Object> exec(String db, String query);
	
	List<Object> exec_now(String db, String query);
	
	List<Object> query(String db, String query);
	
	List<Object> query_now(String db, String query);
	
	List<Object> query_into(String stream, String db, String query);
	
	List<Object> query_into_now(String stream, String db, String query);
	
	String create_statement(String db, String stmt_name, String stmt_query);
	
	String create_statement_now(String db, String stmt_name, String stmt_query);
	
	List<Object> exec_statement(String... args);
	
	List<Object> exec_statement_now(String... args);
	
	List<Object> query_statement(String... args);
	
	List<Object> query_statement_now(String... args);
	
	List<Object> query_statement_into(String... args);
	
	List<Object> query_statement_into_now(String... args);
	
	String delete_statement(String db, String stmt_name);
	
	String delete_statement_now(String db, String stmt_name);
	
	String update_statement(String db, String stmt_name, String stmt_query);
	
	String update_statement_now(String db, String stmt_name, String stmt_query);
	
	String copy(String db1, String db2);
	
	String copy_now(String db1, String db2);
	
	List<Object> statistics();
	
	String version();
	
	List<Object> crudBySearch(String db, String sql) throws Exception;
	
	Long crudByUpdate(String db, String sql) throws Exception;
	
	Set<String> keys(String pattern);
	
	Long del(String... key);
	
	Boolean exists(String key);
	
	Long expire(String key, Long seconds);
	
	Long persist(String key);
	
	Long timeToLive(String key);
	
	String rename(String key, String newKey);
	
	String type(String key);
	
	ScanResult<String> scan(String cursor, ScanParams scanParams);
	
	String get(String key);
	
	List<String> mget(String... key);
	
	String set(String key, String value);
	
	String mset(String... keysvalues);
	
	String msetnx(String... keysvalues);
	
	Long append(String key, String appendContent);
	
	Long strlen(String key);
	
	Long incr(String key);
	
	Long decr(String key);
	
	Long incrby(String key, int increment);
	
	Long decrby(String key, int increment);
	
	String setex(String key, int seconds, String value);
	
	Long lpush(String key, String... str);
	
	Long rpush(String key, String... str);
	
	String lpop(String key);
	
	String rpop(String key);
	
	List<String> lrange(String key, int startIndex, int endIndex);
	
	String lindex(String key, int index);
	
	Long llen(String key);
	
	String lset(String key, Long index, String str);
	
	Long linsert(final String key, final ListPosition where, final String pivot, final String value);
	
	String ltrim(String key, Integer startIndex, Integer endIndex);
	
	List<String> blpop(String key, Integer timeout);
	
	List<String> brpop(String key, Integer timeout);
	
	Long lrem(String key, Long count, String value);
	
	Long hset(String key, String field, String value);
	
	Long hsetnx(String key, String field, String value);
	
	String hget(String key, String field);
	
	String hmset(String key, Map<String, String> kvMap);
	
	List<String> hmget(String key, String... fields);
	
	Map<String, String> hgetall(String key);
	
	Boolean hexists(String key, String field);
	
	Set<String> hkeys(String key);
	
	List<String> hvals(String key);
	
	Long hlen(String key);
	
	Long hdel(String key, String... fields);
	
	Long hincrby(String key, String field, Long increment);
	
	ScanResult<Map.Entry<String,String>> hscan(String key, String cursor);
	
	Long sadd(String key, String... members);
	
	Set<String> smembers(String key);
	
	Boolean sismember(String key, String member);
	
	Long scard(String key);
	
	Long srem(String key, String... members);
	
	Long smove(String key1, String key2, String key1Member);
	
	List<String> srandmember(String key, int count);
	
	Set<String> spop(String key, int count);
	
	Set<String> sinter(String... setKeys);
	
	Set<String> sunion(String... setKeys);
	
	Set<String> sdiff(String... setKeys);
	
	ScanResult<String> sscan(String key, String cursor);
	
	Long zadd(String key, double score, String member);
	
	Long zadd(String key, Map<String, Double> scoreMembers);
	
	Long zcard(String key);
	
	Long zcount(String key, double min, double max);
	
	Double zincrby(String key, double increment, String member);
	
	Long zinterstore(String dstkey, String... sets);
	
	Long zlexcount(String key, String min, String max);
	
	Set<String> zrange(String key, Long start, Long stop);
	
	Set<String> zrangeByScore(String key, double min, double max);
	
	Set<String> zrangeByLex(String key, String min, String max);
	
	Long zrank(String key, String member);
	
	Long zrem(String key, String... members);
	
	Long zremrangeByLex(String key, String min, String max);
	
	Long zremrangeByRank(String key, Long start, Long stop);
	
	Long zremrangebyscore(String key, double min, double max);
	
	Set<String> zrevrange(String key, Long start, Long stop);
	
	Set<String> zrevrangeByScore(String key, double min, double max);
	
	Long zrevrank(String key, String member);
	
	Double zscore(String key, String value);
	
	Long zunionstore(String dstkey, String... sets);
	
	ScanResult<Tuple> zscan(String key, String cursor);
	
	Long setnx(String key, String value);
}
