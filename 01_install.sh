echo INSTALL

source .env

(cd custom_postgres_db && bash build.sh)

docker-compose --env-file .env up  --build -d

until curl --silent "http://localhost:$AIRFLOW_WEBUI_PORT/health" | grep -E -q "healthy"; do
    echo "[Health check] Waiting for Airflow"
    sleep 2
done

echo "Declare initial Connections"
(cd scripts && bash ./declare_connections.sh)

echo "Activate OPENVSCODE"
bash ./activate_openvscode.sh

bash ./show_urls.sh

