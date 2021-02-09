CREATE TABLE sys."_Visit"
(
    model varchar(15) NOT NULL,
    id bigint NOT NULL,
    operate smallint NOT NULL,
    date timestamp(6) NOT NULL
);
COMMENT ON COLUMN sys."_Visit".operate IS '1-增
2-删
3-改
4-查';