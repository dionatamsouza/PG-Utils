/**
    * List tables and their triggers.
    
    * @link http://www.dionatan.com.br
    * @author Developer: Dionatan Pinto de Souza
*/

        -- ainda está pendente colocar schema da function?
    SELECT pg_namespace.nspname   AS schemaname
         , pg_class.relname       AS tablename
         , pg_trigger.tgname      AS trigger
         , pg_proc.proname        AS function
      FROM pg_catalog.pg_trigger
      JOIN pg_catalog.pg_proc
        ON pg_trigger.tgfoid = pg_proc.oid
      JOIN pg_catalog.pg_class
        ON pg_trigger.tgrelid = pg_class.oid
      JOIN pg_catalog.pg_namespace
        ON pg_class.relnamespace = pg_namespace.oid
     WHERE pg_trigger.tgname !~ '^RI\_ConstraintTrigger\_(a|c)\_[0-9]{10}$' ;
