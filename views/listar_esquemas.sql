    CREATE VIEW "listar_esquemas" AS
          
    SELECT pg_namespace.nspname AS schemaname
         , pg_catalog.pg_get_userbyid(pg_namespace.nspowner) AS owner
         , coalesce( contagem.tabelas, 0 ) AS tabelas
      FROM pg_catalog.pg_namespace
 LEFT JOIN (   SELECT schemaname
                    , count(tablename) AS tabelas
                 FROM pg_catalog.pg_tables
             GROUP BY schemaname
           ) AS contagem
        ON pg_namespace.nspname = contagem.schemaname
     WHERE pg_namespace.nspname !~ '^pg_'
       AND pg_namespace.nspname != 'information_schema' ;
