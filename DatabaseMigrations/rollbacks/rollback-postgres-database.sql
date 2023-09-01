--  This script is used to delete all database objects on a Postgres database
--  IT MUST BE USED ONLY ON THE DEV/TEST/SANDBOX ENVIRONMENT
--  to allow switching across branches with different changelog sets
--  To execute the script with Liquibase run: 
--  liquibase execute-sql --sql-file /liquibase/rollbacks/rollback-postgres-database.sql

DO 
'
DECLARE schemasNames text;
DECLARE tablenames text;
DECLARE enumTypes text;
BEGIN    

    tablenames := string_agg(''"'' || schemaname || ''"."'' || tablename || ''"'', '', '')  FROM pg_tables WHERE schemaname != ''pg_catalog'' AND schemaname != ''information_schema'';
    IF coalesce(tablenames, '''') != '''' THEN
        raise notice ''Deleting: %'', tablenames;
        EXECUTE ''DROP TABLE '' || tablenames;
    ELSE
        raise notice ''No table to delete'';
    END IF;

    enumTypes := string_agg(''"'' || typname || ''"'', '', '')  FROM (SELECT DISTINCT concat(n.nspname, ''"."'', t.typname) as typname
                                                                        FROM pg_type t 
                                                                        JOIN pg_enum e on t.oid = e.enumtypid  
                                                                        JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
                                                                        WHERE n.nspname != ''pg_catalog'' AND n.nspname != ''information_schema'') 
                                                                AS t;
    IF coalesce(enumTypes, '''') != '''' THEN
        raise notice ''Deleting: %'', enumTypes;
        EXECUTE ''DROP TYPE '' || enumTypes;
    ELSE
        raise notice ''No enum types to delete'';
    END IF;

    schemasNames:= string_agg(''"'' || nspname || ''"'', '', '')  
                    FROM   pg_namespace 
                    WHERE nspname NOT LIKE ''pg_%''
                    AND nspname != ''public''
                    AND nspname != ''information_schema'';


    IF coalesce(schemasNames, '''') != '''' THEN
        raise notice ''Deleting the following schemas: % '', schemasNames;
        EXECUTE ''DROP SCHEMA '' || schemasNames || ''CASCADE'';
    ELSE
        raise notice ''No schema to delete'';
    END IF;


END; 
'