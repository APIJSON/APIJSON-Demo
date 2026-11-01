/*Copyright ©2025 APIJSON(https://github.com/APIJSON)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.*/

package apijson;

public class SQLUtil {
    public static boolean isRead(String sql) {
        return isRead(sql, false);
    }
    public static boolean isRead(String sql, boolean isRedis) {
        return ! isWrite(sql, isRedis);
    }

    public static boolean isWrite(String sql) {
        return isWrite(sql, false);
    }
    public static boolean isWrite(String sql, boolean isRedis) {
        return isInsert(sql, isRedis) || isUpdate(sql, isRedis) || isDelete(sql, isRedis);
    }

    public static boolean isSelect(String sql) {
        return isSelect(sql, false);
    }
    public static boolean isSelect(String sql, boolean isRedis) {
        return sql != null && ! (isInsert(sql, isRedis) || isUpdate(sql, isRedis) || isDelete(sql, isRedis));
    }

    public static boolean isInsert(String sql) {
        return isInsert(sql, false);
    }
    public static boolean isInsert(String sql, boolean isRedis) {
        return sql != null && ((sql.startsWith("INSERT ") && ! isRedis) || (isRedis && (
                sql.startsWith("SADD ") || sql.startsWith("ZADD ")
                || sql.startsWith("LPUSH ") || sql.startsWith("RPUSH ")
        )));
    }

    public static boolean isUpdate(String sql) {
        return isUpdate(sql, false);
    }
    public static boolean isUpdate(String sql, boolean isRedis) {
        return sql != null && ((sql.startsWith("UPDATE ") && ! isRedis) || (isRedis && (sql.startsWith("SET ")
                || sql.startsWith("HSET ") || sql.startsWith("MSET ")
        )));
    }

    public static boolean isDelete(String sql) {
        return isDelete(sql, false);
    }
    public static boolean isDelete(String sql, boolean isRedis) {
        return sql != null && ((sql.startsWith("DELETE ") && ! isRedis)
                || (isRedis && (sql.startsWith("DEL ") || sql.startsWith("HDEL ") || sql.startsWith("MDEL ")
                || sql.startsWith("SREM ") || sql.startsWith("ZREM ")
                || sql.startsWith("LPOP ") || sql.startsWith("RPOP ")
                || sql.startsWith("FLUSHDB ") || sql.startsWith("FLUSHALL ")
        )));
    }

}
