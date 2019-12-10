/**
    * Retrieves dependencies from a table in a JSON format.
    
    * @link http://www.dionatan.com.br
    * @author Developer: Dionatan Pinto de Souza
*/
CREATE OR REPLACE FUNCTION "utils"."retrieve_json_dependency" (TEXT,TEXT) RETURNS JSON AS $$

DECLARE
    retorno TEXT ;
    
BEGIN
    
    EXECUTE '
    
    SELECT row_to_json(dados) AS dependencias
      FROM ( SELECT pg_tables.schemaname AS esquema
                  , pg_tables.tablename  AS tabela
                  , (   SELECT array_agg(row_to_json(dependencias))
                          FROM (   SELECT utils.retrieve_dependency( esquema, tabela ) AS dependencia
                                     FROM (   SELECT DISTINCT
                                                     fkn.nspname  AS esquema
                                                   , fkc.relname  AS tabela
                                                    
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
                                                    
                                                 AND pkn.nspname = ''' || $1 || '''
                                                 AND pkc.relname = ''' || $2 || '''
                                                    
                                            ORDER BY 1, 2
                                       ) AS dependencias
                               ) AS dependencias
                      ) AS dependencias
               FROM pg_catalog.pg_tables
              WHERE pg_tables.schemaname = ''' || $1 || '''
                AND pg_tables.tablename  = ''' || $2 || '''
           ) AS dados ' INTO retorno ;
    
    retorno := replace( retorno , '\' , '' );
    retorno := replace( retorno , '{"dependencia":"{' , '{' );
    retorno := replace( retorno , '}"}' , '}' );
    retorno := replace( retorno , '","dependencias":null}' , '"}' );
    
    RETURN retorno ;
    
END;

$$ LANGUAGE 'plpgsql';
