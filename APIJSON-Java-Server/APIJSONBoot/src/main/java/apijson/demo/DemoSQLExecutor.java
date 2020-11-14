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

import apijson.framework.APIJSONSQLExecutor;


/**executor for query(read) or update(write) MySQL database
 * @author Lemon
 */
public class DemoSQLExecutor extends APIJSONSQLExecutor {
	public static final String TAG = "DemoSQLExecutor";

	//  可重写以下方法，支持 Redis 等单机全局缓存或分布式缓存
	//	@Override
	//	public List<JSONObject> getCache(String sql, int type) {
	//		return super.getCache(sql, type);
	//	}
	//	@Override
	//	public synchronized void putCache(String sql, List<JSONObject> list, int type) {
	//		super.putCache(sql, list, type);
	//	}
	//	@Override
	//	public synchronized void removeCache(String sql, int type) {
	//		super.removeCache(sql, type);
	//	}

}
