package apijson.demo;

import javax.servlet.http.HttpSession;

import com.alibaba.fastjson.JSONObject;

import apijson.NotNull;
import apijson.RequestMethod;
import apijson.StringUtil;
import apijson.framework.APIJSONFunctionParser;
import apijson.framework.APIJSONVerifier;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class DemoFunctionParser extends APIJSONFunctionParser {
	public DemoFunctionParser() {
		this(null, null, 0, null, null);
	}

	// 展示在远程函数内部可以用 this 拿到的东西
	public DemoFunctionParser(RequestMethod method, String tag, int version, JSONObject request, HttpSession session) {
		super(method, tag, version, request, session);
	}

	/***
	 * 获取当前用户id
	 * 
	 * @param current
	 * @return
	 */
	public String getCurrentUserId(@NotNull JSONObject current) {
		if (this.getSession() == null) {
			return "test"; // 启动时的自动测试
		}
		return APIJSONVerifier.getVisitorId(getSession());
	}

	/**
	 * 一个最简单的远程函数示例，返回一个前面拼接了 Hello 的字符串
	 * 
	 * @param current
	 * @param name
	 * @return
	 * @throws Exception
	 */
	public String sayHello(@NotNull JSONObject current, @NotNull String name) throws Exception {
		// 注意这里参数 name 是 key，不是 value
		Object obj = current.get(name);

		if (this.getSession() == null) {
			return "test"; // 启动时的自动测试
		}
		
		if (obj == null) {
			throw new IllegalArgumentException();
		}
		if (!(obj instanceof String)) {
			throw new IllegalArgumentException();
		}
		
		// 之后可以用 this.getSession 拿到当前的 HttpSession
		return "Hello, " + obj.toString();
	}

	/***
	 * 密码加密
	 * 
	 * @param current
	 * @param id       添加id生成
	 * @param password 密码字段名
	 * @return
	 * @throws Exception
	 */
	public void pwdEncrypt(@NotNull JSONObject current, @NotNull String id, @NotNull String password)
			throws Exception {
		String c_password = current.getString(password);
		current.put(password, c_password + "_" + System.currentTimeMillis());
	}

	/***
	 * 业务表-插入不同表1:n <br/>
	 * 业务表-批量修改不同表1:n <br/>
	 * 测试 子表 前置函数调用,修改值是否成果 <br/>
	 * user_address 表 addr字段
	 * 
	 * @param current
	 * @param password
	 * @return
	 * @throws Exception
	 */
	public void childFunTest(@NotNull JSONObject current, @NotNull String addr) throws Exception {
		String c_addr = current.getString(addr);
		current.put(addr, c_addr + "_" + System.currentTimeMillis());
	}

	/***
	 * 没有在外层事物里面
	 * 
	 * @throws Exception
	 */
//	private void insertTest() throws Exception {
//		String json = "{\n" + "    \"User\":{\n" + "        \"username\":\"test\",\n"
//				+ "        \"password\": \"233223\",\n" + "		\"state\": 1\n" + "    },\n" + "    \"tag\": \"User\"\n"
//				+ "}";
//		com.alibaba.fastjson.JSONObject requestObject = AbstractParser.parseRequest(json);
//		JSONResponse response = new JSONResponse(new FormParser(POST, false).parseResponse(requestObject));
//		log.info(response.toJSONString());
//	}
//
//	private void selectTest() throws Exception {
//		String json = "{\n" + "    \"User\": {\n" + "        \"id\": \"4732209c-5785-4827-b532-5092f154fd94\"\n"
//				+ "    },\n" + "    \"tag\": \"User\"\n" + "}";
//		com.alibaba.fastjson.JSONObject requestObject = AbstractParser.parseRequest(json);
//		JSONResponse response = new JSONResponse(new FormParser(GET, false).parseResponse(requestObject));
//		log.info(response.toJSONString());
//	}

	public void removeKeys(@NotNull JSONObject current, String keys) {
		String[] ks = StringUtil.split(keys, ";"); // 用分号 ; 分割
		// 根据 ks remove 掉 current 里的字段
		for (int i = 0; i < ks.length; i++) {
			current.remove(ks[i]);
		}
	}
}
