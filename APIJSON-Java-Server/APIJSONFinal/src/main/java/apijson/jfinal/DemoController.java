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


package apijson.jfinal;

import static apijson.RequestMethod.DELETE;
import static apijson.RequestMethod.GET;
import static apijson.RequestMethod.GETS;
import static apijson.RequestMethod.HEAD;
import static apijson.RequestMethod.HEADS;
import static apijson.RequestMethod.POST;
import static apijson.RequestMethod.PUT;
import static apijson.framework.javax.APIJSONConstant.ACCESS_;
import static apijson.framework.javax.APIJSONConstant.COUNT;
import static apijson.framework.javax.APIJSONConstant.FORMAT;
import static apijson.framework.javax.APIJSONConstant.FUNCTION_;
import static apijson.framework.javax.APIJSONConstant.ID;
import static apijson.framework.javax.APIJSONConstant.REQUEST_;
import static apijson.framework.javax.APIJSONConstant.USER_ID;
import static apijson.framework.javax.APIJSONConstant.VERSION;
import static apijson.framework.javax.APIJSONConstant.VISITOR_;
import static apijson.framework.javax.APIJSONConstant.VISITOR_ID;

import java.net.URLDecoder;
import java.rmi.ServerException;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Random;
import java.util.Set;
import java.util.concurrent.TimeoutException;

import javax.servlet.http.HttpSession;

import apijson.JSONResponse;
import apijson.Log;
import apijson.RequestMethod;
import apijson.StringUtil;
import apijson.demo.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.JSONArray;
import com.jfinal.aop.Before;
import com.jfinal.core.ActionKey;
import com.jfinal.core.Controller;
import com.jfinal.core.NotAction;
import com.jfinal.ext.interceptor.POST;
import com.jfinal.kit.HttpKit;

import apijson.demo.DemoFunctionParser;
import apijson.demo.DemoParser;
import apijson.demo.DemoVerifier;
import apijson.demo.model.Privacy;
import apijson.demo.model.User;
import apijson.demo.model.Verify;
import apijson.framework.javax.APIJSONController;
import apijson.framework.javax.BaseModel;
import apijson.orm.JSONRequest;
import apijson.orm.exception.ConditionErrorException;
import apijson.orm.exception.ConflictException;
import apijson.orm.exception.NotExistException;
import apijson.orm.exception.OutOfRangeException;


/**请求路由入口控制器，包括通用增删改查接口等，转交给 APIJSON 的 Parser 来处理
 * 具体见 JFinal 文档
 * https://jfinal.com/doc/3-1 
 * 以及 APIJSON 通用文档 3.设计规范 3.1 操作方法  
 * https://github.com/Tencent/APIJSON/blob/master/Document.md#3.1
 * <br > 建议全通过HTTP POST来请求:
 * <br > 1.减少代码 - 客户端无需写HTTP GET,PUT等各种方式的请求代码
 * <br > 2.提高性能 - 无需URL encode和decode
 * <br > 3.调试方便 - 建议使用 APIAuto(http://apijson.cn/api) 或 Postman
 * @author Lemon
 */
public class DemoController extends Controller {
	private static final String TAG = "DemoController";

	public DemoParser newParser(HttpSession session, RequestMethod method) {
		DemoParser parser = (DemoParser) APIJSONController.APIJSON_CREATOR.createParser();
		parser.setMethod(method);
		parser.setSession(session);
		parser.setRequestURL(getRequest().getRequestURL().toString());
		return parser;
	}

	/**处理万能通用接口
	 * @param method
	 * @see https://github.com/Tencent/APIJSON/blob/master/Document.md#3.1
	 */
	public void parseAndResponse(RequestMethod method) {
		String tag = getPara();

		if (StringUtil.isEmpty(tag, true) == false) {
			try {
				tag = URLDecoder.decode(tag, "UTF-8");
			} catch (Throwable e) {
				e.printStackTrace();
			}
		}

		if (StringUtil.isEmpty(tag, true)) {
			// /get， /gets， /head， /heads， /post， /put， /delete 等万能通用接口 
			renderJson(newParser(getSession(), method).parse(getRawData()));
			return;
		}

		DemoParser parser = newParser(null, null);
		// /get/User， /gets/Moment[]， /put/Comment:[]  等简版接口，APIJSON 4.8.0+ 可用，对不兼容的低版本需要注释以下代码
		JSONObject req = parser.wrapRequest(method, tag, JSON.parseObject(getRawData()), false, DemoAppConfig.DEFAULT_JSON_PARSER);
		if (req == null) {
			req = new JSONObject(true);
		}

		Map<String, String[]> paraMap = getParaMap();
		Set<Entry<String, String[]>> set = paraMap == null ? null : paraMap.entrySet();
		if (set != null) {  // 最外层的全局参数
			for (Entry<String, String[]> entry : set) {
				String[] values = entry == null ? null : entry.getValue();
				String value = values == null || values.length <= 0 ? null : values[0];
				if (StringUtil.isEmpty(tag, false)) {
					continue;
				}

				req.put(entry.getKey(), value);
			}
		}

		renderJson(newParser(getSession(), method).parse(req));
	}

