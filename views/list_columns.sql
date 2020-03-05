/**
    * List tables and their columns.
    
    * @link http://www.dionatan.com.br
    * @author Developer: Dionatan Pinto de Souza
*/

    SELECT row_number() OVER ( PARTITION BY a.attrelid ORDER BY a.attnum )                                     AS num
         , n.nspname                                                                                           AS schemaname
         , c.relname                                                                                           AS tablename
         , a.attname                                                                                           AS columnname
         , CASE WHEN pg_index.indisprimary IS NULL THEN false ELSE true END :: BOOLEAN                         AS is_pk
         , CASE WHEN ( a.attnotnull OR (t.typtype = 'd' AND t.typnotnull) ) IS TRUE THEN false ELSE true END   AS is_nullable
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
       AND n.nspname NOT IN ( 'information_schema', 'utils' ) ;
