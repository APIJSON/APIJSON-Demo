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
import org.noear.solon.Solon;
import org.noear.solon.annotation.Configuration;
import org.noear.solon.web.cors.CrossFilter;


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
    System.out.println("官方网站： http://apijson.cn");
    System.out.println("设计规范： https://github.com/Tencent/APIJSON/blob/master/Document.md#3");
    System.out.println("测试链接： http://apijson.cn/api?type=JSON&url=http://localhost:8080/get");
    System.out.println("\n\n<<<<<<<<<<<<<<<<<<<<<<<<< APIJSON 启动完成，试试调用零代码万能通用 API 吧 ^_^ >>>>>>>>>>>>>>>>>>>>>>>>\n");
  }
}
