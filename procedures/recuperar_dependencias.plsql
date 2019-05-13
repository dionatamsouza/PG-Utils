CREATE OR REPLACE FUNCTION "mytools"."recuperar_dependencias" (TEXT,TEXT,TEXT) RETURNS VOID AS $$

DECLARE
    quebra       ALIAS FOR $1;
    schemaname   ALIAS FOR $2;
    tablename    ALIAS FOR $3;
    stSql        VARCHAR;
    leitura      RECORD;
    
BEGIN
    
    stSql := '   SELECT DISTINCT
                        foreign_esquema 
                      , foreign_tabela
                   FROM mytools.listar_relacionamentos
                  WHERE primary_esquema = '''|| schemaname ||'''
                    AND primary_tabela  = '''|| tablename ||'''
               ORDER BY 1   ';
    
    FOR leitura IN EXECUTE stSql LOOP
        
        RAISE NOTICE '% %.%', quebra, leitura.foreign_esquema, leitura.foreign_tabela ;
        
        PERFORM mytools.recuperar_dependencias( '    ' || quebra , leitura.foreign_esquema, leitura.foreign_tabela );
        
    END LOOP ;
    
END;

$$ LANGUAGE 'plpgsql';


-- select * from mytools.recuperar_dependencias('', 'pessoal_4', 'contrato' );
