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

import java.util.*;

import javax.servlet.http.HttpSession;

import apijson.orm.script.JavaScriptExecutor;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import apijson.JSONResponse;
import apijson.NotNull;
import apijson.RequestMethod;
import apijson.StringUtil;
import apijson.framework.APIJSONFunctionParser;
import apijson.orm.AbstractVerifier;
import apijson.orm.JSONRequest;
import apijson.orm.Visitor;


/**可远程调用的函数类，用于自定义业务逻辑处理
 * 具体见 https://github.com/Tencent/APIJSON/issues/101
 * @author Lemon
 */
public class DemoFunctionParser extends APIJSONFunctionParser<Long> {
	public static final String TAG = "DemoFunctionParser";

	static {
		SCRIPT_EXECUTOR_MAP.put("js", new JavaScriptExecutor());
	}

	public DemoFunctionParser() {
		this(null, null, 0, null, null);
	}

	public DemoFunctionParser(RequestMethod method, String tag, int version, JSONObject request, HttpSession session) {
		super(method, tag, version, request, session);
	}

	public Visitor<Long> getCurrentUser(@NotNull JSONObject curObj) {
		return DemoVerifier.getVisitor(getSession());
	}

	public Long getCurrentUserId(@NotNull JSONObject curObj) {
		return DemoVerifier.getVisitorId(getSession());
	}

	public List<Long> getCurrentUserIdAsList(@NotNull JSONObject curObj) {
		List<Long> list = new ArrayList<>(1);
		list.add(DemoVerifier.getVisitorId(getSession()));
		return list;
	}

	public List<Long> getCurrentContactIdList(@NotNull JSONObject curObj) {
		Visitor<Long> user = getCurrentUser(curObj);
		return user == null ? null : user.getContactIdList();
	}


	/**
	 * @param curObj
	 * @param idList
	 * @return
	 * @throws Exception
	 */
	public void verifyIdList(@NotNull JSONObject curObj, @NotNull String idList) throws Exception {
		Object obj = getArgVal(idList);
		if (obj == null) {
			return;
		}

		if (obj instanceof Collection == false) {
			throw new IllegalArgumentException(idList + " 不符合 Array 数组类型! 结构必须是 [] ！");
		}

		Collection<?> collection = (Collection<?>) obj;
		if (collection != null) {
			int i = -1;
			for (Object item : collection) {
				i ++;
				if (item instanceof Long == false && item instanceof Integer == false) {
					throw new IllegalArgumentException(idList + "/" + i + ": " + item + " 不符合 Long 数字类型!");
				}
			}
		}
	}

	@Override
	public boolean isContain(JSONObject curObj, String array, String value) {
		List<String> list = apijson.JSON.parseArray(getArgStr(array), String.class);
		Object val = getArgVal(value);
		return list != null && list.contains(val == null ? null : String.valueOf(val));
	}

	/**
	 * @param curObj
	 * @param urlList
	 * @return
	 * @throws Exception
	 */
	public void verifyURLList(@NotNull JSONObject curObj, @NotNull String urlList) throws Exception {
		Object obj = getArgVal(urlList);
		if (obj == null) {
			return;
		}

		if (obj instanceof Collection == false) {
			throw new IllegalArgumentException(urlList + " 不符合 Array 数组类型! 结构必须是 [] ！");
		}

		Collection<?> collection = (Collection<?>) obj;
		if (collection != null) {
			int i = -1;
			for (Object item : collection) {
				i ++;
				if (item instanceof String == false || StringUtil.isUrl((String) item) == false) {
					throw new IllegalArgumentException(urlList + "/" + i + ": " + item + " 不符合 URL 字符串格式!");
				}
			}
		}
	}


