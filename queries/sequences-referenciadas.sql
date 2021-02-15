-- rabiscos.

SELECT
    seq_sch.nspname  AS sequence_schema
  , seq.relname      AS sequence_name
  , seq_use."schema" AS used_in_schema
  , seq_use."table"  AS used_in_table
  , seq_use."column" AS used_in_column
FROM pg_class seq
  INNER JOIN pg_namespace seq_sch ON seq_sch.oid = seq.relnamespace
  LEFT JOIN (
              SELECT
                  sch.nspname AS "schema"
                , tbl.relname AS "table"
                , col.attname AS "column"
                , regexp_split_to_array(
                      TRIM(LEADING 'nextval(''' FROM
                           TRIM(TRAILING '''::regclass)' FROM
                                pg_get_expr(def.adbin, tbl.oid, TRUE)
                           )
                      )
                      , '\.'
                  )           AS column_sequence
              FROM pg_class tbl --the table
                INNER JOIN pg_namespace sch ON sch.oid = tbl.relnamespace
                --schema
                INNER JOIN pg_attribute col ON col.attrelid = tbl.oid
                --columns
                INNER JOIN pg_attrdef def ON (def.adrelid = tbl.oid AND def.adnum = col.attnum) --default values for columns
              WHERE tbl.relkind = 'r' --regular relations (tables) only
                    AND col.attnum > 0 --regular columns only
                    AND def.adsrc LIKE 'nextval(%)' --sequences only
            ) seq_use ON (seq_use.column_sequence [1] = seq_sch.nspname AND seq_use.column_sequence [2] = seq.relname)
WHERE seq.relkind = 'S' --sequences only

--filtro
and seq.relname ilike '%faixa%turno%'

ORDER BY sequence_schema, sequence_name;



















select * from (
   


    SELECT row_number() OVER ( PARTITION BY a.attrelid ORDER BY a.attnum )                                     AS num
         , n.nspname                                                                                           AS schemaname
         , c.relname                                                                                           AS tablename
         , a.attname                                                                                           AS columnname
         
         , pg_get_serial_sequence('"'||n.nspname||'"."'||c.relname||'"', a.attname) as serial_sequence
         
      -- , CASE WHEN pg_index.indisprimary IS NULL THEN false ELSE true END :: BOOLEAN                         AS is_pk
      -- , CASE WHEN ( a.attnotnull OR (t.typtype = 'd' AND t.typnotnull) ) IS TRUE THEN false ELSE true END   AS is_nullable
         , replace(replace(replace(replace(
                ( pg_catalog.format_type(a.atttypid, a.atttypmod) )
              , 'character varying'
              , 'varchar' )
              , 'character'
              , 'char' )
              , 'timestamp without time zone'
              , 'timestamp' )
              , 'timestamp(3) without time zone'
              , 'timestamp(3)'
           ) AS tipo_dado
         , pg_catalog.pg_get_expr(def.adbin, def.adrelid)   AS valor_padrao
         , dsc.description                                  AS descricao
            
      FROM pg_catalog.pg_namespace n
      JOIN pg_catalog.pg_class c
        ON c.relnamespace = n.oid
      JOIN pg_catalog.pg_attribute a
        ON a.attrelid = c.oid
      JOIN pg_catalog.pg_type t
        ON a.atttypid = t.oid
 LEFT JOIN pg_catalog.pg_attrdef def
        ON a.attrelid = def.adrelid
       AND a.attnum   = def.adnum
 LEFT JOIN pg_catalog.pg_description dsc
        ON c.oid    = dsc.objoid
       AND a.attnum = dsc.objsubid
 LEFT JOIN pg_catalog.pg_class dc
        ON dc.oid = dsc.classoid
       AND dc.relname = 'pg_class'
 LEFT JOIN pg_catalog.pg_namespace dn
        ON dc.relnamespace = dn.oid
       AND dn.nspname = 'pg_catalog'
 LEFT JOIN pg_index
        ON a.attrelid = pg_index.indrelid
       AND a.attnum   = ANY ( pg_index.indkey )
       AND pg_index.indisprimary 
     WHERE a.attnum > 0
       AND NOT a.attisdropped
          
       AND n.nspname !~ '^pg\_'
       AND n.nspname NOT IN ( 'information_schema', 'utils' )
    
    
) as consulta where serial_sequence is not null
