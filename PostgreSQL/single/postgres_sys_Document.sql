create table "Document"
(
    id       bigint              not null
        primary key,
    debug    smallint  default 0 not null,
    "userId" bigint              not null,
    version  smallint            not null,
    name     varchar(100)        not null,
    url      varchar(250)        not null,
    request  text                not null,
    apijson  text,
    header   text,
    date     timestamp default CURRENT_TIMESTAMP,
    type     varchar   default 'JSON'::character varying,
    standard text
);

comment on table "Document" is '测试用例文档
后端开发者在测试好后，把选好的测试用例上传，这样就能共享给前端/客户端开发者';

comment on column "Document".id is '唯一标识';

comment on column "Document".debug is '是否为 DEBUG 调试数据，只允许在开发环境使用，测试和线上环境禁用：0-否，1-是。';

comment on column "Document"."userId" is '用户id
		应该用adminId，只有当登录账户是管理员时才能操作文档。
		需要先建Admin表，新增登录等相关接口。';

comment on column "Document".version is '接口版本号
		<=0 - 不限制版本，任意版本都可用这个接口
		>0 - 在这个版本添加的接口';

comment on column "Document".name is '接口名称';

comment on column "Document".url is '请求地址';

comment on column "Document".request is '请求参数 JSON。用json格式会导致强制排序，而请求中引用赋值只能引用上面的字段，必须有序。';

comment on column "Document".apijson is '从 request 映射为实际的 APIJSON 请求 JSON';

comment on column "Document".header is '请求头 Request Header：
		key: value //注释';

comment on column "Document".date is '创建时间';

comment on column "Document".type is 'PARAM - GET  url parameters,
FORM - POST  application/www-x-form-url-encoded,
JSON - POST  application/json';

comment on column "Document".standard is '请求参数定义，带注释';

alter table "Document"
    owner to postgres;

INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (3, 0, 82001, 1, '退出登录', '/logout', '{}', null, null, '2017-11-26 09:36:10.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1512216131854, 0, 82001, 1, '获取文档列表(即在线解析网页上的文档)-表和字段、请求格式限制', '/get', '{
    "[]": {
        "Table": {
            "TABLE_SCHEMA": "sys",
            "TABLE_TYPE": "BASE TABLE",
            "TABLE_NAME!$": [
                "\\_%",
                "sys\\_%",
                "system\\_%"
            ],
            "@order": "TABLE_NAME+",
            "@column": "TABLE_NAME,TABLE_COMMENT"
        },
        "Column[]": {
            "Column": {
                "TABLE_NAME@": "[]/Table/TABLE_NAME",
                "@column": "COLUMN_NAME,COLUMN_TYPE,IS_NULLABLE,COLUMN_COMMENT"
            }
        }
    },
    "Request[]": {
        "Request": {
            "@order": "version-,method-"
        }
    }
}', null, null, '2017-12-02 12:02:11.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521903761688, 0, 82001, 2, '功能符(逻辑运算): ③ ! 非运算', '/head', '{"User":{"id!{}":[82001,38710]}}', null, null, '2018-03-24 15:02:41.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521903828409, 0, 82001, 2, '功能符(逻辑运算): ② | 或运算', '/head', '{"User":{"id|{}":">90000,<=80000"}}', null, null, '2018-03-24 15:03:48.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521903882829, 0, 82001, 2, '功能符(逻辑运算): ① & 与运算', '/head', '{"User":{"id&{}":">80000,<=90000"}}', null, null, '2018-03-24 15:04:42.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521904698934, 0, 82001, 2, '功能符: 匹配条件范围', '/get', '{"User[]":{"count":3,"User":{"id{}":"<=80000,>90000"}}}', null, null, '2018-03-24 15:18:18.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521905263827, 0, 82001, 2, '操作方法(DELETE):  删除数据', '/delete', '{
   "Moment":{
     "id":120
   },
   "tag":"Moment"
}', null, null, '2018-03-24 15:27:43.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521907009307, 0, 82001, 2, 'Moment列表，每个Moment包括 1.发布者User 2.前3条Comment', '/get', '{
   "[]":{
     "page":0, 
     "count":3, 
     "Moment":{}, 
     "User":{
       "id@":"/Moment/userId"
     },
     "Comment[]":{
       "count":3,
       "Comment":{
         "momentId@":"[]/Moment/id"
       }
     }
   }
}', null, null, '2018-03-24 15:56:49.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521907333044, 0, 82001, 2, 'User', '/get', '{
   "User":{
     "id":38710
   }
}', null, null, '2018-03-24 16:02:13.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1, 0, 82001, 1, '登录', '/login', '{"type": 0, "phone": "13000082001", "version": 1, "password": "123456"}', null, null, '2017-11-26 07:35:19.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (2, 0, 82001, 1, '注册(先获取验证码type:1)', '/register', '{
    "Privacy": {
        "phone": "13000083333",
        "_password": "123456"
    },
    "User": {
        "name": "APIJSONUser"
    },
    "verify": "6840"
}', null, null, '2017-11-26 06:56:10.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1511689914598, 0, 82001, 1, '获取用户隐私信息', '/gets', '{"tag": "Privacy", "Privacy": {"id": 82001}}', null, null, '2017-11-26 09:51:54.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1511796155276, 0, 82001, 1, '获取验证码', '/post/verify', '{"type": 0, "phone": "13000082001"}', null, null, '2017-11-27 15:22:35.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1511796208669, 0, 82001, 1, '检查验证码是否存在', '/heads/verify', '{"type": 0, "phone": "13000082001"}', null, null, '2017-11-27 15:23:28.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1511796589078, 0, 82001, 1, '修改登录密码(先获取验证码type:2)-手机号+验证码', '/put/password', '{"verify": "10322", "Privacy": {"phone": "13000082001", "_password": "666666"}}', null, null, '2017-11-27 15:29:49.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1511796882183, 0, 82001, 1, '充值(需要支付密码)/提现', '/put/balance', '{"tag": "Privacy", "Privacy": {"id": 82001, "balance+": 100.15, "_payPassword": "123456"}}', null, null, '2017-11-27 15:34:42.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1511963677324, 0, 82001, 1, '获取用户', '/get', '{"User": {"id": 82001}}', null, null, '2017-11-29 13:54:37.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1511963722969, 0, 82001, 1, '获取用户列表("id{}":contactIdList)-朋友页', '/get', '{
    "User[]": {
        "count": 10,
        "page": 0,
        "User": {
            "@column": "id,sex,name,tag,head",
            "@order": "name+",
            "id{}": [
                82002,
                82004,
                70793
            ]
        }
    }
}', null, null, '2017-11-29 13:55:22.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1511963990071, 0, 82001, 1, '获取动态Moment+User+praiseUserList', '/get', '{
    "Moment": {
        "id": 15
    },
    "User": {
        "id@": "Moment/userId",
        "@column": "id,name,head"
    },
    "User[]": {
        "count": 10,
        "User": {
            "id{}@": "Moment/praiseUserIdList",
            "@column": "id,name"
        }
    }
}', null, null, '2017-11-29 13:59:50.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1511964176688, 0, 82001, 1, '获取评论列表-动态详情页Comment+User', '/get', '{
    "[]": {
        "count": 20,
        "page": 0,
        "Comment": {
            "@order": "date+",
            "momentId": 15
        },
        "User": {
            "id@": "/Comment/userId",
            "@column": "id,name,head"
        }
    }
}', null, null, '2017-11-29 14:02:56.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1511967853339, 0, 82001, 1, '获取动态列表Moment+User+User:parise[]+Comment[]', '/get', '{     "[]": {         "count": 5,         "page": 0,         "Moment": {             "@order": "date+"         },         "User": {             "id@": "/Moment/userId",             "@column": "id,name,head"         },         "User[]": {             "count": 10,             "User": {                 "id{}@": "[]/Moment/praiseUserIdList",                 "@column": "id,name"             }         },         "[]": {             "count": 6,             "Comment": {                 "@order": "date+",                 "momentId@": "[]/Moment/id"             },             "User": {                 "id@": "/Comment/userId",                 "@column": "id,name"             }         }     } }', null, null, '2017-11-29 15:04:13.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1511969181103, 0, 82001, 1, '添加朋友', '/put', '{
    "User": {
        "id": 82001,
        "contactIdList+": [93793]
    },
    "tag": "User"
}', null, null, '2017-11-29 15:26:21.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1511969417632, 0, 82001, 1, '点赞/取消点赞', '/put', '{
    "Moment": {
        "id": 15,
        "praiseUserIdList-": [
            82001
        ]
    },
    "tag": "Moment"
}', null, null, '2017-11-29 15:30:17.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1511969630371, 0, 82001, 1, '新增评论', '/post', '{     "Comment": {         "momentId": 15,         "content": "测试新增评论"     },     "tag": "Comment" }', null, null, '2017-11-29 15:33:50.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1511970009071, 0, 82001, 1, '新增动态', '/post', '{     "Moment": {         "content": "测试新增动态",         "pictureList": ["http://static.oschina.net/uploads/user/48/96331_50.jpg"         ]     },     "tag": "Moment" }', null, null, '2017-11-29 15:40:09.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1511970224332, 0, 82001, 1, '修改用户信息', '/put', '{
     "User": {
         "id": 82001,
         "name": "测试账号"
     },
     "tag": "User"
 }', null, null, '2017-11-29 15:43:44.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521901518764, 0, 82001, 2, '功能符(对象关键词): ⑤从pictureList获取第0张图片：', '/get', '{     "User": {         "id": 38710,         "@position": 0,         "firstPicture()": "getFromArray(pictureList,@position)"     } }', null, null, '2018-03-24 14:25:18.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521901610783, 0, 82001, 2, '功能符(对象关键词): ④查询 按userId分组、id最大值>=100 的Moment数组', '/get', '{"[]":{"count":10,"Moment":{"@column":"userId;max(id):maxId","@group":"userId","@having":"max(id)>=100"}}}', null, null, '2018-03-24 14:26:50.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521901682845, 0, 82001, 2, '功能符(对象关键词): ③查询按userId分组的Moment数组', '/get', '{"[]":{"count":10,"Moment":{"@column":"userId,id","@group":"userId,id"}}}', null, null, '2018-03-24 14:28:02.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521901746808, 0, 82001, 2, '功能符(对象关键词): ②查询按 name降序、id默认顺序 排序的User数组', '/get', '{"[]":{"count":10,"User":{"@column":"name,id","@order":"name-,id"}}}', null, null, '2018-03-24 14:29:06.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521901787202, 0, 82001, 2, '功能符(对象关键词): ①只查询id,sex,name这几列并且请求结果也按照这个顺序', '/get', '{"User":{"@column":"id,sex,name","id":38710}}', null, null, '2018-03-24 14:29:47.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521902033331, 0, 82001, 2, '功能符(数组关键词): ③查询User数组和对应的User总数', '/get', '{"[]":{"query":2,"count":5,"User":{}},"total@":"/[]/total"}', null, null, '2018-03-24 14:33:53.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521902069870, 0, 82001, 2, '功能符(数组关键词): ②查询第3页的User数组，每页5个', '/get', '{"[]":{"count":5,"page":3,"User":{}}}', null, null, '2018-03-24 14:34:29.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521902110679, 0, 82001, 2, '功能符(数组关键词): ①查询User数组，最多5个', '/get', '{"[]":{"count":5,"User":{}}}', null, null, '2018-03-24 14:35:10.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521904098110, 0, 82001, 2, '功能符: 减少 或 去除', '/put/balance', '{
    
    "Privacy": {
        "id": 82001,
        "balance+": -100,
        "_payPassword": "123456"
    },"tag": "Privacy"
}', null, null, '2018-03-24 15:08:18.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521904162065, 0, 82001, 2, '功能符: 增加 或 扩展', '/put', '{
    "Moment": {
        "id": 15,
        "praiseUserIdList+": [
            82001
        ]
    },
    "tag": "Moment"
}', null, null, '2018-03-24 15:09:22.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521904337053, 0, 82001, 2, '功能符: 新建别名', '/get', '{"Comment":{"@column":"id,toId:parentId","id":51}}', null, null, '2018-03-24 15:12:17.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521904437583, 0, 82001, 2, '功能符: 模糊搜索', '/get', '{"User[]":{"count":3,"User":{"name$":"%m%"}}}', null, null, '2018-03-24 15:13:57.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521904547991, 0, 82001, 2, '功能符: 引用赋值', '/get', '{"Moment":{
   "userId":38710
},
"User":{
   "id@":"/Moment/userId"
}}', null, null, '2018-03-24 15:15:47.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521904617126, 0, 82001, 2, '功能符: 远程调用函数', '/get', '{     "Moment": {         "id": 301,         "@column": "userId,praiseUserIdList",         "isPraised()": "isContain(praiseUserIdList,userId)"     } }', null, null, '2018-03-24 15:16:57.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521904653621, 0, 82001, 2, '功能符: 包含选项范围', '/get', '{"User[]":{"count":3,"User":{"contactIdList<>":38710}}}', null, null, '2018-03-24 15:17:33.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521904756673, 0, 82001, 2, '功能符: 查询数组', '/get', '{"User[]":{"count":3,"User":{}}}', null, null, '2018-03-24 15:19:16.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521905599149, 0, 82001, 2, '操作方法(PUT):  修改数据，只修改所传的字段', '/put', '{
   "Moment":{
     "id":235,
     "content":"APIJSON,let interfaces and documents go to hell !"
   },
   "tag":"Moment"
}', null, null, '2018-03-24 15:33:19.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521905680679, 0, 82001, 2, '操作方法(POST):  新增数据', '/post', '{     "Moment": {         "content": "APIJSON,let interfaces and documents go to hell !"     },     "tag": "Moment" }', null, null, '2018-03-24 15:34:40.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521905787849, 0, 82001, 2, '操作方法(HEADS):  安全/私密获取数量，用于获取银行卡数量等 对安全性要求高的数据总数', '/heads', '{
    "Login": {
        "userId": 38710,"type":1
    },
    "tag": "Login"
}', null, null, '2018-03-24 15:36:27.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521905868718, 0, 82001, 2, '操作方法(GETS):  安全/私密获取数据，用于获取钱包等 对安全性要求高的数据', '/gets', '{
    "Privacy": {
        "id": 82001
    },
    "tag": "Privacy"
}', null, null, '2018-03-24 15:37:48.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521905895590, 0, 82001, 2, '操作方法(HEAD):  普通获取数量，可用浏览器调试', '/head', '{
   "Moment":{
     "userId":38710
   }
}', null, null, '2018-03-24 15:38:15.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521905913187, 0, 82001, 2, '操作方法(GET):  普通获取数据，可用浏览器调试', '/get', '{
   "Moment":{
     "id":235
   }
}', null, null, '2018-03-24 15:38:33.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521906240331, 0, 82001, 2, 'User发布的Moment列表，每个Moment包括 1.发布者User 2.前3条Comment: ③不查已获取的User', '/get', '{
   "[]":{
     "page":0,
     "count":3, 
     "Moment":{
       "userId":38710
     },
     "Comment[]":{
       "count":3,
       "Comment":{
         "momentId@":"[]/Moment/id"
       }
     }
   }
}', null, null, '2018-03-24 15:44:00.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521906265959, 0, 82001, 2, 'User发布的Moment列表，每个Moment包括 1.发布者User 2.前3条Comment: ②省去重复的User', '/get', '{
   "User":{
     "id":38710
   },
   "[]":{
     "page":0,
     "count":3, 
     "Moment":{
       "userId":38710
     }, 
     "Comment[]":{
       "count":3,
       "Comment":{
         "momentId@":"[]/Moment/id"
       }
     }
   }
}', null, null, '2018-03-24 15:44:25.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521906517000, 0, 82001, 2, 'User发布的Moment列表，每个Moment包括 1.发布者User 2.前3条Comment: ①指定id', '/get', '{
    "[]": {
        "page": 0,
        "count": 3,
        "Moment":{"userId":38710}, "User":{"id":38710} ,
        "Comment[]": {
            "count": 3,
            "Comment": {
                "momentId@": "[]/Moment/id"
            }
        }
    }
}', null, null, '2018-03-24 15:48:37.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521907303539, 0, 82001, 2, 'User列表', '/get', '{
   "User[]":{
     "page":0,
     "count":3, 
     "User":{
       "sex":0
     }
   }
}', null, null, '2018-03-24 16:01:43.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521907317870, 0, 82001, 2, 'Moment和对应的User', '/get', '{
   "Moment":{
     "userId":38710
   }, 
   "User":{
     "id":38710
   }
}', null, null, '2018-03-24 16:01:57.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521907333047, 0, 82001, 2, '获取粉丝的动态列表', '/get', '{     "Moment[]": {         "join": "&/User/id@",         "Moment": {},         "User": {             "id@": "/Moment/userId",             "contactIdList<>": 82001,             "@column": "id"         }     } }', null, null, '2018-03-24 16:03:13.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521907546128, 0, 82001, 2, '获取类似微信朋友圈的动态列表', '/get', '{
    "[]": {
        "page": 0,
        "count": 2,
        "Moment": {
            "content$": "%a%"
        },
        "User": {
            "id@": "/Moment/userId",
            "@column": "id,name,head"
        },
        "Comment[]": {
            "count": 2,
            "Comment": {
                "momentId@": "[]/Moment/id"
            }
        }
    }
}', null, null, '2018-03-24 16:05:46.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521907570451, 0, 82001, 2, '获取动态及发布者用户', '/get', '{
    "Moment": {},
    "User": {
        "id@": "Moment/userId"
    }
}', null, null, '2018-03-24 16:06:10.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521907587429, 0, 82001, 2, '获取用户列表', '/get', '{
    "[]": {
        "count": 3,
        "User": {
            "@column": "id,name"
        }
    }
}', null, null, '2018-03-24 16:06:27.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521907601298, 0, 82001, 2, '获取用户', '/get', '{
  "User":{
  }
}', null, null, '2018-03-24 16:06:41.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1569382305979, 0, 82001, 2, '测试查询', '/get', '{
    "User": {
        "id": 82001
    },
    "[]": {
        "Comment": {
            "userId@": "User/id"
        }
    }
}', null, '', '2019-09-25 03:31:45.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1511963330794, 0, 82001, 2, '获取文档列表(即在线解析网页上的共享)-API调用方式', '/get', '{
    "Document[]": {
        "Document": {
            "@role": "LOGIN",
            "@order": "version-,date-"
        }
    }
}', null, null, '2017-11-29 13:48:50.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521907333046, 0, 82001, 2, 'Moment INNER JOIN User LEFT JOIN Comment', '/get', '{
    "[]": {
        "count": 10,
        "page": 0,
        "join": "&/User/id@,</Comment/momentId@",
        "Moment": {
            "@order": "date+"
        },
        "User": {
            "name~": [
                "a",
                "t"
            ],
            "id@": "/Moment/userId",
            "@column": "id,name,head"
        },
        "Comment": {
            "momentId@": "/Moment/id",
            "@column": "id,momentId,content"
        }
    }
}', null, null, '2018-03-24 16:02:43.000000', 'JSON', null);
INSERT INTO sys."Document" (id, debug, "userId", version, name, url, request, apijson, header, date, type, standard) VALUES (1521904394041, 0, 82001, 2, '功能符: 正则匹配', '/get', '{"User[]":{"count":3,"User":{"name~":"^[0-9]+$"}}}', null, null, '2018-03-24 15:13:14.000000', 'JSON', null);
