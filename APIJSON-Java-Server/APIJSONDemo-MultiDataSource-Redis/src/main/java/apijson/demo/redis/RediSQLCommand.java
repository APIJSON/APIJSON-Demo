package apijson.demo.redis;

import redis.clients.jedis.commands.ProtocolCommand;
import redis.clients.jedis.util.SafeEncoder;

public class RediSQLCommand {
    public enum ModuleCommand implements ProtocolCommand {
        CREATE_DB("REDISQL.CREATE_DB"),
        EXEC("REDISQL.EXEC"),
        EXEC_NOW("REDISQL.EXEC.NOW"),
        QUERY("REDISQL.QUERY"),
        QUERY_NOW("REDISQL.QUERY.NOW"),
        QUERY_INTO("REDISQL.QUERY.INTO"),
        QUERY_INTO_NOW("REDISQL.QUERY.INTO.NOW"),
        CREATE_STATEMENT("REDISQL.CREATE_STATEMENT"),
        CREATE_STATEMENT_NOW("REDISQL.CREATE_STATEMENT.NOW"),
        EXEC_STATEMENT("REDISQL.EXEC_STATEMENT"),
        EXEC_STATEMENT_NOW("REDISQL.EXEC_STATEMENT.NOW"),
        QUERY_STATEMENT("REDISQL.QUERY_STATEMENT"),
        QUERY_STATEMENT_NOW("REDISQL.QUERY_STATEMENT.NOW"),
        QUERY_STATEMENT_INTO("REDISQL.QUERY_STATEMENT.INTO"),
        QUERY_STATEMENT_INTO_NOW("REDISQL.QUERY_STATEMENT.INTO.NOW"),
        DELETE_STATEMENT("REDISQL.DELETE_STATEMENT"),
        DELETE_STATEMENT_NOW("REDISQL.DELETE_STATEMENT.NOW"),
        UPDATE_STATEMENT("REDISQL.UPDATE_STATEMENT"),
        UPDATE_STATEMENT_NOW("REDISQL.UPDATE_STATEMENT.NOW"),
        COPY("REDISQL.COPY"),
        COPY_NOW("REDISQ.COPY.NOW"),
        STATISTICS("REDISQL.STATISTICS"),
        VERSION("REDISQL.VERSION");

        private final byte[] raw;

        ModuleCommand(String command) {
            raw = SafeEncoder.encode(command);
        }

        public byte[] getRaw() {
            return raw;
        }
    }
}
