package apijson.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DataBaseConfig {
	private String primary;

	@Value("${spring.datasource.dynamic.primary}")
	public void setPrimary(String primary) {
		this.primary = primary;
	}

	public String getPrimary() {
		return primary;
	}

	public static DataBaseConfig getInstance() {
		return SpringContextUtils.getBean(DataBaseConfig.class);
	}
}
