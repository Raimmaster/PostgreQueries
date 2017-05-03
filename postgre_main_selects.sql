select * from pg_tables; --schemaname, tableowner
select * from pg_index;
select * from pg_indexes;--''
select * from pg_proc;--proname, proowner
select * from pg_trigger;--tgname
select * from pg_user;
select * from pg_roles;--oid
select * from pg_views;--'', viewowner
select pg_get_functiondef(oid) from pg_proc; --full function def
--INFORMATION_SCHEMA

select * from information_schema.check_constraints; --constraint_schema
select * from information_schema.referential_constraints; --FKs; constraint_schema
select * from information_schema.schemata; --current db's accesable schemas
select * from information_schema.tables; --table_catalog, table_schema
select * from information_schema.triggers; --trigger_schema
select * from information_schema.views; --table_catalog, table_schema

