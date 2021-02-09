CREATE TABLE sys."Access"
(
    id integer PRIMARY KEY NOT NULL,
    debug integer DEFAULT 0 NOT NULL,
    name varchar(50) DEFAULT '实际表名，例如 apijson_user'::character varying NOT NULL,
    alias text,
    get text DEFAULT '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]'::text NOT NULL,
    head text DEFAULT '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]'::text NOT NULL,
    gets text DEFAULT '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]'::text NOT NULL,
    heads text DEFAULT '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]'::text NOT NULL,
    post text DEFAULT '["OWNER", "ADMIN"]'::text NOT NULL,
    put text DEFAULT '["OWNER", "ADMIN"]'::text NOT NULL,
    delete text DEFAULT '["OWNER", "ADMIN"]'::text NOT NULL,
    date text DEFAULT CURRENT_TIMESTAMP NOT NULL
);
COMMENT ON COLUMN sys."Access".id IS '唯一标识';
COMMENT ON COLUMN sys."Access".debug IS '是否为调试表，只允许在开发环境使用，测试和线上环境禁用';
COMMENT ON COLUMN sys."Access".alias IS '外部调用的表别名，例如 User';
COMMENT ON COLUMN sys."Access".get IS '允许 get 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]
用 JSON 类型不能设置默认值，反正权限对应的需求是明确的，也不需要自动转 JSONArray。
TODO: 直接 LOGIN,CONTACT,CIRCLE,OWNER 更简单，反正是开发内部用，不需要复杂查询。';
COMMENT ON COLUMN sys."Access".head IS '允许 head 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';
COMMENT ON COLUMN sys."Access".gets IS '允许 gets 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';
COMMENT ON COLUMN sys."Access".heads IS '允许 heads 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';
COMMENT ON COLUMN sys."Access".post IS '允许 post 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';
COMMENT ON COLUMN sys."Access".put IS '允许 put 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';
COMMENT ON COLUMN sys."Access".delete IS '允许 delete 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';
COMMENT ON COLUMN sys."Access".date IS '创建时间';
CREATE UNIQUE INDEX access_alias_uindex ON sys."Access" (alias);
INSERT INTO sys."Access" (id, debug, name, alias, get, head, gets, heads, post, put, delete, date) VALUES (1, 1, 'Access', '', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '[]', '[]', '[]', '2019-07-21 12:21:36');
INSERT INTO sys."Access" (id, debug, name, alias, get, head, gets, heads, post, put, delete, date) VALUES (2, 1, 'Table', null, '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '[]', '[]', '[]', '2018-11-28 16:38:14');
INSERT INTO sys."Access" (id, debug, name, alias, get, head, gets, heads, post, put, delete, date) VALUES (3, 1, 'Column', null, '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '[]', '[]', '[]', '2018-11-28 16:38:14');
INSERT INTO sys."Access" (id, debug, name, alias, get, head, gets, heads, post, put, delete, date) VALUES (4, 1, 'Function', null, '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '[]', '[]', '[]', '2018-11-28 16:38:15');
INSERT INTO sys."Access" (id, debug, name, alias, get, head, gets, heads, post, put, delete, date) VALUES (5, 1, 'Request', null, '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '[]', '[]', '[]', '2018-11-28 16:38:14');
INSERT INTO sys."Access" (id, debug, name, alias, get, head, gets, heads, post, put, delete, date) VALUES (6, 1, 'Response', null, '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '[]', '[]', '[]', '2018-11-28 16:38:15');
INSERT INTO sys."Access" (id, debug, name, alias, get, head, gets, heads, post, put, delete, date) VALUES (7, 1, 'Document', null, '["LOGIN", "ADMIN"]', '["LOGIN", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["OWNER", "ADMIN"]', '["LOGIN", "ADMIN"]', '["OWNER", "ADMIN"]', '2018-11-28 16:38:15');
INSERT INTO sys."Access" (id, debug, name, alias, get, head, gets, heads, post, put, delete, date) VALUES (8, 1, 'TestRecord', null, '["LOGIN", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["OWNER", "ADMIN"]', '["OWNER", "ADMIN"]', '["OWNER", "ADMIN"]', '2018-11-28 16:38:15');
INSERT INTO sys."Access" (id, debug, name, alias, get, head, gets, heads, post, put, delete, date) VALUES (9, 0, 'Test', null, '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '[]', '[]', '[]', '2018-11-28 16:38:15');
INSERT INTO sys."Access" (id, debug, name, alias, get, head, gets, heads, post, put, delete, date) VALUES (10, 1, 'PgAttribute', null, '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '[]', '[]', '[]', '2018-11-28 16:38:14');
INSERT INTO sys."Access" (id, debug, name, alias, get, head, gets, heads, post, put, delete, date) VALUES (11, 1, 'PgClass', null, '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '[]', '[]', '[]', '2018-11-28 16:38:14');
INSERT INTO sys."Access" (id, debug, name, alias, get, head, gets, heads, post, put, delete, date) VALUES (12, 0, 'Login', null, '[]', '[]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '[ "ADMIN"]', '[ "ADMIN"]', '["ADMIN"]', '2018-11-28 16:29:48');
INSERT INTO sys."Access" (id, debug, name, alias, get, head, gets, heads, post, put, delete, date) VALUES (13, 0, 'Verify', null, '[]', '[]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '[ "ADMIN"]', '["ADMIN"]', '2018-11-28 16:29:48');
INSERT INTO sys."Access" (id, debug, name, alias, get, head, gets, heads, post, put, delete, date) VALUES (14, 0, 'apijson_user', 'User', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN","LOGIN","OWNER", "ADMIN"]', '["OWNER", "ADMIN"]', '["ADMIN"]', '2018-11-28 16:28:53');
INSERT INTO sys."Access" (id, debug, name, alias, get, head, gets, heads, post, put, delete, date) VALUES (15, 0, 'apijson_privacy', 'Privacy', '[]', '[]', '["OWNER", "ADMIN"]', '["OWNER", "ADMIN"]', '["UNKNOWN","LOGIN","OWNER", "ADMIN"]', '["OWNER", "ADMIN"]', '["ADMIN"]', '2018-11-28 16:29:48');
INSERT INTO sys."Access" (id, debug, name, alias, get, head, gets, heads, post, put, delete, date) VALUES (16, 0, 'Moment', null, '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["OWNER", "ADMIN"]', '2018-11-28 16:29:19');
INSERT INTO sys."Access" (id, debug, name, alias, get, head, gets, heads, post, put, delete, date) VALUES (17, 0, 'Comment', null, '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]', '["OWNER", "ADMIN"]', '["OWNER", "ADMIN"]', '["OWNER", "ADMIN"]', '2018-11-28 16:29:19');