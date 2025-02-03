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

import apijson.orm.SQLExecutor;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.boot.web.servlet.server.ConfigurableServletWebServerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import apijson.Log;
import apijson.framework.javax.APIJSONApplication;
import apijson.framework.javax.APIJSONCreator;
import apijson.orm.SQLConfig;


/**
 * Demo SpringBoot Application 主应用程序启动类
 * 右键这个类 > Run As > Java Application
 * 具体见 SpringBoot 文档
 * https://www.springcloud.cc/spring-boot.html#using-boot-locating-the-main-class
 *
 * @author Lemon
 */
@Configuration
@SpringBootApplication
@EnableConfigurationProperties
public class DemoApplication implements WebServerFactoryCustomizer<ConfigurableServletWebServerFactory> {

  public static void main(String[] args) throws Exception {
    SpringApplication.run(DemoApplication.class, args);

    Log.DEBUG = true;
    APIJSONApplication.init(false);  // 4.4.0 以上需要这句来保证以上 static 代码块中给 DEFAULT_APIJSON_CREATOR 赋值会生效
  }

  // SpringBoot 2.x 自定义端口方式
  @Override
  public void customize(ConfigurableServletWebServerFactory server) {
    server.setPort(8080);
  }

  // 支持 APIAuto 中 JavaScript 代码跨域请求
  @Bean
  public WebMvcConfigurer corsConfig() {
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

  static {
    // 使用本项目的自定义处理类
    APIJSONApplication.DEFAULT_APIJSON_CREATOR = new APIJSONCreator<Long>() {
      @Override
      public SQLConfig<Long> createSQLConfig() {
        return new DemoSQLConfig();
      }

      @Override
      public SQLExecutor<Long> createSQLExecutor() {
        return new DemoSQLExecutor();
      }
    };

  }

}
