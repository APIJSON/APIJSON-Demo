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

package apijson.boot;

import apijson.orm.AbstractParser;
import apijson.orm.exception.*;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.alibaba.fastjson.serializer.ValueFilter;
import com.fasterxml.jackson.databind.util.LRUMap;
//import com.vesoft.nebula.Date;
//import com.vesoft.nebula.DateTime;
//import com.vesoft.nebula.Duration;
//import com.vesoft.nebula.Edge;
//import com.vesoft.nebula.NullType;
//import com.vesoft.nebula.Tag;
//import com.vesoft.nebula.Time;
//import com.vesoft.nebula.Value;
//import com.vesoft.nebula.Vertex;
//import com.vesoft.nebula.client.graph.data.DateTimeWrapper;
//import com.vesoft.nebula.client.graph.data.DateWrapper;
//import com.vesoft.nebula.client.graph.data.DurationWrapper;
//import com.vesoft.nebula.client.graph.data.TimeWrapper;
//import com.vesoft.nebula.client.graph.data.ValueWrapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClientResponseException;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.lang.reflect.Array;
import java.net.URLDecoder;
import java.rmi.ServerException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.*;
import java.util.Map.Entry;
import java.util.concurrent.TimeoutException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import apijson.JSON;
import apijson.JSONResponse;
import apijson.Log;
import apijson.RequestMethod;
import apijson.StringUtil;
import apijson.demo.DemoFunctionParser;
import apijson.demo.DemoParser;
import apijson.demo.DemoSQLConfig;
import apijson.demo.DemoSQLExecutor;
import apijson.demo.DemoVerifier;
import apijson.demo.model.Privacy;
import apijson.demo.model.User;
import apijson.demo.model.Verify;
import apijson.framework.BaseModel;
import apijson.orm.JSONRequest;
import apijson.orm.model.TestRecord;
import apijson.router.APIJSONRouterController;
import unitauto.MethodUtil;

import static apijson.RequestMethod.DELETE;
import static apijson.RequestMethod.GET;
import static apijson.RequestMethod.GETS;
import static apijson.RequestMethod.HEAD;
import static apijson.RequestMethod.HEADS;
import static apijson.RequestMethod.POST;
import static apijson.RequestMethod.PUT;
import static apijson.framework.APIJSONConstant.ACCESS_;
import static apijson.framework.APIJSONConstant.COUNT;
import static apijson.framework.APIJSONConstant.FORMAT;
import static apijson.framework.APIJSONConstant.FUNCTION_;
import static apijson.framework.APIJSONConstant.ID;
import static apijson.framework.APIJSONConstant.REQUEST_;
import static apijson.framework.APIJSONConstant.TEST_RECORD_;
import static apijson.framework.APIJSONConstant.USER_ID;
import static apijson.framework.APIJSONConstant.VERSION;
import static org.springframework.http.HttpHeaders.COOKIE;
import static org.springframework.http.HttpHeaders.SET_COOKIE;


/**请求路由入口控制器，包括通用增删改查接口等，转交给 APIJSON 的 Parser 来处理
 * 具体见 SpringBoot 文档
 * https://www.springcloud.cc/spring-boot.html#boot-features-spring-mvc
 * 以及 APIJSON 通用文档 3.设计规范 3.1 操作方法
 * https://github.com/Tencent/APIJSON/blob/master/Document.md#3.1
 * <br > 建议全通过HTTP POST来请求:
 * <br > 1.减少代码 - 客户端无需写HTTP GET,PUT等各种方式的请求代码
 * <br > 2.提高性能 - 无需URL encode和decode
 * <br > 3.调试方便 - 建议使用 APIAuto(http://apijson.cn/api) 或 Postman
 * @author Lemon
 */
@Service
@RestController
@RequestMapping("")
public class DemoController extends APIJSONRouterController<Long> {  // APIJSONController<Long> {
    private static final String TAG = "DemoController";

    // 可以更方便地通过日志排查错误
    @Override
    public String getRequestURL() {
        return httpServletRequest.getRequestURL().toString();
    }

    /**增删改查统一的类 RESTful API 入口，牺牲一点路由解析性能来提升一些开发效率
     * @param method
     * @param tag
     * @param params
     * @param request
     * @param session
     * @return
     */
    @PostMapping("router/{method}/{tag}")
    @Override
    public String router(@PathVariable String method, @PathVariable String tag, @RequestParam Map<String, String> params, @RequestBody String request, HttpSession session) {
        return super.router(method, tag, params, request, session);
    }

    // 通用接口，非事务型操作 和 简单事务型操作 都可通过这些接口自动化实现 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    /**全能增删改查接口，可同时进行 增、删、改、查 多种操作，
     * 通过 @method: "POST", @gets: { "Privacy":"Privacy-CIRCLE", "User": { "@role":"LOGIN", "tag":"User" } } 等关键词指定
     * @param request
     * @param session
     * @return
     */
    @PostMapping(value = "crud")  // 直接 {method} 或 apijson/{method} 会和内置网页的路由有冲突
    // @Override
    public String crudAll(@RequestBody String request, HttpSession session) {
        return newParser(session, RequestMethod.CRUD).parse(request);
    }
    /**增删改查统一入口，这个一个方法可替代以下 7 个方法，牺牲一点路由解析性能来提升一些开发效率
     * @param method
     * @param request
     * @param session
     * @return
     */
    @PostMapping(value = "crud/{method}")  // 直接 {method} 或 apijson/{method} 会和内置网页的路由有冲突
    @Override
    public String crud(@PathVariable String method, @RequestBody String request, HttpSession session) {
        return super.crud(method, request, session);
    }

    /**获取
     * @param request 只用String，避免encode后未decode
     * @param session
     * @return
     * @see {@link RequestMethod#GET}
     */
    @PostMapping(value = "get")
    @Override
    public String get(@RequestBody String request, HttpSession session) {
        return super.get(request, session);
    }

    /**计数
     * @param request 只用String，避免encode后未decode
     * @param session
     * @return
     * @see {@link RequestMethod#HEAD}
     */
    @PostMapping("head")
    @Override
    public String head(@RequestBody String request, HttpSession session) {
        return super.head(request, session);
    }

    /**限制性GET，request和response都非明文，浏览器看不到，用于对安全性要求高的GET请求
     * @param request 只用String，避免encode后未decode
     * @param session
     * @return
     * @see {@link RequestMethod#GETS}
     */
    @PostMapping("gets")
    @Override
    public String gets(@RequestBody String request, HttpSession session) {
        return super.gets(request, session);
    }

    /**限制性HEAD，request和response都非明文，浏览器看不到，用于对安全性要求高的HEAD请求
     * @param request 只用String，避免encode后未decode
     * @param session
     * @return
     * @see {@link RequestMethod#HEADS}
     */
    @PostMapping("heads")
    @Override
    public String heads(@RequestBody String request, HttpSession session) {
        return super.heads(request, session);
    }

    /**新增
     * @param request 只用String，避免encode后未decode
     * @param session
     * @return
     * @see {@link RequestMethod#POST}
     */
    @PostMapping("post")
    @Override
    public String post(@RequestBody String request, HttpSession session) {
        return super.post(request, session);
    }

    /**修改
     * @param request 只用String，避免encode后未decode
     * @param session
     * @return
     * @see {@link RequestMethod#PUT}
     */
    @PostMapping("put")
    @Override
    public String put(@RequestBody String request, HttpSession session) {
        return super.put(request, session);
    }

    /**删除
     * @param request 只用String，避免encode后未decode
     * @param session
     * @return
     * @see {@link RequestMethod#DELETE}
     */
    @PostMapping("delete")
    @Override
    public String delete(@RequestBody String request, HttpSession session) {
        return super.delete(request, session);
    }

    // 通用接口，非事务型操作 和 简单事务型操作 都可通过这些接口自动化实现  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    // 以上接口对应的简版接口，格式为 {method}/{tag}?format=true&@explain=true.. <<<<<<<<<<<<<<<<<<<<<<<<<

    /**增删改查统一接口，这个一个接口可替代 7 个万能通用接口，牺牲一些路由解析性能来提升一点开发效率
     * @param method
     * @param tag
     * @param params
     * @param request
     * @param session
     * @return
     */
    @PostMapping("crud/{method}/{tag}")  // 直接 {method}/{tag} 或 apijson/{method}/{tag} 会和内置网页的路由有冲突
    @Override
    public String crudByTag(@PathVariable String method, @PathVariable String tag, @RequestParam Map<String, String> params, @RequestBody String request, HttpSession session) {
        return super.crudByTag(method, tag, params, request, session);
    }

    /**获取
     * @param request 只用String，避免encode后未decode
     * @param session
     * @return
     * @see {@link RequestMethod#GET}
     */
    @PostMapping("get/{tag}")  // 虽然看起来 APIAuto 更好识别是否为 APIJSON 万能接口，但 tag 导致空格截断前 Host 不固定不方便批量测试  {tag}/get")
    @Override
    public String getByTag(@PathVariable String tag, @RequestParam Map<String, String> params, @RequestBody String request, HttpSession session) {
        return super.getByTag(tag, params, request, session);
    }

    /**计数
     * @param request 只用String，避免encode后未decode
     * @param session
     * @return
     * @see {@link RequestMethod#HEAD}
     */
    @PostMapping("head/{tag}")
    @Override
    public String headByTag(@PathVariable String tag, @RequestParam Map<String, String> params, @RequestBody String request, HttpSession session) {
        return super.headByTag(tag, params, request, session);
    }

    /**限制性GET，request和response都非明文，浏览器看不到，用于对安全性要求高的GET请求
     * @param request 只用String，避免encode后未decode
     * @param session
     * @return
     * @see {@link RequestMethod#GETS}
     */
    @PostMapping("gets/{tag}")
    @Override
    public String getsByTag(@PathVariable String tag, @RequestParam Map<String, String> params, @RequestBody String request, HttpSession session) {
        return super.getsByTag(tag, params, request, session);
    }

    /**限制性HEAD，request和response都非明文，浏览器看不到，用于对安全性要求高的HEAD请求
     * @param request 只用String，避免encode后未decode
     * @param session
     * @return
     * @see {@link RequestMethod#HEADS}
     */
    @PostMapping("heads/{tag}")
    @Override
    public String headsByTag(@PathVariable String tag, @RequestParam Map<String, String> params, @RequestBody String request, HttpSession session) {
        return super.headsByTag(tag, params, request, session);
    }

    /**新增
     * @param request 只用String，避免encode后未decode
     * @param session
     * @return
     * @see {@link RequestMethod#POST}
     */
    @PostMapping("post/{tag}")
    @Override
    public String postByTag(@PathVariable String tag, @RequestParam Map<String, String> params, @RequestBody String request, HttpSession session) {
        return super.postByTag(tag, params, request, session);
    }

    /**修改
     * @param request 只用String，避免encode后未decode
     * @param session
     * @return
     * @see {@link RequestMethod#PUT}
     */
    @PostMapping("put/{tag}")
    @Override
    public String putByTag(@PathVariable String tag, @RequestParam Map<String, String> params, @RequestBody String request, HttpSession session) {
        return super.putByTag(tag, params, request, session);
    }

    /**删除
     * @param request 只用String，避免encode后未decode
     * @param session
     * @return
     * @see {@link RequestMethod#DELETE}
     */
    @PostMapping("delete/{tag}")
    @Override
    public String deleteByTag(@PathVariable String tag, @RequestParam Map<String, String> params, @RequestBody String request, HttpSession session) {
        return super.deleteByTag(tag, params, request, session);
    }

    // 以上接口对应的简版接口，格式为 {method}/{tag}?format=true&@explain=true..  >>>>>>>>>>>>>>>>>>>>>>>>>




    /**获取
     * 只为兼容HTTP GET请求，推荐用HTTP POST，可删除
     * @param request 只用String，避免encode后未decode
     * @param session
     * @return
     * @see {@link RequestMethod#GET}
     */
    @GetMapping("get/{request}")
    public String openGet(@PathVariable String request, HttpSession session) {
        try {
            request = URLDecoder.decode(request, StringUtil.UTF_8);
        } catch (Exception e) {
            // Parser会报错
        }
        return get(request, session);
    }

    /**计数
     * 只为兼容HTTP GET请求，推荐用HTTP POST，可删除
     * @param request 只用String，避免encode后未decode
     * @param session
     * @return
     * @see {@link RequestMethod#HEAD}
     */
    @GetMapping("head/{request}")
    public String openHead(@PathVariable String request, HttpSession session) {
        try {
            request = URLDecoder.decode(request, StringUtil.UTF_8);
        } catch (Exception e) {
            // Parser会报错
        }
        return head(request, session);
    }


    //通用接口，非事务型操作 和 简单事务型操作 都可通过这些接口自动化实现>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>










