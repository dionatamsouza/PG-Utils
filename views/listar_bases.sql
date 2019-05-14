    CREATE VIEW "mytools"."listar_bases" AS
          
    SELECT pg_user.usename                                             AS owner
         , pg_database.datname                                         AS banco
         , pg_database_size( pg_database.datname )                     AS tamanho_bytes
         , pg_size_pretty( pg_database_size( pg_database.datname ) )   AS tamanho
      FROM pg_catalog.pg_database
 LEFT JOIN pg_catalog.pg_user
        ON pg_user.usesysid = pg_database.datdba ;
