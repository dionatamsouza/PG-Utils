/**
    * List relationships between tables.
    
    * @link http://www.dionatan.com.br
    * @author Developer: Dionatan Pinto de Souza
*/

    SELECT DISTINCT
           pkn.nspname  AS PRIMARY_ESQUEMA
         , pkc.relname  AS PRIMARY_TABELA
         , pka.attname  AS PRIMARY_COLUNA
         
         , fkn.nspname  AS FOREIGN_ESQUEMA
         , fkc.relname  AS FOREIGN_TABELA
         , fka.attname  AS FOREIGN_COLUNA
         
         , con.conname  AS FK_NAME
          
      FROM pg_catalog.pg_namespace  AS pkn
         , pg_catalog.pg_class      AS pkc
         , pg_catalog.pg_attribute  AS pka
         , pg_catalog.pg_namespace  AS fkn
         , pg_catalog.pg_class      AS fkc
         , pg_catalog.pg_attribute  AS fka
         , pg_catalog.pg_constraint AS con
         , pg_catalog.generate_series(1, 32) AS vtable ( campo )
         , pg_catalog.pg_depend     AS dep
         , pg_catalog.pg_class      AS pkic
          
     WHERE pkn.oid        = pkc.relnamespace
       AND pkc.oid        = pka.attrelid 
       AND pka.attnum     = con.confkey[vtable.campo] 
       AND con.confrelid  = pkc.oid  
       AND fkn.oid        = fkc.relnamespace 
       AND fkc.oid        = fka.attrelid 
       AND fka.attnum     = con.conkey[vtable.campo] 
       AND con.conrelid   = fkc.oid  
       AND con.contype    = 'f'
       AND con.oid        = dep.objid 
       AND pkic.oid       = dep.refobjid 
       AND pkic.relkind   = 'i' 
       AND dep.classid    = 'pg_constraint' :: regclass :: oid 
       AND dep.refclassid = 'pg_class'      :: regclass :: oid ;