    public static final String USER_;
    public static final String PRIVACY_;
    public static final String VERIFY_; //加下划线后缀是为了避免 Verify 和 verify 都叫VERIFY，分不清
    static {
        USER_ = User.class.getSimpleName();
        PRIVACY_ = Privacy.class.getSimpleName();
        VERIFY_ = Verify.class.getSimpleName();
    }



    public static final String CURRENT_USER_ID = "currentUserId";
    public static final String NAME = "name";
    public static final String PHONE = "phone";
    public static final String PASSWORD = "password";
    public static final String _PASSWORD = "_password";
    public static final String _PAY_PASSWORD = "_payPassword";
    public static final String OLD_PASSWORD = "oldPassword";
    public static final String VERIFY = "verify";

    public static final String TYPE = "type";
    public static final String VALUE = "value";



    /**重新加载配置
     * @param request
     * @return
     * @see
     * <pre>
    {
    "type": "ALL",  //重载对象，ALL, FUNCTION, REQUEST, ACCESS，非必须
    "phone": "13000082001",
    "verify": "1234567", //验证码，对应类型为 Verify.TYPE_RELOAD
    "value": {  // 自定义增量更新条件
    "id": 1  // 过滤条件，符合 APIJSON 查询功能符即可
    }
    }
     * </pre>
     */
    @PostMapping("reload")
    @Override
    public JSONObject reload(@RequestBody String request) {
        JSONObject requestObject = null;
        String type;
        JSONObject value;
        String phone;
        String verify;
        try {
            requestObject = DemoParser.parseRequest(request);
            type = requestObject.getString(TYPE);
            value = requestObject.getJSONObject(VALUE);
            phone = requestObject.getString(PHONE);
            verify = requestObject.getString(VERIFY);
        } catch (Exception e) {
            return DemoParser.extendErrorResult(requestObject, e);
        }

        JSONResponse response = new JSONResponse(headVerify(Verify.TYPE_RELOAD, phone, verify));
        response = response.getJSONResponse(VERIFY_);
        if (JSONResponse.isExist(response) == false) {
            return DemoParser.extendErrorResult(requestObject, new ConditionErrorException("手机号或验证码错误"));
        }

        JSONObject result = DemoParser.newSuccessResult();

        boolean reloadAll = StringUtil.isEmpty(type, true) || "ALL".equals(type);

        if (reloadAll || "ACCESS".equals(type)) {
            try {
                result.put(ACCESS_, DemoVerifier.initAccess(false, null, value));
            } catch (ServerException e) {
                e.printStackTrace();
                result.put(ACCESS_, DemoParser.newErrorResult(e));
            }
        }

        if (reloadAll || "FUNCTION".equals(type)) {
            try {
                result.put(FUNCTION_, DemoFunctionParser.init(false, null, value));
            } catch (ServerException e) {
                e.printStackTrace();
                result.put(FUNCTION_, DemoParser.newErrorResult(e));
            }
        }

        if (reloadAll || "REQUEST".equals(type)) {
            try {
                result.put(REQUEST_, DemoVerifier.initRequest(false, null, value));
            } catch (ServerException e) {
                e.printStackTrace();
                result.put(REQUEST_, DemoParser.newErrorResult(e));
            }
        }

        return result;
    }

    /**生成验证码,修改为post请求
     * @param request
     * @see
     * <pre>
    {
    "type": 0,  //类型，0,1,2,3,4，非必须
    "phone": "13000082001"
    }
     * </pre>
     */
    @PostMapping("post/verify")
    public JSONObject postVerify(@RequestBody String request) {
        JSONObject requestObject = null;
        int type;
        String phone;
        try {
            requestObject = DemoParser.parseRequest(request);
            type = requestObject.getIntValue(TYPE);
            phone = requestObject.getString(PHONE);
        } catch (Exception e) {
            return DemoParser.extendErrorResult(requestObject, e);
        }

        new DemoParser(DELETE, false).parse(newVerifyRequest(type, phone, null));

        JSONObject response = new DemoParser(POST, false).parseResponse(
                newVerifyRequest(type, phone, "" + (new Random().nextInt(9999) + 1000))
        );


        if (JSONResponse.isSuccess(response) == false) {
            new DemoParser(DELETE, false).parseResponse(new JSONRequest(new Verify(type, phone)));
            return response;
        }

        //TODO 这里直接返回验证码，方便测试。实际上应该只返回成功信息，验证码通过短信发送
        JSONObject object = new JSONObject();
        object.put(TYPE, type);
        object.put(PHONE, phone);
        return getVerify(JSON.toJSONString(object));
    }

    /**获取验证码
     * @param request
     * @see
     * <pre>
    {
    "type": 0,  //类型，0,1,2,3,4，非必须
    "phone": "13000082001"
    }
     * </pre>
     */
    @PostMapping("gets/verify")
    public JSONObject getVerify(@RequestBody String request) {
        JSONObject requestObject = null;
        int type;
        String phone;
        try {
            requestObject = DemoParser.parseRequest(request);
            type = requestObject.getIntValue(TYPE);
            phone = requestObject.getString(PHONE);
        } catch (Exception e) {
            return DemoParser.extendErrorResult(requestObject, e);
        }
        return new DemoParser(GETS, false).parseResponse(newVerifyRequest(type, phone, null));
    }

    /**校验验证码
     * @param request
     * @see
     * <pre>
    {
    "type": 0,  //类型，0,1,2,3,4，非必须
    "phone": "13000082001",
    "verify": "123456"
    }
     * </pre>
     */
    @PostMapping("heads/verify")
    public JSONObject headVerify(@RequestBody String request) {
        JSONObject requestObject = null;
        int type;
        String phone;
        String verify;
        try {
            requestObject = DemoParser.parseRequest(request);
            type = requestObject.getIntValue(TYPE);
            phone = requestObject.getString(PHONE);
            verify = requestObject.getString(VERIFY);
        } catch (Exception e) {
            return DemoParser.extendErrorResult(requestObject, e);
        }
        return headVerify(type, phone, verify);
    }

    /**校验验证码
     * @author Lemon
     * @param type
     * @param phone
     * @param code
     * @return
     */
    public JSONObject headVerify(int type, String phone, String code) {
        JSONResponse response = new JSONResponse(
                new DemoParser(GETS, false).parseResponse(
                        new JSONRequest(
                                new Verify(type, phone)
                                        .setVerify(code)
                        ).setTag(VERIFY_)
                )
        );
        Verify verify = response.getObject(Verify.class);
        if (verify == null) {
            return DemoParser.newErrorResult(StringUtil.isEmpty(code, true)
                    ? new NotExistException("验证码不存在！") : new ConditionErrorException("手机号或验证码错误！"));
        }

        //验证码过期
        long time = BaseModel.getTimeMillis(verify.getDate());
        long now = System.currentTimeMillis();
        if (now > 60*1000 + time) {
            new DemoParser(DELETE, false).parseResponse(
                    new JSONRequest(new Verify(type, phone)).setTag(VERIFY_)
            );
            return DemoParser.newErrorResult(new TimeoutException("验证码已过期！"));
        }

        return new JSONResponse(
                new DemoParser(HEADS, false).parseResponse(
                        new JSONRequest(new Verify(type, phone).setVerify(code)).setFormat(true)
                )
        );
    }



    /**新建一个验证码请求
     * @param phone
     * @param verify
     * @return
     */
    private apijson.JSONRequest newVerifyRequest(int type, String phone, String verify) {
        return new JSONRequest(new Verify(type, phone).setVerify(verify)).setTag(VERIFY_).setFormat(true);
    }


    public static final String LOGIN = "login";
    public static final String AS_DB_ACCOUNT = "asDBAccount";
    public static final String REMEMBER = "remember";
    public static final String DEFAULTS = "defaults";

    public static final int LOGIN_TYPE_PASSWORD = 0;//密码登录
    public static final int LOGIN_TYPE_VERIFY = 1;//验证码登录
    /**用户登录
     * @param request 只用String，避免encode后未decode
     * @return
     * @see
     * <pre>
    {
    "type": 0,  //登录方式，非必须  0-密码 1-验证码
    "phone": "13000082001",
    "password": "1234567",
    "version": 1 //全局版本号，非必须
    }
     * </pre>
     */
    @PostMapping(LOGIN)  //TODO 改 SQLConfig 里的 dbAccount, dbPassword，直接用数据库鉴权
    public JSONObject login(@RequestBody String request, HttpSession session) {
        JSONObject requestObject = null;
        boolean isPassword;
        String phone;
        String password;
        int version;
        Boolean format;
        boolean remember;
        Boolean asDBAccount;
        JSONObject defaults;
        try {
            requestObject = DemoParser.parseRequest(request);

            isPassword = requestObject.getIntValue(TYPE) == LOGIN_TYPE_PASSWORD;//登录方式
            phone = requestObject.getString(PHONE);//手机
            password = requestObject.getString(PASSWORD);//密码

            if (StringUtil.isPhone(phone) == false) {
                throw new IllegalArgumentException("手机号不合法！");
            }

            if (isPassword) {
                if (StringUtil.isPassword(password) == false) {
                    throw new IllegalArgumentException("密码不合法！");
                }
            } else {
                if (StringUtil.isVerify(password) == false) {
                    throw new IllegalArgumentException("验证码不合法！");
                }
            }

            version = requestObject.getIntValue(VERSION);
            format = requestObject.getBoolean(FORMAT);
            remember = requestObject.getBooleanValue(REMEMBER);
            asDBAccount = requestObject.getBoolean(AS_DB_ACCOUNT);
            defaults = requestObject.getJSONObject(DEFAULTS); //默认加到每个请求最外层的字段
            requestObject.remove(VERSION);
            requestObject.remove(FORMAT);
            requestObject.remove(REMEMBER);
            requestObject.remove(DEFAULTS);
        } catch (Exception e) {
            return DemoParser.extendErrorResult(requestObject, e);
        }


        //手机号是否已注册
        JSONObject phoneResponse = new DemoParser(HEADS, false).parseResponse(
                new JSONRequest(
                        new Privacy().setPhone(phone)
                )
        );
        if (JSONResponse.isSuccess(phoneResponse) == false) {
            return DemoParser.newResult(phoneResponse.getIntValue(JSONResponse.KEY_CODE), phoneResponse.getString(JSONResponse.KEY_MSG));
        }
        JSONResponse response = new JSONResponse(phoneResponse).getJSONResponse(PRIVACY_);
        if(JSONResponse.isExist(response) == false) {
            return DemoParser.newErrorResult(new NotExistException("手机号未注册"));
        }

        //根据phone获取User
        JSONObject privacyResponse = new DemoParser(GETS, false).parseResponse(
                new JSONRequest(
                        new Privacy().setPhone(phone)
                ).setFormat(true)
        );
        response = new JSONResponse(privacyResponse);

        Privacy privacy = response == null ? null : response.getObject(Privacy.class);
        long userId = privacy == null ? 0 : BaseModel.value(privacy.getId());
        if (userId <= 0) {
            return privacyResponse;
        }

        //校验凭证
        if (isPassword) { //password 密码登录
            response = new JSONResponse(
                    new DemoParser(HEADS, false).parseResponse(
                            new JSONRequest(new Privacy(userId).setPassword(password))
                    )
            );
        } else {//verify手机验证码登录
            response = new JSONResponse(headVerify(Verify.TYPE_LOGIN, phone, password));
        }
        if (JSONResponse.isSuccess(response) == false) {
            return response;
        }
        response = response.getJSONResponse(isPassword ? PRIVACY_ : VERIFY_);
        if (JSONResponse.isExist(response) == false) {
            return DemoParser.newErrorResult(new ConditionErrorException("账号或密码错误"));
        }

        response = new JSONResponse(
                new DemoParser(GETS, false).parseResponse(
                        new JSONRequest(  // 兼容 MySQL 5.6 及以下等不支持 json 类型的数据库
                                USER_,  // User 里在 setContactIdList(List<Long>) 后加 setContactIdList(String) 没用
                                new apijson.JSONObject(  // fastjson 查到一个就不继续了，所以只能加到前面或者只有这一个，但这样反过来不兼容 5.7+
                                        new User(userId)  // 所以就用 @json 来强制转为 JSONArray，保证有效
                                ).setJson("contactIdList,pictureList")
                        ).setFormat(true)
                )
        );
        User user = response.getObject(User.class);
        if (user == null || BaseModel.value(user.getId()) != userId) {
            return DemoParser.newErrorResult(new NullPointerException("服务器内部错误"));
        }

        //登录状态保存至session
        super.login(session, user, version, format, defaults);
        session.setAttribute(USER_ID, userId); //用户id
        session.setAttribute(TYPE, isPassword ? LOGIN_TYPE_PASSWORD : LOGIN_TYPE_VERIFY); //登录方式
        session.setAttribute(USER_, user); //用户
        session.setAttribute(PRIVACY_, privacy); //用户隐私信息
        session.setAttribute(REMEMBER, remember); //是否记住登录
        session.setAttribute(AS_DB_ACCOUNT, asDBAccount); //是否作为数据库账号密码
        session.setMaxInactiveInterval(60*60*24*(remember ? 7 : 1)); //设置session过期时间

        response.put(REMEMBER, remember);
        response.put(DEFAULTS, defaults);
        return response;
    }

