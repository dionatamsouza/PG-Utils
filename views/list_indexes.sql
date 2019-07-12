/**
    * List tables and their indexes.
    
    * @link http://www.dionatan.com.br
    * @author Developer: Dionatan Pinto de Souza
*/

    CREATE VIEW "utils"."list_indexes" AS
          
    WITH all_clustered_tables_in_database AS (
          
    SELECT pg_namespace.nspname AS schemaname
         , pg_class.relname     AS tablename
         , pg_class2.relname    AS indexname
      FROM pg_catalog.pg_index
      JOIN pg_catalog.pg_class
        ON pg_index.indrelid = pg_class.oid
      JOIN pg_catalog.pg_namespace
        ON pg_class.relnamespace = pg_namespace.oid
      JOIN pg_catalog.pg_class AS pg_class2
        ON pg_index.indexrelid = pg_class2.oid
     WHERE pg_class.relkind = 'r'
       AND pg_class.relhasindex    IS TRUE
       AND pg_index.indisclustered IS TRUE
          
    )
    
    SELECT pg_indexes.tablespace   AS tablespace
         , pg_indexes.schemaname   AS schemaname
         , pg_indexes.tablename    AS tablename
         , pg_indexes.indexname    AS index_name
         , pg_indexes.indexdef     AS index_definition
         , CASE WHEN ct.indexname IS NULL THEN FALSE ELSE TRUE END AS is_clustered
          
      FROM pg_catalog.pg_indexes
 LEFT JOIN all_clustered_tables_in_database AS ct
        ON pg_indexes.schemaname = ct.schemaname
       AND pg_indexes.tablename  = ct.tablename
       AND pg_indexes.indexname  = ct.indexname ;
