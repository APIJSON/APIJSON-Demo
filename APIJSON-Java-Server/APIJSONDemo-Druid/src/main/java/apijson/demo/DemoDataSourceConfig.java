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

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.alibaba.druid.pool.DruidDataSource;


/**数据源配置，对应 application.yml 的数据库连接池 datasource 配置。
 * 也可以直接 new 再 set 属性，具体见 Druid 的 DbTestCase  
 * https://github.com/alibaba/druid/blob/master/src/test/java/com/alibaba/druid/DbTestCase.java
 * @author Lemon
 */
@Configuration
public class DemoDataSourceConfig {

	@Bean
	@ConfigurationProperties(prefix = "spring.datasource.druid")
	public DruidDataSource druidDataSource() {
		return new DruidDataSource();
	}

}