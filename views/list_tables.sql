/**
    * List tables.
    
    * @link http://www.dionatan.com.br
    * @author Developer: Dionatan Pinto de Souza
*/

    CREATE VIEW "utils"."list_tables" AS 
          
    SELECT T.schemaname                                                                               AS schemaname
         , T.tablename                                                                                AS tablename
         , pg_size_pretty( pg_relation_size( T.schemaname || '.' || T.tablename ) :: BIGINT )         AS tamanho_virtual
         , pg_size_pretty( pg_total_relation_size( T.schemaname || '.' || T.tablename ) :: BIGINT )   AS tamanho_fisico
         , pg_total_relation_size( T.schemaname || '.' || T.tablename ) :: BIGINT                     AS tamanho_fisico_bytes
      FROM ( SELECT quote_ident ( pg_tables.schemaname ) AS schemaname
                  , quote_ident ( pg_tables.tablename  ) AS tablename
               FROM pg_catalog.pg_tables
              WHERE pg_tables.schemaname !~ '^pg_'
                AND pg_tables.schemaname != 'information_schema'
           ) AS t ;
