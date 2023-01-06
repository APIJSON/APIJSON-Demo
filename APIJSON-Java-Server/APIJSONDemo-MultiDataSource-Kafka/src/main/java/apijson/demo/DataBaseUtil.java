package apijson.demo;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import lombok.extern.log4j.Log4j2;

@Log4j2
public class DataBaseUtil {

    /**
     * 根据url获取库名
     * @param url
     * @return
     */
    public static String getLibname(String url) {
        Pattern p = Pattern.compile("jdbc:(?<db>\\w+):.*((//)|@)(?<host>.+):(?<port>\\d+)(/|(;DatabaseName=)|:)(?<dbName>\\w+)\\??.*");
        Matcher m = p.matcher(url);
        if(m.find()) {
            return m.group("dbName");
        }
        return null;
    }

    /***
     * primary: master
     * strict: false
     * @param datasource: 匹配不成功, 自动匹配默认数据库
     * @return
     */
    public static javax.sql.DataSource getDataSource(String datasource) {
		try {
			return DynamicDataSource.getDetail(datasource).getDataSource(); // 数据源
		} catch (Exception e) {
			throw new IllegalArgumentException("动态数据源配置错误 " + datasource);
		}
	}

	public static String getDruidUrl(String datasource) {
		return DynamicDataSource.getDetail(datasource).getUrl(); // 数据库连接url
	}

	public static String getDruidSchema(String datasource) {
		return getLibname(DynamicDataSource.getDetail(datasource).getUrl()); // 数据库名;
	}
	
	public static String getDruidDBAccount(String datasource) {
		return DynamicDataSource.getDetail(datasource).getDbAccount(); // 数据库用户名
	}
	
	public static String getDruidDBPassword(String datasource) {
		return DynamicDataSource.getDetail(datasource).getDbPassword(); // 数据库密码
	}
}
