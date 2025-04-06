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

import apijson.orm.*;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import java.util.HashMap;
import java.util.Map;

import apijson.RequestMethod;
import org.noear.solon.core.handle.SessionState;


/**请求解析器
 * 具体见 https://github.com/Tencent/APIJSON/issues/38
 * @author Lemon
 */
public class DemoParser extends AbstractParser<Long, JSONObject, JSONArray> {

    public static final Map<String, SessionState> KEY_MAP;
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

    private int maxQueryCount = 2000;
//    //	可重写来设置最大查询数量
//    @Override
//    public int getMaxQueryCount() {
//      return maxQueryCount;
//    }
//
//    @Override
//    public int getMaxUpdateCount() {
//        return 2000;
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


    private SessionState session;
    public Parser<Long, JSONObject, JSONArray> setSession(SessionState session) {
        this.session = session;
        return this;
    }
    public SessionState getSession() {
        return session;
    }


    @Override
    public Parser<Long, JSONObject, JSONArray> createParser() {
        return new DemoParser();
    }

    @Override
    public ObjectParser<Long, JSONObject, JSONArray> createObjectParser(JSONObject request, String parentPath
            , SQLConfig<Long, JSONObject, JSONArray> arrayConfig
            , boolean isSubquery, boolean isTable, boolean isArrayMainTable) throws Exception {
        return new DemoObjectParser(getSession(), request, parentPath, arrayConfig
                , isSubquery, isTable, isArrayMainTable).setMethod(getMethod()).setParser(this);
    }

    @Override
    public FunctionParser<Long, JSONObject, JSONArray> createFunctionParser() {
        return new DemoFunctionParser();
    }

    @Override
    public SQLConfig<Long, JSONObject, JSONArray> createSQLConfig() {
        return new DemoSQLConfig();
    }

    @Override
    public SQLExecutor<Long, JSONObject, JSONArray> createSQLExecutor() {
        return new DemoSQLExecutor();
    }

    @Override
    public Verifier<Long, JSONObject, JSONArray> createVerifier() {
        return new DemoVerifier();
    }

    private FunctionParser<Long, JSONObject, JSONArray> functionParser;
    public FunctionParser<Long, JSONObject, JSONArray> getFunctionParser() {
        return functionParser;
    }
    public Object onFunctionParse(String key, String function, String parentPath, String currentName, JSONObject currentObject, boolean containRaw) throws Exception {
        if (functionParser == null) {
            functionParser = createFunctionParser();
            functionParser.setMethod(getMethod());
            functionParser.setTag(getTag());
            functionParser.setVersion(getVersion());
            functionParser.setRequest(requestObject);
        }
        functionParser.setKey(key);
        functionParser.setParentPath(parentPath);
        functionParser.setCurrentName(currentName);
        functionParser.setCurrentObject(currentObject);

        return functionParser.invoke(function, currentObject, containRaw);
    }


    // 实现应用层与数据库共用账号密码，可用于多租户、SQLAuto 等 >>>>>>>>>>>>>>>

}
