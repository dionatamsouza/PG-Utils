/**
    * List procedural languages.
    
    * @link http://www.dionatan.com.br
    * @author Developer: Dionatan Pinto de Souza
*/

    SELECT DISTINCT
           pg_namespace.nspname AS schema
         , pg_proc.proname      AS procedure_name
         , pg_proc.prosrc       AS source
          
      FROM pg_catalog.pg_namespace
         , pg_catalog.pg_proc
 LEFT JOIN pg_catalog.pg_description
        ON pg_proc.oid = pg_description.objoid
 LEFT JOIN pg_catalog.pg_class
        ON pg_description.classoid = pg_class.oid
       AND pg_class.relname        = 'pg_proc'
 LEFT JOIN pg_catalog.pg_namespace AS pg_namespace_2
        ON pg_class.relnamespace  = pg_namespace_2.oid
       AND pg_namespace_2.nspname = 'pg_catalog'
          
     WHERE pg_proc.pronamespace = pg_namespace.oid ;
