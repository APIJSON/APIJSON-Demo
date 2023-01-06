package apijson.demo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.sql.DataSource;

import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import com.alibaba.druid.pool.DruidDataSource;
import com.baomidou.dynamic.datasource.DynamicRoutingDataSource;
import com.baomidou.dynamic.datasource.ds.ItemDataSource;
import com.baomidou.mybatisplus.extension.toolkit.JdbcUtils;

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
			datasource = DataBaseConfig.getInstence().getPrimary();
		}
		// 不存在交给框架处理
		return dataSourceMap.get(datasource);
	}

	@Override
	public void run(ApplicationArguments args) throws Exception {
		initJdbcDataSource(); // 初始化spring application.xml 数据库连接池
		// kafka
		initMQ_kafka();
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
	
	/***
	 * 仅供测试使用
	 */
	public void initMQ_kafka() {
		/* 1.创建kafka生产者的配置信息 */
		Properties props = new Properties();
		/*2.指定连接的kafka集群, broker-list */
		props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "xxx:9092");  
		/*3.ack应答级别*/
		props.put(ProducerConfig.ACKS_CONFIG, "all");
		/*4.重试次数*/ 
		props.put(ProducerConfig.RETRIES_CONFIG, 3); 
		/*5.批次大小，一次发送多少数据，当数据大于16k，生产者会发送数据到 kafka集群 */
		props.put(ProducerConfig.BATCH_SIZE_CONFIG, 16384);  
		/*6.等待时间， 等待时间超过1毫秒，即便数据没有大于16k， 也会写数据到kafka集群 */
		props.put(ProducerConfig.LINGER_MS_CONFIG, 1); 
		/*7. RecordAccumulator 缓冲区大小*/ 
		props.put(ProducerConfig.BUFFER_MEMORY_CONFIG, 33554432);  
		/*8. key, value 的序列化类 */ 
		props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
		props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
		
		
		DynamicDataSource dynDataSource = new DynamicDataSource();
		dynDataSource.setDatasourceName("kafka");
		dynDataSource.setDatabase("MQ");
		dynDataSource.setSchema(""); // 不需要配置数据库名
		dynDataSource.setDbVersion("2.8.1"); // 后面做成动态的
		dynDataSource.setClusterName("kafka");
		dynDataSource.setProps(props);
		dataSourceMap.put(dynDataSource.getDatasourceName(), dynDataSource);
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
