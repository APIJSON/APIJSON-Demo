package apijson.demo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import com.alibaba.druid.pool.DruidDataSource;
import com.baomidou.dynamic.datasource.DynamicRoutingDataSource;
import com.baomidou.dynamic.datasource.ds.ItemDataSource;
import com.baomidou.mybatisplus.extension.toolkit.JdbcUtils;

import apijson.demo.redis.RedisClusterExecutor;
import apijson.demo.redis.RedisDataSource;
import apijson.demo.redis.RedisExecutor;
import apijson.demo.redis.RedisSentinelExecutor;
import apijson.demo.redis.RedisSingleExecutor;
import apijson.orm.SQLConfig;
import lombok.Data;
import lombok.extern.log4j.Log4j2;

@Data
@Order(value = 10)
@Component
@Log4j2
public class DynamicDataSource implements ApplicationRunner {
	private static int jdbcDataSourceSize = 0;
	// value: 数据源相关信息
	private static Map<String, DynamicDataSourceConfig> dataSourceMap = new HashMap<>();
	
	@Autowired
	private DataSource dataSource; // 数据源

	public static int getJdbcDataSourceSize() {
		return jdbcDataSourceSize;
	}

	public static void addJdbcDataSourceSize() {
		jdbcDataSourceSize++;
	}

	public static void addDataSource(DynamicDataSourceConfig dynamicDataSourceConfig) {
		dataSourceMap.put(dynamicDataSourceConfig.getDatasourceName(), dynamicDataSourceConfig);
	}

	/***
	 * 获取数据源详细信息
	 * 
	 * @return
	 */
	public static DynamicDataSourceConfig getDetail(String datasource) {
		if (datasource == null) {
			// 默认数据源
			datasource = DataBaseUrlConfig.getInstence().getPrimary();
		}
		// 不存在交给框架处理
		return dataSourceMap.get(datasource);
	}

	/***
	 * 保存数据源详细信息
	 *
	 * @return
	 */
	public static DynamicDataSourceConfig putDetail(String datasource, DynamicDataSourceConfig dynamicDataSourceConfig) {
		return dataSourceMap.put(datasource, dynamicDataSourceConfig);
	}

	/***
	 * 获取数据源详细信息
	 *
	 * @return
	 */
	public static Map<String, DynamicDataSourceConfig> getDataSourceMap() {
		return dataSourceMap;
	}

	@Override
	public void run(ApplicationArguments args) throws Exception {
		initJdbcDataSource(); // 初始化spring application.xml 数据库连接池

		initRedisCluster();

		initRedisSingle();
		
		//initRedisSentinel();
	}


	/***
	 * 仅供测试使用
	 */
	public void initRedisCluster() {
		RedisDataSource redisDataSource = new RedisDataSource();
		redisDataSource.createCluster();
		DynamicDataSourceConfig dynamicDataSourceConfig = new DynamicDataSourceConfig();
		dynamicDataSourceConfig.setDatasourceName("redisCluster");
		dynamicDataSourceConfig.setDatabase(SQLConfig.DATABASE_REDIS);
		dynamicDataSourceConfig.setSchema(""); // 不需要配置数据库名
		dynamicDataSourceConfig.setDbVersion("7.0.6"); // 后面做成动态的
		dynamicDataSourceConfig.setRedSQLDB("DB");
		dynamicDataSourceConfig.setClusterName("redis-cluster");
		RedisExecutor redisExecutor = new RedisClusterExecutor();
		redisExecutor.init(redisDataSource);
		dynamicDataSourceConfig.setRedisExecutor(redisExecutor);
		dataSourceMap.put(dynamicDataSourceConfig.getDatasourceName(), dynamicDataSourceConfig);
	}
	