    /**退出登录，清空session
     * @param session
     * @return
     */
    @PostMapping("logout")
    @Override
    public JSONObject logout(HttpSession session) {
        SESSION_MAP.remove(session.getId());

        Long userId;
        try {
            userId = DemoVerifier.getVisitorId(session);//必须在session.invalidate();前！
            Log.d(TAG, "logout  userId = " + userId + "; session.getId() = " + (session == null ? null : session.getId()));
            super.logout(session);
        } catch (Exception e) {
            return DemoParser.newErrorResult(e);
        }

        JSONObject result = DemoParser.newSuccessResult();
        JSONObject user = DemoParser.newSuccessResult();
        user.put(ID, userId);
        user.put(COUNT, 1);
        result.put(StringUtil.firstCase(USER_), user);

        return result;
    }


    private static final String REGISTER = "register";
    /**注册
     * @param request 只用String，避免encode后未decode
     * @return
     * @see
     * <pre>
    {
    "Privacy": {
    "phone": "13000082222",
    "_password": "123456"
    },
    "User": {
    "name": "APIJSONUser"
    },
    "verify": "1234"
    }
     * </pre>
     */
    @PostMapping(REGISTER)
    public JSONObject register(@RequestBody String request) {
        JSONObject requestObject = null;

        JSONObject privacyObj;

        String phone;
        String verify;
        String password;
        try {
            requestObject = DemoParser.parseRequest(request);
            privacyObj = requestObject.getJSONObject(PRIVACY_);

            phone = StringUtil.getString(privacyObj.getString(PHONE));
            verify = requestObject.getString(VERIFY);
            password = privacyObj.getString(_PASSWORD);

            if (StringUtil.isPhone(phone) == false) {
                return newIllegalArgumentResult(requestObject, PRIVACY_ + "/" + PHONE);
            }
            if (StringUtil.isPassword(password) == false) {
                return newIllegalArgumentResult(requestObject, PRIVACY_ + "/" + _PASSWORD);
            }
            if (StringUtil.isVerify(verify) == false) {
                return newIllegalArgumentResult(requestObject, VERIFY);
            }
        } catch (Exception e) {
            return DemoParser.extendErrorResult(requestObject, e);
        }


        JSONResponse response = new JSONResponse(headVerify(Verify.TYPE_REGISTER, phone, verify));
        if (JSONResponse.isSuccess(response) == false) {
            return response;
        }
        //手机号或验证码错误
        if (JSONResponse.isExist(response.getJSONResponse(VERIFY_)) == false) {
            return DemoParser.extendErrorResult(response, new ConditionErrorException("手机号或验证码错误！"));
        }



        //生成User和Privacy
        if (StringUtil.isEmpty(requestObject.getString(JSONRequest.KEY_TAG), true)) {
            requestObject.put(JSONRequest.KEY_TAG, REGISTER);
        }
        requestObject.put(JSONRequest.KEY_FORMAT, true);
        response = new JSONResponse(
                new DemoParser(POST).setNeedVerifyLogin(false).parseResponse(requestObject)
        );

        //验证User和Privacy
        User user = response.getObject(User.class);
        long userId = user == null ? 0 : BaseModel.value(user.getId());
        Privacy privacy = response.getObject(Privacy.class);
        long userId2 = privacy == null ? 0 : BaseModel.value(privacy.getId());
        Exception e = null;
        if (userId <= 0 || userId != userId2) { //id不同
            e = new Exception("服务器内部错误！写入User或Privacy失败！");
        }

        if (e != null) { //出现错误，回退
            new DemoParser(DELETE, false).parseResponse(
                    new JSONRequest(new User(userId))
            );
            new DemoParser(DELETE, false).parseResponse(
                    new JSONRequest(new Privacy(userId2))
            );
        }

        return response;
    }


    /**
     * @param requestObject
     * @param key
     * @return
     */
    public static JSONObject newIllegalArgumentResult(JSONObject requestObject, String key) {
        return newIllegalArgumentResult(requestObject, key, null);
    }
    /**
     * @param requestObject
     * @param key
     * @param msg 详细说明
     * @return
     */
    public static JSONObject newIllegalArgumentResult(JSONObject requestObject, String key, String msg) {
        return DemoParser.extendErrorResult(requestObject
                , new IllegalArgumentException(key + ":value 中value不合法！" + StringUtil.getString(msg)));
    }


    /**设置密码
     * @param request 只用String，避免encode后未decode
     * @return
     * @see
     * <pre>
    使用旧密码修改
    {
    "oldPassword": 123456,
    "Privacy":{
    "id": 13000082001,
    "_password": "1234567"
    }
    }
    或使用手机号+验证码修改
    {
    "verify": "1234",
    "Privacy":{
    "phone": "13000082001",
    "_password": "1234567"
    }
    }
     * </pre>
     */
    @PostMapping("put/password")
    public JSONObject putPassword(@RequestBody String request){
        JSONObject requestObject = null;
        String oldPassword;
        String verify;

        int type = Verify.TYPE_PASSWORD;

        JSONObject privacyObj;
        long userId;
        String phone;
        String password;
        try {
            requestObject = DemoParser.parseRequest(request);
            oldPassword = StringUtil.getString(requestObject.getString(OLD_PASSWORD));
            verify = StringUtil.getString(requestObject.getString(VERIFY));

            requestObject.remove(OLD_PASSWORD);
            requestObject.remove(VERIFY);

            privacyObj = requestObject.getJSONObject(PRIVACY_);
            if (privacyObj == null) {
                throw new IllegalArgumentException(PRIVACY_ + " 不能为空！");
            }
            userId = privacyObj.getLongValue(ID);
            phone = privacyObj.getString(PHONE);
            password = privacyObj.getString(_PASSWORD);

            if (StringUtil.isEmpty(password, true)) { //支付密码
                type = Verify.TYPE_PAY_PASSWORD;
                password = privacyObj.getString(_PAY_PASSWORD);
                if (StringUtil.isNumberPassword(password) == false) {
                    throw new IllegalArgumentException(PRIVACY_ + "/" + _PAY_PASSWORD + ":value 中value不合法！");
                }
            } else { //登录密码
                if (StringUtil.isPassword(password) == false) {
                    throw new IllegalArgumentException(PRIVACY_ + "/" + _PASSWORD + ":value 中value不合法！");
                }
            }
        } catch (Exception e) {
            return DemoParser.extendErrorResult(requestObject, e);
        }


        if (StringUtil.isPassword(oldPassword)) {
            if (userId <= 0) { //手机号+验证码不需要userId
                return DemoParser.extendErrorResult(requestObject, new IllegalArgumentException(ID + ":value 中value不合法！"));
            }
            if (oldPassword.equals(password)) {
                return DemoParser.extendErrorResult(requestObject, new ConflictException("新旧密码不能一样！"));
            }

            //验证旧密码
            Privacy privacy = new Privacy(userId);
            if (type == Verify.TYPE_PASSWORD) {
                privacy.setPassword(oldPassword);
            } else {
                privacy.setPayPassword(oldPassword);
            }
            JSONResponse response = new JSONResponse(
                    new DemoParser(HEAD, false).parseResponse(
                            new JSONRequest(privacy).setFormat(true)
                    )
            );
            if (JSONResponse.isExist(response.getJSONResponse(PRIVACY_)) == false) {
                return DemoParser.extendErrorResult(requestObject, new ConditionErrorException("账号或原密码错误，请重新输入！"));
            }
        }
        else if (StringUtil.isPhone(phone) && StringUtil.isVerify(verify)) {
            JSONResponse response = new JSONResponse(headVerify(type, phone, verify));
            if (JSONResponse.isSuccess(response) == false) {
                return response;
            }
            if (JSONResponse.isExist(response.getJSONResponse(VERIFY_)) == false) {
                return DemoParser.extendErrorResult(response, new ConditionErrorException("手机号或验证码错误！"));
            }
            response = new JSONResponse(
                    new DemoParser(GET, false).parseResponse(
                            new JSONRequest(
                                    new Privacy().setPhone(phone)
                            )
                    )
            );
            Privacy privacy = response.getObject(Privacy.class);
            long id = privacy == null ? 0 : BaseModel.value(privacy.getId());
            privacyObj.remove(PHONE);
            privacyObj.put(ID, id);

            requestObject.put(PRIVACY_, privacyObj);
        } else {
            return DemoParser.extendErrorResult(requestObject, new IllegalArgumentException("请输入合法的 旧密码 或 手机号+验证码 ！"));
        }
        //TODO 上线版加上   password = MD5Util.MD5(password);


        //		requestObject.put(JSONRequest.KEY_TAG, "Password");
        requestObject.put(JSONRequest.KEY_FORMAT, true);
        //修改密码
        return new DemoParser(PUT, false).parseResponse(requestObject);
    }



    /**充值/提现
     * @param request 只用String，避免encode后未decode
     * @param session
     * @return
     * @see
     * <pre>
    {
    "Privacy": {
    "id": 82001,
    "balance+": 100,
    "_payPassword": "123456"
    }
    }
     * </pre>
     */
    @PostMapping("put/balance")
    public JSONObject putBalance(@RequestBody String request, HttpSession session) {
        JSONObject requestObject = null;
        JSONObject privacyObj;
        long userId;
        String payPassword;
        double change;
        try {
            DemoVerifier.verifyLogin(session);
            requestObject = new DemoParser(PUT).setTag(PRIVACY_).setRequest(DemoParser.parseRequest(request)).parseCorrectRequest();

            privacyObj = requestObject.getJSONObject(PRIVACY_);
            if (privacyObj == null) {
                throw new NullPointerException("请设置 " + PRIVACY_ + "！");
            }
            userId = privacyObj.getLongValue(ID);
            payPassword = privacyObj.getString(_PAY_PASSWORD);
            change = privacyObj.getDoubleValue("balance+");

            if (userId <= 0) {
                throw new IllegalArgumentException(PRIVACY_ + "." + ID + ":value 中value不合法！");
            }
            if (StringUtil.isPassword(payPassword) == false) {
                throw new IllegalArgumentException(PRIVACY_ + "." + _PAY_PASSWORD + ":value 中value不合法！");
            }
        } catch (Exception e) {
            return DemoParser.extendErrorResult(requestObject, e);
        }

        //验证密码<<<<<<<<<<<<<<<<<<<<<<<

        privacyObj.remove("balance+");
        JSONResponse response = new JSONResponse(
                new DemoParser(HEADS, false).setSession(session).parseResponse(
                        new JSONRequest(PRIVACY_, privacyObj)
                )
        );
        response = response.getJSONResponse(PRIVACY_);
        if (JSONResponse.isExist(response) == false) {
            return DemoParser.extendErrorResult(requestObject, new ConditionErrorException("支付密码错误！"));
        }

        //验证密码>>>>>>>>>>>>>>>>>>>>>>>>


        //验证金额范围<<<<<<<<<<<<<<<<<<<<<<<

        if (change == 0) {
            return DemoParser.extendErrorResult(requestObject, new OutOfRangeException("balance+的值不能为0！"));
        }
        if (Math.abs(change) > 10000) {
            return DemoParser.extendErrorResult(requestObject, new OutOfRangeException("单次 充值/提现 的金额不能超过10000元！"));
        }

        //验证金额范围>>>>>>>>>>>>>>>>>>>>>>>>

        if (change < 0) {//提现
            response = new JSONResponse(
                    new DemoParser(GETS, false).parseResponse(
                            new JSONRequest(
                                    new Privacy(userId)
                            )
                    )
            );
            Privacy privacy = response == null ? null : response.getObject(Privacy.class);
            long id = privacy == null ? 0 : BaseModel.value(privacy.getId());
            if (id != userId) {
                return DemoParser.extendErrorResult(requestObject, new Exception("服务器内部错误！"));
            }

            if (BaseModel.value(privacy.getBalance()) < -change) {
                return DemoParser.extendErrorResult(requestObject, new OutOfRangeException("余额不足！"));
            }
        }


        privacyObj.remove(_PAY_PASSWORD);
        privacyObj.put("balance+", change);
        requestObject.put(PRIVACY_, privacyObj);
        requestObject.put(JSONRequest.KEY_TAG, PRIVACY_);
        requestObject.put(JSONRequest.KEY_FORMAT, true);
        //不免验证，里面会验证身份
        return new DemoParser(PUT).setSession(session).parseResponse(requestObject);
    }



