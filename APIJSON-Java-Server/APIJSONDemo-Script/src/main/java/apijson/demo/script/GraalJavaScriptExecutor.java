package apijson.demo.script;

import org.graalvm.polyglot.Context;
import org.graalvm.polyglot.Engine;
import org.graalvm.polyglot.Source;
import org.graalvm.polyglot.Value;

import com.alibaba.fastjson.JSONObject;

import apijson.orm.AbstractFunctionParser;
import apijson.orm.script.ScriptExecutor;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class GraalJavaScriptExecutor implements ScriptExecutor {

	private final Map<String, Source> scriptMap = new ConcurrentHashMap<>();

	private Engine engine;

	@Override
	public ScriptExecutor init() {
		engine = Engine.create();
		return this;
	}

	private Object extendParameter(AbstractFunctionParser parser, JSONObject currentObject, String methodName, Object[] args) {
		return null;
	}

	@Override
	public void load(String name, String script) {
		try {
			scriptMap.put(name, Source.create("js", script));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public Object execute(AbstractFunctionParser parser, JSONObject currentObject, String methodName, Object[] args) throws Exception {
		Context context = Context.newBuilder().allowAllAccess(true).engine(this.engine).build();
		Value bindings = context.getBindings("js");
		// 加载扩展属性
		Object extendParameter = this.extendParameter(parser, currentObject, methodName, args);
		if (extendParameter != null) {
			bindings.putMember("extParam", extendParameter);
		}

		Map<String, Object> metaMap = new HashMap<>();
		metaMap.put("version", parser.getVersion());
		metaMap.put("tag", parser.getTag());
		metaMap.put("args", args);
		bindings.putMember("_meta", metaMap);
		Value value = context.eval(scriptMap.get(methodName));
		if (value.isBoolean()) {
			return value.asBoolean();
		} else if (value.isNumber()) {
			return value.asInt();
		} else if (value.isString()) {
			return value.asString();
		}
		return value;
	}

	@Override
	public void cleanCache() {
		scriptMap.clear();
	}
}
