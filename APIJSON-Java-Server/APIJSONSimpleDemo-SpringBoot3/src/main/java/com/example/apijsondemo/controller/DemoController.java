package com.example.apijsondemo.controller;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

import com.alibaba.fastjson.JSONObject;

import jakarta.servlet.http.HttpSession;

import com.example.apijsondemo.model.Privacy;

import apijson.JSONResponse;
import apijson.RequestMethod;
import apijson.StringUtil;
import apijson.framework.APIJSONController;
import apijson.framework.APIJSONParser;
import apijson.framework.APIJSONVerifier;
import apijson.framework.BaseModel;
import apijson.orm.Parser;
import apijson.orm.JSONRequest;
import apijson.orm.exception.ConditionErrorException;
import apijson.orm.exception.NotExistException;
import apijson.Log;

import static apijson.framework.APIJSONConstant.VERSION;
import static apijson.framework.APIJSONConstant.FORMAT;
import static apijson.framework.APIJSONConstant.DEFAULTS;
import static apijson.framework.APIJSONConstant.USER_ID;
import static apijson.framework.APIJSONConstant.ID;
import static apijson.RequestMethod.GETS;
import static apijson.RequestMethod.HEADS;

/**
 * 请求路由入口控制器，包括通用增删改查接口等，转交给 APIJSON 的 Parser 来处理
 * 具体见 SpringBoot 文档
 * https://www.springcloud.cc/spring-boot.html#boot-features-spring-mvc
 * 以及 APIJSON 通用文档 3.设计规范 3.1 操作方法
 * https://github.com/Tencent/APIJSON/blob/master/Document.md#3.1
 * <br >
 * 建议全通过HTTP POST来请求:
 * <br >
 * 1.减少代码 - 客户端无需写HTTP GET,PUT等各种方式的请求代码
 * <br >
 * 2.提高性能 - 无需URL encode和decode
 * <br >
 * 3.调试方便 - 建议使用 APIAuto(http://apijson.cn/api) 或 Postman
 * 
 * @author Lemon
 */
@RestController
// @RequestMapping("api")
public class DemoController extends APIJSONController<Long> {

	@Override
	public Parser<Long> newParser(HttpSession session, RequestMethod method) {
		return super.newParser(session, method).setNeedVerify(true); // TODO 这里关闭校验，方便新手快速测试，实际线上项目建议开启
	}

	/**
	 * 增删改查统一接口，这个一个接口可替代 7 个万能通用接口，牺牲一些路由解析性能来提升一点开发效率
	 * 
	 * @param method
	 * @param request
	 * @param session
	 * @return
	 */
	@PostMapping(value = "{method}") // 如果和其它的接口 URL 冲突，可以加前缀，例如改为 crud/{method} 或 Controller 注解
	@Override
	public String crud(@PathVariable String method, @RequestBody String request, HttpSession session) {
		return super.crud(method, request, session);
	}

	/**
	 * 增删改查统一接口，这个一个接口可替代 7 个万能通用接口，牺牲一些路由解析性能来提升一点开发效率
	 * 
	 * @param method
	 * @param tag
	 * @param params
	 * @param request
	 * @param session
	 * @return
	 */
	@PostMapping("{method}/{tag}") // 如果和其它的接口 URL 冲突，可以加前缀，例如改为 crud/{method}/{tag} 或 Controller 注解
	@Override
	public String crudByTag(@PathVariable String method, @PathVariable String tag,
			@RequestParam Map<String, String> params, @RequestBody String request, HttpSession session) {
		return super.crudByTag(method, tag, params, request, session);
	}

	// 下面是登录相关接口
	public static final String PRIVACY;
	static {
		PRIVACY = Privacy.class.getSimpleName(); // 获取类的简单名字，不包含包名
	}

	public static final String LOGIN = "login";
	public static final String LOGOUT = "logout";

	public static final String USERNAME = "username";
	public static final String PASSWORD = "password";

	public static final String REMEMBER = "remember";

