/**
    * List sequences.
    
    * @link http://www.dionatan.com.br
    * @author Developer: Dionatan Pinto de Souza
*/

    CREATE VIEW "utils"."list_sequences" AS
          
    SELECT pg_namespace.nspname AS schemaname
         , pg_class.relname     AS sequence_name
      FROM pg_catalog.pg_class
      JOIN pg_catalog.pg_namespace
        ON pg_class.relnamespace = pg_namespace.oid
     WHERE pg_class.relkind = 'S'
  ORDER BY schemaname
         , sequence_name ;
