#!/bin/bash

container_name=$(docker ps --format '{{.Names}}' | grep 'airflow-scheduler')

docker exec $container_name bash -c "pip list | grep -E 'duckdb|polars|pyarrow|pandas|numpy|scikit-learn|SQLAlchemy'"