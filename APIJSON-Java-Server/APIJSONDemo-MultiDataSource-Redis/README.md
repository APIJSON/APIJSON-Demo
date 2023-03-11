# APIJSONDemo

## 支持多数据源-redis、rediSQL
redis cluster、sentinel、single模式

## 具体使用
抽空补充到 auto apijson, 方便大家在线测试
### post
```js

// redis command
//string
{
	"@datasource": "redisCluster",
    "REDIS_STRING":{
        "key": "b",
        "value": "b",
        "option_method": "set"
    },
    "tag": "REDIS_STRING",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_KEYS":{
        "key": "b",
        "expire_time": "50",
        "option_method": "expire"
    },
    "tag": "REDIS_KEYS",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_STRING":{
        "key": "b2",
        "value": "b2",
        "option_method": "setnx"
    },
    "tag": "REDIS_STRING",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_STRING":{
        "key": "b,b,a,a",
        "option_method": "mset"
    },
    "tag": "REDIS_STRING",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_STRING":{
        "key": "b,b,a,a",
        "option_method": "msetnx"
    },
    "tag": "REDIS_STRING",
    "format": true
}
// hash
{
	"@datasource": "redisCluster",
    "REDIS_HASH":{
        "key": "hs_1",
        "index": "a",
        "value": 1,
        "option_method": "hset"
    },
    "tag": "REDIS_HASH",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_HASH":{
        "key": "hs_1",
        "value": "{'a':'a1','b':'b1'}",
        "option_method": "hmset"
    },
    "tag": "REDIS_HASH",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_HASH":{
        "key": "hs_1",
        "index": "a22",
        "value": "1",
        "option_method": "hsetnx"
    },
    "tag": "REDIS_HASH",
    "format": true
}

// list
{
	"@datasource": "redisCluster",
    "REDIS_LIST":{
        "key": "list",
        "value": [2323,23],
        "option_method": "lpush"
    },
    "tag": "REDIS_LIST",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_LIST":{
        "key": "list",
        "value": "11",
        "index": 1,
        "option_method": "lset"
    },
    "tag": "REDIS_LIST",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_LIST":{
        "key": "list",
        "index": "BEFORE",
        "value": ["3","3-4"],
        "option_method": "linsert"
    },
    "tag": "REDIS_LIST",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_LIST":{
        "key": "list",
        "value": ["3","22"],
        "option_method": "rpush"
    },
    "tag": "REDIS_LIST",
    "format": true
}

//set

{
	"@datasource": "redisCluster",
    "REDIS_SET":{
        "key": "set",
        "value": ["3","22"],
        "option_method": "sadd"
    },
    "tag": "REDIS_SET",
    "format": true
}

// zset

{
	"@datasource": "redisCluster",
    "REDIS_ZSET":{
        "key": "zset",
        "value": "{\"a2\":1.03,\"b2\":1.04}",
        "option_method": "zadd"
    },
    "tag": "REDIS_ZSET",
    "format": true
}
```
### put
```js
// redis command
//string

{
	"@datasource": "redisCluster",
    "REDIS_KEYS:del": {
        "key": "b",
        "option_method": "persist"
    },
    "tag": "REDIS_KEYS",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_KEYS:del": {
        "key{}": ["b","b1"],
        "option_method": "rename"
    },
    "tag": "REDIS_KEYS",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_STRING":{
        "key": "b",
        "expire_time": "50",
        "value": "b1",
        "option_method": "setex"
    },
    "tag": "REDIS_STRING",
    "format": true
}


{
	"@datasource": "redisCluster",
    "REDIS_STRING":{
        "key": "b",
        "value": "append",
        "option_method": "append"
    },
    "tag": "REDIS_STRING",
    "format": true
}


{
	"@datasource": "redisCluster",
    "REDIS_STRING:incr":{
        "key": "int",
        "option_method": "incr"
    },
    "tag": "REDIS_STRING",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_STRING": {
    	"key": "int",
        "option_method": "decr"
    },
    "tag": "REDIS_STRING",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_STRING": {
    	"key": "int",
        "value": 2,
        "option_method": "incrby"
    },
    "tag": "REDIS_STRING",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_STRING": {
    	"key": "int",
        "value": 2,
        "option_method": "decrby"
    },
    "tag": "REDIS_STRING",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_STRING": {
    	"key": "int",
        "value": 2,
        "option_method": "decrby"
    },
    "tag": "REDIS_STRING",
    "format": true
}

// hash
{
	"@datasource": "redisCluster",
    "REDIS_HASH":{
        "key": "hs_1",
        "index": "c",
        "value": 2,
        "option_method": "hincrby"
    },
    "tag": "REDIS_HASH",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_LIST":{
        "key": "list",
        "index{}": [0,1],
        "option_method": "ltrim"
    },
    "tag": "REDIS_LIST",
    "format": true
}

```

