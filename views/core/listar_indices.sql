    CREATE VIEW "mytools"."listar_indices" AS
          
    SELECT schemaname
         , tablename
         , indexname
         , indexdef
      FROM pg_catalog.pg_indexes ;
