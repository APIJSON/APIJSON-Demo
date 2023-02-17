package com.redbeardlab.redisql.client;

import redis.clients.jedis.HostAndPort;
import redis.clients.jedis.JedisShardInfo;
import redis.clients.jedis.commands.ProtocolCommand;
import redis.clients.jedis.util.SafeEncoder;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLParameters;
import javax.net.ssl.SSLSocketFactory;
import java.lang.reflect.Array;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;

public class RediSQLClient extends redis.clients.jedis.Jedis {

    public RediSQLClient() { super(); }
    public RediSQLClient(final String host) { super(host); }
    public RediSQLClient(final HostAndPort hp) { super(hp); }

    public RediSQLClient(String host, int port) {
        super(host, port);
    }

    public RediSQLClient(String host, int port, boolean ssl) {
        super(host, port, ssl);
    }

    public RediSQLClient(String host, int port, boolean ssl, SSLSocketFactory sslSocketFactory, SSLParameters sslParameters, HostnameVerifier hostnameVerifier) {
        super(host, port, ssl, sslSocketFactory, sslParameters, hostnameVerifier);
    }

    public RediSQLClient(String host, int port, int timeout) {
        super(host, port, timeout);
    }

    public RediSQLClient(String host, int port, int timeout, boolean ssl) {
        super(host, port, timeout, ssl);
    }

    public RediSQLClient(String host, int port, int timeout, boolean ssl, SSLSocketFactory sslSocketFactory, SSLParameters sslParameters, HostnameVerifier hostnameVerifier) {
        super(host, port, timeout, ssl, sslSocketFactory, sslParameters, hostnameVerifier);
    }

    public RediSQLClient(String host, int port, int connectionTimeout, int soTimeout) {
        super(host, port, connectionTimeout, soTimeout);
    }

    public RediSQLClient(String host, int port, int connectionTimeout, int soTimeout, boolean ssl) {
        super(host, port, connectionTimeout, soTimeout, ssl);
    }

    public RediSQLClient(String host, int port, int connectionTimeout, int soTimeout, boolean ssl, SSLSocketFactory sslSocketFactory, SSLParameters sslParameters, HostnameVerifier hostnameVerifier) {
        super(host, port, connectionTimeout, soTimeout, ssl, sslSocketFactory, sslParameters, hostnameVerifier);
    }

    public RediSQLClient(JedisShardInfo shardInfo) {
        super(shardInfo);
    }

    public RediSQLClient(URI uri) {
        super(uri);
    }

    public RediSQLClient(URI uri, SSLSocketFactory sslSocketFactory, SSLParameters sslParameters, HostnameVerifier hostnameVerifier) {
        super(uri, sslSocketFactory, sslParameters, hostnameVerifier);
    }

    public RediSQLClient(URI uri, int timeout) {
        super(uri, timeout);
    }

    public RediSQLClient(URI uri, int timeout, SSLSocketFactory sslSocketFactory, SSLParameters sslParameters, HostnameVerifier hostnameVerifier) {
        super(uri, timeout, sslSocketFactory, sslParameters, hostnameVerifier);
    }

    public RediSQLClient(URI uri, int connectionTimeout, int soTimeout) {
        super(uri, connectionTimeout, soTimeout);
    }

    public RediSQLClient(URI uri, int connectionTimeout, int soTimeout, SSLSocketFactory sslSocketFactory, SSLParameters sslParameters, HostnameVerifier hostnameVerifier) {
        super(uri, connectionTimeout, soTimeout, sslSocketFactory, sslParameters, hostnameVerifier);
    }


    private String ok_returns(RediSQLCommand.ModuleCommand cmd, String... args) {
        client.sendCommand(cmd, args);
        return client.getBulkReply();
    }

    private List<Object> list_returns(RediSQLCommand.ModuleCommand cmd, String... args) {
        client.sendCommand(cmd, args);
        return client.getObjectMultiBulkReply();
    }

