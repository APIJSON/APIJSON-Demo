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

import java.io.IOException;
import java.util.*;

import apijson.NotNull;
import apijson.RequestMethod;
import apijson.StringUtil;
import apijson.fastjson2.JSON;
import apijson.fastjson2.JSONRequest;
import apijson.fastjson2.JSONResponse;
import jakarta.servlet.http.HttpSession;
import unitauto.MethodUtil;
import unitauto.MethodUtil.Argument;

import apijson.orm.script.JavaScriptExecutor;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;

import apijson.fastjson2.APIJSONFunctionParser;
import apijson.orm.AbstractVerifier;
import apijson.orm.Visitor;


/**可远程调用的函数类，用于自定义业务逻辑处理
 * 具体见 https://github.com/Tencent/APIJSON/issues/101
 * @author Lemon
 */
public class DemoFunctionParser extends APIJSONFunctionParser<Long> {
	public static final String TAG = "DemoFunctionParser";

	static {
		SCRIPT_EXECUTOR_MAP.put("js", new JavaScriptExecutor<Long, JSONObject, JSONArray>());
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

		JSONObject request = JSON.newJSONObject();

		//Comment<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		JSONObject comment = JSON.newJSONObject();
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

		JSONObject request = JSON.newJSONObject();

		//Comment<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		JSONObject comment = JSON.newJSONObject();;
		comment.put("id{}", getChildCommentIdList(tid));

		request.put("Comment", comment);
		//Comment>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

		JSONObject rp = new DemoParser(RequestMethod.DELETE).setNeedVerify(false).parseResponse(request);

		JSONObject c = rp.getJSONObject("Comment");
		return c == null ? 0 : c.getIntValue(JSONResponse.KEY_COUNT);
	}


	private JSONArray getChildCommentIdList(long tid) {
		JSONArray arr = new JSONArray();

		JSONObject request = JSON.newJSONObject();

		//Comment-id[]<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		JSONRequest idItem = new JSONRequest();

		//Comment<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		JSONRequest comment = new JSONRequest();
		comment.put("toId", tid);
		comment.setColumn("id");
		idItem.put("Comment", JSON.newJSONObject(comment));
		//Comment>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

		request.putAll(JSON.newJSONObject(idItem.toArray(0, 0, "Comment-id")));
		//Comment-id[]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

		JSONObject rp = new DemoParser().setNeedVerify(false).parseResponse(request);

		JSONArray a = rp.getJSONArray("Comment-id[]");
		if (a != null) {
			arr.addAll(a);

			for (int i = 0; i < a.size(); i++) {

				JSONArray a2 = getChildCommentIdList(a.getLongValue(i));
				if (a2 != null) {
					arr.addAll(a2);
				}
			}
		}

		return arr;
	}


	/**TODO 仅用来测试 "key-()":"getIdList()" 和 "key()":"getIdList()"
	 * @param curObj
	 * @return JSONList 只能用JSONArray，用long[]会在SQLConfig解析崩溃
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
	//		public String getMethodDefinition(JSONMap request) throws IllegalArgumentException, ClassNotFoundException, IOException {
	//			return super.getMethodDefination(request);
	//		}
	//		public String getMethodDefinition(JSONMap request, String method, String arguments, String type, String exceptions, String language) throws IllegalArgumentException, ClassNotFoundException, IOException {
	//			return super.getMethodDefination(request, method, arguments, type, exceptions, language);
	//		}

	public void verifyGroupUrlLike(@NotNull JSONObject curObj, String urlLike) throws Exception {
		String urlLikeVal = getArgStr(urlLike);

		if (StringUtil.isEmpty(urlLikeVal) || urlLikeVal.endsWith("/%") == false) {
			throw new IllegalArgumentException(urlLike + "必须以 /% 结尾！");
		}

		String url = urlLikeVal.substring(0, urlLike.length() - 2);
		String rest = url.replaceAll("_", "")
				.replaceAll("%", "%")
				.replaceAll("/", "%")
				.trim();

		if (StringUtil.isEmpty(rest)) {
			throw new IllegalArgumentException(urlLike + "必须以包含有效 URL 字符！");
		}
	}

	/**获取方法参数的定义
	 * @param curObj
	 * @return
	 * @throws IOException
	 * @throws ClassNotFoundException
	 * @throws IllegalArgumentException
	 */
	public String getMethodArguments(@NotNull JSONObject curObj) throws IllegalArgumentException, ClassNotFoundException, IOException {
		return getMethodArguments(curObj, "methodArgs");
	}
	/**获取方法参数的定义
	 * @param curObj
	 * @param methodArgsKey
	 * @return
	 * @throws IllegalArgumentException
	 * @throws ClassNotFoundException
	 * @throws IOException
	 */
	public String getMethodArguments(@NotNull JSONObject curObj, String methodArgsKey) throws IllegalArgumentException, ClassNotFoundException, IOException {
		JSONObject obj = curObj.getJSONObject("request");
		String argsStr = obj == null ? null : obj.getString(methodArgsKey);
		if (StringUtil.isEmpty(argsStr, true)) {
			argsStr = curObj.getString(methodArgsKey);
		}
		List<Argument> methodArgs = JSON.parseArray(removeComment(argsStr), Argument.class);
		if (methodArgs == null || methodArgs.isEmpty()) {
			return "";
		}

		//		Class<?>[] types = new Class<?>[methodArgs.size()];
		//		Object[] args = new Object[methodArgs.size()];
		//		MethodUtil.initTypesAndValues(methodArgs, types, args, true);

		String s = "";
		//		if (types != null) {
		//			String sn;
		//			for (int i = 0; i < types.length; i++) {
		//				sn = types[i] == null ? null : types[i].getSimpleName();
		//				if (sn == null) {
		//					sn = Object.class.getSimpleName();
		//				}
		//
		//				if (i > 0) {
		//					s += ",";
		//				}
		//
		//				if (MethodUtil.CLASS_MAP.containsKey(sn)) {
		//					s += sn;
		//				}
		//				else {
		//					s += types[i].getName();
		//				}
		//			}
		//		}

		for (int i = 0; i < methodArgs.size(); i++) {
			Argument arg = methodArgs.get(i);

			String sn = arg == null ? null : arg.getType();
			if (sn == null) {
				sn = arg.getValue() == null ? Object.class.getSimpleName() : MethodUtil.trimType(arg.getValue().getClass());
			}

			if (i > 0) {
				s += ",";
			}
			s += sn;
		}

		return s;
	}


