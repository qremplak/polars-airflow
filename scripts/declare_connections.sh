#!/bin/bash

container_name=$(docker ps --format '{{.Names}}' | grep 'airflow-scheduler')

source ../.env

### Example (S)FTP Connection
# https://airflow.apache.org/docs/apache-airflow-providers-sftp/stable/connections/sftp.html
docker exec $container_name bash -c "airflow connections add 'external_sftp' \
--conn-uri 'sftp://demo:password@test.rebex.net:22'"

### Example Postgresql Connection
docker exec $container_name bash -c "airflow connections add 'postgres_db' \
--conn-uri 'postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:${POSTGRES_PORT}/${POSTGRES_DB}'"
