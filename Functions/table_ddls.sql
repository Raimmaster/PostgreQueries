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
        and table_schema = tableSchema;
    )
    LOOP
        table_ddl := table_ddl || column_name || ' ' || data_type || ' ';
        IF character_maximum_length IS NOT NULL THEN
            table_ddl := table_ddl || '(' character_maximum_length || ') ';
        END IF;
        IF column_default IS NOT NULL THEN
            table_ddl := table_ddl || ' DEFAULT ' || column_default || ' ';
        END IF;
        IF is_nullable = 'NO' THEN
            table_ddl := table_ddl || ' NOT NULL ';
        END IF;
        

    END LOOP;
    --PRIMARY KEY CONSTRAINTS

    --FOREIGN KEY CONSTRAINTS
    RETURN table_ddl;
END;
$$
LANGUAGE 'plpgsql';