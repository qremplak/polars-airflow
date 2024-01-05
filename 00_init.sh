echo INIT

mkdir -p ./volumes/airflow/logs \
        ./volumes/airflow/tmp_data \
        ./volumes/airflow-postgres/data \
        ./volumes/postgres/data

bash ./fix_permissions.sh