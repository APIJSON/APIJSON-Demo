package apijson.demo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

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

import apijson.orm.SQLConfig;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;

/***
 * 不存在并发问题 缓存 jdbc 数据源,供apijson调用 1、应用启动添加数据源 2、页面动态添加数据源(数据库存储数据源信息)
 * 
 *
 */
@Data
@Order(value = 10)
@Component
@Slf4j
public class DynamicDataSource implements ApplicationRunner {
	// value: 数据源相关信息
	private static Map<String, DynamicDataSource> dataSourceMap = new HashMap<>();
	private static final String DB = "DB";
	// redis 数据源
	private JedisClusterUtil jedisClusterUtil;
	private String database; // 表所在的数据库类型
	private String schema; // 表所在的数据库名
	private String datasourceName; // 数据源
	private String url; // jdbc url
	private String dbAccount; // 数据库用户名
	private String dbPassword; // 数据库密码
	private String dbVersion; // 数据库版本号
	private String clusterName; // 集群名称
	private Properties props; // 属性值
	
	@Autowired
	private DataSource dataSource; // 数据源

	public static void addDataSource(DynamicDataSource detail) {
		dataSourceMap.put(detail.getDatasourceName(), detail);
	}

	/***
	 * 获取数据源详细信息
	 * 
	 * @return
	 */
	public static DynamicDataSource getDetail(String datasource) {
		if (datasource == null) {
			// 默认数据源
			datasource = DataBaseConfig.getInstance().getPrimary();
		}
		// 不存在交给框架处理
		return dataSourceMap.get(datasource);
	}

	@Override
	public void run(ApplicationArguments args) throws Exception {
		initJdbcDataSource(); // 初始化spring application.xml 数据库连接池
		
		// redisCluster
		initRedisCluster();
	}

	/***
	 * 仅供测试使用
	 */
	public void initRedisCluster() {
		JedisClusterUtil jedisClusterUtil = new JedisClusterUtil();
		jedisClusterUtil.createJedisPool();
		jedisClusterUtil.setJedis(DB);
		
		DynamicDataSource dynDataSource = new DynamicDataSource();
		dynDataSource.setDatasourceName("redisCluster");
		dynDataSource.setDatabase(SQLConfig.DATABASE_REDIS);
		dynDataSource.setSchema(""); // 不需要配置数据库名
		dynDataSource.setDbVersion("7.0.6"); // 后面做成动态的
		dynDataSource.setClusterName("redis-cluster");
		dynDataSource.setJedisClusterUtil(jedisClusterUtil);
		dataSourceMap.put(dynDataSource.getDatasourceName(), dynDataSource);
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

			DynamicDataSource dynDataSource = new DynamicDataSource();
			dynDataSource.setDatasourceName(datasourceName);
			dynDataSource.setDatabase(database);
			dynDataSource.setDataSource(druid);
			dynDataSource.setSchema(schema);
			dynDataSource.setUrl(url);
			dynDataSource.setDbAccount(dbAccount);
			dynDataSource.setDbPassword(dbPassword);
			dynDataSource.setDbVersion(dbVersion);
			dataSourceMap.put(datasourceName, dynDataSource);
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