	/**
	 * @param curObj
	 * @param momentId
	 * @return
	 * @throws Exception
	 */
	public int deleteCommentOfMoment(@NotNull JSONObject curObj, @NotNull String momentId) throws Exception {
		Long mid = getArgLong(momentId);
		if (mid == null || mid <= 0 || curObj.getIntValue(JSONResponse.KEY_COUNT) <= 0) {
			return 0;
		}

		JSONRequest request = new JSONRequest();

		//Comment<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		JSONRequest comment = new JSONRequest();
		comment.put("momentId", mid);

		request.put("Comment", comment);
		//Comment>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

		JSONObject rp = new DemoParser(RequestMethod.DELETE).setNeedVerify(false).parseResponse(request);

		JSONObject c = rp.getJSONObject("Comment");
		return c == null ? 0 : c.getIntValue(JSONResponse.KEY_COUNT);
	}


	/**删除评论的子评论
	 * @param curObj
	 * @param toId
	 * @return
	 */
	public int deleteChildComment(@NotNull JSONObject curObj, @NotNull String toId) throws Exception {
		Long tid = getArgLong(toId);
		if (tid == null || tid <= 0 || curObj.getIntValue(JSONResponse.KEY_COUNT) <= 0) {
			return 0;
		}

		//递归获取到全部子评论id

		JSONRequest request = new JSONRequest();

		//Comment<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		JSONRequest comment = new JSONRequest();
		comment.put("id{}", getChildCommentIdList(tid));

		request.put("Comment", comment);
		//Comment>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

		JSONObject rp = new DemoParser(RequestMethod.DELETE).setNeedVerify(false).parseResponse(request);

		JSONObject c = rp.getJSONObject("Comment");
		return c == null ? 0 : c.getIntValue(JSONResponse.KEY_COUNT);
	}


	private JSONArray getChildCommentIdList(long tid) {
		JSONArray arr = new JSONArray();

		JSONRequest request = new JSONRequest();

		//Comment-id[]<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		JSONRequest idItem = new JSONRequest();

		//Comment<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		JSONRequest comment = new JSONRequest();
		comment.put("toId", tid);
		comment.setColumn("id");
		idItem.put("Comment", comment);
		//Comment>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

		request.putAll(idItem.toArray(0, 0, "Comment-id"));
		//Comment-id[]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

		JSONObject rp = new DemoParser().setNeedVerify(false).parseResponse(request);

		JSONArray a = rp.getJSONArray("Comment-id[]");
		if (a != null) {
			arr.addAll(a);

			JSONArray a2;
			for (int i = 0; i < a.size(); i++) {

				a2 = getChildCommentIdList(a.getLongValue(i));
				if (a2 != null) {
					arr.addAll(a2);
				}
			}
		}

		return arr;
	}


	/**TODO 仅用来测试 "key-()":"getIdList()" 和 "key()":"getIdList()"
	 * @param curObj
	 * @return JSONArray 只能用JSONArray，用long[]会在SQLConfig解析崩溃
	 * @throws Exception
	 */
	public JSONArray getIdList(@NotNull JSONObject curObj) {
		return new JSONArray(new ArrayList<Object>(Arrays.asList(12, 15, 301, 82001, 82002, 38710)));
	}


	/**TODO 仅用来测试 "key-()":"verifyAccess()"
	 * @param curObj
	 * @return
	 * @throws Exception
	 */
	public Object verifyAccess(@NotNull JSONObject curObj) throws Exception {
		String role = getArgStr(JSONRequest.KEY_ROLE);
		Long userId = getArgLong(JSONRequest.KEY_USER_ID);
		if (AbstractVerifier.OWNER.equals(role) && ! Objects.equals(userId, DemoVerifier.getVisitorId(getSession()))) {
			throw new IllegalAccessException("登录用户与角色OWNER不匹配！");
		}
		return null;
	}

	// apijson-framework 5.4.0 以下取消注释，兼容 Function 表中 name = getMethodDefinition 的记录（或者删除这条记录，如果使用 UnitAuto，则版本要在 2.7.2 以下）
	//		public String getMethodDefinition(JSONObject request) throws IllegalArgumentException, ClassNotFoundException, IOException {
	//			return super.getMethodDefination(request);
	//		}
	//		public String getMethodDefinition(JSONObject request, String method, String arguments, String type, String exceptions, String language) throws IllegalArgumentException, ClassNotFoundException, IOException {
	//			return super.getMethodDefination(request, method, arguments, type, exceptions, language);
	//		}
}