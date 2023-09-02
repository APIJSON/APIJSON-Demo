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

import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.sql.DataSource;

import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;

import apijson.Log;
import apijson.NotNull;
import apijson.StringUtil;
import apijson.demo.redis.ParseRediSQLReply;
import apijson.demo.redis.RedisBuildData;
import apijson.demo.redis.RedisClusterModelEnum;
import apijson.demo.redis.RedisExecutor;
import apijson.demo.resultSet.DataBuildResultSet;
import apijson.framework.APIJSONSQLExecutor;
import apijson.orm.SQLConfig;
import lombok.extern.log4j.Log4j2;
import redis.clients.jedis.ListPosition;
import redis.clients.jedis.ScanParams;
import redis.clients.jedis.ScanResult;
import redis.clients.jedis.Tuple;
import unitauto.JSON;

/**
 * SQL 执行器，支持连接池及多数据源 具体见 https://github.com/Tencent/APIJSON/issues/151
 * 
 * @author Lemon
 */
@Log4j2
public class DemoSQLExecutor extends APIJSONSQLExecutor<Long> {
	public static final String TAG = "DemoSQLExecutor";

	// 适配连接池，如果这里能拿到连接池的有效 Connection，则 SQLConfig 不需要配置 dbVersion, dbUri, dbAccount,
	// dbPassword
	@Override
	public Connection getConnection(SQLConfig config) throws Exception {
		String datasource = config.getDatasource();
		Log.d(TAG, "getConnection  config.getDatasource() = " + datasource);

		String key = datasource + "-" + config.getDatabase();
		Connection conn = connectionMap.get(key);
		if (conn == null || conn.isClosed()) {
			DataSource dataSource = DataBaseUtil.getDataSource(datasource);
			connectionMap.put(key, dataSource == null ? null : dataSource.getConnection());
		}
		return super.getConnection(config);
	}

	@Override
	public ResultSet executeQuery(@NotNull SQLConfig config, String sql) throws Exception {
		if (config.isRedis()) {
			return redisExecuteQuery(config, sql);
		}
		return super.executeQuery(config, sql);
	}
	
	
	@Override
	public int executeUpdate(@NotNull SQLConfig config, String sql) throws Exception {
		if (config.isRedis()) {
			return redisExecuteUpdate(config, sql).intValue();
		}
		return super.executeUpdate(config, sql);
	}
	
