create table "Request"
(
    id        bigint                 not null
        primary key,
    debug     smallint     default 0 not null,
    version   smallint               not null,
    method    varchar(10),
    tag       varchar(20)            not null,
    structure jsonb                  not null,
    detail    varchar(10000),
    date      timestamp(6) default CURRENT_TIMESTAMP
);

comment on table "Request" is '最好编辑完后删除主键，这样就是只读状态，不能随意更改。需要更改就重新加上主键。

每次启动服务器时加载整个表到内存。
这个表不可省略，model内注解的权限只是客户端能用的，其它可以保证即便服务端代码错误时也不会误删数据。';

comment on column "Request".id is '唯一标识';

comment on column "Request".debug is '是否为 DEBUG 调试数据，只允许在开发环境使用，测试和线上环境禁用：0-否，1-是。';

comment on column "Request".version is 'GET,HEAD可用任意结构访问任意开放内容，不需要这个字段。
其它的操作因为写入了结构和内容，所以都需要，按照不同的version选择对应的structure。

自动化版本管理：
Request JSON最外层可以传 "version":Integer 。
1.未传或 <= 0，用最新版。 "@order":"version-"
2.已传且 > 0，用version以上的可用版本的最低版本。 "@order":"version+", "version{}":">={version}"';

comment on column "Request".method is '只限于GET,HEAD外的操作方法。';

comment on column "Request".tag is '标签';

comment on column "Request".structure is '结构';

comment on column "Request".detail is '详细说明';

comment on column "Request".date is '创建时间';

alter table "Request"
    owner to postgres;

INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (1, 0, 1, 'POST', 'register', '{"User": {"UPDATE": {"id@": "Privacy/id"}, "DISALLOW": "id", "NECESSARY": "name"}, "Privacy": {"UNIQUE": "phone", "VERIFY": {"phone~": "phone"}, "DISALLOW": "id", "NECESSARY": "_password,phone"}}', 'UNIQUE校验phone是否已存在。VERIFY校验phone是否符合手机号的格式', '2017-02-01 11:19:51.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (2, 0, 1, 'POST', 'Moment', '{"INSERT": {"@role": "OWNER", "pictureList": [], "praiseUserIdList": []}, "UPDATE": {"verifyIdList-()": "verifyIdList(praiseUserIdList)", "verifyURLList-()": "verifyURLList(pictureList)"}, "DISALLOW": "id"}', 'INSERT当没传pictureList和praiseUserIdList时用空数组[]补全，保证不会为null', '2017-02-01 11:19:51.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (3, 0, 1, 'POST', 'Comment', '{"UPDATE": {"@role": "OWNER"}, "DISALLOW": "id", "NECESSARY": "momentId,content"}', '必须传userId,momentId,content，不允许传id', '2017-02-01 11:19:51.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (4, 0, 1, 'PUT', 'User', '{"INSERT": {"@role": "OWNER"}, "DISALLOW": "phone", "NECESSARY": "id"}', '必须传id，不允许传phone。INSERT当没传@role时用OWNER补全', '2017-02-01 11:19:51.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (5, 0, 1, 'DELETE', 'Moment', '{"Moment": {"INSERT": {"@role": "OWNER"}, "UPDATE": {"commentCount()": "deleteCommentOfMoment(id)"}, "NECESSARY": "id"}}', null, '2017-02-01 11:19:51.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (6, 0, 1, 'DELETE', 'Comment', '{"INSERT": {"@role": "OWNER"}, "UPDATE": {"childCount()": "deleteChildComment(id)"}, "NECESSARY": "id"}', 'disallow没必要用于DELETE', '2017-02-01 11:19:51.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (8, 0, 1, 'PUT', 'User-phone', '{"User": {"INSERT": {"@role": "OWNER"}, "UPDATE": {"@combine": "_password"}, "DISALLOW": "!", "NECESSARY": "id,phone,_password"}}', '! 表示其它所有，这里指necessary所有未包含的字段', '2017-02-01 11:19:51.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (14, 0, 1, 'POST', 'Verify', '{"DISALLOW": "!", "NECESSARY": "phone,verify"}', '必须传phone,verify，其它都不允许传', '2017-02-18 14:20:43.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (15, 0, 1, 'GETS', 'Verify', '{"NECESSARY": "phone"}', '必须传phone', '2017-02-18 14:20:43.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (16, 0, 1, 'HEADS', 'Verify', '{}', '允许任意内容', '2017-02-18 14:20:43.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (21, 0, 1, 'HEADS', 'Login', '{"DISALLOW": "!", "NECESSARY": "userId,type"}', null, '2017-02-18 14:20:43.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (22, 0, 1, 'GETS', 'User', '{}', '允许传任何内容，除了表对象', '2017-02-18 14:20:43.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (23, 0, 1, 'PUT', 'Privacy', '{"INSERT": {"@role": "OWNER"}, "NECESSARY": "id"}', 'INSERT当没传@role时用OWNER补全', '2017-02-01 11:19:51.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (26, 0, 1, 'DELETE', 'Comment[]', '{"Comment": {"INSERT": {"@role": "OWNER"}, "NECESSARY": "id{}"}}', 'DISALLOW没必要用于DELETE', '2017-02-01 11:19:51.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (27, 0, 1, 'PUT', 'Comment[]', '{"Comment": {"INSERT": {"@role": "OWNER"}, "NECESSARY": "id{}"}}', 'DISALLOW没必要用于DELETE', '2017-02-01 11:19:51.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (28, 0, 1, 'PUT', 'Comment', '{"INSERT": {"@role": "OWNER"}, "NECESSARY": "id"}', '这里省略了Comment，因为tag就是Comment，Parser.getCorrectRequest会自动补全', '2017-02-01 11:19:51.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (29, 0, 1, 'GETS', 'login', '{"Privacy": {"DISALLOW": "id", "NECESSARY": "phone,_password"}}', null, '2017-10-15 10:04:52.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (32, 0, 2, 'GETS', 'Privacy', '{"INSERT": {"@role": "OWNER"}, "DISALLOW": "_password,_payPassword", "NECESSARY": "id"}', null, '2017-06-12 16:05:51.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (33, 0, 2, 'GETS', 'Privacy-CIRCLE', '{"Privacy": {"UPDATE": {"@role": "CIRCLE", "@column": "phone"}, "DISALLOW": "!", "NECESSARY": "id"}}', null, '2017-06-12 16:05:51.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (35, 0, 2, 'POST', 'Document', '{"Document": {"INSERT": {"@role": "OWNER"}, "DISALLOW": "id", "NECESSARY": "userId,name,url,request"}, "TestRecord": {"INSERT": {"@role": "OWNER"}, "UPDATE": {"documentId@": "Document/id"}, "DISALLOW": "id,documentId", "NECESSARY": "userId,response"}}', null, '2017-11-26 08:34:41.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (37, 1, 2, 'DELETE', 'Document', '{"INSERT": {"@role": "OWNER"}, "UPDATE": {"TestRecord": {"@role": "OWNER", "documentId@": "Document/id"}}, "DISALLOW": "!", "NECESSARY": "id"}', null, '2017-11-26 00:36:20.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (38, 0, 2, 'POST', 'TestRecord', '{"INSERT": {"@role": "OWNER"}, "DISALLOW": "id", "NECESSARY": "userId,documentId,response"}', null, '2018-06-16 23:44:36.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (25, 0, 1, 'PUT', 'Praise', '{"INSERT": {"@role": "OWNER"}, "NECESSARY": "id"}', '必须传id', '2017-02-01 11:19:51.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (17, 0, 1, 'PUT', 'Moment', '{"INSERT": {"@role": "OWNER"}, "DISALLOW": "userId,date", "NECESSARY": "id"}', null, '2017-02-01 11:19:51.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (36, 1, 2, 'PUT', 'Document', '{"INSERT": {"@role": "OWNER"}, "DISALLOW": "userId", "NECESSARY": "id"}', null, '2017-11-26 08:35:15.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (31, 0, 1, 'PUT', 'balance-', '{"Privacy": {"INSERT": {"@role": "OWNER"}, "UPDATE": {"@combine": "_password"}, "VERIFY": {"balance-&{}": ">=1,<=10000"}, "DISALLOW": "!", "NECESSARY": "id,balance-,_password"}}', 'UPDATE强制把_password作为WHERE条件', '2017-10-21 08:48:34.000000');
INSERT INTO sys."Request" (id, debug, version, method, tag, structure, detail, date) VALUES (30, 0, 1, 'PUT', 'balance+', '{"Privacy": {"INSERT": {"@role": "OWNER"}, "VERIFY": {"balance+&{}": ">=1,<=100000"}, "DISALLOW": "!", "NECESSARY": "id,balance+"}}', '验证balance+对应的值是否满足>=1且<=100000', '2017-10-21 08:48:34.000000');
