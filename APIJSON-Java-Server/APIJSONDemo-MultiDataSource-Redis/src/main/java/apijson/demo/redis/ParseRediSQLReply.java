package apijson.demo.redis;

import java.util.List;

public class ParseRediSQLReply {
    public static boolean done_reply(List<Object> reply) {
        if (reply.size() != 2) { return false; }
        if ((reply.get(0) instanceof byte[]) && (new String((byte[])reply.get(0)).equals("DONE"))) {
            return (reply.get(1) instanceof Long);
        }
        return false;
    }

    public static Long how_many_done(List<Object> reply)  {
        if (reply == null || reply.size() == 0 ||done_reply(reply) == false) {
            return 0L;
        }
        return (Long)reply.get(1);
    }

    public static boolean is_integer(Object o) {
        return (o instanceof Long);
    }

    public static Long get_integer(Object o) {
        return (Long) o;
    }

    public static boolean is_string(Object o) {
        return (o instanceof byte[]);
    }

    public static String get_string(Object o) {
        return new String((byte[])o);
    }

    public static boolean is_list(Object o) {
        return (o instanceof List);
    }


}
