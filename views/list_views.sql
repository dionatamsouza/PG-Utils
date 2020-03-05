/**
    * List views and materialized views.
    
    * @link http://www.dionatan.com.br
    * @author Developer: Dionatan Pinto de Souza
*/

    SELECT pg_namespace.nspname   AS schemaname
         , pg_class.relname       AS viewname
         , CASE pg_class.relkind
               WHEN 'v' THEN false
               WHEN 'm' THEN true
           END AS materialized
         , pg_get_viewdef(pg_class.oid)   AS source
      FROM pg_catalog.pg_class
 LEFT JOIN pg_catalog.pg_namespace
        ON pg_namespace.oid = pg_class.relnamespace
     WHERE pg_class.relkind IN ( 'v', 'm' )
       AND pg_namespace.nspname !~ '^pg\_'
       AND pg_namespace.nspname NOT IN ( 'information_schema', 'utils' ) ;
