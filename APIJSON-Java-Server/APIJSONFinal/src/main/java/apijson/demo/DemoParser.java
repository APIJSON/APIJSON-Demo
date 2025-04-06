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

import apijson.JSONResponse;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import apijson.RequestMethod;
import apijson.framework.javax.APIJSONParser;

import static apijson.JSONResponse.*;


/**请求解析器
 * 具体见 https://github.com/Tencent/APIJSON/issues/38
 * @author Lemon
 */
public class DemoParser extends APIJSONParser<Long, JSONObject, JSONArray> {

    public DemoParser() {
        super();
    }
    public DemoParser(RequestMethod method) {
        super(method);
    }
    public DemoParser(RequestMethod method, boolean needVerify) {
        super(method, needVerify);
    }

    public static JSONObject parseRequest(String request) {
        try {
            return JSON.parseObject(request);
        } catch (Throwable e) {
            JSONObject obj = JSON.createJSONObject();
            obj.put(KEY_OK, false);
            obj.put(KEY_CODE, JSONResponse.CODE_ILLEGAL_ARGUMENT);
            obj.put(KEY_MSG, "JSON 格式不合法！" + request);
            return obj;
        }
    }

    //	可重写来设置最大查询数量
    //	@Override
    //	public int getMaxQueryCount() {
    //		return 50;
    //	}

}