	@SuppressWarnings("unchecked")
	public ResultSet redisExecuteQuery(@NotNull SQLConfig config, String sql) throws Exception {
		try {
			List<List<Object>> rsData = new ArrayList<>();
			List<String> headers = new ArrayList<>();
			// redis不支持explain 查询
			if (config.isExplain()) {
				// 没有查询到数据
				return new DataBuildResultSet(null, headers, rsData);
			}

			if (config.getColumn() != null) {
				headers = config.getColumn();
			}

			RedisExecutor redisExecutor = DynamicDataSource.getDetail(config.getDatasource()).getRedisExecutor();
			Map<String, Object> configWhere = config.getWhere();
			String configTable = config.getTable();
			if (configTable.startsWith(RedisBuildData.REDIS_TABLE_KEY)) {
				if (config.getColumn() != null && config.getColumn().size() > 0) {
					headers = config.getColumn();
				} else {
					// redisql不支持返回字段名, select * 请把字段填充进去
					throw new IllegalArgumentException("redis table 查询必须指定 column !");
				}
				sql = StringUtil.isEmpty(sql) ? config.getSQL(false) : sql;
				switch (config.getMethod()) {
				case GET:
				case HEAD:
					List<Object> retObj = redisExecutor.crudBySearch(DynamicDataSource.getDetail(config.getDatasource()).getRedSQLDB(), sql);
					if (ParseRediSQLReply.done_reply(retObj)) {
						return new DataBuildResultSet(null, headers, rsData);
					} else {
						for (Object obj : retObj) {
							List<Object> rowList = (List<Object>) obj;
							List<Object> retData = new ArrayList<>();
							for (Object objData : rowList) {
								if (objData instanceof Number) {
									retData.add(objData);
								} else {
									// 字段值不存在
									if (objData == null) {
										retData.add(null);
									} else {
										retData.add(ParseRediSQLReply.get_string(objData));
									}
								}
							}
							rsData.add(retData);
						}
						return new DataBuildResultSet(null, headers, rsData);
					}
				default:
					return new DataBuildResultSet(null, headers, rsData);
				}
			}

			String key = configWhere.get(RedisBuildData.COLUMN_KEY) != null ? key = configWhere.get(RedisBuildData.COLUMN_KEY).toString() : null;
			String[] keys = configWhere.get(RedisBuildData.COLUMN_KEY + "{}") != null ? JSON.parseObject(configWhere.get(RedisBuildData.COLUMN_KEY + "{}").toString(), String[].class) : null;
			if (configTable.startsWith(RedisBuildData.REDIS_KEYS)) {
				List<Object> retData = new ArrayList<>();
				switch (configWhere.get(RedisBuildData.OPTION_METHOD).toString()) {
				case RedisBuildData.OPTION_METHOD_KEYS:
					if (redisExecutor.getClusterModel() == RedisClusterModelEnum.CLUSTER) {
						throw new IllegalArgumentException("redis cluster模式不支持 keys 查找!");
					}
					retData.add(redisExecutor.keys(key));
					break;
				case RedisBuildData.OPTION_METHOD_EXISTS:
					retData.add(redisExecutor.exists(key));
					break;
				case RedisBuildData.OPTION_METHOD_TIMETOLIVE:
					retData.add(redisExecutor.timeToLive(key));
					break;
				case RedisBuildData.OPTION_METHOD_TYPE:
					retData.add(redisExecutor.type(key));
					break;
				case RedisBuildData.OPTION_METHOD_SCAN: // 建议不要scan, 影响性能
					List<String> data = new ArrayList<>();
					ScanParams scanParams = new ScanParams();
					scanParams.match(key);// 匹配以 test:xttblog:* 为前缀的 key
					scanParams.count(100);
					if (redisExecutor.getClusterModel() == RedisClusterModelEnum.CLUSTER) {
						throw new IllegalArgumentException("redis cluster模式不支持 scan 命令!");
//							redisExecutor.getJedisCluster().getClusterNodes().values().stream().forEach(pool -> {
//								try (Jedis jedisNode = pool.getResource()) {
//									String cursor_scan = ScanParams.SCAN_POINTER_START;
//									while (true) {
//										ScanResult<String> resp = jedisNode.scan(cursor_scan, scanParams);
//										cursor_scan = resp.getCursor();// 返回0 说明遍历完成
//										retData.add(resp.getResult());
//										if (StringUtil.equals(cursor_scan, ScanParams.SCAN_POINTER_START)) {
//											break;
//										}
//									}
//								}
//							});
					} else {
						String cursor_scan = ScanParams.SCAN_POINTER_START;
						while (true) {
							// 使用scan命令获取500条数据，使用cursor游标记录位置，下次循环使用
							ScanResult<String> scanResult = redisExecutor.scan(cursor_scan, scanParams);
							cursor_scan = scanResult.getCursor();// 返回0 说明遍历完成
							if (scanResult.getResult().size() > 0) {
								data.addAll(scanResult.getResult());
							}
							if (StringUtil.equals(cursor_scan, ScanParams.SCAN_POINTER_START)) {
								break;
							}
						}
					}
					retData.add(data);
					break;
				}
				headers.add(key);
				rsData.add(retData);
				return new DataBuildResultSet(null, headers, rsData);
			} else if (configTable.startsWith(RedisBuildData.REDIS_STRING_KEY)) {
				List<Object> retData = new ArrayList<>();
				switch (configWhere.get(RedisBuildData.OPTION_METHOD).toString()) {
				case RedisBuildData.OPTION_METHOD_GET:
					retData.add(redisExecutor.get(key));
					break;
				case RedisBuildData.OPTION_METHOD_MGET:
					if (redisExecutor.getClusterModel() == RedisClusterModelEnum.CLUSTER) {
						throw new IllegalArgumentException("redis cluster模式不支持 mget 多个key!");
					}
					retData.addAll(redisExecutor.mget(keys));
					break;
				case RedisBuildData.OPTION_METHOD_STRLEN:
					retData.add(redisExecutor.strlen(key));
					break;
				}
				if (StringUtil.isNotEmpty(key)) {
					headers.add(key);
				} else if (StringUtil.isNotEmpty(keys)) {
					headers.addAll(Arrays.asList(keys));
				}
				rsData.add(retData);
				return new DataBuildResultSet(null, headers, rsData);
			} else if (configTable.startsWith(RedisBuildData.REDIS_LIST_KEY)) {
				List<Object> columnData = new ArrayList<>();
				switch (configWhere.get(RedisBuildData.OPTION_METHOD).toString()) {
				case RedisBuildData.OPTION_METHOD_LPOP:
					columnData.add(redisExecutor.lpop(key));
					break;
				case RedisBuildData.OPTION_METHOD_RPOP:
					columnData.add(redisExecutor.rpop(key));
					break;
				case RedisBuildData.OPTION_METHOD_LRANGE:
					Integer[] keys_lrange = JSON.parseObject(configWhere.get(RedisBuildData.COLUMN_INDEX + "{}"), Integer[].class);
					List<String> lrange = redisExecutor.lrange(key, keys_lrange[0], keys_lrange[1]);
					columnData.add(lrange);
					break;
				case RedisBuildData.OPTION_METHOD_LINDEX:
					Integer index_lindex = JSON.parseObject(configWhere.get(RedisBuildData.COLUMN_INDEX), Integer.class);
					String lindex = redisExecutor.lindex(key, index_lindex);
					columnData.add(lindex);
					break;
				case RedisBuildData.OPTION_METHOD_LLEN:
					long llen = redisExecutor.llen(key);
					columnData.add(llen);
					break;
				case RedisBuildData.OPTION_METHOD_BLPOP:
					Integer blpop_timeout = JSON.parseObject(configWhere.get(RedisBuildData.COLUMN_EXPIRE_TIME), Integer.class);
					List<String> blpop = redisExecutor.blpop(key, blpop_timeout);
					if (blpop != null && blpop.size() == 2) {
						columnData.add(blpop.subList(1, blpop.size()));
					} else {
						columnData.add(blpop);
					}
					break;
				case RedisBuildData.OPTION_METHOD_BRPOP:
					Integer brpop_timeout = JSON.parseObject(configWhere.get(RedisBuildData.COLUMN_EXPIRE_TIME), Integer.class);
					List<String> brpop = redisExecutor.brpop(key, brpop_timeout);
					if (brpop != null && brpop.size() == 2) {
						columnData.add(brpop.subList(1, brpop.size()));
					} else {
						columnData.add(brpop);
					}
					break;
				}
				headers.add(key);
				rsData.add(columnData);
				return new DataBuildResultSet(null, headers, rsData);
			} else if (configTable.startsWith(RedisBuildData.REDIS_HASH_KEY)) {
				List<Object> retData = new ArrayList<>();
				switch (configWhere.get(RedisBuildData.OPTION_METHOD).toString()) {
				case RedisBuildData.OPTION_METHOD_HGET:
					String index_hget = configWhere.get(RedisBuildData.COLUMN_INDEX).toString();
					String hget = redisExecutor.hget(key, index_hget);
					headers.add(index_hget);
					retData.add(hget);
					break;
				case RedisBuildData.OPTION_METHOD_HMGET:
					String[] fields_hmget = JSON.parseObject(configWhere.get(RedisBuildData.COLUMN_INDEX + "{}"), String[].class);
					List<String> hmget = redisExecutor.hmget(key, fields_hmget);
					headers.addAll(Arrays.asList(fields_hmget));
					retData.addAll(hmget);
					break;
				case RedisBuildData.OPTION_METHOD_HGETALL:
					Map<String, String> hgetall = redisExecutor.hgetall(key);
					headers.addAll(hgetall.keySet());
					retData.addAll(hgetall.values());
					break;
				case RedisBuildData.OPTION_METHOD_HEXISTS:
					String field_hexists = configWhere.get(RedisBuildData.COLUMN_INDEX).toString();
					headers.add(field_hexists);
					retData.add(redisExecutor.hexists(key, field_hexists));
					break;
				case RedisBuildData.OPTION_METHOD_HKEYS:
					headers.add(key);
					retData.add(redisExecutor.hkeys(key));
					break;
				case RedisBuildData.OPTION_METHOD_HLEN:
					headers.add(key);
					retData.add(redisExecutor.hlen(key));
					break;
				case RedisBuildData.OPTION_METHOD_HVALS:
					headers.add(key);
					retData.add(redisExecutor.hvals(key));
					break;
				case RedisBuildData.OPTION_METHOD_HSCAN:
					if (redisExecutor.getClusterModel() == RedisClusterModelEnum.CLUSTER) {
						throw new IllegalArgumentException("redis cluster模式不支持 hscan 命令!");
					}
					List<Entry<String, String>> data = new ArrayList<>();
					String cursor_hscan = ScanParams.SCAN_POINTER_START;
					while (true) {
						// 使用scan命令获取500条数据，使用cursor游标记录位置，下次循环使用
						ScanResult<Map.Entry<String, String>> scanResult = redisExecutor.hscan(key, cursor_hscan);
						cursor_hscan = scanResult.getCursor();// 返回0 说明遍历完成
						if (scanResult.getResult().size() > 0) {
							data.addAll(scanResult.getResult());
						}
						if (StringUtil.equals(cursor_hscan, ScanParams.SCAN_POINTER_START)) {
							break;
						}
					}
					headers.add(key);
					retData.add(data);
					break;
				}
				rsData.add(retData);
				return new DataBuildResultSet(null, headers, rsData);
			} else if (configTable.startsWith(RedisBuildData.REDIS_SET_KEY)) {
				List<Object> retData = new ArrayList<>();
				switch (configWhere.get(RedisBuildData.OPTION_METHOD).toString()) {
				case RedisBuildData.OPTION_METHOD_SMEMBERS:
					headers.add(key);
					retData.add(redisExecutor.smembers(key));
					break;
				case RedisBuildData.OPTION_METHOD_SISMEMBER:
					String value_sismember = configWhere.get(RedisBuildData.COLUMN_VALUE).toString();
					headers.add(value_sismember);
					retData.add(redisExecutor.sismember(key, value_sismember));
					break;
				case RedisBuildData.OPTION_METHOD_SCARD:
					headers.add(key);
					retData.add(redisExecutor.scard(key));
					break;
				case RedisBuildData.OPTION_METHOD_SRANDMEMBER:
					Integer count_srandmember = JSON.parseObject(configWhere.get(RedisBuildData.COLUMN_INDEX), Integer.class);
					List<String> srandmember = redisExecutor.srandmember(key, count_srandmember);
					headers.add(key);
					retData.add(srandmember);
					break;
				case RedisBuildData.OPTION_METHOD_SPOP:
					Integer count_spop = JSON.parseObject(configWhere.get(RedisBuildData.COLUMN_INDEX), Integer.class);
					Set<String> spop = redisExecutor.spop(key, count_spop);
					headers.add(key);
					retData.add(spop);
					break;
				case RedisBuildData.OPTION_METHOD_SINTER:
					if (redisExecutor.getClusterModel() == RedisClusterModelEnum.CLUSTER) {
						throw new IllegalArgumentException("redis cluster模式不支持 sinter 命令!");
					}
					Set<String> sinter = redisExecutor.sinter(keys);
					headers.add(RedisBuildData.OPTION_METHOD_SINTER);
					retData.add(sinter);
					break;
				case RedisBuildData.OPTION_METHOD_SUNION:
					if (redisExecutor.getClusterModel() == RedisClusterModelEnum.CLUSTER) {
						throw new IllegalArgumentException("redis cluster模式不支持 sunion 命令!");
					}
					Set<String> sunion = redisExecutor.sunion(keys);
					headers.add(RedisBuildData.OPTION_METHOD_SUNION);
					retData.add(sunion);
					break;
				case RedisBuildData.OPTION_METHOD_SDIFF:
					if (redisExecutor.getClusterModel() == RedisClusterModelEnum.CLUSTER) {
						throw new IllegalArgumentException("redis cluster模式不支持 sdiff 命令!");
					}
					Set<String> sdiff = redisExecutor.sdiff(keys);
					headers.add(RedisBuildData.OPTION_METHOD_SDIFF);
					retData.add(sdiff);
					break;
				case RedisBuildData.OPTION_METHOD_SSCAN:
					if (redisExecutor.getClusterModel() == RedisClusterModelEnum.CLUSTER) {
						throw new IllegalArgumentException("redis cluster模式不支持 sscan 命令!");
					}
					List<String> data = new ArrayList<>();
					String cursor_sscan = ScanParams.SCAN_POINTER_START;
					while (true) {
						// 使用scan命令获取500条数据，使用cursor游标记录位置，下次循环使用
						ScanResult<String> scanResult = redisExecutor.sscan(key, cursor_sscan);
						cursor_sscan = scanResult.getCursor();// 返回0 说明遍历完成
						if (scanResult.getResult().size() > 0) {
							data.addAll(scanResult.getResult());
						}
						if (StringUtil.equals(cursor_sscan, ScanParams.SCAN_POINTER_START)) {
							break;
						}
					}
					headers.add(key);
					retData.add(data);
					break;
				}
				rsData.add(retData);
				return new DataBuildResultSet(null, headers, rsData);
			} else if (configTable.startsWith(RedisBuildData.REDIS_ZSET_KEY)) {
				List<Object> retData = new ArrayList<>();
				switch (configWhere.get(RedisBuildData.OPTION_METHOD).toString()) {
				case RedisBuildData.OPTION_METHOD_ZCARD:
					headers.add(key);
					retData.add(redisExecutor.zcard(key));
					break;
				case RedisBuildData.OPTION_METHOD_ZCOUNT:
					Double[] array_zcount = JSON.parseObject(configWhere.get(RedisBuildData.COLUMN_SCORE + "{}").toString(), Double[].class);
					long zcount = redisExecutor.zcount(key, array_zcount[0], array_zcount[1]);
					headers.add(key);
					retData.add(zcount);
					break;
				case RedisBuildData.OPTION_METHOD_ZLEXCOUNT:
					String[] value_zlexcount = JSON.parseObject(configWhere.get(RedisBuildData.COLUMN_INDEX + "{}").toString(), String[].class);
					long zlexcount = redisExecutor.zlexcount(key, value_zlexcount[0], value_zlexcount[1]);
					headers.add(key);
					retData.add(zlexcount);
					break;
				case RedisBuildData.OPTION_METHOD_ZRANGE:
					Long[] value_zrange = JSON.parseObject(configWhere.get(RedisBuildData.COLUMN_INDEX + "{}").toString(), Long[].class);
					Set<String> zrange = redisExecutor.zrange(key, value_zrange[0], value_zrange[1]);
					headers.add(key);
					retData.add(zrange);
					break;
				case RedisBuildData.OPTION_METHOD_ZRANGEBYSCORE:
					Double[] score_zrangeByScore = JSON.parseObject(configWhere.get(RedisBuildData.COLUMN_SCORE + "{}").toString(), Double[].class);
					Set<String> zrangeByScore = redisExecutor.zrangeByScore(key, score_zrangeByScore[0], score_zrangeByScore[1]);
					headers.add(key);
					retData.add(zrangeByScore);
					break;
				case RedisBuildData.OPTION_METHOD_ZRANGEBYLEX:
					String[] value_zrangeByLex = JSON.parseObject(configWhere.get(RedisBuildData.COLUMN_INDEX + "{}").toString(), String[].class);
					Set<String> zrangeByLex = redisExecutor.zrangeByLex(key, value_zrangeByLex[0], value_zrangeByLex[1]);
					headers.add(key);
					retData.add(zrangeByLex);
					break;
				case RedisBuildData.OPTION_METHOD_ZRANK:
					String member_zrank = configWhere.get(RedisBuildData.COLUMN_VALUE).toString();
					long zrank = redisExecutor.zrank(key, member_zrank);
					headers.add(member_zrank);
					retData.add(zrank);
					break;
				case RedisBuildData.OPTION_METHOD_ZREVRANGE:
					Long[] value_zrevrange = JSON.parseObject(configWhere.get(RedisBuildData.COLUMN_INDEX + "{}").toString(), Long[].class);
					Set<String> zrevrange = redisExecutor.zrevrange(key, value_zrevrange[0], value_zrevrange[1]);
					headers.add(key);
					retData.add(zrevrange);
					break;
				case RedisBuildData.OPTION_METHOD_ZREVRANGEBYSCORE:
					Double[] score_zrevrangeByScore = JSON.parseObject(configWhere.get(RedisBuildData.COLUMN_SCORE + "{}").toString(), Double[].class);
					Set<String> zrevrangeByScore = redisExecutor.zrevrangeByScore(key, score_zrevrangeByScore[0], score_zrevrangeByScore[1]);
					headers.add(key);
					retData.add(zrevrangeByScore);
					break;
				case RedisBuildData.OPTION_METHOD_ZREVRANK:
					String member_zrevrank = configWhere.get(RedisBuildData.COLUMN_VALUE).toString();
					long zrevrank = redisExecutor.zrevrank(key, member_zrevrank);
					headers.add(member_zrevrank);
					retData.add(zrevrank);
					break;
				case RedisBuildData.OPTION_METHOD_ZSCORE:
					String member_zscore = configWhere.get(RedisBuildData.COLUMN_VALUE).toString();
					double zscore = redisExecutor.zscore(key, member_zscore);
					headers.add(member_zscore);
					retData.add(zscore);
					break;
				case RedisBuildData.OPTION_METHOD_ZSCAN:
					if (redisExecutor.getClusterModel() == RedisClusterModelEnum.CLUSTER) {
						throw new IllegalArgumentException("redis cluster模式不支持 zscan 命令!");
					}
					List<Tuple> data = new ArrayList<>();
					String cursor_zscan = ScanParams.SCAN_POINTER_START;
					while (true) {
						// 使用scan命令获取500条数据，使用cursor游标记录位置，下次循环使用
						ScanResult<Tuple> scanResult = redisExecutor.zscan(key, cursor_zscan);
						cursor_zscan = scanResult.getCursor();// 返回0 说明遍历完成
						if (scanResult.getResult().size() > 0) {
							data.addAll(scanResult.getResult());
						}

						if (StringUtil.equals(cursor_zscan, ScanParams.SCAN_POINTER_START)) {
							break;
						}
					}
					retData.add(data);
					headers.add(key);
					break;
				case RedisBuildData.OPTION_METHOD_ZINCRBY:
					Double increment_zincrby = JSON.parseObject(configWhere.get(RedisBuildData.COLUMN_SCORE).toString(), Double.class);
					String member_zincrby = configWhere.get(RedisBuildData.COLUMN_VALUE).toString();
					Double zincrby = redisExecutor.zincrby(key, increment_zincrby, member_zincrby);
					headers.add(member_zincrby);
					retData.add(zincrby);
					break;
				}
				rsData.add(retData);
				return new DataBuildResultSet(null, headers, rsData);
			}
		} catch (Exception e) {
			if (e instanceof IllegalArgumentException) {
				throw new IllegalArgumentException(e);
			} else {
				e.printStackTrace();
				throw new IllegalArgumentException("redis method 请保证参数传递正确! ");
			}
		}
		return null;
	}