	public void initRedisSentinel() {
		RedisDataSource redisDataSource = new RedisDataSource();
		redisDataSource.createSentinel();
		DynamicDataSourceConfig dynamicDataSourceConfig = new DynamicDataSourceConfig();
		dynamicDataSourceConfig.setDatasourceName("redisSentinel");
		dynamicDataSourceConfig.setDatabase(SQLConfig.DATABASE_REDIS);
		dynamicDataSourceConfig.setSchema(""); // 不需要配置数据库名
		dynamicDataSourceConfig.setDbVersion("7.0.6"); // 后面做成动态的
		dynamicDataSourceConfig.setRedSQLDB("DB");
		dynamicDataSourceConfig.setClusterName("redis-sentinel");
		RedisExecutor redisExecutor = new RedisSentinelExecutor();
		redisExecutor.init(redisDataSource);
		dynamicDataSourceConfig.setRedisExecutor(redisExecutor);
		dataSourceMap.put(dynamicDataSourceConfig.getDatasourceName(), dynamicDataSourceConfig);
	}

	public void initRedisSingle() {
		RedisDataSource redisDataSource = new RedisDataSource();
		redisDataSource.createSingle();
		DynamicDataSourceConfig dynamicDataSourceConfig = new DynamicDataSourceConfig();
		dynamicDataSourceConfig.setDatasourceName("redisSingle");
		dynamicDataSourceConfig.setDatabase(SQLConfig.DATABASE_REDIS);
		dynamicDataSourceConfig.setSchema(""); // 不需要配置数据库名
		dynamicDataSourceConfig.setDbVersion("7.0.6"); // 后面做成动态的
		dynamicDataSourceConfig.setClusterName("redis-single");
		RedisExecutor redisExecutor = new RedisSingleExecutor();
		redisExecutor.init(redisDataSource);
		dynamicDataSourceConfig.setRedisExecutor(redisExecutor);
		dataSourceMap.put(dynamicDataSourceConfig.getDatasourceName(), dynamicDataSourceConfig);
	}


	/***
	 * 初始化数据库连接池
	 */
	private void initJdbcDataSource() {
		DynamicRoutingDataSource dataSourceList = (DynamicRoutingDataSource) this.dataSource;
		for (String datasourceName : dataSourceList.getDataSources().keySet()) {
			ItemDataSource dataSource = (ItemDataSource) dataSourceList.getDataSources().get(datasourceName);
			DruidDataSource druid = (DruidDataSource) dataSource.getRealDataSource();
			String url = druid.getDataSourceStat().getUrl(); // 数据库连接url
			String schema = DataBaseUtil.getLibname(url); // 数据库名;
			String database = JdbcUtils.getDbType(url).getDb().toUpperCase(); // 数据库类型
			String dbAccount = druid.getUsername(); // 数据库用户名
			String dbPassword = druid.getPassword(); // 数据库密码
			String dbVersion = getDBVersion(dataSource);

			DynamicDataSourceConfig dynamicDataSourceConfig = new DynamicDataSourceConfig();
			dynamicDataSourceConfig.setDatasourceName(datasourceName);
			dynamicDataSourceConfig.setDatabase(database);
			dynamicDataSourceConfig.setDataSource(druid);
			dynamicDataSourceConfig.setSchema(schema);
			dynamicDataSourceConfig.setUrl(url);
			dynamicDataSourceConfig.setDbAccount(dbAccount);
			dynamicDataSourceConfig.setDbPassword(dbPassword);
			dynamicDataSourceConfig.setDbVersion(dbVersion);
			addJdbcDataSourceSize();
			dataSourceMap.put(datasourceName, dynamicDataSourceConfig);
		}
	}

	public String getDBVersion(DataSource dataSource) {
		Connection connection = null;
		Statement statement = null;
		ResultSet resultSet = null;
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery("select version() as version");
			while (resultSet.next()) {
				return resultSet.getString("version");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (resultSet != null) {
					resultSet.close();
				}
				if (statement != null) {
					statement.close();
				}
				if (connection != null) {
					connection.close();
				}
			} catch (SQLException throwables) {
			}
		}
		return null;
	}
}
