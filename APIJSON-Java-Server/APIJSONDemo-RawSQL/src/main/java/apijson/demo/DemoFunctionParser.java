package apijson.demo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import apijson.NotNull;
import apijson.RequestMethod;
import apijson.StringUtil;
import apijson.framework.javax.APIJSONConstant;
import apijson.framework.javax.APIJSONFunctionParser;
import apijson.router.javax.APIJSONRouterVerifier;

public class DemoFunctionParser extends APIJSONFunctionParser<String> {
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
	 * @throws Exception
	 */
	public String getCurrentUserId(@NotNull JSONObject current) throws IllegalAccessException {
		if (this.getSession() == null) {
			return "test"; // 启动时的自动测试
		}
		String uid = (String) this.getSession().getAttribute(APIJSONConstant.VISITOR_ID);
		if (uid == null) {
			throw new IllegalAccessException("user not logged in");
		}
		// return FormVerifier.getVisitorId(getSession());
		return uid;
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
	 * 只开放GET请求 原始sql统计查询
	 */
	public Object rawSQL(@NotNull JSONObject current, @NotNull String paramName) {
		if (this.getSession() == null) {
			return "test"; // 启动时的自动测试
		}
		String key = APIJSONRouterVerifier.getCacheKeyForRequest(this.getMethod().name().toLowerCase(), current.getString("tag"));
		JSONObject document = APIJSONRouterVerifier.DOCUMENT_MAP.get(key) != null ? APIJSONRouterVerifier.DOCUMENT_MAP.get(key).get(this.getVersion()) != null ? APIJSONRouterVerifier.DOCUMENT_MAP.get(key).get(this.getVersion()) : null
				: null;
		String sqlauto = document.getString("sqlauto");
		String datasource = current.getString(apijson.JSONObject.KEY_DATABASE);
		return buildSearchData(current, datasource, sqlauto, paramName);
	}

	private Object buildSearchData(JSONObject current, String datasource, String sqlauto, String paramName) {
		Connection connection = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			DataSource dataSource = DemoApplication.getApplicationContext().getBean(DataSource.class);
			connection = dataSource.getConnection();
			// 执行预编译查询
			ps = connection.prepareStatement(sqlauto);
			JSONArray jr = current.getJSONArray(paramName);
			for (int i = 1; i <= jr.size(); i++) {
				Object psValue = current.get(jr.get(i - 1)) == null ? null : current.get(jr.get(i - 1));
				if (psValue == null) {
					throw new IllegalAccessException("request 参数 " + jr.get(i) + " 不存在! ");
				}
				ps.setObject(i, psValue);
			}
			rs = ps.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			final int length = rsmd.getColumnCount();
			List<JSONObject> rsData = new ArrayList<>();
			while (rs.next()) {
				JSONObject rowData = new JSONObject();
				for (int i = 1; i <= length; i++) {
					rowData.put(rsmd.getColumnLabel(i), rs.getObject(i));
				}
				rsData.add(rowData);
			}
			// 组装返回数据
			return rsData;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (rs != null) {
				try {
					rs.close();
				} catch (Exception e) {
				}
			}

			if (ps != null) {
				try {
					ps.close();
				} catch (Exception e) {
				}
			}

			if (connection != null) {
				try {
					connection.close();
				} catch (Exception e) {
				}
			}
		}
		return null;
	}
	
	/***
	 * 兼容数组 和 ;分隔字符串
	 * 
	 * @param current
	 * @param keys
	 */
	public void removeKeys(@NotNull JSONObject current, String keys) {
		if (this.getSession() == null) {
			return; // 启动时的自动测试
		}
		// 删除Request数组对应的key
		boolean vertifyArrayKey = current.containsKey(keys) && current.get(keys) instanceof JSONArray ? true : false;
		if (vertifyArrayKey) {
			for (int i = 0; i < current.getJSONArray(keys).size(); i++) {
				current.remove(current.getJSONArray(keys).get(i));
			}
			return;
		}

		// 删除Request;分隔对应的key
		boolean vertifySplitKey = current.containsKey(keys) && current.get(keys) instanceof String ? true : false;
		if (vertifySplitKey) {
			String[] ks = StringUtil.split(current.getString(keys), ";"); // 用分号 ; 分割
			// 根据 ks remove 掉 current 里的字段
			for (int i = 0; i < ks.length; i++) {
				current.remove(ks[i]);
			}
			return;
		}
		// 默认参数;分隔
		String[] ks = StringUtil.split(keys, ";"); // 用分号 ; 分割
		// 根据 ks remove 掉 current 里的字段
		for (int i = 0; i < ks.length; i++) {
			current.remove(ks[i]);
		}
	}
}
