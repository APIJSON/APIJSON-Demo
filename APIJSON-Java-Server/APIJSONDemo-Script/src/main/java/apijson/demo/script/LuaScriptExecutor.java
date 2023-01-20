package apijson.demo.script;

import com.alibaba.fastjson.JSONObject;

import apijson.demo.UserEntity;
import apijson.orm.AbstractFunctionParser;
import apijson.orm.script.JSR223ScriptExecutor;

/**
 * Lua脚本执行器
 */
public class LuaScriptExecutor extends JSR223ScriptExecutor {
	@Override
	protected String scriptEngineName() {
		return "luaj";
	}

	@Override
	protected Object extendParameter(AbstractFunctionParser parser, JSONObject currentObject, String methodName, Object[] args) {
		UserEntity user = new UserEntity();
		user.setUsername("ddd");
		return user;
	}

	@Override
	protected boolean isLockScript(String methodName) {
		return true;
	}

	@Override
	public Object execute(AbstractFunctionParser parser, JSONObject currentObject, String methodName, Object[] args) throws Exception {
		//业务侧控制锁颗粒度,可以通过脚本名进行加锁
		synchronized (methodName) {
			return super.execute(parser, currentObject, methodName, args);
		}
	}
}