    // 为 APIAuto 提供的代理接口(解决跨域问题) 和 导入第三方文档的测试接口 https://github.com/TommyLemon/APIAuto  <<<<<<<<<<<<<<<<<<<<<<<<<<<

    public static class SessionMap extends LRUMap<String, HttpSession> {
        public SessionMap() {
            super(16, 1000000);
        }
        public void remove(String key) {
            _map.remove(key);
        }
    }

    public static final SessionMap SESSION_MAP;

    public static final String ADD_COOKIE = "Add-Cookie";
    public static final String APIJSON_DELEGATE_ID = "Apijson-Delegate-Id";  // 有些 Web 框架会强制把全大写改为全小写或大驼峰
    public static final List<String> EXCEPT_HEADER_LIST;
    static {
        SESSION_MAP = new SessionMap();

        EXCEPT_HEADER_LIST = Arrays.asList(  //accept-encoding 在某些情况下导致乱码，origin 和 sec-fetch-mode 等 CORS 信息导致服务器代理失败
                "accept-encoding", "accept-language", "content-length", "dnt", // "accept", "connection"
                "host", "origin", "referer", "user-agent", "sec-fetch-mode", "sec-fetch-site", "sec-fetch-dest", "sec-fetch-user"
        );
    }

    public static final int REQUEST_RECORD_TYPE_NULL = 0;
    public static final int REQUEST_RECORD_TYPE_API = 1;
    public static final int REQUEST_RECORD_TYPE_UNIT = 2;
    public static final int REQUEST_RECORD_TYPE_SQL = 3;

    public static Integer REQUEST_RECORD_TYPE = 0;

    @Autowired
    HttpServletRequest httpServletRequest;
    @Autowired
    HttpServletResponse httpServletResponse;

