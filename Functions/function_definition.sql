CREATE OR REPLACE FUNCTION fn_get_function_definition( a_fn_name text ) 
RETURNS text AS 
    DECLARE 
        ddl text; 
        fn_name text; 
        fn_args text; 
        fn_oid integer; 
        fn_return_type text; 
        fn_src text; 
        fn_lang text; 
        fn_nargs integer; 
    BEGIN 
        ddl := 'CREATE OR REPLACE FUNCTION '; 
        select proname into fn_name from pg_proc pp where pp.proname = a_fn_name; IF fn_name = '' THEN return 'FUNCTION NOT FOUND'; 
        END IF; select proargnames into fn_args from pg_proc where proname = a_fn_name; 
        select oid into fn_oid from pg_proc where proname = a_fn_name; 
        select pg_catalog.pg_get_function_arguments(fn_oid) into fn_args; 
        select prosrc into fn_src from pg_proc where proname = a_fn_name; 
        select pronargs into fn_nargs from pg_proc where proname = a_fn_name; 
        select pl.lanname into fn_lang from pg_proc pp inner join pg_language pl on pp.prolang = pl.oid where proname = a_fn_name; 
        select pt.typname into fn_return_type from pg_proc pp inner join pg_type pt on pp.prorettype = pt.oid where proname = a_fn_name; 
        ddl := ddl || fn_name || '( ' || fn_args || ' ) RETURNS ' || fn_return_type || ' AS ' || fn_src || ' LANGUAGE ' || fn_lang || ';'; 
        RETURN ddl; 
    END; 
LANGUAGE plpgsql;