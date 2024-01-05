source .env

echo "Airflow"
echo "http://$HOSTNAME:$AIRFLOW_WEBUI_PORT/"

echo "OpenVSCode - Dags folder"
echo "http://$HOSTNAME:$AIRFLOW_OPENVSCODE_PORT/?folder=/opt/airflow/dags&tkn=$AIRFLOW_OPENVSCODE_TOKEN"

echo "OpenVSCode - Core folder"
echo "http://$HOSTNAME:$AIRFLOW_OPENVSCODE_PORT/?folder=/opt/airflow/core&tkn=$AIRFLOW_OPENVSCODE_TOKEN"