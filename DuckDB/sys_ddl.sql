create table "Praise"
(
);

create table "Random"
(
);

create table "_Visit"
(
);


create table "Method"
(
);


create table "Document"
(
    id              bigint,
    debug           smallint,
    "userId"        bigint,
    "testAccountId" bigint,
    version         smallint,
    name            varchar(100),
    type            varchar(5),
    url             varchar(250),
    request         text,
    apijson         text,
    sqlauto         text,
    standard        text,
    header          text,
    date            timestamp,
    detail          text
);


create table apijson_privacy
(
    id             bigint         not null
        primary key,
    certified      smallint       not null,
    phone          varchar(64)    not null,
    balance        numeric(10, 2) not null,
    _password      varchar(20)    not null,
    "_payPassword" varchar(32)    not null
);

comment on table apijson_privacy is '用户隐私信息表。\n对安全要求高，不想泄漏真实名称。对外名称为 Privacy';

comment on column apijson_privacy.id is '唯一标识';

comment on column apijson_privacy.certified is '已认证';

comment on column apijson_privacy.phone is '手机号，仅支持 11 位数的。不支持 +86 这种国家地区开头的。如果要支持就改为 VARCHAR(14)';

comment on column apijson_privacy.balance is '余额';

comment on column apijson_privacy._password is '登录密码';

comment on column apijson_privacy."_payPassword" is '支付密码';

create index "phone_UNIQUE"
    on apijson_privacy (phone);

create table apijson_user
(
    id              bigint   not null
        primary key,
    sex             smallint not null,
    name            varchar(20),
    tag             varchar(45),
    head            varchar(300),
    "contactIdList" json,
    "pictureList"   json,
    date            timestamp(6)
);

comment on table apijson_user is '用户公开信息表。对安全要求高，不想泄漏真实名称。对外名称为 User';

comment on column apijson_user.id is '唯一标识';

comment on column apijson_user.sex is '性别：
0-男
1-女';

comment on column apijson_user.name is '名称';

comment on column apijson_user.tag is '标签';

comment on column apijson_user.head is '头像url';

comment on column apijson_user."contactIdList" is '联系人id列表';

comment on column apijson_user."pictureList" is '照片列表';

comment on column apijson_user.date is '创建日期';


create table "Comment"
(
    id         bigint           not null
        primary key,
    "toId"     bigint default 0 not null,
    "userId"   bigint           not null,
    "momentId" bigint           not null,
    date       timestamp(6),
    content    varchar(1000)    not null
);

comment on table "Comment" is '评论';

comment on column "Comment".id is '唯一标识';

comment on column "Comment"."toId" is '被回复的id';

comment on column "Comment"."userId" is '评论人id';

comment on column "Comment"."momentId" is '动态id';

comment on column "Comment".date is '创建日期';

comment on column "Comment".content is '内容';

create table "Moment"
(
    id                 bigint not null
        primary key,
    "userId"           bigint not null,
    date               timestamp(6),
    content            varchar(300),
    "praiseUserIdList" json  not null,
    "pictureList"      json  not null
);

comment on table "Moment" is '动态';

comment on column "Moment".id is '唯一标识';

comment on column "Moment"."userId" is '用户id';

comment on column "Moment".date is '创建日期';

comment on column "Moment".content is '内容';

comment on column "Moment"."praiseUserIdList" is '点赞的用户id列表';

comment on column "Moment"."pictureList" is '图片列表';


create table "TestRecord"
(
    id              bigint                                 not null
        primary key,
    "userId"        bigint                                 not null,
    "documentId"    bigint                                 not null,
    response        text                                   not null,
    date            timestamp(6) default CURRENT_TIMESTAMP not null,
    compare         text,
    standard        text,
    "randomId"      bigint       default 0,
    headless        smallint     default 0                 not null,
    "reportId"      bigint       default 0                 not null,
    "testAccountId" bigint       default 0                 not null,
    duration        bigint       default 0                 not null,
    "minDuration"   bigint       default 0                 not null,
    "maxDuration"   bigint       default 0                 not null,
    host            varchar(200)
);

