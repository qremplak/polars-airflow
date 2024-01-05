source .env

echo "Fix permissions"

sudo chown -R $HOST_UID:$HOST_GID .
sudo chmod -R g+s .

sudo chown -R $AIRFLOW_UID:$AIRFLOW_GID ./volumes/airflow ./workspace ./core
sudo chown -R $AIRFLOW_POSTGRES_UID:$AIRFLOW_POSTGRES_GID ./volumes/airflow-postgres
sudo chown -R $POSTGRES_UID:$POSTGRES_GID ./volumes/postgres

sudo chmod -R g+s ./volumes
