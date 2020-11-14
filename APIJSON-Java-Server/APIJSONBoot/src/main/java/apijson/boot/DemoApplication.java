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

package apijson.boot;

import java.lang.reflect.Modifier;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.naming.Context;

import org.springframework.beans.BeansException;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.embedded.ConfigurableEmbeddedServletContainer;
import org.springframework.boot.context.embedded.EmbeddedServletContainerCustomizer;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.PropertyFilter;

import apijson.Log;
import apijson.StringUtil;
import apijson.framework.APIJSONApplication;
import apijson.framework.APIJSONCreator;
import apijson.orm.FunctionParser;
import apijson.orm.Parser;
import apijson.orm.SQLConfig;
import apijson.orm.SQLExecutor;
import apijson.orm.Structure;
import apijson.orm.Verifier;
import unitauto.MethodUtil;
import unitauto.MethodUtil.Argument;
import unitauto.MethodUtil.InstanceGetter;
import unitauto.MethodUtil.JSONCallback;
import unitauto.NotNull;
import unitauto.jar.UnitAutoApp;


/**SpringBootApplication
 * 右键这个类 > Run As > Java Application
 * @author Lemon
 */
@Configuration
@SpringBootApplication
public class DemoApplication implements ApplicationContextAware {
	private static final String TAG = "DemoApplication";

