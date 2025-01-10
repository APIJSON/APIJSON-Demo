create table "Function"
(
    id           bigint                                 not null
        primary key,
    language     varchar,
    name         varchar(30)                            not null,
    "returnType" varchar(45)  default 'Object'::character varying,
    arguments    varchar(100),
    demo         text                                   not null,
    detail       varchar(1000),
    date         timestamp(6) default CURRENT_TIMESTAMP not null,
    "userId"     bigint       default 0,
    version      integer      default 0,
    tag          varchar,
    methods      varchar,
    return       integer
);

comment on column "Function".name is '方法名';

comment on column "Function".arguments is '参数列表，每个参数的类型都是 String。
用 , 分割的字符串 比 [JSONArray] 更好，例如 array,item ，更直观，还方便拼接函数。';

comment on column "Function".demo is '可用的示例。';

comment on column "Function".detail is '详细描述';

comment on column "Function".date is '创建时间';

comment on column "Function"."userId" is '用户id';

comment on column "Function"."returnType" is '返回类型';

comment on column "Function".language is '语言：Java(java), JavaScript(js), Lua(lua), Python(py), Ruby(ruby), PHP(php) 等，NULL 默认为 Java，JDK 1.6-11 默认支持 JavaScript，JDK 12+ 需要额外依赖 Nashron/Rhiro 等 js 引擎库，其它的语言需要依赖对应的引擎库，并在 ScriptEngineManager 中注册';

comment on column "Function".return is '返回值示例';

comment on column "Function".version is '允许的最低版本号，只限于GET,HEAD外的操作方法。\nTODO 使用 requestIdList 替代 version,tag,methods';

comment on column "Function".tag is '允许的标签.\nnull - 允许全部\nTODO 使用 requestIdList 替代 version,tag,methods';

comment on column "Function".methods is '允许的操作方法。\nnull - 允许全部\nTODO 使用 requestIdList 替代 version,tag,methods';



insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (8, 'getFromArray', 'array,position', '{"array": [1, 2, 3], "result()": "getFromArray(array,1)"}', '根据下标获取数组里的值。position 传数字时直接作为值，而不是从所在对象 request 中取值', '2018-10-13 08:30:31.000000', 0, 'Object', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (9, 'getFromObject', 'object,key', '{"key": "id", "object": {"id": 1}}', '根据键获取对象里的值。', '2018-10-13 08:30:31.000000', 0, 'Object', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (13, 'getWithDefault', 'value,defaultValue', '{"value": null, "defaultValue": 1}', '如果 value 为 null，则返回 defaultValue', '2019-08-20 15:26:36.000000', 0, 'Object', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (14, 'removeKey', 'key', '{"key": "s", "key2": 2}', '从对象里移除 key', '2019-08-20 15:26:36.000000', 0, 'Object', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (6, 'isContainKey', 'object,key', '{"key": "id", "object": {"id": 1}}', '判断是否对象包含键。', '2018-10-13 08:30:31.000000', 0, 'boolean', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (4, 'countObject', 'object', '{"object": {"key0": 1, "key1": 2}}', '获取对象长度。', '2018-10-13 08:23:23.000000', 0, 'int', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (10, 'deleteCommentOfMoment', 'momentId', '{"momentId": 1}', '根据动态 id 删除它的所有评论', '2019-08-17 18:46:56.000000', 0, 'int', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (23, 'getCurrentUserIdAsList', null, '{}', '获取当前登录用户 id 列表，只包含一个 id，只是为了前端方便构造某些请求', '2023-01-30 07:47:29.546907', 0, 'List', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (19, 'getMethodArguments', 'methodArgs', '{"methodArgs": "methodArgs"}', '获取远程函数的参数', '2023-01-30 07:47:29.546907', 0, 'String', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (21, 'deleteChildComment', 'commentId', '{}', '删除评论的子评论', '2023-01-30 07:47:29.546907', 0, 'int', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (20, 'getMethodRequest', null, '{}', '获取远程函数的请求', '2023-01-30 07:47:29.546907', 0, 'String', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (17, 'getMethodDefinition', 'method,arguments,type,exceptions,language', '{"method": "method"}', '获取远程函数的签名定义', '2023-01-30 12:04:42.000000', 0, 'String', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (3, 'countArray', 'array', '{"array": [1, 2, 3]}', '获取数组长度。没写调用键值对，会自动补全 "result()": "countArray(array)"', '2018-10-13 08:23:23.000000', 0, 'int', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (11, 'verifyIdList', 'array', '{"array": [1, 2, 3], "result()": "verifyIdList(array)"}', '校验类型为 id 列表', '2019-08-17 19:58:33.000000', 0, null, null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (22, 'getCurrentUserId', null, '{}', '获取当前登录用户 id', '2023-01-30 07:47:29.546907', 0, 'Long', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (18, 'getMethodDefination', 'method,arguments,type,exceptions,language', '{"method": "method"}', '获取远程函数的签名定义', '2023-01-30 04:05:54.754726', 0, 'String', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (16, 'getFunctionDetail', null, '{}', '获取远程函数的详情', '2019-08-20 15:26:36.000000', 0, 'String', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (7, 'isContainValue', 'object,value', '{"value": 1, "object": {"id": 1}}', '判断是否对象包含值。', '2018-10-13 08:30:31.000000', 0, 'boolean', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (24, 'getCurrentUser', null, '{}', '获取当前登录用户公开信息', '2023-01-30 07:47:29.546907', 0, 'Visitor', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (15, 'getFunctionDemo', null, '{}', '获取远程函数的 Demo', '2019-08-20 15:26:36.000000', 0, 'JSONObject', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (5, 'isContain', 'array,value', '{"array": [1, 2, 3], "value": 2}', '判断是否数组包含值。', '2018-10-13 08:23:23.000000', 0, 'boolean', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (25, 'getCurrentContactIdList', null, '{}', '获取当前登录用户的联系人 id 列表', '2023-01-30 07:47:29.546907', 0, 'List', null, null, 0, null, null);
insert into "Function" (id, name, arguments, demo, detail, date, "userId", "returnType", language, return, version, tag, methods) values (12, 'verifyURLList', 'array', '{"array": ["http://123.com/1.jpg", "http://123.com/a.png", "http://www.abc.com/test.gif"], "result()": "verifyURLList(array)"}', '校验类型为 URL 列表', '2019-08-17 19:58:33.000000', 0, null, null, null, 0, null, null);
