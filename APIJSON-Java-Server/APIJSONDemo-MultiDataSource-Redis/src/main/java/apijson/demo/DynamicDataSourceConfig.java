package apijson.demo;

import java.util.Properties;
import javax.sql.DataSource;
import apijson.demo.redis.RedisExecutor;
import lombok.Data;

@Data
public class DynamicDataSourceConfig {
	private RedisExecutor redisExecutor;
	private String database; // 表所在的数据库类型
	private String schema; // 表所在的数据库名
	private String datasourceName; // 数据源
	private String url; // jdbc url
	private String dbAccount; // 数据库用户名
	private String dbPassword; // 数据库密码
	private String dbVersion; // 数据库版本号
	private String clusterName; // 集群名称
	private String diverClassName;
	private Properties props; // 属性值
	private String redSQLDB = "DB";
	private DataSource dataSource; // 数据源
}
