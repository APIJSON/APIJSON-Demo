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

package apijson.jfinal;

import apijson.JSONParser;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.parser.Feature;
import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.config.Constants;
import com.jfinal.config.Handlers;
import com.jfinal.config.Interceptors;
import com.jfinal.config.JFinalConfig;
import com.jfinal.config.Plugins;
import com.jfinal.config.Routes;
import com.jfinal.core.Controller;
import com.jfinal.server.undertow.UndertowServer;
import com.jfinal.template.Engine;

import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import apijson.Log;
import apijson.StringUtil;
import apijson.demo.DemoFunctionParser;
import apijson.demo.DemoParser;
import apijson.demo.DemoSQLConfig;
import apijson.demo.DemoVerifier;
import apijson.framework.javax.APIJSONApplication;
import apijson.framework.javax.APIJSONCreator;
import apijson.orm.AbstractVerifier;


/**
 * Demo JFinal Config 主应用程序启动类
 * 右键这个类 > Run As > Java Application
 * 具体见 JFinal 文档
 * https://jfinal.com/doc/2-1
 *
 * @author Lemon
 */
public class DemoAppConfig extends JFinalConfig {

  public static void main(String[] args) throws Exception {
    UndertowServer.start(DemoAppConfig.class);   // src/main/resources/undertow.txt 中配置 undertow.port 优先于 UndertowServer.start 传参 int port

    Log.DEBUG = true;  // 上线生产环境前改为 false，可不输出 APIJSONORM 的日志 以及 SQLException 的原始(敏感)信息
    APIJSONApplication.init(false);
  }

  public static JSONParser<JSONObject, JSONArray> DEFAULT_JSON_PARSER;

  static {
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
    //
    //		try { //加载驱动程序
    //			Log.d(TAG, "尝试加载 DB2 驱动 <<<<<<<<<<<<<<<<<<<<< ");
    //			Class.forName("com.ibm.db2.jcc.DB2Driver");
    //			Log.d(TAG, "成功加载 DB2 驱动！>>>>>>>>>>>>>>>>>>>>> ");
    //		}
    //		catch (ClassNotFoundException e) {
    //			e.printStackTrace();
    //			Log.e(TAG, "加载 DB2 驱动失败，请检查 pom.xml 中 com.ibm.db2 版本是否存在以及可用 ！！！");
    //		}

    // APIJSON 配置 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    Map<String, Pattern> COMPILE_MAP = AbstractVerifier.COMPILE_MAP;
    COMPILE_MAP.put("PHONE", StringUtil.PATTERN_PHONE);
    COMPILE_MAP.put("EMAIL", StringUtil.PATTERN_EMAIL);
    COMPILE_MAP.put("ID_CARD", StringUtil.PATTERN_ID_CARD);

    // 使用 fastjson
    apijson.JSON.JSON_OBJECT_CLASS = JSONObject.class;
    apijson.JSON.JSON_ARRAY_CLASS = JSONArray.class;

    final Feature[] DEFAULT_FASTJSON_FEATURES = {Feature.OrderedField, Feature.UseBigDecimal};
    apijson.JSON.DEFAULT_JSON_PARSER = DEFAULT_JSON_PARSER = new JSONParser<JSONObject, JSONArray>() {

      @Override
      public JSONObject createJSONObject() {
        return new JSONObject(true);
      }

      @Override
      public JSONArray createJSONArray() {
        return new JSONArray();
      }

      @Override
      public String toJSONString(Object obj, boolean format) {
        return obj == null || obj instanceof String ? (String) obj : JSON.toJSONString(obj);
      }

      @Override
      public Object parseJSON(Object json) {
        return JSON.parse(toJSONString(json), DEFAULT_FASTJSON_FEATURES);
      }

      @Override
      public JSONObject parseObject(Object json) {
        return JSON.parseObject(toJSONString(json), DEFAULT_FASTJSON_FEATURES);
      }

      @Override
      public <T> T parseObject(Object json, Class<T> clazz) {
        return JSON.parseObject(toJSONString(json), clazz, DEFAULT_FASTJSON_FEATURES);
      }

      @Override
      public JSONArray parseArray(Object json) {
        return JSON.parseArray(toJSONString(json));
      }

      @Override
      public <T> List<T> parseArray(Object json, Class<T> clazz) {
        return JSON.parseArray(toJSONString(json), clazz);
      }

    };

    // 使用本项目的自定义处理类
    APIJSONApplication.DEFAULT_APIJSON_CREATOR = new APIJSONCreator<Long, JSONObject, JSONArray>() {

      @Override
      public DemoParser createParser() {
        return new DemoParser();
      }

      @Override
      public DemoFunctionParser createFunctionParser() {
        return new DemoFunctionParser();
      }

      @Override
      public DemoVerifier createVerifier() {
        return new DemoVerifier();
      }

      @Override
      public DemoSQLConfig createSQLConfig() {
        return new DemoSQLConfig();
      }

    };

    // APIJSON 配置 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  }

  // 支持 APIAuto 中 JavaScript 代码跨域请求 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  public void configRoute(Routes me) {
    me.add("/", DemoController.class);
  }

  public void configEngine(Engine me) {
    me.setBaseTemplatePath("webapp").setToClassPathSourceFactory();
  }

  public void configConstant(Constants me) {
  }

  public void configPlugin(Plugins me) {
  }

  public void configHandler(Handlers me) {
  }

  public void configInterceptor(Interceptors me) {
    me.add(new Interceptor() {

      @Override
      public void intercept(Invocation inv) {
        Controller controller = inv.getController();
        HttpServletRequest request = controller == null ? null : controller.getRequest();
        if (request == null) {
          return;
        }

        String origin = request.getHeader("origin");
        String corsHeaders = request.getHeader("access-control-request-headers");
        String corsMethod = request.getHeader("access-control-request-method");

        HttpServletResponse response = controller.getResponse();
        response.setHeader("Access-Control-Allow-Origin", StringUtil.isEmpty(origin, true) ? "*" : origin);
        response.setHeader("Access-Control-Allow-Credentials", "true");
        response.setHeader("Access-Control-Allow-Headers", StringUtil.isEmpty(corsHeaders, true) ? "*" : corsHeaders);
        response.setHeader("Access-Control-Allow-Methods", StringUtil.isEmpty(corsMethod, true) ? "*" : corsMethod);
        response.setHeader("Access-Control-Max-Age", "86400");

        if ("OPTIONS".equals(request.getMethod().toUpperCase())) {
          controller.renderJson("{}");
          return;
        }

        inv.invoke();
      }
    });

  }

  // 支持 APIAuto 中 JavaScript 代码跨域请求 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

}
