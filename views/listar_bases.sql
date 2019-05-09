    CREATE VIEW "listar_bases" AS
          
    SELECT datname                                                     AS database
         , pg_size_pretty( pg_database_size( pg_database.datname ) )   AS tamanho
         , pg_database_size( pg_database.datname )                     AS tamanho_bytes
      FROM pg_catalog.pg_database
  ORDER BY pg_database_size( pg_database.datname ) DESC ;
