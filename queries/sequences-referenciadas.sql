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

