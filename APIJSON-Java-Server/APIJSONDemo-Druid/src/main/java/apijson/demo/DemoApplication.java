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

import org.springframework.beans.BeansException;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import apijson.Log;
import apijson.framework.APIJSONApplication;
import apijson.framework.APIJSONCreator;
import apijson.orm.SQLConfig;
import apijson.orm.SQLExecutor;


/**SpringBootApplication
 * 右键这个类 > Run As > Java Application
 * @author Lemon
 */
@Configuration
@SpringBootApplication
@EnableAutoConfiguration
@EnableConfigurationProperties
public class DemoApplication implements ApplicationContextAware {

	static {
		APIJSONApplication.DEFAULT_APIJSON_CREATOR = new APIJSONCreator() {
			@Override
			public SQLConfig createSQLConfig() {
				return new DemoSQLConfig();
			}
			@Override
			public SQLExecutor createSQLExecutor() {
				return new DemoSQLExecutor();
			}
		};
		
		// 把以下需要用到的数据库驱动取消注释即可，如果这里没有可以自己新增
		//		try { //加载驱动程序
		//			Log.d(TAG, "尝试加载 SQLServer 驱动 <<<<<<<<<<<<<<<<<<<<< ");
		//			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		//			Log.d(TAG, "成功加载 SQLServer 驱动！>>>>>>>>>>>>>>>>>>>>> ");
		//		}
		//		catch (ClassNotFoundException e) {
		//			e.printStackTrace();
		//			Log.e(TAG, "加载 SQLServer 驱动失败，请检查 pom.xml 中 net.sourceforge.jtds 版本是否存在以及可用 ！！！");
		//		}
		//		
		//		try { //加载驱动程序
		//			Log.d(TAG, "尝试加载 Oracle 驱动 <<<<<<<<<<<<<<<<<<<<< ");
		//			Class.forName("oracle.jdbc.driver.OracleDriver");
		//			Log.d(TAG, "成功加载 Oracle 驱动！>>>>>>>>>>>>>>>>>>>>> ");
		//		}
		//		catch (ClassNotFoundException e) {
		//			e.printStackTrace();
		//			Log.e(TAG, "加载 Oracle 驱动失败，请检查 pom.xml 中 com.oracle.jdbc 版本是否存在以及可用 ！！！");
		//		}

	}
	
	public static void main(String[] args) throws Exception {
		SpringApplication.run(DemoApplication.class, args);

        Log.DEBUG = true;
		APIJSONApplication.init(false);  // 4.4.0 以上需要这句来保证以上 static 代码块中给 DEFAULT_APIJSON_CREATOR 赋值会生效
	}
	
	// 全局 ApplicationContext 实例，方便 getBean 拿到 Spring/SpringBoot 注入的类实例
	private static ApplicationContext APPLICATION_CONTEXT;
	public static ApplicationContext getApplicationContext() {
		return APPLICATION_CONTEXT;
	}
	@Override
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		APPLICATION_CONTEXT = applicationContext;		
	}

	
	// 支持 APIAuto 中 JavaScript 代码跨域请求 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	@Bean
	public WebMvcConfigurer corsConfigurer() {
		return new WebMvcConfigurer() {
			@Override
			public void addCorsMappings(CorsRegistry registry) {
				registry.addMapping("/**")
				.allowedOriginPatterns("*")  
				.allowedMethods("*")
				.allowCredentials(true)
				.maxAge(3600);  
			}
		};
	}

	// 支持 APIAuto 中 JavaScript 代码跨域请求 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

}