	/**获取方法的定义
	 * @param curObj
	 * @return
	 * @throws IOException
	 * @throws ClassNotFoundException
	 * @throws IllegalArgumentException
	 */
	public String getMethodDefinition(@NotNull JSONObject curObj) throws IllegalArgumentException {
		//		curObj.put("arguments", removeComment(curObj.getString("methodArgs")));
		return getMethodDefinition(curObj, "method", "arguments", "genericType", "genericExceptions", "Java");
	}
	/**获取方法的定义
	 * @param curObj
	 * @param method
	 * @param arguments
	 * @param type
	 * @return method(argType0,argType1...): returnType
	 * @throws IOException
	 * @throws ClassNotFoundException
	 * @throws IllegalArgumentException
	 */
	public String getMethodDefinition(@NotNull JSONObject curObj, String method, String arguments
			, String type, String exceptions, String language) throws IllegalArgumentException {
		String n = curObj.getString(method);
		if (StringUtil.isEmpty(n, true)) {
			throw new NullPointerException("getMethodDefination  StringUtil.isEmpty(methodArgs, true) !");
		}
		String a = curObj.getString(arguments);
		String t = curObj.getString(type);
		String e = curObj.getString(exceptions);

		if (language == null) {
			language = "";
		}
		switch (language) {
			case "TypeScript":
				return n + "(" + (StringUtil.isEmpty(a, true) ? "" : a) + ")" + (StringUtil.isEmpty(t, true) ? "" : ": " + t) + (StringUtil.isEmpty(e, true) ? "" : " throws " + e);
			case "Go":
				return n + "(" + (StringUtil.isEmpty(a, true) ? "" : a ) + ")" + (StringUtil.isEmpty(t, true) ? "" : " " + t) + (StringUtil.isEmpty(e, true) ? "" : " throws " + e);
			default:
				//类型可能很长，Eclipse, Idea 代码提示都是类型放后面			return (StringUtil.isEmpty(t, true) ? "" : t + " ") + n + "(" + (StringUtil.isEmpty(a, true) ? "" : a) + ")";
				return n + "(" + (StringUtil.isEmpty(a, true) ? "" : a) + ")" + (StringUtil.isEmpty(t, true) ? "" : ": " + t) + (StringUtil.isEmpty(e, true) ? "" : " throws " + e);
		}
	}

	/**
	 * methodArgs 和 classArgs 都可以带注释
	 */
	public String getMethodRequest(@NotNull JSONObject curObj) {
		String req = curObj.getString("request");
		if (StringUtil.isEmpty(req, true) == false) {
			return req;
		}

		req = "{";
		Boolean isStatic = curObj.getBoolean("static");
		String methodArgs = curObj.getString("methodArgs");
		String classArgs = curObj.getString("classArgs");

		boolean comma = false;
		if (isStatic != null && isStatic) {
			req += "\n    \"static\": " + true;
			comma = true;
		}
		if (! StringUtil.isEmpty(methodArgs, true)) {
			req += (comma ? "," : "") + "\n    \"methodArgs\": " + methodArgs;
			comma = true;
		}
		if (! StringUtil.isEmpty(classArgs, true)) {
			req += (comma ? "," : "") + "\n    \"classArgs\": " + classArgs;
		}
		req += "\n}";
		return req;
	}

	//	public static JSONObject removeComment(String json) {
	//		return JSON.parseObject(removeComment(json));
	//	}
	public static String removeComment(String json) {
		return json == null ? null: json.replaceAll("(//.*)|(/\\*[\\s\\S]*?\\*/)", "");
	}

}