    /**代理接口，解决前端（APIAuto等）跨域问题
     * @param rawUrl 被代理的 url
     * @param type 请求类型
     * @param headerStr 指定请求头
     * @param exceptHeaders 排除请求头
     * @param sessionId HTTP Session ID
     * @param record 录制类型，方便生成 APIAuto/UnitAuto/SQLAuto 文档，流量回放等：0-不录制；1 - 录制 API；2 - 录制 Unit；3 - 录制 SQL；-1 - 回放 API；-2 - 回放 Unit；-3 - 回放 SQL
     * @param body POST Body
     * @param method HTTP Method
     * @param session HTTP Session
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping(value = "delegate")
    public String delegate(
            @RequestParam("$_delegate_url") String rawUrl,
            @RequestParam(value = "$_type", required = false) String type,
            @RequestParam(value = "$_headers", required = false) String headerStr,
            @RequestParam(value = "$_except_headers", required = false) String exceptHeaders,
            @RequestParam(value = "$_delegate_id", required = false) String sessionId,
            @RequestParam(value = "$_record", required = false) Integer record,
            @RequestBody(required = false) String body,
            HttpMethod method, HttpSession session
    ) {
        if (Log.DEBUG == false) {
            return DemoParser.newErrorResult(new IllegalAccessException("非 DEBUG 模式下不允许使用服务器代理！")).toJSONString();
        }

        int recordType = record != null ? record : (REQUEST_RECORD_TYPE != null ? REQUEST_RECORD_TYPE : 0);
        boolean isSQL = Math.abs(recordType) == REQUEST_RECORD_TYPE_SQL;
        boolean isUnit = Math.abs(recordType) == REQUEST_RECORD_TYPE_UNIT;

        String url = rawUrl;
        if ("GRPC".equals(type)) {
            int index = url.indexOf("://");
            String endpoint = index < 0 ? url : url.substring(index + 3);

            index = endpoint.indexOf("/");
            String remoteMethod = index < 0 ? "" : endpoint.substring(index);

            url = "http://localhost:50050" + remoteMethod;

            JSONObject obj = JSON.parseObject(body);
            if (obj == null) {
                obj = new JSONObject(true);
            }
            if (obj.get("endpoint") == null) {
                endpoint = index < 0 ? endpoint : endpoint.substring(0, index);
                obj.put("endpoint", endpoint);
            }

            body = obj.toJSONString();
        }
        else if ("PARAM".equals(type) || "FORM".equals(type)) {
            body = null; // 居然把 GET param 和 POST form 的也取到
        }
        else if (body != null && "DATA".equals(type)) { // if (StringUtil.isNotEmpty(body, true)) {
            int index = body.indexOf("%24_type=");
            if (index < 0) {
                index = body.indexOf("$_type=");
            }
            if (index < 0) {
                index = body.indexOf("%24_record=");
            }
            if (index < 0) {
                index = body.indexOf("$_record=");
            }
            if (index < 0) {
                index = body.indexOf("%24_delegate_id=");
            }
            if (index < 0) {
                index = body.indexOf("$_delegate_id=");
            }
            if (index < 0) {
                index = body.indexOf("%24_delegate_url=");
            }
            if (index < 0) {
                index = body.indexOf("$_delegate_url=");
            }
            if (index < 0) {
                index = body.indexOf("%24_headers=");
            }
            if (index < 0) {
                index = body.indexOf("$_headers=");
            }
            if (index < 0) {
                index = body.indexOf("%24_except_headers=");
            }
            if (index < 0) {
                index = body.indexOf("$_except_headers=");
            }

            if (index >= 0) {
                body = body.substring(0, index);
            }
        }

        Enumeration<String> names = httpServletRequest.getHeaderNames();
        HttpHeaders headers = null;
        String hs = ""; // 里面带一个多余的 Apijson-Delegate-Id，尤其 SQLAuto 必须排除， StringUtil.isEmpty(headerStr, true) ? "" : headerStr;
        Map<String, String> hm = new LinkedHashMap<>();

        List<String> setCookie = null;
        List<String> addCookie = null;
        List<String> apijsonDelegateId = null;

        if (StringUtil.isNotEmpty(headerStr, true)) {
            headers = new HttpHeaders();

            String[] lines = StringUtil.split(headerStr.trim(), "\n");
            if (lines != null) {
                for (String line : lines) {
                    line = line.trim();

                    int ind = line.indexOf(":");
                    if (ind < 0 || line.trim().startsWith("//")) {
                        continue;
                    }

                    int ind2 = line.lastIndexOf("//");
                    if (ind2 >= 0) {
                        line = line.substring(0, ind2).trim();
                    }

                    if (line.isEmpty()) {
                        continue;
                    }

                    String name = line.substring(0, ind).trim();
                    String h = line.substring(ind + 1).trim();

                    if (SET_COOKIE.toLowerCase().equals(name.toLowerCase())) {  //接收到时就已经被强制小写
                        setCookie = Arrays.asList(h);  // JSON.parseArray(request.getHeader(name), String.class);
                    } else if (ADD_COOKIE.toLowerCase().equals(name.toLowerCase())) {
                        addCookie = Arrays.asList(h);
                    } else if (APIJSON_DELEGATE_ID.toLowerCase().equals(name.toLowerCase())) {
                        apijsonDelegateId = Arrays.asList(h);
                    } else {
                        headers.put(name, Arrays.asList(h));

                        if (recordType != 0) {
                            if (isSQL) {
                                hm.put(name, h);

                                try {
                                    com.alibaba.fastjson.JSON.parse(h);
                                } catch (Throwable e) {
                                    Log.e(TAG, "delegate  try {\n" +
                                            "                                JSON.parse(h);\n" +
                                            "                            } catch (Throwable e) = " + e.getMessage());
                                    hs += "\n" + name + ": " + "\"" + h.replaceAll("\"", "\\\"") + "\"";
                                    continue;
                                }
                            }

                            hs += "\n" + name + ": " + h;
                        }
                    }
                }
            }
        }
        else if (names != null) {
            headers = new HttpHeaders();
            //Arrays.asList(null) 抛异常，可以排除不存在的头来替代  exceptHeaders == null //空字符串表示不排除任何头
            List<String> exceptHeaderList = StringUtil.isEmpty(exceptHeaders, true)
                    ? EXCEPT_HEADER_LIST : Arrays.asList(StringUtil.split(exceptHeaders));

            while (names.hasMoreElements()) {
                String name = names.nextElement();
                if (name != null && exceptHeaderList.contains(name.toLowerCase()) == false) {
                    //APIAuto 是一定精准发送 Set-Cookie 名称过来的，预留其它命名可实现覆盖原 Cookie Header 等更多可能

                    String h = httpServletRequest.getHeader(name);
                    if (SET_COOKIE.toLowerCase().equals(name.toLowerCase())) {  //接收到时就已经被强制小写
                        setCookie = Arrays.asList(h);  // JSON.parseArray(request.getHeader(name), String.class);
                    } else if (ADD_COOKIE.toLowerCase().equals(name.toLowerCase())) {
                        addCookie = Arrays.asList(h);
                    } else if (APIJSON_DELEGATE_ID.toLowerCase().equals(name.toLowerCase())) {
                        apijsonDelegateId = Arrays.asList(h);
                    } else {
                        headers.add(name, h);

                        if (recordType != 0) {
                            if (isSQL) {
                                hm.put(name, h);

                                try {
                                    com.alibaba.fastjson.JSON.parse(h);
                                }
                                catch (Throwable e) {
                                    Log.e(TAG, "delegate  try {\n" +
                                            "                                JSON.parse(h);\n" +
                                            "                            } catch (Throwable e) = " + e.getMessage());
                                    hs += "\n" + name + ": " + "\"" + h.replaceAll("\"", "\\\"") + "\"";
                                    continue;
                                }
                            }

                            hs += "\n" + name + ": " + h;
                        }
                    }
                }
            }
        }

        if (sessionId == null) {
            sessionId = apijsonDelegateId == null || apijsonDelegateId.isEmpty() ? null : apijsonDelegateId.get(0);
        }
        if (sessionId != null) {
            HttpSession s = SESSION_MAP.get(sessionId);
            if (s != null) {
                session = s;
            }
        }

        if (setCookie == null && session != null) {
            setCookie = (List<String>) session.getAttribute(COOKIE);
        }

        if (addCookie != null && addCookie.isEmpty() == false) {
            if (setCookie == null) {
                setCookie = addCookie;
            }
            else {
                setCookie = new ArrayList<>(setCookie);
                setCookie.addAll(addCookie);
            }
        }

        if (setCookie != null) { //允许传空的 Cookie && setCookie.isEmpty() == false) {
            headers.put(COOKIE, setCookie);
        }


        //可能是 HTTP POST FORM，即便是 HTTP POST JSON，URL 的参数也要拼接，尽可能保持原样  if (method == HttpMethod.GET) {
        Map<String, String[]> map = httpServletRequest.getParameterMap();

        if (map != null) {
            map = new LinkedHashMap<>(map);  //解决 throw exception: Unmodified Map
            map.remove("$_record");
            map.remove("$_type");
            map.remove("$_headers");
            map.remove("$_except_headers");
            map.remove("$_delegate_url");
            map.remove("$_delegate_id");

            Set<Entry<String, String[]>> set = map.entrySet();

            if (set != null && set.isEmpty() == false) {

                if (url.contains("?") == false) {
                    url += "?";
                }
                boolean first = url.endsWith("?");

                for (Entry<String, String[]> e : set) {
                    if (e != null) {
                        String[] vals = e.getValue();
                        url += ((first ? "" : "&") + e.getKey() + "=" + ( vals == null || vals.length <= 0 ? "" : StringUtil.getString(vals[0]) ));
                        first = false;
                    }
                }
            }
        }
        // }

        String rspBody = null;
        if (recordType >= 0) {
            rspBody = sendRequest(session, method, url, body, headers);
        }

        if (recordType != 0) {
            try {
                boolean isBodyEmpty = StringUtil.isEmpty(body, true);

                MediaType contentType = headers.getContentType();
                JSONObject req = recordType == REQUEST_RECORD_TYPE_API ? null : JSON.parseObject(body);

                String host = isSQL ? req.getString("uri") : url;
                int index = host.indexOf("://");
                String rest = index < 0 ? host : host.substring(index + 3);
                int index2 = rest.indexOf("/");
                host = url.substring(0, index + 3) + (index2 < 0 ? rest : rest.substring(0, index2));

                String branch = isSQL ? req.getString("uri") : (isBodyEmpty ? url : rawUrl);
                branch = index < 0 ? branch : (index2 < 0 ? branch.substring(index) : branch.substring(index + 3 + index2));

                String reqType = isBodyEmpty ? (method == HttpMethod.PUT || method == HttpMethod.DELETE ?
                        method.toString() : (method == HttpMethod.POST ? "PARAM"
                        : (MediaType.APPLICATION_FORM_URLENCODED.equals(contentType) ? "FORM"
                        : (MediaType.MULTIPART_FORM_DATA.equals(contentType) ? "DATA" : "JSON"))) // FIXME 考虑 XML, PNG 等格式？
                ) : "JSON";

                String sql = isSQL ? StringUtil.getTrimedString(req.getString("sql")) : null;
                String newSql = "";
//                String[] lines = sql.split(" \\? "); // StringUtil.split(sql, " \\? ", false);
//                int len = lines == null ? 0 : lines.length;
//                if (len > 0) {
//                    JSONArray args = req.getJSONArray("args");
//                    Set<String> set = hm.keySet();
//                    Iterator<String> iterator = set.iterator();
//
//                    for (int i = 0; i < len; i++) {
//                        String line = lines[i];
//                        newSql += (i <= 0 ? "" : " ${" + (iterator.hasNext() ? iterator.next() : "arg" + i) + "} ") + line;
//                        if (i <= 0 || iterator.hasNext()) {
//                            continue;
//                        }
//
//                        hs += "arg" + i + ": " + JSON.toJSONString(args.get(i));
//                    }
//                    sql = newSql.trim();
//                }

                JSONArray args = isSQL ? req.getJSONArray("args") : null;
                Set<String> set = hm.keySet();
                Iterator<String> iterator = set.iterator();

                String s = sql;
                int i = -1;
                while (isSQL && recordType > 0) {
                    // 这种方法当 ? 在某个作为值的字符串内 ' ? ' 会有误判，
                    // 可以改为 preparedStatement.prepare 后拿到最终 SQL，然后对比不一致的地方，再替换。
                    // 也可以直接使用 preparedStatement 内的 SQL 解析算法。

                    int ind = s.indexOf("?");
                    if (ind < 0) {
                        break;
                    }

                    String l = s.substring(0, ind);
                    String r = s.substring(ind + 1);

                    if ((ind <= 0 || s.substring(ind - 1, ind).trim().isEmpty())
                                && (ind >= s.length() - 1 || s.substring(ind + 1, ind + 2).trim().isEmpty())) {
                        boolean hasNext = iterator.hasNext();
                        if (hasNext == false) {
                            Object v = args.get(i);
                            hs += "\narg" + i + ": " + (v instanceof Boolean || v instanceof Number
                                    ? v : (v instanceof String ? "\"" + v + "\"" : JSON.toJSONString(v))
                            );
                        }

                        i ++;
                        newSql += l + "${" + (hasNext ? iterator.next() : "arg" + i) + "}";
                        s = r;

                        continue;
                    }

                    newSql += l + "?";
                    s = r;
                }

                if (StringUtil.isNotEmpty(newSql, true)) {
                    sql = newSql.trim();
                }

                JSONRequest existReq = new JSONRequest();
                if (isUnit) {
                    if (req != null) {
                        // Method <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                        apijson.JSONRequest mthd = new apijson.JSONRequest();
                        if (recordType > 0) {
                            mthd.setColumn("id");
                        }
                        mthd.put("language", req.getString("language"));
                        mthd.put(MethodUtil.KEY_UI, req.getInteger(MethodUtil.KEY_UI));
                        mthd.put(MethodUtil.KEY_STATIC, req.getInteger(MethodUtil.KEY_STATIC));
                        mthd.put(MethodUtil.KEY_PACKAGE, req.getString(MethodUtil.KEY_PACKAGE));
                        mthd.put(MethodUtil.KEY_CLASS, req.getString(MethodUtil.KEY_CLASS));
                        mthd.put(MethodUtil.KEY_CONSTRUCTOR, req.getString(MethodUtil.KEY_CONSTRUCTOR));
                        mthd.put(MethodUtil.KEY_CLASS_ARGS, req.getString(MethodUtil.KEY_CLASS_ARGS));
                        mthd.put(MethodUtil.KEY_TYPE, req.getString(MethodUtil.KEY_TYPE));
                        mthd.put(MethodUtil.KEY_METHOD, req.getString(MethodUtil.KEY_METHOD));
                        mthd.put(MethodUtil.KEY_METHOD_ARGS, req.getString(MethodUtil.KEY_METHOD_ARGS));
                        // mthd.put("header", StringUtil.isEmpty(hs, true) ? null : hs.trim());
                        existReq.put("Method", mthd);
                        // Method >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                    }
                }
                else {
                    // Document <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                    apijson.JSONRequest document = new apijson.JSONRequest();
                    if (recordType > 0) {
                        document.setColumn("id");
                    }
                    document.setOrder("id-");
                    document.put("type", reqType);
                    document.put("url", branch);
                    // document.put("header", StringUtil.isEmpty(hs, true) ? null : hs.trim());
                    if (isSQL) {
                        document.put("sqlauto", sql);
                    }
                    existReq.put("Document", document);
                    // Document >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                }

                JSONObject existRsp = newParser(session, GET).parseResponse(existReq);
                JSONResponse existRsp2 = new JSONResponse(existRsp).getJSONResponse("Document");
                long documentId = existRsp2 == null ? 0 : existRsp2.getId();

                JSONRequest request = new JSONRequest();
                apijson.JSONRequest testRecord = new apijson.JSONRequest();

                if (documentId <= 0) {
                    if (isUnit) {
                        request.setTag("Method");
                        // Method <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                        apijson.JSONRequest mthd = new apijson.JSONRequest();
                        mthd.put("from", 2); // 0-测试工具，1-CI/CD，2-流量录制
                        mthd.put("language", req.getString("language"));
                        mthd.put(MethodUtil.KEY_UI, req.getInteger(MethodUtil.KEY_UI));
                        mthd.put(MethodUtil.KEY_STATIC, req.getInteger(MethodUtil.KEY_STATIC));
                        mthd.put(MethodUtil.KEY_PACKAGE, req.getString(MethodUtil.KEY_PACKAGE));
                        mthd.put(MethodUtil.KEY_CLASS, req.getString(MethodUtil.KEY_CLASS));
                        mthd.put(MethodUtil.KEY_CONSTRUCTOR, req.getString(MethodUtil.KEY_CONSTRUCTOR));
                        mthd.put(MethodUtil.KEY_CLASS_ARGS, req.getString(MethodUtil.KEY_CLASS_ARGS));
                        mthd.put("genericClassArgs", req.getString(MethodUtil.KEY_CLASS_ARGS));
                        mthd.put(MethodUtil.KEY_TYPE, req.getString(MethodUtil.KEY_TYPE));
                        mthd.put(MethodUtil.KEY_METHOD, req.getString(MethodUtil.KEY_METHOD));
                        mthd.put(MethodUtil.KEY_METHOD_ARGS, req.getString(MethodUtil.KEY_METHOD_ARGS));
                        mthd.put("genericMethodArgs", req.getString(MethodUtil.KEY_METHOD_ARGS));
                        mthd.put("request", body);
                        request.put("Method", mthd);
                        // Method >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                    }
                    else if (recordType > 0) {
                        request.setTag("Document");
                        // Document <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                        JSONObject document = new JSONObject(true);
                        document.put("from", 2); // 0-测试工具，1-CI/CD，2-流量录制
                        document.put("name", "[Record] " + new java.util.Date().toLocaleString());
                        document.put("type", reqType);
                        document.put("url", branch);
                        document.put("header", StringUtil.isEmpty(hs, true) ? null : hs.trim());
                        document.put("request", isSQL ? "{}" : (isBodyEmpty ? JSON.toJSONString(map) : body));
                        if (isSQL) {
                            // 没有名称，除非 args 传对象而不是数组
                            // JSONArray args = req.getJSONArray("args");
                            // String argStr = "";
                            // if (args != null) {
                            //    for (int i = 0; i < args.size(); i++) {
                            //       argStr += "\nargs/" + i + ": " + h;
                            //    }
                            // }

                            // document.put("header", argStr);
                            document.put("sqlauto", sql);
                        }
                        // document.put("detail", "");
                        request.put("Document", document);
                        // Document >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                    }
                    else {
                        throw new NotExistException("documentId <= 0 && recordType <= 0, no recorded response");
                    }
                }
                else {
                    // Random <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                    Map<String, ?> m = isSQL ? null : (isBodyEmpty ? map : JSON.parseObject(body));
                    String config = isSQL ? hs : parseRandomConfig("", m);

                    JSONObject random = new JSONObject(true);
                    random.put("count", 1);
                    random.put("documentId", documentId);
                    random.put("config", config.trim());
                    // Random >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

                    if (recordType > 0) {
                        random.put("from", 2); // 0-测试工具，1-CI/CD，2-流量录制
                        random.put("name", "[Record] " + new java.util.Date().toLocaleString());

                        request.put("Random", random);
                        request.setTag("Random");
                    } else {
                        //  testRecord.setColumn("id,response,header");
                        testRecord.put("documentId", documentId);

                        boolean isDefault = false;
                        String reqStr = existRsp2.getString(isSQL ? "sqlauto" : "request");
                        if (reqStr != null && reqStr.equals(body)) {
                            isDefault = true;
                        }
                        else {
                            try {
                                Object reqObj = JSON.parse(reqStr);
                                isDefault = Objects.equals(reqObj, req);
                            }
                            catch (Throwable e) {
                                Log.w(TAG, "delegate  try { Object reqObj = JSON.parse(reqStr); ..." +
                                        " } catch (Throwable e) = " + e.getMessage());
                            }
                        }

                        if (isDefault) {
                            testRecord.put("randomId", 0);
                        }
                        else {
                            long randomId = 0;
                            try {
                                apijson.JSONRequest randomReq = new apijson.JSONRequest();
                                randomReq.put("Random", random);

                                JSONObject rsp = newParser(session, GET).parseResponse(randomReq);
                                JSONObject rsp2 = rsp == null ? null : rsp.getJSONObject("Random");
                                randomId = rsp2 == null ? 0 : rsp2.getLongValue("id");
                            }
                            catch (Throwable e) {
                                Log.w(TAG, "delegate  try { apijson.JSONRequest randomReq = new apijson.JSONRequest(); ..." +
                                        " } catch (Throwable e) = " + e.getMessage());
                            }

                            if (randomId <= 0) {
                                throw new NotExistException("cannot find Random for documentId=" + documentId + " AND requestBody = " + body);
                            }

                            testRecord.put("randomId", randomId);
                        }
                    }
                }

                if (recordType < 0) {
                    testRecord.setOrder("from-,date-");
                }
                else {   // TestRecord <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                    testRecord.put("from", 2); // 0-接口工具，1-CI/CD，2-流量录制
                    testRecord.put("host", host);
                    testRecord.put("response", rspBody); // 用 JSONRequest.put 会转为 JSONObject
                }   // TestRecord >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

                request.put("TestRecord", testRecord);
                JSONObject rsp = newParser(session, recordType < 0 ? GET : POST).parseResponse(request);
                if (recordType < 0) {
                    JSONObject rsp2 = rsp == null ? null : rsp.getJSONObject("TestRecord");
                    String response = rsp2 == null ? null : rsp2.getString("response");
                    if (StringUtil.isNotEmpty(response, true)) {
                        String header = rsp2.getString("header");
                        String[] lines = StringUtil.split(StringUtil.getTrimedString(header), "\n");

                        if (lines != null) {
                            for (String line : lines) {
                                line = line.trim();

                                int ind = line.indexOf(":");
                                if (ind < 0 || line.trim().startsWith("//")) {
                                    continue;
                                }

                                int ind2 = line.lastIndexOf("//");
                                if (ind2 >= 0) {
                                    line = line.substring(0, ind2).trim();
                                }

                                if (line.isEmpty()) {
                                    continue;
                                }

                                String name = line.substring(0, ind).trim();
                                String h = line.substring(ind + 1).trim();

                                httpServletResponse.setHeader(name, h);
                            }
                        }

                        return response;
                    }
                }
            }
            catch (Throwable e) {
                Log.w(TAG, "delegate  try { boolean isBodyEmpty = StringUtil.isEmpty(body, true); ... } catch (Throwable e) = " + e.getMessage());
            }
        }

        if (recordType < 0) {
            rspBody = sendRequest(session, method, url, body, headers);
        }

        return rspBody;
    }

    protected String sendRequest(HttpSession session, HttpMethod method, String url, String body, HttpHeaders headers) {
        String rspBody = null;
        try {
            RestTemplate client = new RestTemplate();
            HttpEntity<String> requestEntity = new HttpEntity<>(method == HttpMethod.GET ? null : body, headers);
            ResponseEntity<String> entity = client.exchange(url, method, requestEntity, String.class);

            HttpHeaders hhs = entity.getHeaders();
            if (session != null && hhs != null) {
                List<String> cookie = hhs.get(SET_COOKIE);
                if (cookie != null && cookie.isEmpty() == false) {
                    session.setAttribute(COOKIE, cookie);
                }
            }

            // FIXME 部分请求头导致 Response Body 未返回前端
//            Set<Entry<String, List<String>>> set = hhs.entrySet();
//            for (Entry<String, List<String>> e : set) {
//                String key = e == null ? null : e.getKey();
//                if (key != null) {
//                    List<String> value = e.getValue();
//                    httpServletResponse.setHeader(key, null);
//                    for (String v : value) {
//                        httpServletResponse.addHeader(key, v);
//                    }
//                }
//            }

            HttpStatus status = entity.getStatusCode();
            httpServletResponse.setStatus(status.value(), status.getReasonPhrase());
            rspBody = entity.getBody();
        }
        catch (Throwable e) {
            try {
                if (e instanceof RestClientResponseException) {
                    RestClientResponseException hce = (RestClientResponseException) e;
                    String msg = hce.getStatusText();
                    rspBody = hce.getResponseBodyAsString();
                    httpServletResponse.setStatus(hce.getRawStatusCode(), StringUtil.isEmpty(msg, true) ? e.getMessage() : msg);
                } else {
                    int code = CommonException.getCode(e);
                    httpServletResponse.setStatus(code, e.getMessage());
                }
            }
            catch (Throwable ex) {
                int code = CommonException.getCode(e);
                httpServletResponse.setStatus(code, e.getMessage());
                // throw e;
            }
        }

        SESSION_MAP.put(session.getId(), session);
        httpServletResponse.setHeader(APIJSON_DELEGATE_ID, session.getId());

        return rspBody;
    }

    private String parseRandomConfig(String path, Object obj) {
        String config = "";

        if (obj instanceof Map) {
            Map m = (Map) obj;
            Set<? extends Entry<?, ?>> s = m == null ? null : m.entrySet();
            if (s != null) {
                //  TODO APIAuto 得先支持空 key        config += "\n" + path + ": {}"; // 避免默认 JSON 中这个数组为 null 导致后面生成的是 JSONArray

                for (Entry<?, ?> e : s) {
                    Object k = e == null ? null : e.getKey();
                    if (k == null) {
                        continue;
                    }

                    Object v = e.getValue();
                    config += "\n" + parseRandomConfig(DemoParser.getAbsPath(path, k.toString()), v).trim();
                }
            }
            return config;
        }

        if (obj instanceof Collection) {
            Collection c = (Collection) obj;
            if (c != null) {
                config += "\n" + path + ": []"; // 避免默认 JSON 中这个数组为 null 导致后面生成的是 JSONObject

                int i = -1;
                for (Object v : c) {
                    i ++;

                    config += "\n" + parseRandomConfig(DemoParser.getAbsPath(path, String.valueOf(i)), v).trim();
                }
            }
            return config;
        }

        if (obj instanceof Array) {
            Array a = (Array) obj;
            if (a != null) {
                config += "\n" + path + ": []"; // 避免默认 JSON 中这个数组为 null 导致后面生成的是 JSONObject

                int len = Array.getLength(a);
                for (int i = 0; i < len; i++) {
                    Object v = Array.get(a, i);
                    config += "\n" + parseRandomConfig(DemoParser.getAbsPath(path, String.valueOf(i)), v).trim();
                }
            }
            return config;
        }

        boolean isStr = obj instanceof String || obj instanceof Character;
        config += "\n" + path + ": " + (obj == null ? "null" : (isStr ? "\"" : "") + obj + (isStr ? "\"" : ""));

        return config;
    }

    public static boolean EXECUTE_STRICTLY = true;
    /**执行 SQL 语句，支持 SQLAuto，注意仅仅不要开放给后端组外的任何人，更不要暴露到公司外的公网！
     * @param request 只用String，避免encode后未decode
     * @return
     * @see
     * <pre>
    {
    "sql": "SELECT * FROM sys.Access LIMIT ${limit}",  // SQL 语句，可以带占位符
    "args": {
    "limit": 5
    }
    }
     * </pre>
     */
    @PostMapping("sql/execute")
    public String execute(@RequestBody String request, HttpSession session) {
        try {
            if (Log.DEBUG == false) {
                return DemoParser.newErrorResult(new IllegalAccessException("非 DEBUG 模式下不允许调用 /sql/execute ！")).toJSONString();
            }

            DemoVerifier.verifyLogin(session);

            long startTime = System.currentTimeMillis();

            JSONObject req = JSON.parseObject(request);
            String sql = req == null ? null : req.getString("sql");
            if (StringUtil.isEmpty(sql)) {
                throw new IllegalArgumentException("sql 不能为空！");
            }

            String database = req.getString("database");
            String uri = req.getString("uri");
            if (StringUtil.isEmpty(database, true) && StringUtil.isEmpty(uri, true)) {
                throw new NullPointerException("database 和 uri 不能同时为空！至少其中一个要传有效值!");
            }
            String schema = req.getString("schema");

            String account = req.getString("account");
            String password = req.getString("password");
            JSONArray arg = req.getJSONArray("args");
            try {
                if (StringUtil.isEmpty(database, true)) {

                    int start = uri.indexOf("://");
                    String prefix = uri.substring(0, start);
                    int mid = prefix.lastIndexOf(":");
                    if (mid >= 0) {
                        prefix = prefix.substring(mid + 1);
                    }

                    if (DemoSQLConfig.DATABASE_INFLUXDB.equalsIgnoreCase(prefix) || DemoSQLConfig.DATABASE_CASSANDRA.equalsIgnoreCase(prefix)) {
                        database = prefix.toUpperCase();

                        int end = uri.lastIndexOf("/");
                        if (end >= 0) {
                            if (StringUtil.isEmpty(schema, true)) {
                                schema = uri.substring(end + 1);
                            }
                            uri = uri.substring(0, end);
                        }

//                        if (DemoSQLConfig.DATABASE_INFLUXDB.equalsIgnoreCase(prefix)) {
                            uri = "http" + uri.substring(start);
                            // account = "root";
                            // password = "apijson@123";
//                        }

                        if (DemoSQLConfig.DATABASE_CASSANDRA.equalsIgnoreCase(prefix)) { // unknown protocol: jdbc
                            account = "test"; // "peter";
                            password = "test"; // null;
                        }
                    } else if (DemoSQLExecutor.DATABASE_NEBULA.equalsIgnoreCase(prefix)) {
                        database = prefix.toUpperCase();
                    }
                }


                String trimmedSQL = sql == null ? null : sql.trim();

                List<Object> valueList = arg;

                DemoSQLExecutor executor = new DemoSQLExecutor();
                DemoSQLConfig config = new DemoSQLConfig();

                config.setDatabase(database);
                config.setSchema(schema);
                config.setDBUri(uri);
                config.setDBAccount(account);
                config.setDBPassword(password);
                config.setPrepared(true);
                config.setPreparedValueList(valueList);
                config.setSql(sql);

                String sqlPrefix = trimmedSQL == null || trimmedSQL.length() < 7 ? "" : trimmedSQL.substring(0, 7).toUpperCase();
                boolean isWrite = sqlPrefix.startsWith("INSERT ") || sqlPrefix.startsWith("UPDATE ") || sqlPrefix.startsWith("DELETE ");

                JSONArray arr = null;

                long updateCount = 0;
                long executeDuration = 0;
                long cursorDuration = 0;
                long rsDuration = 0;
                long executeStartTime = System.currentTimeMillis();

                if (DemoSQLConfig.DATABASE_INFLUXDB.equals(database) || DemoSQLConfig.DATABASE_CASSANDRA.equals(database)) {
                    JSONObject result = executor.execute(config, false);
                    executeDuration = System.currentTimeMillis() - executeStartTime;

                    if (isWrite) {
                        updateCount = result == null ? 0 : result.getIntValue(JSONResponse.KEY_COUNT);
                    } else {
                        arr = result == null ? null : result.getJSONArray(DemoSQLExecutor.KEY_RAW_LIST);
                        if (arr == null) {
                            arr = new JSONArray();
                            if (result != null) {
                                arr.add(result);
                            }
                        }
                    }
                } else {
                    Statement statement = executor.getStatement(config, trimmedSQL);
                    if (statement instanceof PreparedStatement) {
                        if (EXECUTE_STRICTLY) {
                            if (isWrite) {
                                ((PreparedStatement) statement).executeUpdate();
                            } else {
                                ((PreparedStatement) statement).executeQuery();
                            }
                        } else {
                            ((PreparedStatement) statement).execute();
                        }
                    } else {
                        if (arg != null && !arg.isEmpty()) {
                            throw new UnsupportedOperationException("非预编译模式不允许传参 arg ！");
                        }

                        if (EXECUTE_STRICTLY) {
                            if (isWrite) {
                                statement.executeUpdate(sql);
                            } else {
                                statement.executeQuery(sql);
                            }
                        } else {
                            statement.execute(sql);
                        }
                    }

                    executeDuration = System.currentTimeMillis() - executeStartTime;

                    arr = new JSONArray();
                    ResultSet rs = statement.getResultSet();
                    ResultSetMetaData rsmd = rs == null ? null : rs.getMetaData();
                    int length = rsmd == null ? 0 : rsmd.getColumnCount();


                    long cursorStartTime = System.currentTimeMillis();
                    while (rs != null && rs.next()) {
                        cursorDuration += System.currentTimeMillis() - cursorStartTime;

                        JSONObject obj = new JSONObject(true);
                        for (int i = 1; i <= length; i++) {
                            long sqlStartTime = System.currentTimeMillis();
                            String name = rsmd.getColumnName(i);  // rsmd.getColumnLable(i);
                            Object value = rs.getObject(i);
                            rsDuration += System.currentTimeMillis() - sqlStartTime;

                            obj.put(name, value);
                        }

                        arr.add(obj);
                    }

                    //        try {
                    updateCount = statement.getUpdateCount();
                    //        } catch (Throwable e) {
                    //          e.printStackTrace();
                    //        }
                }

                JSONObject result = DemoParser.newSuccessResult();
                result.put("sql", sql);
                result.put("args", arg);
                if (isWrite) {
                    result.put("count", updateCount);
                }
                result.put("list", arr);

                long endTime = System.currentTimeMillis();
                long duration = endTime - startTime;

                long sqlDuration = executeDuration + cursorDuration + rsDuration;
                long parseDuration = duration - sqlDuration;

                result.put("time:start|duration|end|parse|sql", startTime + "|" + duration + "|" + endTime + "|" + parseDuration + "|" + sqlDuration);

                if (DemoSQLExecutor.DATABASE_NEBULA.equalsIgnoreCase(database) == false) {
                    return result.toJSONString();
                }

                return com.alibaba.fastjson.JSON.toJSONString(result, new ValueFilter() {
                    @Override
                    public Object process(Object o, String key, Object val) {
//                        if (val instanceof ValueWrapper) {
//                            return process(o, key, ((ValueWrapper) val).getValue());
//                        }
//
//                        if (val instanceof Value) {
//                            return process(o, key, ((Value) val).getFieldValue());
//                        }
//
//                        if (val instanceof Vertex) {
//                            JSONObject obj = new JSONObject(true);
//                            obj.put("vid", new String(((Vertex) val).getVid().getSVal()));
//                            obj.put("str", val.toString());
//
//                            List<Tag> tags = ((Vertex) val).getTags();
//
//                            if (tags != null) {
//                                JSONArray arr = new JSONArray();
//                                for (int i = 0; i < tags.size(); i++) {
//                                    arr.add(process(o, String.valueOf(i), tags.get(i)));
//                                }
//                                obj.put("tags", arr);
//                            }
//
//                            return obj;
//                        }
//
//                        if (val instanceof Tag) {
//                            JSONObject obj = new JSONObject(true);
//                            obj.put("name", new String(((Tag) val).getName()));
//                            obj.put("str", val.toString());
//
//                            Map<byte[], Value> props = ((Tag) val).getProps();
//
//                            if (props != null) {
//                                JSONObject propsObj = new JSONObject(true);
//                                props.forEach(new BiConsumer<byte[], Value>() {
//                                    @Override
//                                    public void accept(byte[] bytes, Value value) {
//                                        String k = new String(bytes);
//                                        propsObj.put(k, process(propsObj, k, value));
//                                    }
//                                });
//                                obj.put("props", propsObj);
//                            }
//
//                            return obj;
//                        }
//
//                        if (val instanceof Edge) {
//                            JSONObject obj = new JSONObject(true);
//                            obj.put("name", new String(((Edge) val).getName()));
//                            obj.put("str", val.toString());
//
//                            Map<byte[], Value> props = ((Edge) val).getProps();
//
//                            if (props != null) {
//                                JSONObject propsObj = new JSONObject(true);
//                                props.forEach(new BiConsumer<byte[], Value>() {
//                                    @Override
//                                    public void accept(byte[] bytes, Value value) {
//                                        String k = new String(bytes);
//                                        propsObj.put(k, process(propsObj, k, value));
//                                    }
//                                });
//                                obj.put("props", propsObj);
//                            }
//
//                            return obj;
//                        }
//
//                        if (val instanceof NullType) {
//                            return null;
//                        }
//
//                        if (val instanceof DateWrapper) {
//                            return ((DateWrapper) val).toString();
//                        }
//
//                        if (val instanceof TimeWrapper) {
//                            return ((TimeWrapper) val).getLocalTimeStr();
//                        }
//
//                        if (val instanceof DateTimeWrapper) {
//                            return ((DateTimeWrapper) val).getLocalDateTimeStr();
//                        }
//
//                        if (val instanceof DurationWrapper) {
//                            return ((DurationWrapper) val).getMicroseconds();
//                        }
//
//                        if (val instanceof Date) {
//                            Date d = (Date) val;
//                            return new java.sql.Date(d.getYear() - 1900, d.getMonth(), d.getDay()).toString();
//                        }
//
//                        if (val instanceof Time) {
//                            Time t = (Time) val;
//                            return new java.sql.Time(t.getHour(), t.getMinute(), t.getSec()).toString();
//                        }
//
//                        if (val instanceof DateTime) {
//                            DateTime dt = (DateTime) val;
//                            //  return new java.util.Date(dt.getYear(), dt.getNonth(), dt.getDayO, dt.getHour(), dt.getMinute(), dt.getSec0).toGnTString();
//                            return new java.sql.Date(dt.getYear() - 1988, dt.getMonth(), dt.getDay())
//                                    + " " + new java.sql.Time(dt.getHour(), dt.getMinute(), dt.getSec());
//                        }
//
//                        if (val instanceof Duration) {
//                            return ((Duration) val).getMicroseconds();
//                        }

                        return val;
                    }
                }, SerializerFeature.WriteMapNullValue);
            } catch (Exception e) {
                JSONObject result = DemoParser.newErrorResult(e);
                result.put("throw", e.getClass().getName());
                result.put("trace:stack", e.getStackTrace());

                if (req != null) {
                    req.putAll(result);
                    return req.toJSONString();
                }
                return result.toJSONString();
            }
        } catch (Exception e) {
            JSONObject result = DemoParser.newErrorResult(e);
            result.put("throw", e.getClass().getName());
            result.put("trace:stack", e.getStackTrace());
            return result.toJSONString();
        }

    }


