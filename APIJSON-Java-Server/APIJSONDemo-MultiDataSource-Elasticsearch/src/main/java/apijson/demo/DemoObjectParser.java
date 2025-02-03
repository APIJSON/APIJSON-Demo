package apijson.demo;

import java.util.List;

import javax.servlet.http.HttpSession;

import com.alibaba.fastjson.JSONObject;

import apijson.NotNull;
import apijson.RequestMethod;
import apijson.framework.javax.APIJSONObjectParser;
import apijson.orm.Join;
import apijson.orm.SQLConfig;

public class DemoObjectParser extends APIJSONObjectParser<Object> {
	
    public DemoObjectParser(HttpSession session, @NotNull JSONObject request, String parentPath, SQLConfig arrayConfig
            , boolean isSubquery, boolean isTable, boolean isArrayMainTable) throws Exception {
        super(session, request, parentPath, arrayConfig, isSubquery, isTable, isArrayMainTable);
    }

    @Override
    public SQLConfig newSQLConfig(RequestMethod method, String table, String alias, JSONObject request, List<Join> joinList, boolean isProcedure) throws Exception {
        return DemoSQLConfig.newSQLConfig(method, table, alias, request, joinList, isProcedure);
    }
}
