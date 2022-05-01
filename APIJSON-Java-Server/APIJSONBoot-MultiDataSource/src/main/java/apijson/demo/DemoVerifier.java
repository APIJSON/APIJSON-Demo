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

import apijson.router.APIJSONRouterVerifier;


/**安全校验器，校验请求参数、角色与权限等
 * 具体见 https://github.com/Tencent/APIJSON/issues/12
 * @author Lemon
 */
public class DemoVerifier extends APIJSONRouterVerifier<Long> {  // APIJSONVerifier<Long> {
	public static final String TAG = "DemoVerifier";

	// 重写方法来自定义字段名等	
	//	@Override
	//	public String getVisitorIdKey(SQLConfig config) {
	//		return super.getVisitorIdKey(config);  // return "userid"; // return "uid" 等自定义的字段名
	//	}

}
