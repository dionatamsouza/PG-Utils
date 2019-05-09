     CREATE VIEW "listar_queries" AS
          
     SELECT pg_stat_activity.datname                                                                                                            AS banco
          , pg_stat_activity.query_start :: TIMESTAMP(0) :: TIME                                                                                AS inicio
          , replace(replace( age( configuracoes.now, pg_stat_activity.query_start :: TIMESTAMP ) :: VARCHAR(9) , '-', '' ), '.', '' ) :: TIME   AS tempo
          , pg_stat_activity.application_name                                                                                                   AS aplicacao
          , pg_stat_activity.usename                                                                                                            AS usuario
          , pg_stat_activity.client_addr                                                                                                        AS ip
          , pg_stat_activity.pid :: INTEGER                                                                                                     AS pid   /* usar procpid em versoes anteriores */
          , query :: TEXT                                                                                                                       AS query /* usar current_query em versoes anteriores */
       FROM pg_catalog.pg_stat_activity
 CROSS JOIN ( SELECT pg_backend_pid() AS pid
                   , now()            AS now
            ) AS configuracoes
      WHERE pg_stat_activity.pid  != configuracoes.pid
        AND pg_stat_activity.state = 'active' ;
