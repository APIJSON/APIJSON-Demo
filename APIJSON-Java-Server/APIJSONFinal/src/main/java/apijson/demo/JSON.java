package apijson.demo;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import java.util.Map;

public class JSON {

    public static String toJSONString(Object obj) {
        return apijson.JSON.toJSONString(obj);
    }

    public static JSONObject parseObject(Object obj) {
        return apijson.JSON.parseObject(obj);
    }

    public static JSONArray parseArray(Object obj) {
        return apijson.JSON.parseArray(obj);
    }

    public static JSONObject createJSONObject() {
        return apijson.JSON.createJSONObject();
    }

    public static JSONObject createJSONObject(String key, Object value) {
        return apijson.JSON.createJSONObject(key, value);
    }

    public static JSONObject createJSONObject(Map<String, Object> map) {
        return apijson.JSON.createJSONObject(map);
    }

    public static JSONObject createJSONArray() {
        return apijson.JSON.createJSONArray();
    }

}
