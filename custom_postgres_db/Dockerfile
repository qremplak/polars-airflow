FROM postgres:16-alpine

# Every sql files in this folder will be executed at start up
ADD init_db.sql /docker-entrypoint-initdb.d