### get
```js
// redis command
//string

{
	"@datasource": "redisCluster",
    "REDIS_STRING:a": {
    	"key": "b",
        "option_method": "get"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_KEYS:a": {
    	"key": "b",
        "option_method": "exists"
    },
    "format": true
}

// keys
{
	"@datasource": "redisCluster",
    "REDIS_KEYS[]": {
        "REDIS_KEYS": {
        	"key": "b*",
        	"option_method": "keys"
        },
        "page": 0,
        "count": 10
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_KEYS:a": {
    	"key": "b",
        "option_method": "timeToLive"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_KEYS:a": {
    	"key": "b",
        "option_method": "type"
    },
    "format": true
}


{
	"@datasource": "redisCluster",
    "REDIS_STRING:a": {
    	"key{}": ["b","a"],
        "option_method": "mget"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_STRING:a": {
    	"key": "b",
        "option_method": "strlen"
    },
    "format": true
}
//hash

{
	"@datasource": "redisCluster",
    "REDIS_HASH:a": {
    	"key": "hs_1",
        "index": "a",
        "option_method": "hexists"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_HASH:a": {
    	"key": "hs_1",
        "index": "a",
        "option_method": "hget"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_HASH:a": {
    	"key": "hs_1",
        "option_method": "hgetall"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_HASH:a": {
    	"key": "hs_1",
        "option_method": "hkeys"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_HASH:a": {
    	"key": "hs_1",
        "option_method": "hlen"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_HASH:a": {
    	"key": "hs_1",
        "index{}": ["a","b1"],
        "option_method": "hmget"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_HASH:a": {
    	"key": "hs_1",
        "option_method": "hvals"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_LIST": {
        "key": "list",
        "index{}": [0,20],
        "option_method": "lrange"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_LIST": {
        "key": "list",
        "expire_time": 3,
        "option_method": "blpop"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_LIST": {
        "key": "list",
        "expire_time": 3,
        "option_method": "brpop"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_LIST:data": {
        "key": "list",
        "index": 1,
        "option_method": "lindex"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_LIST": {
        "key": "list",
        "option_method": "llen"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_LIST": {
        "key": "list",
        "option_method": "lpop"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_LIST":{
        "key": "list",
        "option_method": "rpop"
    },
    "tag": "REDIS_LIST",
    "format": true
}

// set

{
	"@datasource": "redisCluster",
    "REDIS_SET": {
        "key": "set",
        "option_method": "scard"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_SET": {
        "key": "set",
        "value": "22",
        "option_method": "sismember"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_SET": {
        "key": "set",
        "option_method": "smembers"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_SET": {
        "key": "set",
        "index": 2,
        "option_method": "spop"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_SET": {
        "key": "set",
        "index": 2,
        "option_method": "srandmember"
    },
    "format": true
}

{
	"@datasource": "redisSingle",
    "REDIS_SET": {
        "key{}": ["set","set1"],
        "option_method": "sinter"
    },
    "format": true
}

{
	"@datasource": "redisSingle",
    "REDIS_SET": {
        "key{}": ["set","set1"],
        "option_method": "sunion"
    },
    "format": true
}

{
	"@datasource": "redisSingle",
    "REDIS_SET": {
        "key{}": ["set","set1"],
        "option_method": "sdiff"
    },
    "format": true
}

//zset

{
	"@datasource": "redisCluster",
    "REDIS_ZSET": {
        "key": "zset",
        "option_method": "zcard"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_ZSET": {
        "key": "zset",
        "score{}": [1.0, 1.01],
        "option_method": "zcount"
    },
    "format": true
}


{
	"@datasource": "redisCluster",
    "REDIS_ZSET":{
        "key": "zset",
        "score": 2.0,
        "value": "a31",
        "option_method": "zincrby"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_ZSET":{
        "key": "zset",
        "index{}": [0,-1],
        "option_method": "zrange"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_ZSET":{
        "key": "zset",
        "index{}": ["-","+"],
        "option_method": "zlexcount"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_ZSET":{
        "key": "zset",
        "score{}": [1,1.21],
        "option_method": "zrangeByScore"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_ZSET":{
        "key": "zset",
        "index{}": ["-","(c"],
        "option_method": "zrangeByLex"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_ZSET":{
        "key": "zset",
        "value": "a2",
        "option_method": "zrank"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_ZSET":{
        "key": "zset",
        "index{}": ["-","(c"],
        "option_method": "zrangeByLex"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_ZSET":{
        "key": "zset",
        "index{}": [0,-1],
        "option_method": "zrevrange"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_ZSET":{
        "key": "salary",
        "score{}": [10000,2000],
        "option_method": "zrevrangeByScore"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_ZSET":{
        "key": "salary",
        "value": "peter",
        "option_method": "zrevrank"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_ZSET":{
        "key": "salary",
        "value": "peter",
        "option_method": "zscore"
    },
    "format": true
}

{
	"@datasource": "redisSentinel",
    "REDIS_ZSET":{
        "key": "zset",
        "option_method": "zscan"
    },
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_KEYS":{
        "key": "c*",
        "option_method": "scan"
    },
    "format": true
}

{
	"@datasource": "redisSingle",
    "REDIS_SET":{
        "key": "set",
        "option_method": "sscan"
    },
    "format": true
}

{
	"@datasource": "redisSentinel",
    "REDIS_HASH":{
        "key": "hs_1",
        "option_method": "hscan"
    },
    "format": true
}

```

