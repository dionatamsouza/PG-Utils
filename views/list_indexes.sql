    CREATE VIEW "utils"."list_indexes" AS
          
    SELECT schemaname
         , tablename
         , indexname
         , indexdef
      FROM pg_catalog.pg_indexes ;
