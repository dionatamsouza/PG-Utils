CREATE OR REPLACE FUNCTION "utils"."aguardar_ate" (TIME) RETURNS VOID AS $$

BEGIN
    
   PERFORM pg_sleep( segundos )
          
      FROM ( SELECT ( ( t_tempo.h * 3600 ) + ( t_tempo.m * 60 ) + s ) AS segundos
               FROM ( SELECT (trim(date_part('second', t_tempo.tempo )::varchar(2))) :: integer AS s
                           , date_part('minute', t_tempo.tempo )  ::  integer                   AS m
                           , date_part('hour',   t_tempo.tempo )  ::  integer                   AS h
                        FROM ( SELECT $1 - now() :: time ) AS t_tempo (tempo)
                    ) AS t_tempo 
           ) AS preparar ;
    
END
$$ LANGUAGE 'plpgsql';
