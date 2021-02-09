CREATE TABLE sys."Response"
(
    id bigint PRIMARY KEY NOT NULL,
    method varchar(10),
    model varchar(20) NOT NULL,
    structure text NOT NULL,
    detail varchar(10000),
    date timestamp(6)
);
COMMENT ON COLUMN sys."Response".id IS '唯一标识';
COMMENT ON COLUMN sys."Response".method IS '方法';
COMMENT ON COLUMN sys."Response".model IS '表名，table是SQL关键词不能用';
COMMENT ON COLUMN sys."Response".structure IS '结构';
COMMENT ON COLUMN sys."Response".detail IS '详细说明';
COMMENT ON COLUMN sys."Response".date IS '创建日期';
CREATE INDEX "id_UNIQUE" ON sys."Response" (id);
INSERT INTO sys."Response" (id, method, model, structure, detail, date) VALUES (1, 'GET', 'User', '{"put": {"extra": "Response works! Test:He(She) is lazy and wrote nothing here"}, "remove": "phone"}', null, '2017-05-22 12:36:47.000000');
INSERT INTO sys."Response" (id, method, model, structure, detail, date) VALUES (2, 'DELETE', 'Comment', '{"remove": "Comment:child"}', null, '2017-05-03 17:51:26.000000');
INSERT INTO sys."Response" (id, method, model, structure, detail, date) VALUES (3, 'DELETE', 'Moment', '{"remove": "Comment"}', null, '2017-05-03 17:51:26.000000');