### delete
```js
// redis command
//string
{
	"@datasource": "redisCluster",
    "REDIS_KEYS:del": {
        "key": "b",
        "option_method": "del"
    },
    "tag": "REDIS_KEYS",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_KEYS:del": {
        "key": "b",
        "option_method": "persist"
    },
    "tag": "REDIS_KEYS",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_KEYS:del": {
        "key": "b",
        "option_method": "del"
    },
    "tag": "REDIS_KEYS",
    "format": true
}

// hash
{
	"@datasource": "redisCluster",
    "REDIS_HASH:a": {
    	"key": "hs_1",
        "index{}": ["a"],
        "option_method": "hdel"
    },
    "tag": "REDIS_HASH",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_LIST:a": {
    	"key": "list",
        "index": 2,
        "value": "3-4",
        "option_method": "lrem"
    },
    "tag": "REDIS_LIST",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_ZSET:a": {
    	"key": "zset",
        "value{}": ["a3","a31"],
        "option_method": "zrem"
    },
    "tag": "REDIS_ZSET",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_ZSET:a": {
    	"key": "myzset",
        "index{}": ["[alpha","[omega"],
        "option_method": "zremrangeByLex"
    },
    "tag": "REDIS_ZSET",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_ZSET:a": {
    	"key": "zset",
        "index{}": [0,1],
        "option_method": "zremrangeByRank"
    },
    "tag": "REDIS_ZSET",
    "format": true
}

{
	"@datasource": "redisCluster",
    "REDIS_ZSET:a": {
    	"key": "zset",
        "score{}": [1.0,4.1],
        "option_method": "zremrangebyscore"
    },
    "tag": "REDIS_ZSET",
    "format": true
}
```

