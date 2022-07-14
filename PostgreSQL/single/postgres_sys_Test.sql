create table "Test"
(
    id smallint not null
        primary key
);

alter table "Test"
    owner to postgres;

INSERT INTO sys."Test" (id) VALUES (1);
