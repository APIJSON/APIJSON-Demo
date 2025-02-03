package apijson.demo;

import com.alibaba.fastjson.JSONObject;

import apijson.RequestMethod;
import apijson.framework.javax.APIJSONObjectParser;
import apijson.framework.javax.APIJSONParser;
import apijson.orm.SQLConfig;

public class DemoParser extends APIJSONParser<String> {
	public DemoParser() {
		super();
	}

	public DemoParser(RequestMethod method) {
		super(method);
	}

	public DemoParser(RequestMethod method, boolean needVerify) {
		super(method, needVerify);
	}

	// 可重写来设置最大查询数量
	// @Override
	// public int getMaxQueryCount() {
	// return 50;
	// }

	@Override
	public APIJSONObjectParser<String> createObjectParser(JSONObject request, String parentPath, SQLConfig<String> arrayConfig, boolean isSubquery, boolean isTable, boolean isArrayMainTable) throws Exception {
		return new DemoObjectParser(getSession(), request, parentPath, arrayConfig, isSubquery, isTable, isArrayMainTable).setMethod(getMethod()).setParser(this);
	}

	
}