## Access表
```sql
INSERT INTO `housekeeping`.`access` (`id`, `debug`, `name`, `alias`, `get`, `head`, `gets`, `heads`, `post`, `put`, `delete`, `date`, `detail`, `appId`, `userId`, `deletedKey`, `deletedValue`) VALUES (70, 0, 'REDIS_STRING', NULL, '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '2022-12-23 17:41:40', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `housekeeping`.`access` (`id`, `debug`, `name`, `alias`, `get`, `head`, `gets`, `heads`, `post`, `put`, `delete`, `date`, `detail`, `appId`, `userId`, `deletedKey`, `deletedValue`) VALUES (72, 0, 'REDIS_KEYS', NULL, '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '2022-12-24 10:19:29', 'redis', '123', '4732209c-5785-4827-b532-5092f154fd94', NULL, NULL);
INSERT INTO `housekeeping`.`access` (`id`, `debug`, `name`, `alias`, `get`, `head`, `gets`, `heads`, `post`, `put`, `delete`, `date`, `detail`, `appId`, `userId`, `deletedKey`, `deletedValue`) VALUES (73, 0, 'REDIS_LIST', NULL, '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '2022-12-25 12:53:01', 'redis', '123', '4732209c-5785-4827-b532-5092f154fd94', NULL, NULL);
INSERT INTO `housekeeping`.`access` (`id`, `debug`, `name`, `alias`, `get`, `head`, `gets`, `heads`, `post`, `put`, `delete`, `date`, `detail`, `appId`, `userId`, `deletedKey`, `deletedValue`) VALUES (74, 0, 'REDIS_HASH', NULL, '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '2022-12-25 12:53:17', 'redis', '123', '4732209c-5785-4827-b532-5092f154fd94', NULL, NULL);
INSERT INTO `housekeeping`.`access` (`id`, `debug`, `name`, `alias`, `get`, `head`, `gets`, `heads`, `post`, `put`, `delete`, `date`, `detail`, `appId`, `userId`, `deletedKey`, `deletedValue`) VALUES (75, 0, 'REDIS_SET', NULL, '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '2022-12-25 12:53:24', 'redis', '123', '4732209c-5785-4827-b532-5092f154fd94', NULL, NULL);
INSERT INTO `housekeeping`.`access` (`id`, `debug`, `name`, `alias`, `get`, `head`, `gets`, `heads`, `post`, `put`, `delete`, `date`, `detail`, `appId`, `userId`, `deletedKey`, `deletedValue`) VALUES (76, 0, 'REDIS_ZSET', NULL, '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"LOGIN\",\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '[\"OWNER\", \"ADMIN\"]', '2022-12-25 12:53:31', 'redis', '123', '4732209c-5785-4827-b532-5092f154fd94', NULL, NULL);

```

