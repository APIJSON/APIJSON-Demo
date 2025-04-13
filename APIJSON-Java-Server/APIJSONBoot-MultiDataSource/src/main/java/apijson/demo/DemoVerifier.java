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

import apijson.framework.APIJSONVerifier;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import java.util.regex.Pattern;


/**安全校验器，校验请求参数、角色与权限等
 * 具体见 https://github.com/Tencent/APIJSON/issues/12
 * @author Lemon
 */
public class DemoVerifier extends APIJSONVerifier<Long, JSONObject, JSONArray> {
	public static final String TAG = "DemoVerifier";
	
	static { 
		// 可注册 COMPILE_MAP 来简化正则校验，以别名代替表达式
		COMPILE_MAP.put("PHONE", Pattern.compile("^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\\d{8}$"));
		COMPILE_MAP.put("QQ", Pattern.compile("[1-9][0-9]{4,}"));
		COMPILE_MAP.put("EMAIL", Pattern.compile("^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"));
		COMPILE_MAP.put("IDCARD", Pattern.compile("(^\\d{15}$)|(^\\d{18}$)|(^\\d{17}(\\d|X|x)$)"));
		COMPILE_MAP.put("TEL", Pattern.compile("(^\\(\\d{3,4}-)|\\d{3,4}-\\)?\\d{7,8}$"));

		IS_UPDATE_MUST_HAVE_ID_CONDITION = false;
	}

	// 重写方法来自定义字段名等	
	//	@Override
	//	public String getVisitorIdKey(SQLConfig<Long, JSONObject, JSONArray> config) {
	//		return super.getVisitorIdKey(config);  // return "userid"; // return "uid" 等自定义的字段名
	//	}

}