comment on column "TestRecord".id is '唯一标识';

comment on column "TestRecord"."userId" is '用户id';

comment on column "TestRecord"."documentId" is '测试用例文档id';

comment on column "TestRecord".response is '接口返回结果JSON';

comment on column "TestRecord".date is '创建日期';

comment on column "TestRecord".compare is '对比结果';

comment on column "TestRecord".standard is 'response 的校验标准，是一个 JSON 格式的 AST ，描述了正确 Response 的结构、里面的字段名称、类型、长度、取值范围 等属性。';

comment on column "TestRecord"."randomId" is '随机配置 id';

comment on column "TestRecord".headless is '是否为无 UI 的 Headless 模式：0-否 1-是';

comment on column "TestRecord"."reportId" is '测试报告 ID';

comment on column "TestRecord"."testAccountId" is '测试账号 id';

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

comment on column "Function".language is '语言：Java(java), JavaScript(js), Lua(lua), Python(py), Ruby(ruby), PHP(php) 等，NULL 默认为 Java，JDK 1.6-11 默认支持 JavaScript，JDK 12+ 需要额外依赖 Nashron/Rhiro 等 js 引擎库，其它的语言需要依赖对应的引擎库，并在 ScriptEngineManager 中注册';

comment on column "Function".name is '方法名';

comment on column "Function"."returnType" is '返回类型';

comment on column "Function".arguments is '参数列表，每个参数的类型都是 String。
用 , 分割的字符串 比 [JSONArray] 更好，例如 array,item ，更直观，还方便拼接函数。';

comment on column "Function".demo is '可用的示例。';

comment on column "Function".detail is '详细描述';

comment on column "Function".date is '创建时间';

comment on column "Function"."userId" is '用户id';

comment on column "Function".version is '允许的最低版本号，只限于GET,HEAD外的操作方法。\nTODO 使用 requestIdList 替代 version,tag,methods';

comment on column "Function".tag is '允许的标签.\nnull - 允许全部\nTODO 使用 requestIdList 替代 version,tag,methods';

comment on column "Function".methods is '允许的操作方法。\nnull - 允许全部\nTODO 使用 requestIdList 替代 version,tag,methods';

comment on column "Function".return is '返回值示例';

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


create table "Access"
(
    id     integer                                                                                  not null
        primary key,
    schema varchar(100) default NULL::character varying,
    debug  integer      default 0                                                                   not null,
    name   varchar(50)  default '实际表名，例如 apijson_user'::character varying                     not null,
    alias  text,
    get    text         default '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]'::text not null,
    head   text         default '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]'::text not null,
    gets   text         default '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]'::text            not null,
    heads  text         default '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]'::text            not null,
    post   text         default '["OWNER", "ADMIN"]'::text                                          not null,
    put    text         default '["OWNER", "ADMIN"]'::text                                          not null,
    delete text         default '["OWNER", "ADMIN"]'::text                                          not null,
    date   text         default CURRENT_TIMESTAMP                                                   not null,
    detail text
);

comment on column "Access".id is '唯一标识';

comment on column "Access".debug is '是否为调试表，只允许在开发环境使用，测试和线上环境禁用';

comment on column "Access".alias is '外部调用的表别名，例如 User';

comment on column "Access".get is '允许 get 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]
用 JSON 类型不能设置默认值，反正权限对应的需求是明确的，也不需要自动转 JSONArray。
TODO: 直接 LOGIN,CONTACT,CIRCLE,OWNER 更简单，反正是开发内部用，不需要复杂查询。';

comment on column "Access".head is '允许 head 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';

comment on column "Access".gets is '允许 gets 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';

comment on column "Access".heads is '允许 heads 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';

comment on column "Access".post is '允许 post 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';

comment on column "Access".put is '允许 put 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';

comment on column "Access".delete is '允许 delete 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';

comment on column "Access".date is '创建时间';


create table "Verify"
(
    id     bigint,
    type   integer,
    phone  bigint,
    verify integer,
    date   timestamp
);


