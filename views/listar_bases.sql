    CREATE VIEW "listar_bases" AS
          
    SELECT datname                                                     AS database
         , pg_size_pretty( pg_database_size( pg_database.datname ) )   AS tamanho
         , pg_database_size( pg_database.datname )                     AS tamanho_bytes
      FROM pg_catalog.pg_database
  ORDER BY pg_database_size( pg_database.datname ) DESC ;

/*
       SELECT pg_user.usename                                           AS owner
          , pg_database.datname                                         AS banco
          , pg_size_pretty( pg_database_size( pg_database.datname ) )   AS tamanho
       FROM pg_database
       JOIN pg_user
         ON pg_user.usesysid = pg_database.datdba
*/
