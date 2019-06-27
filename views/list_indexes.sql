/**
    * List tables and their indexes.
    
    * @link http://www.dionatan.com.br
    * @author Developer: Dionatan Pinto de Souza
*/

    CREATE VIEW "utils"."list_indexes" AS
          
    SELECT schemaname
         , tablename
         , indexname
         , indexdef
      FROM pg_catalog.pg_indexes ;
