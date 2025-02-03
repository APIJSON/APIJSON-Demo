///*Copyright ©2016 TommyLemon(https://github.com/TommyLemon/APIJSON)
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.*/
//
//package apijson.demo;
//
//import com.zaxxer.hikari.HikariDataSource;
//import org.springframework.boot.context.properties.ConfigurationProperties;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//
//import javax.sql.DataSource;
//
//
///**数据源配置，对应 application.yml 的数据库连接池 datasource 配置。
// * 也可以直接 new 再 set 属性，具体见 HikariCP 的文档
// * https://github.com/brettwooldridge/HikariCP#rocket-initialization
// * @author Lemon
// */
//@Configuration
//public class DemoDataSourceConfig {
//
//	@Bean
//	@ConfigurationProperties(prefix = "spring.datasource.hikari")
//	public DataSource dataSource() {
//		return new HikariDataSource();
//	}
//
//	@Bean
//	@ConfigurationProperties(prefix = "spring.datasource.ds-0")
//	public DataSource dataSourceDS0() {
//		return new HikariDataSource();
//	}
//
//	@Bean
//	@ConfigurationProperties(prefix = "spring.datasource.ds-1")
//	public DataSource dataSourceDS1() {
//		return new HikariDataSource();
//	}
//
//}