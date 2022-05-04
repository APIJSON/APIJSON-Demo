create table "Function"
(
    id          bigint                                 not null
        primary key,
    debug       integer      default 0                 not null,
    name        varchar(30)                            not null,
    type        varchar(45)  default 'Object'::character varying,
    arguments   varchar(100),
    demo        text                                   not null,
    detail      varchar(1000),
    date        timestamp(6) default CURRENT_TIMESTAMP not null,
    back        varchar(45),
    requestlist varchar(45),
    "userId"    bigint       default 0
);

comment on table "Function" is '远程函数。强制在启动时校验所有demo是否能正常运行通过';

comment on column "Function".id is '唯一标识';

comment on column "Function".debug is '是否为 DEBUG 调试数据，只允许在开发环境使用，测试和线上环境禁用：0-否，1-是。';

comment on column "Function".name is '方法名';

comment on column "Function".type is '返回类型';

comment on column "Function".arguments is '参数列表，每个参数的类型都是 String。
用 , 分割的字符串 比 [JSONArray] 更好，例如 array,item ，更直观，还方便拼接函数。';

comment on column "Function".demo is '可用的示例。';

comment on column "Function".detail is '详细描述';

comment on column "Function".date is '创建时间';

comment on column "Function".back is '返回类型';

comment on column "Function".requestlist is 'Request 的 id 列表';

comment on column "Function"."userId" is '用户id';

alter table "Function"
    owner to postgres;

INSERT INTO sys."Function" (id, debug, name, type, arguments, demo, detail, date, back, requestlist, "userId") VALUES (3, 0, 'countArray', 'Object', 'array', '{"array": [1, 2, 3]}', '获取数组长度。没写调用键值对，会自动补全 "result()": "countArray(array)"', '2018-10-13 08:23:23.000000', null, null, 0);
INSERT INTO sys."Function" (id, debug, name, type, arguments, demo, detail, date, back, requestlist, "userId") VALUES (4, 0, 'countObject', 'Object', 'object', '{"object": {"key0": 1, "key1": 2}}', '获取对象长度。', '2018-10-13 08:23:23.000000', null, null, 0);
INSERT INTO sys."Function" (id, debug, name, type, arguments, demo, detail, date, back, requestlist, "userId") VALUES (5, 0, 'isContain', 'Object', 'array,value', '{"array": [1, 2, 3], "value": 2}', '判断是否数组包含值。', '2018-10-13 08:23:23.000000', null, null, 0);
INSERT INTO sys."Function" (id, debug, name, type, arguments, demo, detail, date, back, requestlist, "userId") VALUES (6, 0, 'isContainKey', 'Object', 'object,key', '{"key": "id", "object": {"id": 1}}', '判断是否对象包含键。', '2018-10-13 08:30:31.000000', null, null, 0);
INSERT INTO sys."Function" (id, debug, name, type, arguments, demo, detail, date, back, requestlist, "userId") VALUES (7, 0, 'isContainValue', 'Object', 'object,value', '{"value": 1, "object": {"id": 1}}', '判断是否对象包含值。', '2018-10-13 08:30:31.000000', null, null, 0);
INSERT INTO sys."Function" (id, debug, name, type, arguments, demo, detail, date, back, requestlist, "userId") VALUES (8, 0, 'getFromArray', 'Object', 'array,position', '{"array": [1, 2, 3], "result()": "getFromArray(array,1)"}', '根据下标获取数组里的值。position 传数字时直接作为值，而不是从所在对象 request 中取值', '2018-10-13 08:30:31.000000', null, null, 0);
INSERT INTO sys."Function" (id, debug, name, type, arguments, demo, detail, date, back, requestlist, "userId") VALUES (9, 0, 'getFromObject', 'Object', 'object,key', '{"key": "id", "object": {"id": 1}}', '根据键获取对象里的值。', '2018-10-13 08:30:31.000000', null, null, 0);
INSERT INTO sys."Function" (id, debug, name, type, arguments, demo, detail, date, back, requestlist, "userId") VALUES (11, 0, 'verifyIdList', 'Object', 'array', '{"array": [1, 2, 3], "result()": "verifyIdList(array)"}', '校验类型为 id 列表', '2019-08-17 19:58:33.000000', null, null, 0);
INSERT INTO sys."Function" (id, debug, name, type, arguments, demo, detail, date, back, requestlist, "userId") VALUES (12, 0, 'verifyURLList', 'Object', 'array', '{"array": ["http://123.com/1.jpg", "http://123.com/a.png", "http://www.abc.com/test.gif"], "result()": "verifyURLList(array)"}', '校验类型为 URL 列表', '2019-08-17 19:58:33.000000', null, null, 0);
INSERT INTO sys."Function" (id, debug, name, type, arguments, demo, detail, date, back, requestlist, "userId") VALUES (13, 0, 'getWithDefault', 'Object', 'value,defaultValue', '{"value": null, "defaultValue": 1}', '如果 value 为 null，则返回 defaultValue', '2019-08-20 15:26:36.000000', null, null, 0);
INSERT INTO sys."Function" (id, debug, name, type, arguments, demo, detail, date, back, requestlist, "userId") VALUES (14, 0, 'removeKey', 'Object', 'key', '{"key": "s", "key2": 2}', '从对象里移除 key', '2019-08-20 15:26:36.000000', null, null, 0);
INSERT INTO sys."Function" (id, debug, name, type, arguments, demo, detail, date, back, requestlist, "userId") VALUES (15, 0, 'getFunctionDemo', 'Object', null, '{}', '获取远程函数的 Demo', '2019-08-20 15:26:36.000000', null, null, 0);
INSERT INTO sys."Function" (id, debug, name, type, arguments, demo, detail, date, back, requestlist, "userId") VALUES (16, 0, 'getFunctionDetail', 'Object', null, '{}', '获取远程函数的详情', '2019-08-20 15:26:36.000000', null, null, 0);
INSERT INTO sys."Function" (id, debug, name, type, arguments, demo, detail, date, back, requestlist, "userId") VALUES (10, 0, 'deleteCommentOfMoment', 'Object', 'momentId', '{"momentId": 1}', '根据动态 id 删除它的所有评论', '2019-08-17 18:46:56.000000', null, null, 0);
