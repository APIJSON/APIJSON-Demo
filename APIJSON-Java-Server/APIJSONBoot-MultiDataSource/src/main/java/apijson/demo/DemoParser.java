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

package apijson.demo;

import com.alibaba.fastjson.JSONObject;

import javax.servlet.http.HttpSession;

import apijson.RequestMethod;
import apijson.StringUtil;
import apijson.boot.DemoController;
import apijson.demo.model.Privacy;
import apijson.demo.model.User;
import apijson.framework.APIJSONObjectParser;
import apijson.framework.APIJSONParser;
import apijson.framework.APIJSONVerifier;
import apijson.orm.SQLConfig;


/**请求解析器
 * 具体见 https://github.com/Tencent/APIJSON/issues/38
 * @author Lemon
 */
public class DemoParser extends APIJSONParser<Long> {

    public DemoParser() {
        super();
    }
    public DemoParser(RequestMethod method) {
        super(method);
    }
    public DemoParser(RequestMethod method, boolean needVerify) {
        super(method, needVerify);
    }

    //	可重写来设置最大查询数量
    //	@Override
    //	public int getMaxQueryCount() {
    //		return 50;
    //	}


    @Override
    public APIJSONObjectParser createObjectParser(JSONObject request, String parentPath, SQLConfig arrayConfig
            , boolean isSubquery, boolean isTable, boolean isArrayMainTable) throws Exception {
        return new DemoObjectParser(getSession(), request, parentPath, arrayConfig
                , isSubquery, isTable, isArrayMainTable).setMethod(getMethod()).setParser(this);
    }

    // 实现应用层与数据库共用账号密码，可用于多租户、SQLAuto 等 <<<<<<<<<<<<<<<<
    private boolean asDBAccount;
    private String dbAccount;
    private String dbPassword;
    @Override
    public APIJSONParser<Long> setSession(HttpSession session) {
        Boolean asDBAccount = (Boolean) session.getAttribute(DemoController.AS_DB_ACCOUNT);
        this.asDBAccount = asDBAccount != null && asDBAccount;
        if (this.asDBAccount) {
          //User user = (User) session.getAttribute(DemoController.USER_);
          //this.dbAccount = user.getName();
          Privacy privacy = (Privacy) session.getAttribute(DemoController.PRIVACY_);
          this.dbAccount = privacy.getPhone();
          this.dbPassword = privacy.get__password();
        }

        return super.setSession(session);
    }

    @Override
    public JSONObject executeSQL(SQLConfig config, boolean isSubquery) throws Exception {
        if (asDBAccount && config instanceof DemoSQLConfig) {
          DemoSQLConfig cfg = (DemoSQLConfig) config;
          if (StringUtil.isEmpty(cfg.getDBAccount())) {
            cfg.setDBAccount(dbAccount);
          }
          if (StringUtil.isEmpty(cfg.getDBPassword())) {
            cfg.setDBPassword(dbPassword);
          }
        }
        return super.executeSQL(config, isSubquery);
    }

    // 实现应用层与数据库共用账号密码，可用于多租户、SQLAuto 等 >>>>>>>>>>>>>>>

}
