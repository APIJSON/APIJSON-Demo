package apijson.demo;

import static com.alibaba.druid.pool.DruidDataSourceFactory.PROP_CONNECTIONPROPERTIES;
import static com.alibaba.druid.pool.DruidDataSourceFactory.PROP_URL;

import java.net.InetAddress;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.sql.DataSource;

import org.apache.http.HttpHost;
import org.elasticsearch.common.transport.TransportAddress;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import com.alibaba.druid.pool.DruidDataSource;
import com.alibaba.druid.pool.ElasticSearchDruidDataSourceFactory;
import com.baomidou.dynamic.datasource.DynamicRoutingDataSource;
import com.baomidou.dynamic.datasource.ds.ItemDataSource;
import com.baomidou.mybatisplus.extension.toolkit.JdbcUtils;

import apijson.JSONObject;
import apijson.StringUtil;
import apijson.orm.SQLConfig;
import lombok.Data;
import lombok.extern.log4j.Log4j2;

/***
 * 不存在并发问题 
 * 缓存 jdbc 数据源,供apijson调用 
 * 1、应用启动添加数据源 
 * 2、页面动态添加数据源(数据库存储数据源信息)
 * 
 *
 */
@Data
@Order(value = 10)
@Component
@Log4j2
public class DynamicJdbcDataSource implements ApplicationRunner {
	// value: 数据源相关信息
	private static Map<String, DynamicJdbcDataSource> dataSourceMap = new HashMap<>();
	private String database; // 表所在的数据库类型
	private String schema; // 表所在的数据库名
	private String datasourceName; // 数据源
	private String url; // jdbc url
	private String dbAccount; // 数据库用户名
	private String dbPassword; // 数据库密码
	private String dbVersion; // 数据库版本号
	private String clusterName; // 集群名称
	private TransportAddress[] transportAddresss; // elasticSearch tcp地址
	private HttpHost[] httpHosts; // elasticSearch http地址

	@Autowired
	private DataSource dataSource; // 数据源

	public static void addDataSource(DynamicJdbcDataSource detail) {
		dataSourceMap.put(detail.getDatasourceName(), detail);
	}

	/***
	 * 获取数据源详细信息
	 * 
	 * @return
	 */
	public static DynamicJdbcDataSource getDetail(String datasource) {
		if (datasource == null) {
			// 默认数据源
			datasource = DataBaseConfig.getInstence().getPrimary();
		}
		// 不存在交给框架处理
		return dataSourceMap.get(datasource);
	}

	@Override
	public void run(ApplicationArguments args) throws Exception {
		initJdbcDataSource(); // 初始化spring application.xml 数据库连接池
		// 从数据库初始化 动态数据源
		initElasticDataSource();
	}

	/***
	 * 后面替换为从数据库加载
	 * 
	 * @throws Exception
	 */
	public void initElasticDataSource() throws Exception {
		String datasourceName = "elasticSearch";
		String urlPrefix = "jdbc:elasticsearch://";
		String httpAddress = "127.0.0.1:9201,192.168.0.1:9203,192.168.0.101:9203";
		String[] httpAddressArr = httpAddress.split(",");
		HttpHost[] httpHosts = new HttpHost[httpAddressArr.length];
		for (int i = 0; i < httpAddressArr.length; i++) {
			String val = httpAddressArr[i];
			String[] data = val.split(":");
			HttpHost httpHost = new HttpHost(InetAddress.getByName(data[0]), Integer.parseInt(data[1]));
			httpHosts[i] = httpHost;
		}

		String tcpAddress = "127.0.0.1:9201,192.168.0.1:9203,192.168.0.101:9203";
		String url = urlPrefix + tcpAddress;
		String[] tcpAddressArr = tcpAddress.split(",");
		TransportAddress[] transportAddresss = new TransportAddress[tcpAddressArr.length];
		for (int i = 0; i < tcpAddressArr.length; i++) {
			String val = tcpAddressArr[i];
			String[] data = val.split(":");
			TransportAddress transportAddress = new TransportAddress(InetAddress.getByName(data[0]), Integer.parseInt(data[1]));
			transportAddresss[i] = transportAddress;
		}
		log.info("elasticSearch数据源:{},ip地址:{} ", datasourceName, JSONObject.toJSONString(transportAddresss));
		String database = SQLConfig.DATABASE_ELASTICSEARCH; // 数据库类型
		String dbAccount = null;  // 数据库用户名
		String dbPassword = null; // 数据库密码
		Properties properties = new Properties();
		properties.put(PROP_URL, url);
		String connectionStr = "client.transport.ignore_cluster_name=true";
		if (StringUtil.isNotEmpty(dbAccount) && StringUtil.isNotEmpty(dbPassword)) {
			connectionStr += ";xpack.security.user="+dbAccount+":"+dbPassword;
		}
		// properties.put(PROP_CONNECTIONPROPERTIES, "client.transport.ignore_cluster_name=true;xpack.security.user=elastic:5laftq1NilavFTibKOaZ");
		properties.put(PROP_CONNECTIONPROPERTIES, connectionStr);
		DataSource dataSource = ElasticSearchDruidDataSourceFactory.createDataSource(properties);

		DynamicJdbcDataSource dynDataSource = new DynamicJdbcDataSource();
		dynDataSource.setDatasourceName(datasourceName);
		dynDataSource.setDatabase(database);
		dynDataSource.setDataSource(dataSource);
		dynDataSource.setSchema(""); // 不需要配置数据库名
		// APIJSONSQLConfig.TABLE_KEY_MAP.put("ES_blog", "es_blog/dd"); 来支持 index/doc
		dynDataSource.setUrl(url);
		if (StringUtil.isNotEmpty(dbAccount) && StringUtil.isNotEmpty(dbPassword)) {
			dynDataSource.setDbAccount(dbAccount);
			dynDataSource.setDbPassword(dbPassword);
		}
		dynDataSource.setDbVersion("7.17.5");
		dynDataSource.setClusterName("docker-cluster");
		dynDataSource.setTransportAddresss(transportAddresss);
		dynDataSource.setHttpHosts(httpHosts);
		dataSourceMap.put(datasourceName, dynDataSource);
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

			DynamicJdbcDataSource dynDataSource = new DynamicJdbcDataSource();
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
