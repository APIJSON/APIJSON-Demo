create table "Script"
(
    id              bigint,
    "userId"        bigint,
    "testAccountId" bigint,
    "documentId"    bigint,
    simple          smallint,
    ahead           smallint,
    title           varchar(100),
    name            varchar(100),
    script          text,
    date            timestamp,
    detail          varchar(1000)
);

alter table "Script"
    owner to postgres;


insert into "Script" (id, "userId", "testAccountId", "documentId", simple, ahead, title, name, script, date, detail) values (1, 0, 0, 0, 0, 0, null, 'getType', 'function getType(curObj, key) {
    var val = curObj == null ? null : curObj[key];
    return val instanceof Array ? "array" : typeof val;
}', '2022-11-17 00:01:23.000000', null);
insert into "Script" (id, "userId", "testAccountId", "documentId", simple, ahead, title, name, script, date, detail) values (2, 0, 0, 0, 0, 0, null, 'isContain', 'function isContain(curObj, arrKey, valKey) {
    var arr = curObj == null ? null : curObj[arrKey];
    var val = curObj == null ? null : curObj[valKey];
    return arr != null && arr.indexOf(val) >=0;
}', '2022-11-17 00:02:48.000000', null);
insert into "Script" (id, "userId", "testAccountId", "documentId", simple, ahead, title, name, script, date, detail) values (3, 0, 0, 0, 1, 0, null, 'init', 'var i = 1;
"init done "  + i;', '2022-11-17 00:41:35.000000', null);
insert into "Script" (id, "userId", "testAccountId", "documentId", simple, ahead, title, name, script, date, detail) values (4, 0, 0, 0, 0, 0, null, 'length', 'function length(curObj, key) {
    var val = curObj == null ? null : curObj[key];
    return val == null ? 0 : val.length;
}', '2022-11-17 01:18:43.000000', null);
insert into "Script" (id, "userId", "testAccountId", "documentId", simple, ahead, title, name, script, date, detail) values (1670877704568, 82001, 0, 1560244940013, 1, 0, '执行脚本 2022-12-13 04:41', '', '', '2022-12-13 04:41:44.000000', null);
insert into "Script" (id, "userId", "testAccountId", "documentId", simple, ahead, title, name, script, date, detail) values (1670877914051, 82001, 0, 0, 1, 1, '执行脚本 2022-12-13 04:44', '', 'function assert(assertion, msg) {
     if (assertion === true) {
         return
     }
     if (msg == null) {
         msg = ''assert failed! assertion = '' + assertion
     }

     if (isTest) {
         console.log(msg)
         alert(msg)
     } else {
         throw new Error(msg)
     } 
}  

if (isTest) {
     assert(true)
     assert(false)
     assert(true, ''ok'')
     assert(false, ''data.User shoule not be null!'') 
}

function getCurAccount() {
  return App.getCurrentAccount()
}', '2022-12-13 04:45:14.000000', null);
insert into "Script" (id, "userId", "testAccountId", "documentId", simple, ahead, title, name, script, date, detail) values (1670878495619, 82001, 82002, 0, 1, 0, '执行脚本 2022-12-13 04:54', '', 'function getCurAccount() {
  return App.getCurrentAccount()
}', '2022-12-13 04:54:55.000000', null);
insert into "Script" (id, "userId", "testAccountId", "documentId", simple, ahead, title, name, script, date, detail) values (1670878529042, 82001, 82001, 0, 1, 1, '执行脚本 2022-12-13 04:55', '', 'function getCurAccount() {
  return App.getCurrentAccount()
}', '2022-12-13 04:55:29.000000', null);
insert into "Script" (id, "userId", "testAccountId", "documentId", simple, ahead, title, name, script, date, detail) values (1670878622401, 82001, 82003, 0, 1, 0, '执行脚本 2022-12-13 04:57', '', 'if (isPre) {
  header[''my-header''] = ''test''
}', '2022-12-13 04:57:02.000000', null);
insert into "Script" (id, "userId", "testAccountId", "documentId", simple, ahead, title, name, script, date, detail) values (1670885503909, 82001, 0, 1657045372046, 1, 1, '执行脚本 2022-12-13 06:51', '', 'if (isPre) {
  req.User.id = 82005
}', '2022-12-13 06:51:43.000000', null);
insert into "Script" (id, "userId", "testAccountId", "documentId", simple, ahead, title, name, script, date, detail) values (1670887211207, 82001, 0, 1657045372046, 1, 0, '执行脚本 2022-12-13 07:20', '', '', '2022-12-13 07:20:11.000000', null);
insert into "Script" (id, "userId", "testAccountId", "documentId", simple, ahead, title, name, script, date, detail) values (1671083305189, 82001, 0, 0, 1, 0, null, 'globalPost0', '', '2022-12-15 13:48:25.000000', null);
