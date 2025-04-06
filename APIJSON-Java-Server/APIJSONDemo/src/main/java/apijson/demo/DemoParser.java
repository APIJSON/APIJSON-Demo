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

import apijson.RequestMethod;
import apijson.framework.APIJSONObjectParser;
import apijson.framework.APIJSONParser;
import apijson.orm.*;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import jakarta.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.Map;


/**请求解析器
 * 具体见 https://github.com/Tencent/APIJSON/issues/38
 * @author Lemon
 */
public class DemoParser extends APIJSONParser<Long, JSONObject, JSONArray> {

    public static final Map<String, HttpSession> KEY_MAP;
    static {
      KEY_MAP = new HashMap<>();
    }

    public DemoParser() {
        super();
    }
    public DemoParser(RequestMethod method) {
        super(method);
    }
    public DemoParser(RequestMethod method, boolean needVerify) {
        super(method, needVerify);
    }

//    private int maxQueryCount = 200;
//    //	可重写来设置最大查询数量
//    @Override
//    public int getMaxQueryCount() {
//      return maxQueryCount;
//    }
//
//    @Override
//    public int getMaxUpdateCount() {
//        return 200;
//    }
//
//    @Override
//    public int getMaxObjectCount() {
//        return getMaxUpdateCount();
//    }
//
//    @Override
//    public int getMaxSQLCount() {
//        return getMaxUpdateCount();
//    }

    @Override
    public APIJSONObjectParser<Long, JSONObject, JSONArray> createObjectParser(JSONObject request, String parentPath
            , SQLConfig<Long, JSONObject, JSONArray> arrayConfig
            , boolean isSubquery, boolean isTable, boolean isArrayMainTable) throws Exception {
        return new DemoObjectParser(getSession(), request, parentPath, arrayConfig
                , isSubquery, isTable, isArrayMainTable).setMethod(getMethod()).setParser(this);
    }

    // 实现应用层与数据库共用账号密码，可用于多租户、SQLAuto 等 >>>>>>>>>>>>>>>

}
