package com.example.apijsondemo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.example.apijsondemo.config.DemoSQLConfig;

import apijson.Log;
import apijson.framework.APIJSONApplication;
import apijson.framework.APIJSONCreator;
import apijson.orm.SQLConfig;
import apijson.orm.SQLExecutor;

@Configuration
@SpringBootApplication
@EnableConfigurationProperties
public class ApijsonDemoApplication {
	public static final String TAG = "APIJSON 启动器";

	// 全局 ApplicationContext 实例，方便 getBean 拿到 Spring/SpringBoot 注入的类实例
	private static ApplicationContext APPLICATION_CONTEXT;

	public static ApplicationContext getApplicationContext() {
		return APPLICATION_CONTEXT;
	}

	public static void main(String[] args) throws Exception {
		APPLICATION_CONTEXT = SpringApplication.run(ApijsonDemoApplication.class, args);

		Log.DEBUG = true; // TODO 上线前改为 false

		APIJSONApplication.init(false); // 4.4.0 以上需要这句来保证以上 static 代码块中给 DEFAULT_APIJSON_CREATOR 赋值会生效

	}

	// TODO 需要设置限制条件
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
		// APiJSON 配置
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

		// 配置数据库
		try { // 加载驱动程序
			Log.d(TAG, "尝试加载 mysql 驱动 <<<<<<<<<<<<<<<<<<<<< ");
			Class.forName("com.mysql.cj.jdbc.Driver");
			Log.d(TAG, "成功加载 mysql 驱动！>>>>>>>>>>>>>>>>>>>>> ");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			Log.e(TAG, "加载 mysql 驱动失败，请检查 pom.xml 中 com.mysql 版本是否存在以及可用 ！！！");
		}
	}

}
