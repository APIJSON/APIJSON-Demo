create table "Request"
(
    id        bigint,
    debug     smallint,
    version   smallint,
    method    varchar(10),
    tag       varchar(30),
    structure json,
    detail    varchar(10000),
    date      timestamp
);



insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1, 0, 1, 'POST', 'register', '{"User": {"MUST": "name", "REFUSE": "id", "UPDATE": {"id@": "Privacy/id"}}, "Privacy": {"MUST": "_password,phone", "REFUSE": "id", "UNIQUE": "phone", "VERIFY": {"phone~": "PHONE"}}}', 'UNIQUE校验phone是否已存在。VERIFY校验phone是否符合手机号的格式', '2017-02-01 19:19:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (2, 0, 1, 'POST', 'Moment', '{"INSERT": {"@role": "OWNER", "pictureList": [], "praiseUserIdList": []}, "REFUSE": "id", "UPDATE": {"verifyIdList-()": "verifyIdList(praiseUserIdList)", "verifyURLList-()": "verifyURLList(pictureList)"}}', 'INSERT当没传pictureList和praiseUserIdList时用空数组[]补全，保证不会为null', '2017-02-01 19:19:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (3, 0, 1, 'POST', 'Comment', '{"MUST": "momentId,content", "REFUSE": "id", "UPDATE": {"@role": "OWNER"}}', '必须传userId,momentId,content，不允许传id', '2017-02-01 19:19:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (4, 0, 1, 'PUT', 'User', '{"MUST": "id", "INSERT": {"@role": "OWNER"}, "REFUSE": "phone"}', '必须传id，不允许传phone。INSERT当没传@role时用OWNER补全', '2017-02-01 19:19:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (5, 0, 1, 'DELETE', 'Moment', '{"Moment": {"MUST": "id", "INSERT": {"@role": "OWNER"}, "UPDATE": {"commentCount()": "deleteCommentOfMoment(id)"}}}', null, '2017-02-01 19:19:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (6, 0, 1, 'DELETE', 'Comment', '{"MUST": "id", "INSERT": {"@role": "OWNER"}, "UPDATE": {"childCount()": "deleteChildComment(id)"}}', 'disallow没必要用于DELETE', '2017-02-01 19:19:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (8, 0, 1, 'PUT', 'User-phone', '{"User": {"MUST": "id,phone,_password", "INSERT": {"@role": "OWNER"}, "REFUSE": "!", "UPDATE": {"@combine": "_password"}}}', '! 表示其它所有，这里指necessary所有未包含的字段', '2017-02-01 19:19:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (14, 0, 1, 'POST', 'Verify', '{"MUST": "phone,verify", "REFUSE": "!"}', '必须传phone,verify，其它都不允许传', '2017-02-18 22:20:43.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (15, 0, 1, 'GETS', 'Verify', '{"MUST": "phone"}', '必须传phone', '2017-02-18 22:20:43.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (16, 0, 1, 'HEADS', 'Verify', '{}', '允许任意内容', '2017-02-18 22:20:43.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (17, 0, 1, 'PUT', 'Moment', '{"MUST": "id", "REFUSE": "userId,date", "UPDATE": {"@role": "OWNER", "verifyIdList-()": "verifyIdList(praiseUserIdList)", "verifyURLList-()": "verifyURLList(pictureList)"}}', null, '2017-02-01 19:19:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (21, 0, 1, 'HEADS', 'Login', '{"MUST": "userId,type", "REFUSE": "!"}', null, '2017-02-18 22:20:43.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (22, 0, 1, 'GETS', 'User', '{}', '允许传任何内容，除了表对象', '2017-02-18 22:20:43.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (23, 0, 1, 'PUT', 'Privacy', '{"MUST": "id", "INSERT": {"@role": "OWNER"}}', 'INSERT当没传@role时用OWNER补全', '2017-02-01 19:19:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (25, 0, 1, 'PUT', 'Praise', '{"MUST": "id"}', '必须传id', '2017-02-01 19:19:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (26, 0, 1, 'DELETE', 'Comment[]', '{"Comment": {"MUST": "id{}", "INSERT": {"@role": "OWNER"}}}', 'DISALLOW没必要用于DELETE', '2017-02-01 19:19:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (27, 0, 1, 'PUT', 'Comment[]', '{"Comment": {"MUST": "id{}", "INSERT": {"@role": "OWNER"}}}', 'DISALLOW没必要用于DELETE', '2017-02-01 19:19:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (28, 0, 1, 'PUT', 'Comment', '{"MUST": "id", "INSERT": {"@role": "OWNER"}}', '这里省略了Comment，因为tag就是Comment，Parser.getCorrectRequest会自动补全', '2017-02-01 19:19:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (29, 0, 1, 'GETS', 'login', '{"Privacy": {"MUST": "phone,_password", "REFUSE": "id"}}', null, '2017-10-15 18:04:52.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (30, 0, 1, 'PUT', 'balance+', '{"Privacy": {"MUST": "id,balance+", "REFUSE": "!", "VERIFY": {"balance+&{}": ">=1,<=100000"}}}', '验证balance+对应的值是否满足>=1且<=100000', '2017-10-21 16:48:34.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (31, 0, 1, 'PUT', 'balance-', '{"Privacy": {"MUST": "id,balance-,_password", "REFUSE": "!", "UPDATE": {"@combine": "_password"}, "VERIFY": {"balance-&{}": ">=1,<=10000"}}}', 'UPDATE强制把_password作为WHERE条件', '2017-10-21 16:48:34.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (32, 0, 2, 'GETS', 'Privacy', '{"MUST": "id", "INSERT": {"@role": "OWNER"}, "REFUSE": "_password,_payPassword"}', null, '2017-06-13 00:05:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (33, 0, 2, 'GETS', 'Privacy-CIRCLE', '{"Privacy": {"MUST": "id", "REFUSE": "!", "UPDATE": {"@role": "CIRCLE", "@column": "phone"}}}', null, '2017-06-13 00:05:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (35, 0, 2, 'POST', 'Document', '{"Document": {"MUST": "name,url,request", "INSERT": {"@role": "OWNER"}, "REFUSE": "id"}, "TestRecord": {"MUST": "response", "INSERT": {"@role": "OWNER"}, "REFUSE": "id,documentId", "UPDATE": {"documentId@": "Document/id"}}}', null, '2017-11-26 16:34:41.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (36, 1, 2, 'PUT', 'Document', '{"MUST": "id", "INSERT": {"@role": "OWNER"}, "REFUSE": "userId"}', null, '2017-11-26 16:35:15.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (37, 1, 2, 'DELETE', 'Document', '{"MUST": "id", "INSERT": {"@role": "OWNER"}, "REFUSE": "!", "UPDATE": {"Random": {"@role": "OWNER", "documentId@": "Method/id"}, "TestRecord": {"@role": "OWNER", "documentId@": "Document/id"}}}', null, '2017-11-26 08:36:20.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (38, 0, 2, 'POST', 'TestRecord', '{"MUST": "documentId,response", "INSERT": {"@role": "OWNER"}, "REFUSE": "id"}', null, '2018-06-17 07:44:36.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (39, 1, 2, 'POST', 'Method', '{"Method": {"MUST": "method,class,package", "INSERT": {"@role": "OWNER"}, "REFUSE": "id"}, "TestRecord": {"MUST": "response", "INSERT": {"@role": "OWNER"}, "REFUSE": "id,documentId", "UPDATE": {"documentId@": "Method/id"}}}', null, '2017-11-26 08:34:41.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (40, 1, 2, 'PUT', 'Method', '{"MUST": "id", "INSERT": {"@role": "OWNER"}, "REFUSE": "userId"}', null, '2017-11-26 08:35:15.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (41, 1, 2, 'DELETE', 'Method', '{"MUST": "id", "INSERT": {"@role": "OWNER"}, "REFUSE": "!"}', null, '2017-11-26 00:36:20.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (42, 0, 2, 'POST', 'Random', '{"INSERT": {"@role": "OWNER"}, "Random": {"MUST": "documentId,name,config"}, "TestRecord": {"UPDATE": {"randomId@": "/Random/id", "documentId@": "/Random/documentId"}}}', null, '2017-11-26 08:34:41.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (43, 1, 2, 'PUT', 'Random', '{"MUST": "id", "INSERT": {"@role": "OWNER"}, "REFUSE": "userId"}', null, '2017-11-26 08:35:15.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (44, 1, 2, 'DELETE', 'Random', '{"MUST": "id", "INSERT": {"@role": "OWNER"}, "UPDATE": {"TestRecord": {"@role": "OWNER", "randomId@": "/id"}}}', null, '2017-11-26 00:36:20.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (45, 0, 2, 'POST', 'Comment:[]', '{"TYPE": {"Comment[]": "OBJECT[]"}, "INSERT": {"@role": "OWNER"}, "Comment[]": [], "ALLOW_PARTIAL_UPDATE_FAIL": "Comment[]"}', null, '2020-03-01 13:40:04.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (46, 0, 2, 'POST', 'Moment:[]', '{"INSERT": {"@role": "OWNER"}, "Moment[]": []}', null, '2020-03-01 13:41:42.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (47, 0, 2, 'PUT', 'Comment:[]', '{"INSERT": {"@role": "OWNER"}, "Comment[]": []}', null, '2020-03-01 13:40:04.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (48, 1, 2, 'DELETE', 'TestRecord', '{"MUST": "id", "INSERT": {"@role": "OWNER"}}', null, '2017-11-26 00:36:20.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (49, 0, 2, 'POST', 'Input', '{"MUST": "deviceId,x,y", "INSERT": {"@role": "OWNER"}, "REFUSE": "id"}', null, '2017-11-26 08:34:41.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (50, 0, 2, 'POST', 'Device', '{"MUST": "brand,model", "INSERT": {"@role": "OWNER"}, "REFUSE": "id"}', null, '2017-11-26 08:34:41.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (51, 0, 2, 'POST', 'System', '{"MUST": "type,versionCode,versionName", "INSERT": {"@role": "OWNER"}, "REFUSE": "id"}', null, '2017-11-26 08:34:41.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (52, 0, 2, 'POST', 'Flow', '{"MUST": "deviceId,systemId,name", "INSERT": {"@role": "OWNER"}, "REFUSE": "id"}', null, '2017-11-26 08:34:41.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (53, 0, 4, 'GETS', 'Privacy', '{"MUST": "id", "INSERT": {"@role": "OWNER"}, "REFUSE": "!"}', null, '2017-06-13 00:05:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (54, 0, 2, 'POST', 'Output', '{"MUST": "inputId", "INSERT": {"@role": "OWNER"}, "REFUSE": "id"}', null, '2018-06-17 07:44:36.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (55, 0, 2, 'DELETE', 'Output', '{"MUST": "id", "INSERT": {"@role": "OWNER"}}', null, '2017-11-26 00:36:20.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (56, 0, 3, 'DELETE', 'Method', '{"MUST": "id", "INSERT": {"@role": "OWNER"}, "REFUSE": "!"}', null, '2017-11-26 00:36:20.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (57, 0, 4, 'GETS', 'User[]', '{"User": {"INSERT": {"@role": "CIRCLE"}}, "REFUSE": "query"}', null, '2021-10-22 00:29:32.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (58, 0, 1, 'PUT', 'Moment-praiseUserIdList+', '{"Moment": {"MUST": "id", "REFUSE": "!", "UPDATE": {"@role": "CIRCLE", "newListWithCurUserId-()": "newListWithCurUserId(praiseUserIdList+)"}}}', '单独针对 Moment 点赞设置校验规则（允许圈子成员操作自己的数据）', '2017-02-01 19:19:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (59, 0, 1, 'PUT', 'Moment-praiseUserIdList-', '{"Moment": {"MUST": "id", "REFUSE": "!", "UPDATE": {"@role": "CIRCLE", "praiseUserIdList--()": "newListWithCurUserId()"}}}', '单独针对 Moment 取消点赞设置校验规则（允许圈子成员操作自己的数据）', '2017-02-01 19:19:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (61, 1, 1, 'POST', 'Request', '{"MUST": "method,tag,structure", "INSERT": {"@role": "LOGIN"}, "REFUSE": "!detail,!"}', null, '2022-05-03 03:07:37.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1651614346391, 0, 1, 'GET', 'momentList', '{"MUST": "Moment[].page", "TYPE": {"format": "BOOLEAN", "Moment[].page": "NUMBER", "Moment[].count": "NUMBER"}, "REFUSE": "!Moment[].count,!format,!"}', '查询动态列表类 RESTful 简单接口', '2022-05-04 05:46:04.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1657562189773, 0, 1, 'GET', 'moments', '{"MUST": "Moment[].page", "TYPE": {"format": "BOOLEAN", "Moment[].page": "NUMBER", "Moment[].count": "NUMBER"}, "REFUSE": "!Moment[].count,!format,!"}', '查动态列表类 RESTful 简单接口', '2022-07-12 01:56:32.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1657793230364, 0, 1, 'GET', 'User[]', '{"MUST": "", "TYPE": {}, "REFUSE": "!"}', '随机配置 2022-07-14 18:07', '2022-07-14 18:07:10.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984265, 0, 1, 'GET', 'user', '{"MUST": "", "TYPE": {}, "REFUSE": "!"}', '随机配置 2022-07-19 19:26', '2022-07-19 19:26:24.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984266, 0, 5, 'POST', 'Activity', '{}', null, '2017-11-26 08:34:41.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984267, 0, 5, 'POST', 'Fragment', '{}', null, '2017-11-26 08:34:41.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984268, 0, 5, 'POST', 'View', '{}', null, '2017-11-26 08:34:41.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984269, 0, 5, 'POST', 'Activity:[]', '{"TYPE": {"Activity[]": "OBJECT[]"}, "INSERT": {"@role": "OWNER"}, "Activity[]": []}', null, '2020-03-01 13:40:04.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984270, 0, 5, 'POST', 'Fragment:[]', '{"TYPE": {"Fragment[]": "OBJECT[]"}, "INSERT": {"@role": "OWNER"}, "Fragment[]": []}', null, '2020-03-01 13:40:04.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984271, 0, 5, 'POST', 'View:[]', '{"TYPE": {"View[]": "OBJECT[]"}, "INSERT": {"@role": "OWNER"}, "View[]": []}', null, '2020-03-01 13:40:04.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984274, 0, 5, 'PUT', 'Activity', '{"MUST": "id", "INSERT": {"@role": "OWNER"}}', null, '2017-11-26 08:35:15.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984275, 0, 5, 'PUT', 'Fragment', '{"MUST": "id", "INSERT": {"@role": "OWNER"}}', null, '2017-11-26 08:35:15.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984276, 0, 5, 'PUT', 'View', '{"MUST": "id", "INSERT": {"@role": "OWNER"}}', null, '2017-11-26 08:35:15.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984277, 0, 5, 'DELETE', 'Activity', '{"MUST": "id", "INSERT": {"@role": "OWNER"}}', null, '2017-11-26 00:36:20.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984278, 0, 5, 'DELETE', 'Fragment', '{"MUST": "id", "INSERT": {"@role": "OWNER"}}', null, '2017-11-26 00:36:20.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984279, 0, 5, 'DELETE', 'View', '{"MUST": "id", "INSERT": {"@role": "OWNER"}}', null, '2017-11-26 00:36:20.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984280, 0, 5, 'DELETE', 'View[]', '{"View": {"MUST": "id{}", "INSERT": {"@role": "OWNER"}}}', 'DISALLOW没必要用于DELETE', '2017-02-01 19:19:51.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984281, 0, 2, 'POST', 'Comment[]', '{"TYPE": {"Comment[]": "OBJECT[]"}, "INSERT": {"@role": "OWNER"}, "Comment[]": []}', null, '2020-03-01 13:40:04.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984282, 0, 5, 'POST', 'Data', '{}', null, '2022-12-11 04:58:27.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984283, 0, 5, 'PUT', 'Data', '{"MUST": "id", "INSERT": {"@role": "OWNER"}}', null, '2022-12-11 04:58:27.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984284, 0, 5, 'DELETE', 'Data', '{"MUST": "id", "INSERT": {"@role": "OWNER"}}', null, '2022-12-11 04:58:27.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984285, 0, 5, 'POST', 'Script', '{"MUST": "name,script", "INSERT": {"@role": "OWNER"}}', null, '2017-11-26 08:34:41.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984286, 0, 5, 'PUT', 'Script', '{"MUST": "id", "INSERT": {"@role": "OWNER"}}', null, '2017-11-26 08:34:41.000000');
insert into "Request" (id, debug, version, method, tag, structure, detail, date) values (1658229984287, 0, 5, 'DELETE', 'Script', '{"MUST": "id", "INSERT": {"@role": "OWNER"}}', null, '2017-11-26 08:34:41.000000');