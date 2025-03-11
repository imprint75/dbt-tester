SELECT table_name FROM information_schema.tables WHERE table_schema='source';

DROP TABLE source.users;

DROP SCHEMA source;
