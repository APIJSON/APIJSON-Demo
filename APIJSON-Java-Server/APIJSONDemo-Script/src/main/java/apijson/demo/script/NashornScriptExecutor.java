package apijson.demo.script;

import java.util.HashMap;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;

import apijson.orm.AbstractFunctionParser;
import apijson.orm.script.JSR223ScriptExecutor;
import apijson.orm.script.ScriptExecutor;
import jdk.nashorn.api.scripting.NashornScriptEngineFactory;

public class NashornScriptExecutor extends JSR223ScriptExecutor {
	@SuppressWarnings("restriction")
	@Override
	public ScriptExecutor init() {
		NashornScriptEngineFactory factory = new NashornScriptEngineFactory();
		String[] stringArray = new String[] { "-doe", "--global-per-engine" };
		scriptEngine = factory.getScriptEngine(stringArray);
		return this;
	}

	
	@Override
	protected String scriptEngineName() {
		return "nashornJS";
	}


	@Override
	protected Object extendParameter(AbstractFunctionParser parser, JSONObject currentObject, String methodName, Object[] args) {
		Map<String,String> tmpData = new HashMap<>();
		tmpData.put("data", "122");
		return tmpData;
	}


	@Override
	protected boolean isLockScript(String methodName) {
		return false;
	}
}
