#!/bin/bash

container_name=$(docker ps --format '{{.Names}}' | grep 'airflow-scheduler')

docker exec $container_name bash -c "airflow dags reserialize"