	private Long redisExecuteUpdate(@NotNull SQLConfig config, String sql) throws Exception {
		try {
			RedisExecutor redisExecutor = DynamicDataSource.getDetail(config.getDatasource()).getRedisExecutor();
			String configTable = config.getTable();
			if (configTable.startsWith(RedisBuildData.REDIS_TABLE_KEY)) {
				sql = StringUtil.isEmpty(sql) ? config.getSQL(false) : sql;
				switch (config.getMethod()) {
				case POST:
					return redisExecutor.crudByUpdate(DynamicDataSource.getDetail(config.getDatasource()).getRedSQLDB(), sql);
				case PUT:
				case DELETE:
					// 后面有需要,直接修改apijson sql 生成语句
					// AbstractSQLConfig
					int index = sql.indexOf("REGEXP BINARY");
					if (index > 0) {
						sql = sql.replace("REGEXP BINARY", "=");
					} else {
						index = sql.indexOf("REGEXP");
						if (index > 0) {
							sql = sql.replace("REGEXP", "=");
						}
					}
					return redisExecutor.crudByUpdate(DynamicDataSource.getDetail(config.getDatasource()).getRedSQLDB(), sql);
				default:
					return 0L;
				}
			}

			Map<String, Object> dataMap = RedisBuildData.buidData(config);
			String key = dataMap.get(RedisBuildData.COLUMN_KEY) != null ? dataMap.get(RedisBuildData.COLUMN_KEY).toString() : null;
			String[] keys = dataMap.get(RedisBuildData.COLUMN_KEY + "{}") != null ? JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_KEY + "{}"), String[].class) : null;
			if (configTable.startsWith(RedisBuildData.REDIS_STRING_KEY)) {
				switch (config.getMethod()) {
				case POST:
					switch (dataMap.get(RedisBuildData.OPTION_METHOD).toString()) {
					case RedisBuildData.OPTION_METHOD_SET:
						String set = redisExecutor.set(key, dataMap.get(RedisBuildData.COLUMN_VALUE).toString());
						return StringUtil.equals(set, "OK") ? 1L : 0L;
					case RedisBuildData.OPTION_METHOD_MSET:
						if (redisExecutor.getClusterModel() == RedisClusterModelEnum.CLUSTER) {
							throw new IllegalArgumentException("redis cluster模式不支持 mset 命令!");
						}
						keys = dataMap.get(RedisBuildData.COLUMN_KEY).toString().split(",");
						String mset = redisExecutor.mset(keys);
						return StringUtil.equals(mset, "OK") ? 1L : 0L;
					case RedisBuildData.OPTION_METHOD_MSETNX:
						if (redisExecutor.getClusterModel() == RedisClusterModelEnum.CLUSTER) {
							throw new IllegalArgumentException("redis cluster模式不支持 msetnx 命令!");
						}
						keys = dataMap.get(RedisBuildData.COLUMN_KEY).toString().split(",");
						String msetnx = redisExecutor.msetnx(keys);
						return StringUtil.equals(msetnx, "OK") ? 1L : 0L;
					case RedisBuildData.OPTION_METHOD_SETNX:
						return redisExecutor.setnx(key, dataMap.get(RedisBuildData.COLUMN_VALUE).toString());
					default:
						return 0L;
					}
				case PUT:
					switch (dataMap.get(RedisBuildData.OPTION_METHOD).toString()) {
					case RedisBuildData.OPTION_METHOD_APPEND:
						return redisExecutor.append(key, dataMap.get(RedisBuildData.COLUMN_VALUE).toString());
					case RedisBuildData.OPTION_METHOD_SETEX:
						Integer seconds = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_EXPIRE_TIME), Integer.class);
						String setex = redisExecutor.setex(key, seconds, dataMap.get(RedisBuildData.COLUMN_VALUE).toString());
						return StringUtil.equals(setex, "OK") ? 1L : 0L;
					case RedisBuildData.OPTION_METHOD_INCR:
						return redisExecutor.incr(key);
					case RedisBuildData.OPTION_METHOD_DECR:
						return redisExecutor.decr(key);
					case RedisBuildData.OPTION_METHOD_INCRBY:
						Integer incrby = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_VALUE), Integer.class);
						return redisExecutor.incrby(key, incrby);
					case RedisBuildData.OPTION_METHOD_DECRBY:
						Integer decrby = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_VALUE), Integer.class);
						return redisExecutor.decrby(key, decrby);
					default:
						return 0L;
					}
				case DELETE:
				default:
					return 0L;
				}
			} else if (configTable.startsWith(RedisBuildData.REDIS_HASH_KEY)) {
				switch (config.getMethod()) {
				case POST:
					switch (dataMap.get(RedisBuildData.OPTION_METHOD).toString()) {
					case RedisBuildData.OPTION_METHOD_HSETNX:
						String index_hsetnx = dataMap.get(RedisBuildData.COLUMN_INDEX).toString();
						String value_hsetnx = dataMap.get(RedisBuildData.COLUMN_VALUE).toString();
						return redisExecutor.hsetnx(key, index_hsetnx, value_hsetnx);
					case RedisBuildData.OPTION_METHOD_HSET:
						String index_hset = dataMap.get(RedisBuildData.COLUMN_INDEX).toString();
						String value_hset = dataMap.get(RedisBuildData.COLUMN_VALUE).toString();
						redisExecutor.hset(key, index_hset, value_hset);
						return 1L; // 修改返回0,新增返回1
					case RedisBuildData.OPTION_METHOD_HMSET:
						String value_hmset = dataMap.get(RedisBuildData.COLUMN_VALUE).toString();
						Map<String, String> indexVal = JSONObject.parseObject(value_hmset, new TypeReference<Map<String, String>>() {
						});
						String hmset = redisExecutor.hmset(key, indexVal);
						return StringUtil.equals(hmset, "OK") ? 1L : 0L;
					}
				case PUT:
					switch (dataMap.get(RedisBuildData.OPTION_METHOD).toString()) {
					case RedisBuildData.OPTION_METHOD_HINCRBY:
						String index_hincrby = dataMap.get(RedisBuildData.COLUMN_INDEX).toString();
						Long value_hincrby = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_VALUE), Long.class);
						return redisExecutor.hincrby(key, index_hincrby, value_hincrby);
					}
				case DELETE:
					switch (dataMap.get(RedisBuildData.OPTION_METHOD).toString()) {
					case RedisBuildData.OPTION_METHOD_HDEL:
						String[] delKeys = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_INDEX + "{}"), String[].class);
						return redisExecutor.hdel(key, delKeys);
					}
				default:
					return 0L;
				}
			} else if (configTable.startsWith(RedisBuildData.REDIS_LIST_KEY)) {
				switch (config.getMethod()) {
				case POST:
					switch (dataMap.get(RedisBuildData.OPTION_METHOD).toString()) {
					case RedisBuildData.OPTION_METHOD_LPUSH:
						String[] value_lpush = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_VALUE), String[].class);
						return redisExecutor.lpush(key, value_lpush);
					case RedisBuildData.OPTION_METHOD_RPUSH:
						String[] value_rpush = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_VALUE), String[].class);
						return redisExecutor.rpush(key, value_rpush);
					case RedisBuildData.OPTION_METHOD_LSET:
						Long index_lset = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_INDEX), Long.class);
						String value_lset = dataMap.get(RedisBuildData.COLUMN_VALUE).toString();
						String lset = redisExecutor.lset(key, index_lset, value_lset);
						return StringUtil.equals(lset, "OK") ? 1L : 0L;
					case RedisBuildData.OPTION_METHOD_LINSERT:
						String position_linsert = dataMap.get(RedisBuildData.COLUMN_INDEX).toString();
						ListPosition where;
						if (StringUtil.equalsIgnoreCase(position_linsert, ListPosition.BEFORE.toString())) {
							where = ListPosition.BEFORE;
						} else {
							where = ListPosition.AFTER;
						}
						String[] array_linsert = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_VALUE), String[].class);
						return redisExecutor.linsert(key, where, array_linsert[0], array_linsert[1]);
					}
				case PUT:
					switch (dataMap.get(RedisBuildData.OPTION_METHOD).toString()) {
					case RedisBuildData.OPTION_METHOD_LTRIM:
						Integer[] index_ltrim = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_INDEX + "{}"), Integer[].class);
						String ltrim = redisExecutor.ltrim(key, index_ltrim[0], index_ltrim[1]);
						return StringUtil.equals(ltrim, "OK") ? 1L : 0L;
					}
				case DELETE:
					switch (dataMap.get(RedisBuildData.OPTION_METHOD).toString()) {
					case RedisBuildData.OPTION_METHOD_LREM:
						Long index_lrem = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_INDEX), Long.class);
						String value_lrem = dataMap.get(RedisBuildData.COLUMN_VALUE).toString();
						return redisExecutor.lrem(key, index_lrem, value_lrem);
					}
				default:
					return 0L;
				}
			} else if (configTable.startsWith(RedisBuildData.REDIS_SET_KEY)) {
				switch (config.getMethod()) {
				case POST:
					switch (dataMap.get(RedisBuildData.OPTION_METHOD).toString()) {
					case RedisBuildData.OPTION_METHOD_SADD:
						String[] members_sadd = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_VALUE), String[].class);
						return redisExecutor.sadd(key, members_sadd);
					}
				case PUT:
					switch (dataMap.get(RedisBuildData.OPTION_METHOD).toString()) {
					case RedisBuildData.OPTION_METHOD_SMOVE:
						String key1Member = dataMap.get(RedisBuildData.COLUMN_VALUE).toString();
						Long smove = redisExecutor.smove(keys[0], keys[1], key1Member);
						return smove;
					}
				case DELETE:
					switch (dataMap.get(RedisBuildData.OPTION_METHOD).toString()) {
					case RedisBuildData.OPTION_METHOD_SREM:
						String[] members_srem = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_VALUE + "{}"), String[].class);
						Long ret_srem = redisExecutor.srem(key, members_srem);
						return ret_srem;
					}
				default:
					return 0L;
				}
			} else if (configTable.startsWith(RedisBuildData.REDIS_ZSET_KEY)) {
				switch (config.getMethod()) {
				case POST:
					switch (dataMap.get(RedisBuildData.OPTION_METHOD).toString()) {
					case RedisBuildData.OPTION_METHOD_ZADD:
						String value_zadd = dataMap.get(RedisBuildData.COLUMN_VALUE).toString();
						Map<String, Double> zaddVal = JSONObject.parseObject(value_zadd, new TypeReference<Map<String, Double>>() {
						});
						return redisExecutor.zadd(key, zaddVal);
					case RedisBuildData.OPTION_METHOD_ZINTERSTORE:
						String[] array_zinterstore = Arrays.copyOfRange(keys, 1, keys.length);
						return redisExecutor.zinterstore(keys[0], array_zinterstore);
					}
				case DELETE:
					switch (dataMap.get(RedisBuildData.OPTION_METHOD).toString()) {
					case RedisBuildData.OPTION_METHOD_ZREM:
						String[] members_zrem = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_VALUE + "{}"), String[].class);
						return redisExecutor.zrem(key, members_zrem);
					case RedisBuildData.OPTION_METHOD_ZREMRANGEBYLEX:
						String[] value_zremrangeByLex = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_INDEX + "{}"), String[].class);
						return redisExecutor.zremrangeByLex(key, value_zremrangeByLex[0], value_zremrangeByLex[1]);
					case RedisBuildData.OPTION_METHOD_ZREMRANGEBYRANK:
						Long[] value_zremrangeByRank = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_INDEX + "{}"), Long[].class);
						return redisExecutor.zremrangeByRank(key, value_zremrangeByRank[0], value_zremrangeByRank[1]);
					case RedisBuildData.OPTION_METHOD_ZREMRANGEBYSCORE:
						Double[] score_zremrangebyscore = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_SCORE + "{}"), Double[].class);
						Long zremrangebyscore = redisExecutor.zremrangebyscore(key, score_zremrangebyscore[0], score_zremrangebyscore[1]);
						return zremrangebyscore;
					case RedisBuildData.OPTION_METHOD_ZUNIONSTORE:
						String destKey = keys[0];
						String[] array_zunionstore = Arrays.copyOfRange(keys, 1, keys.length);
						Long zunionstore = redisExecutor.zunionstore(destKey, array_zunionstore);
						return zunionstore;
					}
				default:
					return 0L;
				}
			} else if (configTable.startsWith(RedisBuildData.REDIS_KEYS)) {
				switch (config.getMethod()) {
				case POST:
					switch (dataMap.get(RedisBuildData.OPTION_METHOD).toString()) {
					case RedisBuildData.OPTION_METHOD_EXPIRE:
						Long seconds = JSON.parseObject(dataMap.get(RedisBuildData.COLUMN_EXPIRE_TIME), Long.class);
						return redisExecutor.expire(key, seconds);
					}
				case PUT:
					switch (dataMap.get(RedisBuildData.OPTION_METHOD).toString()) {
					case RedisBuildData.OPTION_METHOD_RENAME:
						if (redisExecutor.getClusterModel() == RedisClusterModelEnum.CLUSTER) {
							throw new IllegalArgumentException("redis cluster模式不支持 rename 修改 key 的名称!");
						}
						String rename = redisExecutor.rename(keys[0], keys[1]);
						return StringUtil.equals(rename, "OK") ? 1L : 0L;
					}
				case DELETE:
					switch (dataMap.get(RedisBuildData.OPTION_METHOD).toString()) {
					case RedisBuildData.OPTION_METHOD_DEL:
						if (dataMap.get(RedisBuildData.COLUMN_KEY) != null) {
							return redisExecutor.del(key);
						}
						if (dataMap.get(RedisBuildData.COLUMN_KEY + "{}") != null) {
							if (redisExecutor.getClusterModel() == RedisClusterModelEnum.CLUSTER) {
								throw new IllegalArgumentException("redis cluster模式不支持 del keys !");
							}
							return redisExecutor.del(keys);
						}
					case RedisBuildData.OPTION_METHOD_PERSIST:
						return redisExecutor.persist(key);
					}
				default:
					return 0L;
				}
			}
		} catch (Exception e) {
			if (e instanceof IllegalArgumentException) {
				throw new IllegalArgumentException(e);
			} else {
				e.printStackTrace();
				throw new IllegalArgumentException("redis method 请保证参数传递正确! ");
			}
		}
		return 0L;
	}
	/***
	 * 查询返回字段值进行二次处理
	 */