	/**
	 * 登录
	 * 
	 * @param request
	 * @param session
	 * @return
	 */
	@PostMapping(LOGIN)
	public JSONObject login(@RequestBody String request, HttpSession session) {

		JSONObject requestObject = null;

		String username, password;

		// 框架信息，暂时可以忽略
		int version; // 全局默认版本号
		Boolean format; // 全局默认格式化配置
		JSONObject defaults; // 给每个请求JSON最外层加的字段
		boolean remember; // 是否记住登录状态

		// 提取信息
		try {
			requestObject = APIJSONParser.parseRequest(request);

			username = requestObject.getString(USERNAME); // 用户名
			password = requestObject.getString(PASSWORD); // 密码

			if (StringUtil.isName(username) == false) {
				throw new IllegalArgumentException("用户名不合法！");
			}

			if (StringUtil.isPassword(password) == false) {
				throw new IllegalArgumentException("密码不合法！");
			}

			version = requestObject.getIntValue(VERSION);
			format = requestObject.getBoolean(FORMAT);
			defaults = requestObject.getJSONObject(DEFAULTS); // 默认加到每个请求最外层的字段
			remember = requestObject.getBooleanValue(REMEMBER);
			requestObject.remove(VERSION);
			requestObject.remove(FORMAT);
			requestObject.remove(DEFAULTS);
			requestObject.remove(REMEMBER);
		} catch (Exception e) {
			return APIJSONParser.extendErrorResult(requestObject, e);
		}

		// 检查用户存在
		// 获取用户信息
		JSONObject userResponse = new APIJSONParser<Long>(HEADS, false).parseResponse(
				new JSONRequest(
						new Privacy().setUserName(username)));

		// 请求中间出错了
		if (JSONResponse.isSuccess(userResponse) == false) {
			return APIJSONParser.newResult(
					userResponse.getIntValue(JSONResponse.KEY_CODE),
					userResponse.getString(JSONResponse.KEY_MSG));
		}

		// 没有获取到用户信息
		JSONResponse response = new JSONResponse(userResponse).getJSONResponse(PRIVACY);
		if (JSONResponse.isExist(response) == false) {
			return APIJSONParser.newErrorResult(new NotExistException("用户名未注册"));
		}

		// 根据username获取User
		JSONObject privacyResponse = new APIJSONParser<Long>(GETS, false).parseResponse(
				new JSONRequest(
						new Privacy().setUserName(username)).setFormat(true));

		// 排除错误情况，并获取privacy和userId
		response = new JSONResponse(privacyResponse);
		Privacy privacy = response == null ? null : response.getObject(Privacy.class);

		long userId = privacy == null ? 0 : BaseModel.value(privacy.getId());

		if (userId <= 0) {
			return privacyResponse;
		}

		// 验证密码
		// 这里是明文密码，实际上可以用 BCrypt 之类的 Encryptor 加密
		// 通过 id 和 password 获取用户
		response = new JSONResponse(
				new APIJSONParser<Long>(HEADS, false).parseResponse(
						new JSONRequest(new Privacy(userId).setPassword(password))));

		// 请求中间出错了
		if (JSONResponse.isSuccess(response) == false) {
			return response;
		}

		response = response.getJSONResponse(PRIVACY);

		// 没有获取到用户信息
		if (JSONResponse.isExist(response) == false) {
			return APIJSONParser.newErrorResult(new ConditionErrorException("账号或密码错误"));
		}

		// 登录状态保存至session
		super.login(session, privacy, version, format, defaults);
		session.setAttribute(USER_ID, userId); // 用户id
		session.setAttribute(PRIVACY, privacy); // 用户隐私信息
		session.setAttribute(REMEMBER, remember); // 是否保持登录
		session.setMaxInactiveInterval(60 * 60 * 12 * (remember ? 6 : 1)); // 设置session会话最大非活动间隔时间

		response.put(REMEMBER, remember);
		response.put(DEFAULTS, defaults);
		return response;
	}

	/**
	 * 退出登录
	 * 
	 * @param session
	 * @return
	 */
	@PostMapping(LOGOUT)
	@Override
	public JSONObject logout(HttpSession session) {
		long userId;
		try {
			userId = APIJSONVerifier.getVisitorId(session);// 必须在session.invalidate();前！
			Log.d(TAG,
					"logout  userId = " + userId + "; session.getId() = " + (session == null ? null : session.getId()));
			// 销毁服务端 session
			super.logout(session);
		} catch (Exception e) {
			return APIJSONParser.newErrorResult(new ConditionErrorException("已经退出登录"));
		}

		// 返回登出成功 response
		JSONObject result = APIJSONParser.newSuccessResult();
		JSONObject user = APIJSONParser.newSuccessResult();
		user.put(ID, userId);
		user.put(LOGOUT, "success");
		result.put(StringUtil.firstCase(PRIVACY), user);

		return result;
	}

}
