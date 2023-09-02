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


import apijson.JSON;
import apijson.RequestMethod;
import apijson.framework.APIJSONSQLExecutor;
import apijson.orm.SQLConfig;
import com.alibaba.fastjson.JSONObject;
import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericToStringSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;

import java.io.Serializable;
import java.util.List;
import java.util.concurrent.TimeUnit;

import static apijson.framework.APIJSONConstant.PRIVACY_;
import static apijson.framework.APIJSONConstant.USER_;


/**
 * SQL 执行器，支持连接池及多数据源
 * 具体见 https://github.com/Tencent/APIJSON/issues/151
 *
 * @author Lemon
 */
public class DemoSQLExecutor extends APIJSONSQLExecutor<Long> {
    public static final String TAG = "DemoSQLExecutor";

    // Redis 缓存 <<<<<<<<<<<<<<<<<<<<<<<
    public static final RedisTemplate<String, String> REDIS_TEMPLATE;
    static {
        REDIS_TEMPLATE = new RedisTemplate<>();
        REDIS_TEMPLATE.setConnectionFactory(new JedisConnectionFactory(new RedisStandaloneConfiguration("127.0.0.1", 6379)));
        REDIS_TEMPLATE.setKeySerializer(new StringRedisSerializer());
        REDIS_TEMPLATE.setHashValueSerializer(new GenericToStringSerializer<>(Serializable.class));
        REDIS_TEMPLATE.setValueSerializer(new GenericToStringSerializer<>(Serializable.class));
        //    REDIS_TEMPLATE.setValueSerializer(new FastJsonRedisSerializer<List<JSONObject>>(List.class));
        REDIS_TEMPLATE.afterPropertiesSet();
    }

    //  可重写以下方法，支持 Redis 等单机全局缓存或分布式缓存
    @Override
    public List<JSONObject> getCache(String sql, SQLConfig config) {
        List<JSONObject> list = super.getCache(sql, config);
        if (list == null) {
            list = JSON.parseArray(REDIS_TEMPLATE.opsForValue().get(sql), JSONObject.class);
        }
        return list;
    }

    @Override
    public synchronized void putCache(String sql, List<JSONObject> list, SQLConfig config) {
        super.putCache(sql, list, config);

        String table = config != null && config.isMain() ? config.getTable() : null;
        if (table != null && DemoSQLConfig.CONFIG_TABLE_LIST.contains(table) == false) {
            if (config.isExplain() || RequestMethod.isHeadMethod(config.getMethod(), true)) {
                REDIS_TEMPLATE.opsForValue().set(sql, JSON.toJSONString(list), 10 * 60, TimeUnit.SECONDS);
            } else {
                REDIS_TEMPLATE.opsForValue().set(sql, JSON.toJSONString(list), USER_.equals(table) || PRIVACY_.equals(table) ? 10 * 60 : 60, TimeUnit.SECONDS);
            }
        }
    }

    @Override
    public synchronized void removeCache(String sql, SQLConfig config) {
        super.removeCache(sql, config);
        if (config.getMethod() == RequestMethod.DELETE) { // 避免缓存击穿
            REDIS_TEMPLATE.expire(sql, 60, TimeUnit.SECONDS);
        } else {
            REDIS_TEMPLATE.delete(sql);
        }
    }

    // Redis 缓存 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


}
