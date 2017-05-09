--Inciso 1 - Connections
select pid from pg_stat_activity;
select pg_terminate_backend( <procpid> );

--Inciso 2 - DDL Tablas
--TABLES
select 
	tab.schemaname, 
	tab.tablename, 
	tab.tablespace 
from pg_tables tab;

--COLUMNS
select
	cols.table_catalog, cols.table_schema, cols.table_name, cols.columns_name, cols.column_default, cols.is_nullable,
	cols.data_type, cols.character_maximum_length, udt_name
from information_schema.columns cols;

--CHECKS
select 
	chks.constraint_catalog, chks.constraint_schema, chks.check_clause
from information_schema.check_constraints chks;

--PKs
--missing column name
select
	refs_cons.constraint_catalog, refs_cons.constraint_schema, refs_cons.update_rule, refs_cons.delete_rule
from information_schema.referential_constraints refs_cons;


--FKs

--REFERENCES constraint_catalog ()

--Inciso 3 - Indexes
--No PKs nor FKs
select * from pg_indexes;