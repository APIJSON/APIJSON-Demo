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
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.parser.Feature;
import org.noear.solon.Solon;
import org.noear.solon.annotation.Configuration;
import org.noear.solon.web.cors.CrossFilter;
import apijson.JSONParser;

import java.util.List;

/**
 * Demo Solon Application 主应用程序启动类
 * 右键这个类 > Run As > Java Application
 * 具体见 Solon 文档
 * https://solon.noear.org/
 *
 * @author Lemon
 */
@Configuration
public class DemoApplication {

  public static void main(String[] args) throws Exception {
    Solon.start(DemoApplication.class, args, app -> {
      // 支持 APIAuto 中 JavaScript 代码跨域请求
      app.filter(-1, new CrossFilter().allowCredentials(true).maxAge(3600));
    });

    Log.DEBUG = true; // TODO 上线前改为 false

    // 使用 fastjson
    apijson.JSON.JSON_OBJECT_CLASS = JSONObject.class;
    apijson.JSON.JSON_ARRAY_CLASS = JSONArray.class;

    final Feature[] DEFAULT_FASTJSON_FEATURES = {Feature.OrderedField, Feature.UseBigDecimal};
    apijson.JSON.DEFAULT_JSON_PARSER = new JSONParser<JSONObject, JSONArray>() {

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

    System.out.println("官方网站： http://apijson.cn");
    System.out.println("设计规范： https://github.com/Tencent/APIJSON/blob/master/Document.md#3");
    System.out.println("测试链接： http://apijson.cn/api?type=JSON&url=http://localhost:8080/get");
    System.out.println("\n\n<<<<<<<<<<<<<<<<<<<<<<<<< APIJSON 启动完成，试试调用零代码万能通用 API 吧 ^_^ >>>>>>>>>>>>>>>>>>>>>>>>\n");
  }
}
