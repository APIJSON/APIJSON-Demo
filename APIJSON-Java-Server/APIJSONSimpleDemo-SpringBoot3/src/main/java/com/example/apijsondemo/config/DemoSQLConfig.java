package com.example.apijsondemo.config;

import apijson.framework.APIJSONSQLConfig;

public class DemoSQLConfig extends APIJSONSQLConfig<Long> {

    static {
        DEFAULT_DATABASE = DATABASE_MYSQL; // 用的数据库软件
        DEFAULT_SCHEMA = "sys"; // 数据库名

        // 表名和数据库不一致的，需要配置映射关系。只使用 APIJSONORM 时才需要；
        // 如果用了 apijson-framework 且调用了 APIJSONApplication.init 则不需要
        // (间接调用 DemoVerifier.init 方法读取数据库 Access 表来替代手动输入配置)。
        // 但如果 Access 这张表的对外表名与数据库实际表名不一致，仍然需要这里注册。例如
        // TABLE_KEY_MAP.put(Access.class.getSimpleName(), "access");

        // 表名映射，隐藏真实表名，对安全要求很高的表可以这么做
        // TABLE_KEY_MAP.put("User", "apijson_user");
        // TABLE_KEY_MAP.put("Privacy", "apijson_privacy");
    }

    @Override
    public String getDBVersion() {
        return "8.0.27";
    }

}
