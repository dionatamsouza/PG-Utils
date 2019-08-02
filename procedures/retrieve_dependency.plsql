/**
    * Retrieves dependencies from a table.
    
    * @link http://www.dionatan.com.br
    * @author Developer: Dionatan Pinto de Souza
*/
CREATE OR REPLACE FUNCTION "utils"."retrieve_dependency" (TEXT,TEXT,TEXT) RETURNS VOID AS $$

DECLARE
    quebra       ALIAS FOR $1;
    schemaname   ALIAS FOR $2;
    tablename    ALIAS FOR $3;
    stSql        VARCHAR;
    leitura      RECORD;
    
BEGIN
    
    stSql := '   SELECT DISTINCT
                        fkn.nspname  AS foreign_esquema
                      , fkc.relname  AS foreign_tabela
                       
                   FROM pg_catalog.pg_namespace AS pkn
                      , pg_catalog.pg_class pkc
                      , pg_catalog.pg_attribute AS pka
                      , pg_catalog.pg_namespace AS fkn
                      , pg_catalog.pg_class fkc
                      , pg_catalog.pg_attribute AS fka
                      , pg_catalog.pg_constraint AS con
                      , pg_catalog.generate_series(1, 32) AS vtable ( campo )
                      , pg_catalog.pg_depend AS dep
                      , pg_catalog.pg_class AS pkic
                       
                  WHERE pkn.oid        = pkc.relnamespace
                    AND pkc.oid        = pka.attrelid 
                    AND pka.attnum     = con.confkey[vtable.campo] 
                    AND con.confrelid  = pkc.oid  
                    AND fkn.oid        = fkc.relnamespace 
                    AND fkc.oid        = fka.attrelid 
                    AND fka.attnum     = con.conkey[vtable.campo] 
                    AND con.conrelid   = fkc.oid  
                    AND con.contype    = ''f''
                    AND con.oid        = dep.objid 
                    AND pkic.oid       = dep.refobjid 
                    AND pkic.relkind   = ''i'' 
                    AND dep.classid    = ''pg_constraint'' :: regclass :: oid 
                    AND dep.refclassid = ''pg_class'' :: regclass :: oid
                       
                    AND pkn.nspname = '''|| schemaname ||'''
                    AND pkc.relname = '''|| tablename ||'''
                       
               ORDER BY 1, 2   ';


    FOR leitura IN EXECUTE stSql LOOP
        
        RAISE NOTICE '% %.%', quebra, leitura.foreign_esquema, leitura.foreign_tabela ;
        
        PERFORM utils.retrieve_dependency( '    ' || quebra , leitura.foreign_esquema, leitura.foreign_tabela );
        
    END LOOP ;
    
END;

$$ LANGUAGE 'plpgsql';