    /**Swagger 文档 Demo，供 APIAuto 测试导入 Swagger 文档到数据库用
     * @return
     */
    @GetMapping("v2/api-docs")
    public String swaggerAPIDocs() {
        return "{\n"+
                "    \"paths\": {\n"+
                "        \"/user/list\": {\n"+
                "            \"get\": {\n"+
                "                \"summary\": \"用户列表\",\n"+
                "                \"parameters\": [\n"+
                "                    {\n"+
                "                        \"name\": \"pageSize\",\n"+
                "                        \"description\": \"每页数量\",\n"+
                "                        \"default\": 10\n"+
                "                    },\n"+
                "                    {\n"+
                "                        \"name\": \"pageNum\",\n"+
                "                        \"default\": 1\n"+
                "                    },\n"+
                "                    {\n"+
                "                        \"name\": \"searchKey\",\n"+
                "                        \"description\": \"搜索关键词\",\n"+
                "                        \"default\": \"a\"\n"+
                "                    }\n"+
                "                ]\n"+
                "            }\n"+
                "        },\n"+
                "        \"/user\": {\n"+
                "            \"get\": {\n"+
                "                \"summary\": \"用户详情\",\n"+
                "                \"parameters\": [\n"+
                "                    {\n"+
                "                        \"name\": \"id\",\n"+
                "                        \"description\": \"主键\",\n"+
                "                        \"default\": 82001\n"+
                "                    }\n"+
                "                ]\n"+
                "            }\n"+
                "        },\n"+
                "        \"/comment/post\": {\n"+
                "            \"post\": {\n"+
                "                \"summary\": \"新增评论\",\n"+
                "                \"parameters\": [\n"+
                "                    {\n"+
                "                        \"name\": \"userId\",\n"+
                "                        \"description\": \"用户id\",\n"+
                "                        \"default\": 82001\n"+
                "                    },\n"+
                "                    {\n"+
                "                        \"name\": \"momentId\",\n"+
                "                        \"description\": \"动态id\",\n"+
                "                        \"default\": 15\n"+
                "                    },\n"+
                "                    {\n"+
                "                        \"name\": \"content\",\n"+
                "                        \"description\": \"内容\",\n"+
                "                        \"default\": \"测试评论\"\n"+
                "                    }\n"+
                "                ]\n"+
                "            }\n"+
                "        }\n"+
                "    }\n"+
                "}";
    }