//	@Override
//	protected JSONObject onPutColumn(@NotNull SQLConfig config, @NotNull ResultSet rs, @NotNull ResultSetMetaData rsmd
//			, final int tablePosition, @NotNull JSONObject table, final int columnIndex, Join join, Map<String, JSONObject> childMap) throws Exception {
//		if (table == null) {  // 对应副表 viceSql 不能生成正常 SQL， 或者是 ! - Outer, ( - ANTI JOIN 的副表这种不需要缓存及返回的数据
//			Log.i(TAG, "onPutColumn table == null >> return table;");
//			return table;
//		}
//
//		if (isHideColumn(config, rs, rsmd, tablePosition, table, columnIndex, childMap)) {
//			Log.i(TAG, "onPutColumn isHideColumn(config, rs, rsmd, tablePosition, table, columnIndex, childMap) >> return table;");
//			return table;
//		}
//
//		String label = getKey(config, rs, rsmd, tablePosition, table, columnIndex, childMap);
//		Object value = getValue(config, rs, rsmd, tablePosition, table, columnIndex, label, childMap);
//		
//		// TODO
//		if(StringUtils.equals(config.getTable(), "User") && StringUtils.equals(label, "addr_id")) {
//			value = "1-1-1";
//		}
//		// 主表必须 put 至少一个 null 进去，否则全部字段为 null 都不 put 会导致中断后续正常返回值
//		if (value != null || (join == null && table.isEmpty())) {
//			table.put(label, value);
//		}
//
//		return table;
//	}

	// 取消注释支持 !key 反选字段 和 字段名映射，需要先依赖插件 https://github.com/APIJSON/apijson-column
	// @Override
	// protected String getKey(SQLConfig config, ResultSet rs, ResultSetMetaData
	// rsmd, int tablePosition, JSONObject table,
	// int columnIndex, Map<String, JSONObject> childMap) throws Exception {
	// return ColumnUtil.compatOutputKey(super.getKey(config, rs, rsmd,
	// tablePosition, table, columnIndex, childMap), config.getTable(),
	// config.getMethod());
	// }

	// 不需要隐藏字段这个功能时，取消注释来提升性能
	// @Override
	// protected boolean isHideColumn(SQLConfig config, ResultSet rs,
	// ResultSetMetaData rsmd, int tablePosition,
	// JSONObject table, int columnIndex, Map<String, JSONObject> childMap) throws
	// SQLException {
	// return false;
	// }

}
