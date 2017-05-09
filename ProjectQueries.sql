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
------OLD SQL
--select
--	refs_cons.constraint_catalog, refs_cons.constraint_schema, refs_cons.update_rule, refs_cons.delete_rule
--from information_schema.referential_constraints refs_cons;
------OLD SQL

--Current one; Lists FKs too
select 
	cols.constraint_name, 
	cols.table_catalog as db, 
	cols.table_schema, 
	cols.table_name, 
	tabs.constraint_type, 
	cols.column_name 
from 
	information_schema.table_constraints tabs 
inner join 
	information_schema.constraint_column_usage cols 
on 
	tabs.constraint_name = cols.constraint_name;


--FKs
SELECT
    table_schema.constraint_schema, tc.constraint_name, tc.table_name, kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
WHERE constraint_type = 'FOREIGN KEY' 

--Inciso 3 - Indexes
--No PKs nor FKs
select * from pg_indexes;

--Lists FKs
SELECT
    tc.constraint_name, tc.table_name, kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
WHERE constraint_type = 'FOREIGN KEY' 
