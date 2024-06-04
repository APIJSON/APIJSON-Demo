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

import apijson.orm.AbstractFunctionParser;
import com.alibaba.fastjson.JSONObject;

import apijson.RequestMethod;


/**可远程调用的函数类，用于自定义业务逻辑处理
 * 具体见 https://github.com/Tencent/APIJSON/issues/101
 * @author Lemon
 */
public class DemoFunctionParser extends AbstractFunctionParser {
	public static final String TAG = "DemoFunctionParser";


	public DemoFunctionParser() {
		this(null, null, 0, null);
	}
	public DemoFunctionParser(RequestMethod method, String tag, int version, JSONObject request) {
		super(method, tag, version, request);
	}


}