    public String create_db(String db) {
        return ok_returns(RediSQLCommand.ModuleCommand.CREATE_DB, db);
    }

    public String create_db(String db, String file_path) {
        return ok_returns(RediSQLCommand.ModuleCommand.CREATE_DB, db, file_path);
    }

    public List<Object> exec(String db, String query) {
        return list_returns(RediSQLCommand.ModuleCommand.EXEC, db, query);
    }

    public List<Object> exec_now(String db, String query) {
        return list_returns(RediSQLCommand.ModuleCommand.EXEC_NOW, db, query);
    }

    public List<Object> query(String db, String query) {
        return list_returns(RediSQLCommand.ModuleCommand.QUERY, db, query);
    }

    public List<Object> query_now(String db, String query) {
        return list_returns(RediSQLCommand.ModuleCommand.QUERY_NOW, db, query);
    }

    public List<Object> query_into(String stream, String db, String query) {
        return list_returns(RediSQLCommand.ModuleCommand.QUERY_INTO, stream, db, query);
    }

    public List<Object> query_into_now(String stream, String db, String query) {
        return list_returns(RediSQLCommand.ModuleCommand.QUERY_INTO_NOW, stream, db, query);
    }

    public String create_statement(String db, String stmt_name, String stmt_query) {
        return ok_returns(RediSQLCommand.ModuleCommand.CREATE_STATEMENT, db, stmt_name, stmt_query);
    }

    public String create_statement_now(String db, String stmt_name, String stmt_query) {
        return ok_returns(RediSQLCommand.ModuleCommand.CREATE_STATEMENT_NOW, db, stmt_name, stmt_query);
    }

     public List<Object> exec_statement(String... args) {
        return list_returns(RediSQLCommand.ModuleCommand.EXEC_STATEMENT, args);
    }

    public List<Object> exec_statement_now(String... args) {
        return list_returns(RediSQLCommand.ModuleCommand.EXEC_STATEMENT_NOW, args);
    }

    public List<Object> query_statement(String... args) {
        return list_returns(RediSQLCommand.ModuleCommand.QUERY_STATEMENT, args);
    }

    public List<Object> query_statement_now(String... args) {
        return list_returns(RediSQLCommand.ModuleCommand.QUERY_STATEMENT_NOW, args);
    }

    public List<Object> query_statement_into(String... args) {
        return list_returns(RediSQLCommand.ModuleCommand.QUERY_STATEMENT_INTO, args);
    }

    public List<Object> query_statement_into_now(String... args) {
        return list_returns(RediSQLCommand.ModuleCommand.QUERY_STATEMENT_INTO_NOW, args);
    }

    public String delete_statement(String db, String stmt_name) {
        return ok_returns(RediSQLCommand.ModuleCommand.DELETE_STATEMENT, db, stmt_name);
    }

    public String delete_statement_now(String db, String stmt_name) {
        return ok_returns(RediSQLCommand.ModuleCommand.DELETE_STATEMENT_NOW, db, stmt_name);
    }

    public String update_statement(String db, String stmt_name, String stmt_query) {
        return ok_returns(RediSQLCommand.ModuleCommand.UPDATE_STATEMENT, db, stmt_name, stmt_query);
    }

    public String update_statement_now(String db, String stmt_name, String stmt_query) {
        return ok_returns(RediSQLCommand.ModuleCommand.UPDATE_STATEMENT_NOW, db, stmt_name, stmt_query);
    }

    public String copy(String db1, String db2) {
        return ok_returns(RediSQLCommand.ModuleCommand.COPY, db1, db2);
    }

    public String copy_now(String db1, String db2) {
        return ok_returns(RediSQLCommand.ModuleCommand.COPY_NOW, db1, db2);
    }

    public List<Object> statistics() {
        return list_returns(RediSQLCommand.ModuleCommand.STATISTICS);
    }

    public String version(String db1, String db2) {
        return ok_returns(RediSQLCommand.ModuleCommand.VERSION);
    }



}

