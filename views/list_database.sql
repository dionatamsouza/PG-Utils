/**
    * List databases.
    
    * @link http://www.dionatan.com.br
    * @author Developer: Dionatan Pinto de Souza
*/

    CREATE VIEW "utils"."list_database" AS
          
    SELECT pg_user.usename                                             AS owner
         , pg_database.datname                                         AS banco
         , pg_database_size( pg_database.datname )                     AS tamanho_bytes
         , pg_size_pretty( pg_database_size( pg_database.datname ) )   AS tamanho
      FROM pg_catalog.pg_database
 LEFT JOIN pg_catalog.pg_user
        ON pg_user.usesysid = pg_database.datdba ;