	//通用接口，非事务型操作 和 简单事务型操作 都可通过这些接口自动化实现<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	/**获取
	 * @return
	 * @see {@link RequestMethod#GET}
	 */
	@Before(POST.class)
	public void get() {
		parseAndResponse(GET);
	}

	/**计数
	 * @return
	 * @see {@link RequestMethod#HEAD}
	 */
	@Before(POST.class)
	public void head() {
		parseAndResponse(HEAD);
	}

	/**限制性GET，request和response都非明文，浏览器看不到，用于对安全性要求高的GET请求
	 * @return
	 * @see {@link RequestMethod#GETS}
	 */
	@Before(POST.class)
	public void gets() {
		parseAndResponse(GETS);
	}

	/**限制性HEAD，request和response都非明文，浏览器看不到，用于对安全性要求高的HEAD请求
	 * @return
	 * @see {@link RequestMethod#HEADS}
	 */
	@Before(POST.class)
	public void heads() {
		parseAndResponse(HEADS);
	}

	/**新增
	 * @return
	 * @see {@link RequestMethod#POST}
	 */
	@Before(POST.class)
	public void post() {
		parseAndResponse(POST);
	}

	/**修改
	 * @return
	 * @see {@link RequestMethod#PUT}
	 */
	@Before(POST.class)
	public void put() {
		parseAndResponse(PUT);
	}

	/**删除
	 * @return
	 * @see {@link RequestMethod#DELETE}
	 */
	@Before(POST.class)
	public void delete() {
		parseAndResponse(DELETE);
	}



	//通用接口，非事务型操作 和 简单事务型操作 都可通过这些接口自动化实现>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>










	public static final String USER_;
	public static final String PRIVACY_;
	public static final String VERIFY_; //加下划线后缀是为了避免 Verify 和 verify 都叫VERIFY，分不清
	static {
		USER_ = User.class.getSimpleName();
		PRIVACY_ = Privacy.class.getSimpleName();
		VERIFY_ = Verify.class.getSimpleName();
	}



	public static final String CURRENT_USER_ID = "currentUserId";
	public static final String NAME = "name";
	public static final String PHONE = "phone";
	public static final String PASSWORD = "password";
	public static final String _PASSWORD = "_password";
	public static final String _PAY_PASSWORD = "_payPassword";
	public static final String OLD_PASSWORD = "oldPassword";
	public static final String VERIFY = "verify";

	public static final String TYPE = "type";
	public static final String VALUE = "value";



	/**重新加载配置
	 * @return
	 * @see
	 * <pre>
		{
			"type": "ALL",  //重载对象，ALL, FUNCTION, REQUEST, ACCESS，非必须
			"phone": "13000082001",
			"verify": "1234567" //验证码，对应类型为 Verify.TYPE_RELOAD
		}
	 * </pre>
	 */
	@Before(POST.class)
	public void reload() {
		DemoParser parser = new DemoParser();

		String request = HttpKit.readData(getRequest());
		JSONObject requestObject = null;
		String type;
		JSONObject value;
		String phone;
		String verify;
		try {
			requestObject = JSON.parseObject(request);
			type = requestObject.getString(TYPE);
			value = requestObject.getJSONObject(VALUE);
			phone = requestObject.getString(PHONE);
			verify = requestObject.getString(VERIFY);
		} catch (Exception e) {
			renderJson(parser.extendErrorResult(requestObject, e));
			return;
		}

		JSONResponse<JSONObject, JSONArray> response = new JSONResponse<>(headVerify(Verify.TYPE_RELOAD, phone, verify));
		response = response.getJSONResponse(VERIFY_, DemoAppConfig.DEFAULT_JSON_PARSER);
		if (JSONResponse.isExist(response) == false) {
			renderJson(parser.extendErrorResult(requestObject, new ConditionErrorException("手机号或验证码错误")));
			return;
		}

		JSONObject result = (JSONObject) parser.newSuccessResult();

		boolean reloadAll = StringUtil.isEmpty(type, true) || "ALL".equals(type);

		if (reloadAll || "ACCESS".equals(type)) {
			try {
				result.put(ACCESS_, DemoVerifier.initAccess(false, null, value));
			} catch (ServerException e) {
				e.printStackTrace();
				result.put(ACCESS_, parser.newErrorResult(e));
			}
		}

		if (reloadAll || "FUNCTION".equals(type)) {
			try {
				result.put(FUNCTION_, DemoFunctionParser.init(false, null, value));
			} catch (ServerException e) {
				e.printStackTrace();
				result.put(FUNCTION_, parser.newErrorResult(e));
			}
		}

		if (reloadAll || "REQUEST".equals(type)) {
			try {
				result.put(REQUEST_, DemoVerifier.initRequest(false, null, value));
			} catch (ServerException e) {
				e.printStackTrace();
				result.put(REQUEST_, parser.newErrorResult(e));
			}
		}

		renderJson(result);
	}

	/**生成验证码,修改为post请求
	 * @see
	 * <pre>
		{
			"type": 0,  //类型，0,1,2,3,4，非必须
			"phone": "13000082001"
		}
	 * </pre>
	 */
	@Before(POST.class)
	@ActionKey("post/verify")
	public void postVerify() {
		DemoParser parser = new DemoParser();

		String request = HttpKit.readData(getRequest());
		JSONObject requestObject = null;
		int type;
		String phone;
		try {
			requestObject = JSON.parseObject(request);
			type = requestObject.getIntValue(TYPE);
			phone = requestObject.getString(PHONE);
		} catch (Exception e) {
			renderJson(parser.extendErrorResult(requestObject, e));
			return;
		}

		new DemoParser(DELETE, false).parse(newVerifyRequest(type, phone, null));

		JSONObject response = new DemoParser(POST, false).parseResponse(
				newVerifyRequest(type, phone, "" + (new Random().nextInt(9999) + 1000))
		);

		JSONObject verify = null;
		try {
			verify = response.getJSONObject(StringUtil.firstCase(VERIFY_));
		} catch (Exception e) {}

		if (verify == null || JSONResponse.isSuccess(verify.getIntValue(JSONResponse.KEY_CODE)) == false) {
			new DemoParser(DELETE, false).parseResponse((JSONObject) apijson.JSON.parseObject(new Verify(type, phone)));
			renderJson(response);
			return;
		}

		//TODO 这里直接返回验证码，方便测试。实际上应该只返回成功信息，验证码通过短信发送
		JSONObject object = new JSONObject();
		object.put(TYPE, type);
		object.put(PHONE, phone);
		renderJson(getVerify(JSON.toJSONString(object)));
	}

	/**获取验证码
	 * @see
	 * <pre>
		{
			"type": 0,  //类型，0,1,2,3,4，非必须
			"phone": "13000082001"
		}
	 * </pre>
	 */
	@Before(POST.class)
	@ActionKey("gets/verify")
	public void getVerify() {
		renderJson(getVerify(HttpKit.readData(getRequest())));
	}

	@NotAction
	public JSONObject getVerify(String request) {
		DemoParser parser = new DemoParser(GETS, false);

		JSONObject requestObject = null;
		int type;
		String phone;
		try {
			requestObject = JSON.parseObject(request);
			type = requestObject.getIntValue(TYPE);
			phone = requestObject.getString(PHONE);
		} catch (Exception e) {
			return parser.extendErrorResult(requestObject, e);
		}

		return parser.parseResponse(newVerifyRequest(type, phone, null));
	}

	/**校验验证码
	 * @see
	 * <pre>
		{
			"type": 0,  //类型，0,1,2,3,4，非必须
			"phone": "13000082001",
			"verify": "123456"
		}
	 * </pre>
	 */
	@Before(POST.class)
	@ActionKey("heads/verify")
	public void headVerify() {
		DemoParser parser = new DemoParser();

		String request = HttpKit.readData(getRequest());
		JSONObject requestObject = null;
		int type;
		String phone;
		String verify;
		try {
			requestObject = JSON.parseObject(request);
			type = requestObject.getIntValue(TYPE);
			phone = requestObject.getString(PHONE);
			verify = requestObject.getString(VERIFY);
		} catch (Exception e) {
			renderJson(parser.extendErrorResult(requestObject, e));
			return;
		}

		renderJson(headVerify(type, phone, verify));
	}

	/**校验验证码
	 * @author Lemon
	 * @param type
	 * @param phone
	 * @param code
	 * @return
	 */
	@NotAction
	public JSONObject headVerify(int type, String phone, String code) {
		DemoParser parser = new DemoParser();

		JSONResponse<JSONObject, JSONArray> response = new JSONResponse<>(
				new DemoParser(GETS, false).parseResponse(
						(JSONObject) apijson.JSON.parseObject(new JSONRequest(
								new Verify(type, phone)
								.setVerify(code)
								).setTag(VERIFY_)
						))
				);
		Verify verify = response.getObject(Verify.class);
		if (verify == null) {
			return parser.newErrorResult(StringUtil.isEmpty(code, true)
					? new NotExistException("验证码不存在！") : new ConditionErrorException("手机号或验证码错误！"));
		}

		//验证码过期
		long time = BaseModel.getTimeMillis(verify.getDate());
		long now = System.currentTimeMillis();
		if (now > 60*1000 + time) {
			new DemoParser(DELETE, false).parseResponse(
					(JSONObject) apijson.JSON.parseObject(
							new JSONRequest(new Verify(type, phone)).setTag(VERIFY_)
					)
			);
			return parser.newErrorResult(new TimeoutException("验证码已过期！"));
		}

		return new JSONResponse<>(
				new DemoParser(HEADS, false).parseResponse(
						(JSONObject) apijson.JSON.parseObject(
								new JSONRequest(new Verify(type, phone).setVerify(code)).setFormat(true)
						)
				)
		).toObject(JSONObject.class);
	}



	/**新建一个验证码请求
	 * @param phone
	 * @param verify
	 * @return
	 */
	@NotAction
	private JSONObject newVerifyRequest(int type, String phone, String verify) {
		JSONObject obj = new JSONObject(true);
		obj.putAll(new JSONRequest(new Verify(type, phone).setVerify(verify)).setTag(VERIFY_).setFormat(true));
		return obj;
	}


	public static final String LOGIN = "login";
	public static final String REMEMBER = "remember";
	public static final String DEFAULTS = "defaults";

	public static final int LOGIN_TYPE_PASSWORD = 0;//密码登录
	public static final int LOGIN_TYPE_VERIFY = 1;//验证码登录
	/**用户登录
	 * @return
	 * @see
	 * <pre>
		{
			"type": 0,  //登录方式，非必须  0-密码 1-验证码
			"phone": "13000082001",
			"password": "1234567",
			"version": 1 //全局版本号，非必须
		}
	 * </pre>
	 */
	@Before(POST.class)
	public void login() {
		DemoParser parser = new DemoParser();

		String request = HttpKit.readData(getRequest());
		HttpSession session = getSession();

		JSONObject requestObject = null;
		boolean isPassword;
		String phone;
		String password;
		int version;
		Boolean format;
		boolean remember;
		JSONObject defaults;
		try {
			requestObject = JSON.parseObject(request);

			isPassword = requestObject.getIntValue(TYPE) == LOGIN_TYPE_PASSWORD;//登录方式
			phone = requestObject.getString(PHONE);//手机
			password = requestObject.getString(PASSWORD);//密码

			if (StringUtil.isPhone(phone) == false) {
				throw new IllegalArgumentException("手机号不合法！");
			}

			if (isPassword) {
				if (StringUtil.isPassword(password) == false) {
					throw new IllegalArgumentException("密码不合法！");
				}
			} else {
				if (StringUtil.isVerify(password) == false) {
					throw new IllegalArgumentException("验证码不合法！");
				}
			}

			version = requestObject.getIntValue(VERSION);
			format = requestObject.getBoolean(FORMAT);
			remember = requestObject.getBooleanValue(REMEMBER);
			defaults = requestObject.getJSONObject(DEFAULTS); //默认加到每个请求最外层的字段
			requestObject.remove(VERSION);
			requestObject.remove(FORMAT);
			requestObject.remove(REMEMBER);
			requestObject.remove(DEFAULTS);
		} catch (Exception e) {
			renderJson(parser.extendErrorResult(requestObject, e));
			return;
		}

		//手机号是否已注册
		JSONObject phoneResponse = new DemoParser(HEADS, false).parseResponse(
				(JSONObject) apijson.JSON.parseObject(new Privacy().setPhone(phone))
		);
		if (JSONResponse.isSuccess(phoneResponse) == false) {
			renderJson(parser.newResult(phoneResponse.getIntValue(JSONResponse.KEY_CODE), phoneResponse.getString(JSONResponse.KEY_MSG)));
			return;
		}
		JSONResponse<JSONObject, JSONArray> response = new JSONResponse<JSONObject, JSONArray>(phoneResponse).getJSONResponse(PRIVACY_);
		if(JSONResponse.isExist(response) == false) {
			renderJson(parser.newErrorResult(new NotExistException("手机号未注册")));
			return;
		}

		//根据phone获取User
		JSONObject privacyResponse = new DemoParser(GETS, false).parseResponse(
				(JSONObject) apijson.JSON.parseObject(
						new JSONRequest(
								new Privacy().setPhone(phone)
						).setFormat(true)
				)
		);
		response = new JSONResponse<>(privacyResponse);

		Privacy privacy = response == null ? null : response.getObject(Privacy.class);
		long userId = privacy == null ? 0 : BaseModel.value(privacy.getId());
		if (userId <= 0) {
			renderJson(privacyResponse);
			return;
		}

		//校验凭证 
		if (isPassword) {//password密码登录
			response = new JSONResponse<>(
					new DemoParser(HEADS, false).parseResponse(
							(JSONObject) apijson.JSON.parseObject(
									new Privacy(userId).setPassword(password)
							)
					)
			);
		} else {//verify手机验证码登录
			response = new JSONResponse<>(headVerify(Verify.TYPE_LOGIN, phone, password));
		}
		if (JSONResponse.isSuccess(response) == false) {
			renderJson(response);
			return;
		}
		response = response.getJSONResponse(isPassword ? PRIVACY_ : VERIFY_);
		if (JSONResponse.isExist(response) == false) {
			renderJson(parser.newErrorResult(new ConditionErrorException("账号或密码错误")));
			return;
		}

		response = new JSONResponse<>(
				new DemoParser(GETS, false).parseResponse(
						JSON.parseObject(new JSONRequest(  // 兼容 MySQL 5.6 及以下等不支持 json 类型的数据库
								USER_,  // User 里在 setContactIdList(List<Long>) 后加 setContactIdList(String) 没用
								new JSONRequest(  // fastjson 查到一个就不继续了，所以只能加到前面或者只有这一个，但这样反过来不兼容 5.7+
										new User(userId)  // 所以就用 @json 来强制转为 JSONArray，保证有效
										).setJson("contactIdList,pictureList")
								).setFormat(true)
						))
				);
		User user = (User) response.getObject(User.class, DemoAppConfig.DEFAULT_JSON_PARSER);
		if (user == null || BaseModel.value(user.getId()) != userId) {
			renderJson(parser.newErrorResult(new NullPointerException("服务器内部错误")));
			return;
		}

		//登录状态保存至session
		session.setAttribute(USER_ID, userId); //用户id
		session.setAttribute(TYPE, isPassword ? LOGIN_TYPE_PASSWORD : LOGIN_TYPE_VERIFY); //登录方式
		session.setAttribute(USER_, user); //用户
		session.setAttribute(PRIVACY_, privacy); //用户隐私信息
		session.setAttribute(REMEMBER, remember); //是否记住登录
		session.setAttribute(VISITOR_ID, userId); //用户id
		session.setAttribute(VISITOR_, user); //用户
		session.setAttribute(VERSION, version); //全局默认版本号
		session.setAttribute(FORMAT, format); //全局默认格式化配置
		session.setAttribute(DEFAULTS, defaults); //给每个请求JSON最外层加的字段
		session.setMaxInactiveInterval(60*60*24*(remember ? 7 : 1)); //设置session过期时间

		response.put(REMEMBER, remember);
		response.put(DEFAULTS, defaults);

		renderJson(response);
	}

	/**退出登录，清空session
	 * @return
	 */
	@Before(POST.class)
	public void logout() {
		DemoParser parser = new DemoParser();

		HttpSession session = getSession();
		long userId;
		try {
			userId = DemoVerifier.getVisitorId(session);//必须在session.invalidate();前！
			Log.d(TAG, "logout  userId = " + userId + "; session.getId() = " + (session == null ? null : session.getId()));
			session.invalidate();
		} catch (Exception e) {
			renderJson(parser.newErrorResult(e));
			return;
		}

		JSONObject result = parser.newSuccessResult();
		JSONObject user = parser.newSuccessResult();
		user.put(ID, userId);
		user.put(COUNT, 1);
		result.put(StringUtil.firstCase(USER_), user);

		renderJson(result);
	}


	private static final String REGISTER = "register";
	/**注册
	 * @return
	 * @see
	 * <pre>
		{
			"Privacy": {
				"phone": "13000082222",
				"_password": "123456"
			},
			"User": {
				"name": "APIJSONUser"
			},
			"verify": "1234"
		}
	 * </pre>
	 */
	@Before(POST.class)
	public void register() {
		DemoParser parser = new DemoParser();

		String request = HttpKit.readData(getRequest());
		JSONObject requestObject = null;

		JSONObject privacyObj;

		String phone;
		String verify;
		String password;
		try {
			requestObject = JSON.parseObject(request);
			privacyObj = requestObject.getJSONObject(PRIVACY_);

			phone = StringUtil.getString(privacyObj.getString(PHONE));
			verify = requestObject.getString(VERIFY);
			password = privacyObj.getString(_PASSWORD);

			if (StringUtil.isPhone(phone) == false) {
				renderJson(newIllegalArgumentResult(requestObject, PRIVACY_ + "/" + PHONE));
				return;
			}
			if (StringUtil.isPassword(password) == false) {
				renderJson(newIllegalArgumentResult(requestObject, PRIVACY_ + "/" + _PASSWORD));
				return;
			}
			if (StringUtil.isVerify(verify) == false) {
				renderJson(newIllegalArgumentResult(requestObject, VERIFY));
				return;
			}
		} catch (Exception e) {
			renderJson(parser.extendErrorResult(requestObject, e));
			return;
		}


		JSONResponse<JSONObject, JSONArray> response = new JSONResponse<>(headVerify(Verify.TYPE_REGISTER, phone, verify));
		if (JSONResponse.isSuccess(response) == false) {
			renderJson(response);
			return;
		}
		//手机号或验证码错误
		if (JSONResponse.isExist(response.getJSONResponse(VERIFY_)) == false) {
			renderJson(parser.extendErrorResult(response.toObject(JSONObject.class), new ConditionErrorException("手机号或验证码错误！")));
			return;
		}

		//生成User和Privacy
		if (StringUtil.isEmpty(requestObject.getString(apijson.JSONRequest.KEY_TAG), true)) {
			requestObject.put(apijson.JSONRequest.KEY_TAG, REGISTER);
		}
		requestObject.put(apijson.JSONRequest.KEY_FORMAT, true);
		response = new JSONResponse<>( 
				new DemoParser(POST).setNeedVerifyLogin(false).parseResponse(requestObject)
				);

		//验证User和Privacy
		User user = response.getObject(User.class);
		long userId = user == null ? 0 : BaseModel.value(user.getId());
		Privacy privacy = response.getObject(Privacy.class);
		long userId2 = privacy == null ? 0 : BaseModel.value(privacy.getId());
		Exception e = null;
		if (userId <= 0 || userId != userId2) { //id不同
			e = new Exception("服务器内部错误！写入User或Privacy失败！");
		}

		if (e != null) { //出现错误，回退
			new DemoParser(DELETE, false).parseResponse(
					JSON.parseObject(new User(userId))
			);
			new DemoParser(DELETE, false).parseResponse(
					JSON.parseObject(new Privacy(userId2))
			);
		}

		renderJson(response);
	}


	/**
	 * @param requestObject
	 * @param key
	 * @return
	 */
	@NotAction
	public static JSONObject newIllegalArgumentResult(JSONObject requestObject, String key) {
		return newIllegalArgumentResult(requestObject, key, null);
	}
	/**
	 * @param requestObject
	 * @param key
	 * @param msg 详细说明
	 * @return
	 */
	@NotAction
	public static JSONObject newIllegalArgumentResult(JSONObject requestObject, String key, String msg) {
		DemoParser parser = new DemoParser();
		return parser.extendErrorResult(requestObject
				, new IllegalArgumentException(key + ":value 中value不合法！" + StringUtil.getString(msg)));
	}


	/**设置密码
	 * @return
	 * @see
	 * <pre>
	    使用旧密码修改
		{
			"oldPassword": 123456,
			"Privacy":{
			  "id": 13000082001,
			  "_password": "1234567"
			}
		}
		或使用手机号+验证码修改
		{
			"verify": "1234",
			"Privacy":{
			  "phone": "13000082001",
			  "_password": "1234567"
			}
		}
	 * </pre>
	 */
	@Before(POST.class)
	@ActionKey("put/password")
	public void putPassword() {
		DemoParser parser = new DemoParser();

		String request = HttpKit.readData(getRequest());

		JSONObject requestObject = null;
		String oldPassword;
		String verify;

		int type = Verify.TYPE_PASSWORD;

		JSONObject privacyObj;
		long userId;
		String phone;
		String password;
		try {
			requestObject = DemoParser.parseRequest(request);
			oldPassword = StringUtil.getString(requestObject.getString(OLD_PASSWORD));
			verify = StringUtil.getString(requestObject.getString(VERIFY));

			requestObject.remove(OLD_PASSWORD);
			requestObject.remove(VERIFY);

			privacyObj = requestObject.getJSONObject(PRIVACY_);
			if (privacyObj == null) {
				throw new IllegalArgumentException(PRIVACY_ + " 不能为空！");
			}
			userId = privacyObj.getLongValue(ID);
			phone = privacyObj.getString(PHONE);
			password = privacyObj.getString(_PASSWORD);

			if (StringUtil.isEmpty(password, true)) { //支付密码
				type = Verify.TYPE_PAY_PASSWORD;
				password = privacyObj.getString(_PAY_PASSWORD);
				if (StringUtil.isNumberPassword(password) == false) {
					throw new IllegalArgumentException(PRIVACY_ + "/" + _PAY_PASSWORD + ":value 中value不合法！");
				}
			} else { //登录密码
				if (StringUtil.isPassword(password) == false) {
					throw new IllegalArgumentException(PRIVACY_ + "/" + _PASSWORD + ":value 中value不合法！");
				}
			}
		} catch (Exception e) {
			renderJson(parser.extendErrorResult(requestObject, e));
			return;
		}


		if (StringUtil.isPassword(oldPassword)) {
			if (userId <= 0) { //手机号+验证码不需要userId
				renderJson(parser.extendErrorResult(requestObject, new IllegalArgumentException(ID + ":value 中value不合法！")));
				return;
			}
			if (oldPassword.equals(password)) {
				renderJson(parser.extendErrorResult(requestObject, new ConflictException("新旧密码不能一样！")));
				return;
			}

			//验证旧密码
			Privacy privacy = new Privacy(userId);
			if (type == Verify.TYPE_PASSWORD) {
				privacy.setPassword(oldPassword);
			} else {
				privacy.setPayPassword(oldPassword);
			}
			JSONResponse<JSONObject, JSONArray> response = new JSONResponse<>( 
					new DemoParser(HEAD, false).parseResponse(
							JSON.parseObject(new JSONRequest(privacy).setFormat(true))
					)
			);
			if (JSONResponse.isExist(response.getJSONResponse(PRIVACY_)) == false) {
				renderJson(parser.extendErrorResult(requestObject, new ConditionErrorException("账号或原密码错误，请重新输入！")));
				return;
			}
		}
		else if (StringUtil.isPhone(phone) && StringUtil.isVerify(verify)) {
			JSONResponse<JSONObject, JSONArray> response = new JSONResponse<>(headVerify(type, phone, verify));
			if (JSONResponse.isSuccess(response) == false) {
				renderJson(response);
				return;
			}
			if (JSONResponse.isExist(response.getJSONResponse(VERIFY_)) == false) {
				renderJson(parser.extendErrorResult(response.toObject(JSONObject.class), new ConditionErrorException("手机号或验证码错误！")));
				return;
			}
			response = new JSONResponse<>(
					new DemoParser(GET, false).parseResponse(
							JSON.parseObject(
									new Privacy().setPhone(phone)
							)
					)
			);
			Privacy privacy = response.getObject(Privacy.class);
			long id = privacy == null ? 0 : BaseModel.value(privacy.getId());
			privacyObj.remove(PHONE);
			privacyObj.put(ID, id);

			requestObject.put(PRIVACY_, privacyObj);
		} else {
			renderJson(parser.extendErrorResult(requestObject, new IllegalArgumentException("请输入合法的 旧密码 或 手机号+验证码 ！")));
			return;
		}
		//TODO 上线版加上   password = MD5Util.MD5(password);


		//		requestObject.put(apijson.JSONRequest.KEY_TAG, "Password");
		requestObject.put(apijson.JSONRequest.KEY_FORMAT, true);

		//修改密码
		renderJson(new DemoParser(PUT, false).parseResponse(requestObject));
	}



	/**充值/提现
	 * @see
	 * <pre>
		{
			"Privacy": {
				"id": 82001,
				"balance+": 100,
				"_payPassword": "123456"
			}
		}
	 * </pre>
	 */
	@Before(POST.class)
	@ActionKey("put/balance")
	public void putBalance() {
		DemoParser parser = new DemoParser();

		String request = HttpKit.readData(getRequest());
		HttpSession session = getSession();
		JSONObject requestObject = null;
		JSONObject privacyObj;
		long userId;
		String payPassword;
		double change;
		try {
			DemoVerifier.verifyLogin(session);
			requestObject = new DemoParser(PUT).setRequest(DemoParser.parseRequest(request)).parseCorrectRequest();

			privacyObj = requestObject.getJSONObject(PRIVACY_);
			if (privacyObj == null) {
				throw new NullPointerException("请设置 " + PRIVACY_ + "！");
			}
			userId = privacyObj.getLongValue(ID);
			payPassword = privacyObj.getString(_PAY_PASSWORD);
			change = privacyObj.getDoubleValue("balance+");

			if (userId <= 0) {
				throw new IllegalArgumentException(PRIVACY_ + "." + ID + ":value 中value不合法！");
			}
			if (StringUtil.isPassword(payPassword) == false) {
				throw new IllegalArgumentException(PRIVACY_ + "." + _PAY_PASSWORD + ":value 中value不合法！");
			}
		} catch (Exception e) {
			renderJson(parser.extendErrorResult(requestObject, e));
			return;
		}

		//验证密码<<<<<<<<<<<<<<<<<<<<<<<

		privacyObj.remove("balance+");
		JSONResponse<JSONObject, JSONArray> response = new JSONResponse<>(
				new DemoParser(HEADS, false).setSession(session).parseResponse(
						JSON.createJSONObject(PRIVACY_, privacyObj)
						)
				);
		response = response.getJSONResponse(PRIVACY_);
		if (JSONResponse.isExist(response) == false) {
			renderJson(parser.extendErrorResult(requestObject, new ConditionErrorException("支付密码错误！")));
			return;
		}

		//验证密码>>>>>>>>>>>>>>>>>>>>>>>>


		//验证金额范围<<<<<<<<<<<<<<<<<<<<<<<

		if (change == 0) {
			renderJson(parser.extendErrorResult(requestObject, new OutOfRangeException("balance+的值不能为0！")));
			return;
		}
		if (Math.abs(change) > 10000) {
			renderJson(parser.extendErrorResult(requestObject, new OutOfRangeException("单次 充值/提现 的金额不能超过10000元！")));
			return;
		}

		//验证金额范围>>>>>>>>>>>>>>>>>>>>>>>>

		if (change < 0) {//提现
			response = new JSONResponse<>(
					new DemoParser(GETS, false).parseResponse(
							JSON.parseObject(
									new Privacy(userId)
							)
					)
			);
			Privacy privacy = response == null ? null : response.getObject(Privacy.class);
			long id = privacy == null ? 0 : BaseModel.value(privacy.getId());
			if (id != userId) {
				renderJson(parser.extendErrorResult(requestObject, new Exception("服务器内部错误！")));
				return;
			}

			if (BaseModel.value(privacy.getBalance()) < -change) {
				renderJson(parser.extendErrorResult(requestObject, new OutOfRangeException("余额不足！")));
				return;
			}
		}


		privacyObj.remove(_PAY_PASSWORD);
		privacyObj.put("balance+", change);
		requestObject.put(PRIVACY_, privacyObj);
		requestObject.put(apijson.JSONRequest.KEY_TAG, PRIVACY_);
		requestObject.put(apijson.JSONRequest.KEY_FORMAT, true);
		//不免验证，里面会验证身份
		renderJson(new DemoParser(PUT).setSession(session).parseResponse(requestObject));
	}


}