    /**Rap 文档 Demo，供 APIAuto 测试导入 Rap 文档到数据库用
     * @return
     */
    @GetMapping("repository/joined")
    public String rapJoinedRepository() {
        return "{\n" +
                "    \"data\": [\n" +
                "        {\n" +
                "            \"id\": 1243,\n" +
                "            \"name\": \"Test\",\n" +
                "            \"description\": \"4 test\",\n" +
                "            \"logo\": null,\n" +
                "            \"token\": \"JrA78ktHhsGJtlhtUwt4Bpk3i96-QQLE\",\n" +
                "            \"visibility\": true,\n" +
                "            \"ownerId\": 1803,\n" +
                "            \"organizationId\": null,\n" +
                "            \"creatorId\": 1803,\n" +
                "            \"lockerId\": null,\n" +
                "            \"createdAt\": \"2017-12-05T08:48:44.000Z\",\n" +
                "            \"updatedAt\": \"2019-12-30T02:36:48.000Z\",\n" +
                "            \"deletedAt\": null,\n" +
                "            \"creator\": {\n" +
                "                \"id\": 1803,\n" +
                "                \"fullname\": \"TommyLemon\",\n" +
                "                \"email\": \"111@qq.com\"\n" +
                "            },\n" +
                "            \"owner\": {\n" +
                "                \"id\": 1803,\n" +
                "                \"fullname\": \"TommyLemon\",\n" +
                "                \"email\": \"111@qq.com\"\n" +
                "            },\n" +
                "            \"locker\": null,\n" +
                "            \"members\": [\n" +
                "                {\n" +
                "                    \"id\": 1803,\n" +
                "                    \"fullname\": \"TommyLemon\",\n" +
                "                    \"email\": \"111@qq.com\"\n" +
                "                }\n" +
                "            ],\n" +
                "            \"organization\": null,\n" +
                "            \"collaborators\": [],\n" +
                "            \"RepositoriesMembers\": {\n" +
                "                \"userId\": 1803,\n" +
                "                \"repositoryId\": 1243\n" +
                "            },\n" +
                "            \"canUserEdit\": true\n" +
                "        }\n" +
                "    ]\n" +
                "}";
    }


