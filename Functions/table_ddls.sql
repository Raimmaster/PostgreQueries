CREATE FUNCTION "create_table_ddl" (schema_name text, table_name text) returns text as '
	
' LANGUAGE 'plpgsql';
DECLARE
TABLE_DDL VARCHAR (32767);
BEGIN
    TABLE_DDL := CONCAT('CREATE TABLE ', TABLE_NAME_IN);
    TABLE_DDL := CONCAT(TABLE_DDL, '(');
    FOR row_s IN (
        SELECT
            TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_LENGTH, NULLABLE, DATA_DEFAULT
            FROM ALL_TAB_COLUMNS
        WHERE
            OWNER = OWNER_NAME AND
            TABLE_NAME = TABLE_NAME_IN
    )
    LOOP
        TABLE_DDL := CONCAT(TABLE_DDL, row_s.COLUMN_NAME);
        TABLE_DDL := CONCAT(TABLE_DDL, ' ');
        TABLE_DDL := CONCAT(TABLE_DDL, row_s.DATA_TYPE);
        TABLE_DDL := CONCAT(TABLE_DDL, '(');
        TABLE_DDL := CONCAT(TABLE_DDL, row_s.DATA_LENGTH);
        TABLE_DDL := CONCAT(TABLE_DDL, ') ');
        IF row_s.NULLABLE = 'Y' THEN
            TABLE_DDL := CONCAT(TABLE_DDL, 'NULL');
        ELSE
            TABLE_DDL := CONCAT(TABLE_DDL, 'NOT NULL');
        END IF;
        TABLE_DDL := CONCAT(TABLE_DDL, ', ');
    END LOOP;

    TABLE_DDL := 

    TABLE_DDL := TABLE_DDL || ')';
    RETURN TABLE_DDL;

END;

--Example output
CREATE TABLE account_role
(
  user_id integer NOT NULL,
  role_id integer NOT NULL,
  grant_date timestamp without time zone,
  PRIMARY KEY (user_id, role_id),
  CONSTRAINT account_role_role_id_fkey FOREIGN KEY (role_id)
      REFERENCES role (role_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT account_role_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES account (user_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)


CREATE OR REPLACE FUNCTION generate_table_ddl(tableName text, tableSchema text)
    RETURNS text AS
$$
DECLARE
    column_row record;
    pk_row record;
    fk_row record;
    table_ddl text;
BEGIN
    table_ddl := 'CREATE TABLE ' || tableSchema || '.' || tableName || '(';
    --COLUMNS
    --col_name col_type (numeric_limit) CHECK CLAUSE
    FOR column_row IN (
        select
            table_schema, table_name, 
            column_name, column_default, 
            is_nullable, data_type, 
            character_maximum_length
        from information_schema.columns
        where table_name = tableName
        and table_schema = tableSchema
    )
    LOOP
        table_ddl := table_ddl || column_row.column_name || ' ' || column_row.data_type || ' ';
        IF column_row.character_maximum_length IS NOT NULL THEN
            table_ddl := table_ddl || '(' || column_row.character_maximum_length || ') ';
        END IF;
        IF column_row.column_default IS NOT NULL THEN
            table_ddl := table_ddl || ' DEFAULT ' || column_row.column_default || ' ';
        END IF;
        IF column_row.is_nullable = 'NO' THEN
            table_ddl := table_ddl || ' NOT NULL ';
        END IF;
        table_ddl := table_ddl || ', ';
    END LOOP;
    --PRIMARY KEY CONSTRAINTS
    
    table_ddl := table_ddl || ' PRIMARY KEY (';
    for pk_row in ( 
        select 
            cols.table_schema, 
            cols.table_name,
            cols.column_name 
        from 
            information_schema.table_constraints tabs 
        inner join 
            information_schema.constraint_column_usage cols 
        on 
            tabs.constraint_name = cols.constraint_name
        where 
            tabs.constraint_type = 'PRIMARY KEY' and 
            cols.table_schema = tableSchema and
            cols.table_name = tableName
    )
    LOOP
        table_ddl := table_ddl || pk_row.column_name || ', ';
    END LOOP;
    
    --FOREIGN KEY CONSTRAINTS
    FOR fk_row IN (
        SELECT
            tc.constraint_schema, tc.constraint_name as fk_constr, 
            tc.table_name, kcu.column_name, 
            ccu.table_name AS foreign_table_name,
            ccu.column_name AS foreign_column_name,
            rfc.update_rule, rfc.delete_rule
        FROM 
            information_schema.table_constraints AS tc 
            JOIN information_schema.key_column_usage AS kcu
              ON tc.constraint_name = kcu.constraint_name
            JOIN information_schema.constraint_column_usage AS ccu
              ON ccu.constraint_name = tc.constraint_name
            JOIN information_schema.referential_constraints AS rfc
              ON tc.constraint_name = rfc.constraint_name
        WHERE constraint_type = 'FOREIGN KEY' AND
            tc.table_name = tableName
    )
    LOOP
        table_ddl := table_ddl || ' CONSTRAINT ';
        table_ddl := table_ddl || fk_row.fk_constr;
        table_ddl := table_ddl || ' FOREIGN KEY (' || fk_row.kcu.column_name ') ';
        table_ddl := table_ddl || ' REFERENCES ' || fk_row.ccu.table_name || '(';
        table_ddl := table_ddl || fk_row.ccu.column_name || ') ';
        table_ddl := table_ddl || 'ON UPDATE ' || rfc.update_rule;
        table_ddl := table_ddl || ' ON DELETE ' || rfc.delete_rule || ',';
    END LOOP;

    table_ddl := table_ddl || ');';
    RETURN table_ddl;
END;
$$
LANGUAGE 'plpgsql';