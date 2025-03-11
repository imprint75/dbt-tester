SELECT table_name FROM information_schema.tables WHERE table_schema='source';

CREATE SCHEMA if not exists source;

CREATE TABLE if not exists source.users (
 id serial primary key,
 user_name varchar(60) null,
 email varchar(60) null,
 timezone varchar(60) null
);