    /**Rap 文档 Demo，供 APIAuto 测试导入 Rap 文档到数据库用
     * @param id
     * @return
     */
    @GetMapping("repository/get")
    public String rapRepositoryDetail(@RequestParam("id") String id) {
        return "{\n" +
                "    \"data\": {\n" +
                "        \"id\": " + id + ",\n" +
                "        \"name\": \"Test\",\n" +
                "        \"description\": \"4 test\",\n" +
                "        \"logo\": null,\n" +
                "        \"token\": \"JrA78ktHhsGJtlhtUwt4Bpk3i96-QQLE\",\n" +
                "        \"visibility\": true,\n" +
                "        \"ownerId\": 1803,\n" +
                "        \"organizationId\": null,\n" +
                "        \"creatorId\": 1803,\n" +
                "        \"lockerId\": null,\n" +
                "        \"createdAt\": \"2017-12-05T08:48:44.000Z\",\n" +
                "        \"updatedAt\": \"2019-12-30T02:36:48.000Z\",\n" +
                "        \"deletedAt\": null,\n" +
                "        \"creator\": {\n" +
                "            \"id\": 1803,\n" +
                "            \"fullname\": \"TommyLemon\",\n" +
                "            \"email\": \"111@qq.com\"\n" +
                "        },\n" +
                "        \"owner\": {\n" +
                "            \"id\": 1803,\n" +
                "            \"fullname\": \"TommyLemon\",\n" +
                "            \"email\": \"111@qq.com\"\n" +
                "        },\n" +
                "        \"locker\": null,\n" +
                "        \"members\": [\n" +
                "            {\n" +
                "                \"id\": 1803,\n" +
                "                \"fullname\": \"TommyLemon\",\n" +
                "                \"email\": \"111@qq.com\"\n" +
                "            }\n" +
                "        ],\n" +
                "        \"organization\": null,\n" +
                "        \"collaborators\": [],\n" +
                "        \"modules\": [\n" +
                "            {\n" +
                "                \"id\": 1973,\n" +
                "                \"name\": \"示例模块\",\n" +
                "                \"description\": \"示例模块\",\n" +
                "                \"priority\": 1,\n" +
                "                \"creatorId\": 1803,\n" +
                "                \"repositoryId\": 1243,\n" +
                "                \"createdAt\": \"2017-12-05T08:48:44.000Z\",\n" +
                "                \"updatedAt\": \"2017-12-05T08:48:44.000Z\",\n" +
                "                \"deletedAt\": null,\n" +
                "                \"interfaces\": [\n" +
                "                    {\n" +
                "                        \"id\": 4042,\n" +
                "                        \"name\": \"getUser\",\n" +
                "                        \"url\": \"/get\",\n" +
                "                        \"method\": \"POST\",\n" +
                "                        \"description\": \"get an User\",\n" +
                "                        \"priority\": 1,\n" +
                "                        \"status\": 200,\n" +
                "                        \"creatorId\": 1803,\n" +
                "                        \"lockerId\": null,\n" +
                "                        \"moduleId\": 1973,\n" +
                "                        \"repositoryId\": 1243,\n" +
                "                        \"createdAt\": \"2017-12-05T08:51:02.000Z\",\n" +
                "                        \"updatedAt\": \"2020-05-30T16:25:28.000Z\",\n" +
                "                        \"deletedAt\": null,\n" +
                "                        \"locker\": null,\n" +
                "                        \"properties\": [\n" +
                "                            {\n" +
                "                                \"id\": 81553,\n" +
                "                                \"scope\": \"request\",\n" +
                "                                \"type\": \"Object\",\n" +
                "                                \"pos\": 2,\n" +
                "                                \"name\": \"User\",\n" +
                "                                \"rule\": \"\",\n" +
                "                                \"value\": \"{}\",\n" +
                "                                \"description\": \"\",\n" +
                "                                \"parentId\": -1,\n" +
                "                                \"priority\": 43204,\n" +
                "                                \"interfaceId\": 4042,\n" +
                "                                \"creatorId\": 1803,\n" +
                "                                \"moduleId\": 1973,\n" +
                "                                \"repositoryId\": 1243,\n" +
                "                                \"required\": false,\n" +
                "                                \"createdAt\": \"2017-12-05T08:52:03.000Z\",\n" +
                "                                \"updatedAt\": \"2020-05-30T16:25:28.000Z\",\n" +
                "                                \"deletedAt\": null\n" +
                "                            },\n" +
                "                            {\n" +
                "                                \"id\": 81562,\n" +
                "                                \"scope\": \"response\",\n" +
                "                                \"type\": \"Object\",\n" +
                "                                \"pos\": 2,\n" +
                "                                \"name\": \"User\",\n" +
                "                                \"rule\": \"\",\n" +
                "                                \"value\": \"{\\n\\\"id\\\": 38710 ,\\n\\\"sex\\\": 0 ,\\n\\\"name\\\": \\\"TommyLemon\\\" ,\\n\\\"contactIdList\\\":  [\\n82003 ,\\n82005 ,\\n90814 \\n],\\n\\\"pictureList\\\":  [\\n\\\"http://static.oschina.net/uploads/user/1218/2437072_100.jpg?t=1461076033000\\\" \\n]\\n}\",\n" +
                "                                \"description\": \"\",\n" +
                "                                \"parentId\": -1,\n" +
                "                                \"priority\": 1,\n" +
                "                                \"interfaceId\": 4042,\n" +
                "                                \"creatorId\": 1803,\n" +
                "                                \"moduleId\": 1973,\n" +
                "                                \"repositoryId\": 1243,\n" +
                "                                \"required\": false,\n" +
                "                                \"createdAt\": \"2017-12-05T08:54:16.000Z\",\n" +
                "                                \"updatedAt\": \"2020-05-30T16:25:28.000Z\",\n" +
                "                                \"deletedAt\": null\n" +
                "                            },\n" +
                "                            {\n" +
                "                                \"id\": 17621689,\n" +
                "                                \"scope\": \"request\",\n" +
                "                                \"type\": \"String\",\n" +
                "                                \"pos\": 1,\n" +
                "                                \"name\": \"site\",\n" +
                "                                \"rule\": null,\n" +
                "                                \"value\": \"apijson\",\n" +
                "                                \"description\": \"来源网站\",\n" +
                "                                \"parentId\": -1,\n" +
                "                                \"priority\": 1590855928395,\n" +
                "                                \"interfaceId\": 4042,\n" +
                "                                \"creatorId\": 1803,\n" +
                "                                \"moduleId\": 1973,\n" +
                "                                \"repositoryId\": 1243,\n" +
                "                                \"required\": false,\n" +
                "                                \"createdAt\": \"2020-05-30T16:25:28.000Z\",\n" +
                "                                \"updatedAt\": \"2020-05-30T16:25:28.000Z\",\n" +
                "                                \"deletedAt\": null\n" +
                "                            }\n" +
                "                        ]\n" +
                "                    },\n" +
                "                    {\n" +
                "                        \"id\": 1446108,\n" +
                "                        \"name\": \"post\",\n" +
                "                        \"url\": \"/post\",\n" +
                "                        \"method\": \"POST\",\n" +
                "                        \"description\": \"post user\",\n" +
                "                        \"priority\": 2,\n" +
                "                        \"status\": 200,\n" +
                "                        \"creatorId\": 1803,\n" +
                "                        \"lockerId\": null,\n" +
                "                        \"moduleId\": 1973,\n" +
                "                        \"repositoryId\": 1243,\n" +
                "                        \"createdAt\": \"2020-01-13T10:32:51.000Z\",\n" +
                "                        \"updatedAt\": \"2020-05-30T16:29:13.000Z\",\n" +
                "                        \"deletedAt\": null,\n" +
                "                        \"locker\": null,\n" +
                "                        \"properties\": [\n" +
                "                            {\n" +
                "                                \"id\": 17394319,\n" +
                "                                \"scope\": \"request\",\n" +
                "                                \"type\": \"String\",\n" +
                "                                \"pos\": 1,\n" +
                "                                \"name\": \"he\",\n" +
                "                                \"rule\": null,\n" +
                "                                \"value\": \"test\",\n" +
                "                                \"description\": \"\",\n" +
                "                                \"parentId\": -1,\n" +
                "                                \"priority\": 1590334790882,\n" +
                "                                \"interfaceId\": 1446108,\n" +
                "                                \"creatorId\": 1803,\n" +
                "                                \"moduleId\": 1973,\n" +
                "                                \"repositoryId\": 1243,\n" +
                "                                \"required\": false,\n" +
                "                                \"createdAt\": \"2020-05-24T15:39:50.000Z\",\n" +
                "                                \"updatedAt\": \"2020-05-30T16:29:13.000Z\",\n" +
                "                                \"deletedAt\": null\n" +
                "                            }\n" +
                "                        ]\n" +
                "                    },\n" +
                "                    {\n" +
                "                        \"id\": 1596193,\n" +
                "                        \"name\": \"login\",\n" +
                "                        \"url\": \"/login\",\n" +
                "                        \"method\": \"POST\",\n" +
                "                        \"description\": \"\",\n" +
                "                        \"priority\": 1590853798312,\n" +
                "                        \"status\": 200,\n" +
                "                        \"creatorId\": 1803,\n" +
                "                        \"lockerId\": null,\n" +
                "                        \"moduleId\": 1973,\n" +
                "                        \"repositoryId\": 1243,\n" +
                "                        \"createdAt\": \"2020-05-30T15:49:58.000Z\",\n" +
                "                        \"updatedAt\": \"2020-05-30T16:25:08.000Z\",\n" +
                "                        \"deletedAt\": null,\n" +
                "                        \"locker\": null,\n" +
                "                        \"properties\": [\n" +
                "                            {\n" +
                "                                \"id\": 17621552,\n" +
                "                                \"scope\": \"request\",\n" +
                "                                \"type\": \"String\",\n" +
                "                                \"pos\": 3,\n" +
                "                                \"name\": \"phone\",\n" +
                "                                \"rule\": null,\n" +
                "                                \"value\": \"13000082001\",\n" +
                "                                \"description\": \"手机号\",\n" +
                "                                \"parentId\": -1,\n" +
                "                                \"priority\": 1590853936991,\n" +
                "                                \"interfaceId\": 1596193,\n" +
                "                                \"creatorId\": 1803,\n" +
                "                                \"moduleId\": 1973,\n" +
                "                                \"repositoryId\": 1243,\n" +
                "                                \"required\": false,\n" +
                "                                \"createdAt\": \"2020-05-30T15:52:16.000Z\",\n" +
                "                                \"updatedAt\": \"2020-05-30T16:25:07.000Z\",\n" +
                "                                \"deletedAt\": null\n" +
                "                            },\n" +
                "                            {\n" +
                "                                \"id\": 17621553,\n" +
                "                                \"scope\": \"request\",\n" +
                "                                \"type\": \"String\",\n" +
                "                                \"pos\": 3,\n" +
                "                                \"name\": \"password\",\n" +
                "                                \"rule\": null,\n" +
                "                                \"value\": \"123456\",\n" +
                "                                \"description\": \"密码\",\n" +
                "                                \"parentId\": -1,\n" +
                "                                \"priority\": 1590853936994,\n" +
                "                                \"interfaceId\": 1596193,\n" +
                "                                \"creatorId\": 1803,\n" +
                "                                \"moduleId\": 1973,\n" +
                "                                \"repositoryId\": 1243,\n" +
                "                                \"required\": false,\n" +
                "                                \"createdAt\": \"2020-05-30T15:52:16.000Z\",\n" +
                "                                \"updatedAt\": \"2020-05-30T16:25:07.000Z\",\n" +
                "                                \"deletedAt\": null\n" +
                "                            },\n" +
                "                            {\n" +
                "                                \"id\": 17621554,\n" +
                "                                \"scope\": \"response\",\n" +
                "                                \"type\": \"String\",\n" +
                "                                \"pos\": 3,\n" +
                "                                \"name\": \"msg\",\n" +
                "                                \"rule\": null,\n" +
                "                                \"value\": \"\",\n" +
                "                                \"description\": \"success\",\n" +
                "                                \"parentId\": -1,\n" +
                "                                \"priority\": 1590853936997,\n" +
                "                                \"interfaceId\": 1596193,\n" +
                "                                \"creatorId\": 1803,\n" +
                "                                \"moduleId\": 1973,\n" +
                "                                \"repositoryId\": 1243,\n" +
                "                                \"required\": false,\n" +
                "                                \"createdAt\": \"2020-05-30T15:52:16.000Z\",\n" +
                "                                \"updatedAt\": \"2020-05-30T16:25:07.000Z\",\n" +
                "                                \"deletedAt\": null\n" +
                "                            },\n" +
                "                            {\n" +
                "                                \"id\": 17621565,\n" +
                "                                \"scope\": \"response\",\n" +
                "                                \"type\": \"Number\",\n" +
                "                                \"pos\": 3,\n" +
                "                                \"name\": \"code\",\n" +
                "                                \"rule\": \"\",\n" +
                "                                \"value\": \"200\",\n" +
                "                                \"description\": null,\n" +
                "                                \"parentId\": -1,\n" +
                "                                \"priority\": 1590853937020,\n" +
                "                                \"interfaceId\": 1596193,\n" +
                "                                \"creatorId\": null,\n" +
                "                                \"moduleId\": 1973,\n" +
                "                                \"repositoryId\": 1243,\n" +
                "                                \"required\": false,\n" +
                "                                \"createdAt\": \"2020-05-30T15:52:17.000Z\",\n" +
                "                                \"updatedAt\": \"2020-05-30T16:25:07.000Z\",\n" +
                "                                \"deletedAt\": null\n" +
                "                            },\n" +
                "                            {\n" +
                "                                \"id\": 17621688,\n" +
                "                                \"scope\": \"request\",\n" +
                "                                \"type\": \"String\",\n" +
                "                                \"pos\": 1,\n" +
                "                                \"name\": \"head\",\n" +
                "                                \"rule\": null,\n" +
                "                                \"value\": \"apijson\",\n" +
                "                                \"description\": \"请求头\",\n" +
                "                                \"parentId\": -1,\n" +
                "                                \"priority\": 1590855907992,\n" +
                "                                \"interfaceId\": 1596193,\n" +
                "                                \"creatorId\": 1803,\n" +
                "                                \"moduleId\": 1973,\n" +
                "                                \"repositoryId\": 1243,\n" +
                "                                \"required\": false,\n" +
                "                                \"createdAt\": \"2020-05-30T16:25:07.000Z\",\n" +
                "                                \"updatedAt\": \"2020-05-30T16:25:07.000Z\",\n" +
                "                                \"deletedAt\": null\n" +
                "                            }\n" +
                "                        ]\n" +
                "                    }\n" +
                "                ]\n" +
                "            }\n" +
                "        ],\n" +
                "        \"canUserEdit\": true\n" +
                "    }\n" +
                "}";
    }

    // 为 APIAuto 提供的代理接口(解决跨域问题) 和 导入第三方文档的测试接口 https://github.com/TommyLemon/APIAuto   https://github.com/TommyLemon/APIAuto  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



    // 为 UnitAuto 提供的单元测试接口  https://github.com/TommyLemon/UnitAuto  <<<<<<<<<<<<<<<<<<<<<<<<<<<

    @PostMapping("method/list")
    public JSONObject listMethod(@RequestBody String request) {
        return super.listMethod(request);
    }

    @PostMapping("method/invoke")
    public void invokeMethod(@RequestBody String request, HttpServletRequest servletRequest) {
        super.invokeMethod(request, servletRequest);
    }

    // 为 UnitAuto 提供的单元测试接口  https://github.com/TommyLemon/UnitAuto  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


    // 为 APIAuto, UnitAuto, SQLAuto 提供的后台 Headless 无 UI 测试转发接口  <<<<<<<<<<<<<<<<<<<<<<<<<<<

    @GetMapping("api/test/start")
    public String startApiTest(HttpSession session) {
        //response.sendRedirect("http://localhost:3000/test/start");
        long id = 100000 + Math.round(899999*Math.random());
        DemoParser.KEY_MAP.put(String.valueOf(id), session);  // 调这个接口一般是前端/CI/CD，调查询接口的是 Node，Session 不同 session.setAttribute("key", id);
        return delegate("http://localhost:3000/test/start?key=" + id, null, null, null, null, null, null, HttpMethod.GET, session);
    }
    @GetMapping("api/test/status")
    public String getApiTestStatus(@RequestParam(value = "key", required = false) String key, HttpSession session) {
        //response.sendRedirect("http://localhost:3000/test/status");
        DemoParser.KEY_MAP.remove(key);
        return delegate("http://localhost:3000/test/status", null, null, null, null, null, null, HttpMethod.GET, session);
    }

    @GetMapping("unit/test/start")
    public String startUnitTest(HttpSession session) {
        long id = 100000 + Math.round(899999*Math.random());
        DemoParser.KEY_MAP.put(String.valueOf(id), session);  // 调这个接口一般是前端/CI/CD，调查询接口的是 Node，Session 不同 session.setAttribute("key", id);
        return delegate("http://localhost:3001/test/start?key=" + id, null, null, null, null, null, null, HttpMethod.GET, session);
    }
    @GetMapping("unit/test/status")
    public String getUnitTestStatus(@RequestParam(value = "key", required = false) String key, HttpSession session) {
        DemoParser.KEY_MAP.remove(key);
        return delegate("http://localhost:3001/test/status", null, null, null, null, null, null, HttpMethod.GET, session);
    }

    @GetMapping("sql/test/start")
    public String startSQLTest(HttpSession session) {
        long id = 100000 + Math.round(899999*Math.random());
        DemoParser.KEY_MAP.put(String.valueOf(id), session);  // 调这个接口一般是前端/CI/CD，调查询接口的是 Node，Session 不同 session.setAttribute("key", id);
        return delegate("http://localhost:3002/test/start?key=" + id, null, null, null, null, null, null, HttpMethod.GET, session);
    }
    @GetMapping("sql/test/status")
    public String getSQLTestStatus(@RequestParam("key") String key, HttpSession session) {
        DemoParser.KEY_MAP.remove(key);
        return delegate("http://localhost:3002/test/status", null, null, null, null, null, null, HttpMethod.GET, session);
    }

    // 为 APIAuto, UnitAuto, SQLAuto 提供的后台 Headless 无 UI 测试转发接口  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


}
