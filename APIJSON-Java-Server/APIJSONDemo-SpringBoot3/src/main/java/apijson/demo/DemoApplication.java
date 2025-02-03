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

import apijson.Log;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.boot.web.servlet.server.ConfigurableServletWebServerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;


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

    Log.DEBUG = true; // TODO 上线前改为 false
    System.out.println("官方网站： http://apijson.cn");
    System.out.println("设计规范： https://github.com/Tencent/APIJSON/blob/master/Document.md#3");
    System.out.println("测试链接： http://apijson.cn/api?type=JSON&url=http://localhost:8080/get");
    System.out.println("\n\n<<<<<<<<<<<<<<<<<<<<<<<<< APIJSON 启动完成，试试调用零代码万能通用 API 吧 ^_^ >>>>>>>>>>>>>>>>>>>>>>>>\n");
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


}