	static {
		// APIJSON 配置 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		
		Map<String, Pattern> COMPILE_MAP = Structure.COMPILE_MAP;
		COMPILE_MAP.put("PHONE", StringUtil.PATTERN_PHONE);
		COMPILE_MAP.put("EMAIL", StringUtil.PATTERN_EMAIL);
		COMPILE_MAP.put("ID_CARD", StringUtil.PATTERN_ID_CARD);
		
		// 使用本项目的自定义处理类
		APIJSONApplication.DEFAULT_APIJSON_CREATOR = new APIJSONCreator() {
			
			@Override
			public Parser<Long> createParser() {
				return new DemoParser();
			}
			@Override
			public FunctionParser createFunctionParser() {
				return new DemoFunctionParser();
			}
			
			@Override
			public Verifier<Long> createVerifier() {
				return new DemoVerifier();
			}
			
			@Override
			public SQLConfig createSQLConfig() {
				return new DemoSQLConfig();
			}
			@Override
			public SQLExecutor createSQLExecutor() {
				return new DemoSQLExecutor();
			}
		
		};
		
		// APIJSON 配置 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		
		
		
		// UnitAuto 单元测试配置  https://github.com/TommyLemon/UnitAuto  <<<<<<<<<<<<<<<<<<<<<<<<<<<
		
		UnitAutoApp.init();
		
		// 适配 Spring 注入的类及 Context 等环境相关的类
		final InstanceGetter ig = MethodUtil.INSTANCE_GETTER;
		MethodUtil.INSTANCE_GETTER = new InstanceGetter() {

			@Override
			public Object getInstance(@NotNull Class<?> clazz, List<Argument> classArgs, Boolean reuse) throws Exception {
				if (APPLICATION_CONTEXT != null && ApplicationContext.class.isAssignableFrom(clazz) && clazz.isAssignableFrom(APPLICATION_CONTEXT.getClass())) {
					return APPLICATION_CONTEXT;
				}

				if (reuse != null && reuse && (classArgs == null || classArgs.isEmpty())) {
					return APPLICATION_CONTEXT.getBean(clazz);
				}

				return ig.getInstance(clazz, classArgs, reuse);
			}
		};
		
		// 排除转换 JSON 异常的类，一般是 Context 等环境相关的类
		final JSONCallback jc = MethodUtil.JSON_CALLBACK;
		MethodUtil.JSON_CALLBACK = new JSONCallback() {

			@Override
			public JSONObject newSuccessResult() {
				return jc.newSuccessResult();
			}

			@Override
			public JSONObject newErrorResult(Throwable e) {
				return jc.newErrorResult(e);
			}
			
			@Override
			public JSONObject parseJSON(String type, Object value) {
				if (value == null || unitauto.JSON.isBooleanOrNumberOrString(value) || value instanceof JSON || value instanceof Enum) {
					return jc.parseJSON(type, value);
				}

				if (value instanceof ApplicationContext
						|| value instanceof Context
						|| value instanceof javax.validation.MessageInterpolator.Context
						|| value instanceof org.omg.CORBA.Context
						|| value instanceof org.apache.catalina.Context
						|| value instanceof ch.qos.logback.core.Context
						) {
					value = value.toString();
				}
				else {
					try {
						value = JSON.parse(JSON.toJSONString(value, new PropertyFilter() {
							@Override
							public boolean apply(Object object, String name, Object value) {
								if (value == null) {
									return true;
								}

								if (value instanceof ApplicationContext
										|| value instanceof Context
										|| value instanceof javax.validation.MessageInterpolator.Context
										|| value instanceof org.omg.CORBA.Context
										|| value instanceof org.apache.catalina.Context
										|| value instanceof ch.qos.logback.core.Context
										) {
									return false;
								}

								return Modifier.isPublic(value.getClass().getModifiers());
							}
						}));
					} catch (Exception e) {
						Log.e(TAG, "toJSONString  catch \n" + e.getMessage());
					}
				}

				return jc.parseJSON(type, value);
			}
			
		};
		
		// UnitAuto 单元测试配置  https://github.com/TommyLemon/UnitAuto  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		
	}

	
	public static void main(String[] args) throws Exception {
		SpringApplication.run(DemoApplication.class, args);

		Log.DEBUG = true; //上线生产环境前改为 false，可不输出 APIJSONORM 的日志 以及 SQLException 的原始(敏感)信息
		APIJSONApplication.init();
	}
	
	
	private static ApplicationContext APPLICATION_CONTEXT;
	public static ApplicationContext getApplicationContext() {
		return APPLICATION_CONTEXT;
	}
	@Override
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		APPLICATION_CONTEXT = applicationContext;		
	}	

	//SpringBoot 2.x 自定义端口方式
	//	@Bean
	//	public TomcatServletWebServerFactory servletContainer(){
	//		return new TomcatServletWebServerFactory(8081) ;
	//	}
	//SpringBoot 1.x 自定义端口方式，配置文件加 server.port=80 无效(MacOS 10.10.?)
	@Bean
	public EmbeddedServletContainerCustomizer containerCustomizer() {
		return new EmbeddedServletContainerCustomizer() {

			@Override
			public void customize(ConfigurableEmbeddedServletContainer container) {
				container.setPort(8080); //自定义端口号，如果和 TiDB 等其它程序端口有冲突，可改为 8081, 9090, 9091 等未被占用的端口 	
			}
		};
	}


	// 支持 APIAuto 中 JavaScript 代码跨域请求 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	
	/** 
	 * 跨域过滤器 
	 * @return 
	 */  
	@Bean  
	public CorsFilter corsFilter() {  
		UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();  
		source.registerCorsConfiguration("/**", buildConfig());
		return new CorsFilter(source);  
	}  
	/**CORS跨域配置
	 * @return
	 */
	private CorsConfiguration buildConfig() {  
		CorsConfiguration corsConfiguration = new CorsConfiguration();  
		corsConfiguration.addAllowedOrigin("*"); //允许的域名或IP地址
		corsConfiguration.addAllowedHeader("*"); //允许的请求头
		corsConfiguration.addAllowedMethod("*"); //允许的HTTP请求方法
		corsConfiguration.setAllowCredentials(true); //允许发送跨域凭据，前端Axios存取JSESSIONID必须要
		return corsConfiguration;  
	}  
	
	// 支持 APIAuto 中 JavaScript 代码跨域请求 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

}
