/**
    * Creates views and procedures useful in a Postgres version 9.3.
    
    * @link http://www.dionatan.com.br
    * @author Developer: Dionatan Pinto de Souza
*/

SET client_encoding = 'SQL_ASCII' ;

CREATE SCHEMA IF NOT EXISTS "utils" ;

./procedures/retrieve_dependency.plsql
./views/list_database.sql
./views/list_schemas.sql
./views/list_tables.sql
./views/list_columns.sql
./views/list_indexes.sql
./views/list_procedures.sql
./views/list_relationships.sql
./views/list_queries.sql