## Request表
```sql
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (188, 0, 1, 'POST', 'REDIS_KEYS', '{\"UPDATE\": {\"@role\": \"OWNER,ADMIN\",\"@combine\": \"key,keys\"}, \"REFUSE\": \"id\"}', '新增', '2022-12-24 10:21:00', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (189, 0, 1, 'POST', 'REDIS_KEYS[]', '{\"REDIS_KEYS[]\": [{\"REFUSE\": \"id\"}], \"UPDATE\": {\"@role\": \"OWNER,ADMIN\",\"@combine\": \"key,keys\"}}', '批量新增', '2022-12-24 10:21:00', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (190, 0, 1, 'PUT', 'REDIS_KEYS', '{\"REDIS_KEYS\":{ \"REFUSE\": \"userId\", \"INSERT\": {\"@role\": \"OWNER,ADMIN\",\"@combine\": \"key,keys\"}} }', '修改', '2022-12-24 10:21:00', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (191, 0, 1, 'DELETE', 'REDIS_KEYS', '{\"REDIS_KEYS\":{\"INSERT\": {\"@role\": \"OWNER,ADMIN\",\"@combine\": \"key,keys\"}} }', '批量删除', '2022-12-24 10:21:00', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (192, 0, 1, 'POST', 'REDIS_HASH', '{\"UPDATE\": {\"@role\": \"OWNER,ADMIN\",\"@combine\": \"key,keys\"}, \"REFUSE\": \"id\"}', '新增', '2022-12-25 12:54:53', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (193, 0, 1, 'POST', 'REDIS_HASH[]', '{\"REDIS_HASH[]\": [{\"REFUSE\": \"id\"}], \"UPDATE\": {\"@role\": \"OWNER,ADMIN\",\"@combine\": \"key,keys\"}}', '批量新增', '2022-12-25 12:54:53', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (194, 0, 1, 'PUT', 'REDIS_HASH', '{\"REDIS_HASH\":{ \"REFUSE\": \"userId\", \"INSERT\": {\"@role\": \"OWNER,ADMIN\",\"@combine\": \"key,keys\"}} }', '修改', '2022-12-25 12:54:53', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (195, 0, 1, 'DELETE', 'REDIS_HASH', '{\"REDIS_HASH\":{\"INSERT\": {\"@role\": \"OWNER,ADMIN\",\"@combine\": \"key,keys\"}} }', '批量删除', '2022-12-25 12:54:53', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (196, 0, 1, 'POST', 'REDIS_LIST', '{\"UPDATE\": {\"@role\": \"OWNER,ADMIN\",\"@combine\": \"key,keys\"}, \"REFUSE\": \"id\"}', '新增', '2022-12-25 12:55:15', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (197, 0, 1, 'POST', 'REDIS_LIST[]', '{\"REDIS_LIST[]\": [{\"REFUSE\": \"id\"}], \"UPDATE\": {\"@role\": \"OWNER,ADMIN\",\"@combine\": \"key,keys\"}}', '批量新增', '2022-12-25 12:55:15', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (198, 0, 1, 'PUT', 'REDIS_LIST', '{\"REDIS_LIST\":{ \"REFUSE\": \"userId\", \"INSERT\": {\"@role\": \"OWNER,ADMIN\",\"@combine\": \"key,keys\"}} }', '修改', '2022-12-25 12:55:15', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (199, 0, 1, 'DELETE', 'REDIS_LIST', '{\"REDIS_LIST\":{\"INSERT\": {\"@role\": \"OWNER,ADMIN\",\"@combine\": \"key,keys\"}} }', '批量删除', '2022-12-25 12:55:15', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (200, 0, 1, 'POST', 'REDIS_SET', '{\"UPDATE\": {\"@role\": \"OWNER,ADMIN\"}, \"REFUSE\": \"id\"}', '新增', '2022-12-25 12:55:34', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (201, 0, 1, 'POST', 'REDIS_SET[]', '{\"REDIS_SET[]\": [{\"REFUSE\": \"id\"}], \"UPDATE\": {\"@role\": \"OWNER,ADMIN\"}}', '批量新增', '2022-12-25 12:55:34', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (202, 0, 1, 'PUT', 'REDIS_SET', '{\"REDIS_SET\":{ \"REFUSE\": \"userId\", \"INSERT\": {\"@role\": \"OWNER,ADMIN\",\"@combine\": \"key,keys\"}} }', '修改', '2022-12-25 12:55:34', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (203, 0, 1, 'DELETE', 'REDIS_SET', '{\"REDIS_SET\":{\"INSERT\": {\"@role\": \"OWNER,ADMIN\"}} }', '批量删除', '2022-12-25 12:55:34', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (204, 0, 1, 'POST', 'REDIS_ZSET', '{\"UPDATE\": {\"@role\": \"OWNER,ADMIN\"}, \"REFUSE\": \"id\"}', '新增', '2022-12-25 12:55:51', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (205, 0, 1, 'POST', 'REDIS_ZSET[]', '{\"REDIS_ZSET[]\": [{\"REFUSE\": \"id\"}], \"UPDATE\": {\"@role\": \"OWNER,ADMIN\"}}', '批量新增', '2022-12-25 12:55:51', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (206, 0, 1, 'PUT', 'REDIS_ZSET', '{\"REDIS_ZSET\":{ \"REFUSE\": \"userId\", \"INSERT\": {\"@role\": \"OWNER,ADMIN\",\"@combine\": \"key,keys\"}} }', '修改', '2022-12-25 12:55:51', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (207, 0, 1, 'DELETE', 'REDIS_ZSET', '{\"REDIS_ZSET\":{\"INSERT\": {\"@role\": \"OWNER,ADMIN\"}} }', '批量删除', '2022-12-25 12:55:51', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (208, 0, 1, 'POST', 'REDIS_STRING', '{\"UPDATE\": {\"@role\": \"OWNER,ADMIN\"}, \"REFUSE\": \"id\"}', '新增', '2022-12-25 13:16:23', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (209, 0, 1, 'POST', 'REDIS_STRING[]', '{\"REDIS_STRING[]\": [{\"REFUSE\": \"id\"}], \"UPDATE\": {\"@role\": \"OWNER,ADMIN\"}}', '批量新增', '2022-12-25 13:16:23', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (210, 0, 1, 'PUT', 'REDIS_STRING', '{\"REDIS_STRING\":{ \"REFUSE\": \"userId\", \"INSERT\": {\"@role\": \"OWNER,ADMIN\",\"@combine\": \"key,keys\"}} }', '修改', '2022-12-25 13:16:23', '2332', '4732209c-5785-4827-b532-5092f154fd94');
INSERT INTO `housekeeping`.`request` (`id`, `debug`, `version`, `method`, `tag`, `structure`, `detail`, `date`, `appId`, `userId`) VALUES (211, 0, 1, 'DELETE', 'REDIS_STRING', '{\"REDIS_STRING\":{\"INSERT\": {\"@role\": \"OWNER,ADMIN\"}} }', '批量删除', '2022-12-25 13:16:23', '2332', '4732209c-5785-4827-b532-5092f154fd94');
```
## 备注
APIJSON版本需要支持@combine 动态条件 <br/>
也可以改成spring boot redis配置, applicationContext.getBean(name);方式操作 redis




