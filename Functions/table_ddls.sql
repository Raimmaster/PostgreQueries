CREATE FUNCTION "create_table_ddl" (varchar) returns varchar as '
	
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
