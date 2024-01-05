#!/bin/bash

container_name=$(docker ps --format '{{.Names}}' | grep 'airflow-scheduler')

source .env

# https://github.com/gitpod-io/openvscode-server/releases

sudo docker exec $container_name bash -c '\
export OPENVSCODE_PATH=openvscode-server-v1.85.0-linux-x64
if [ ! -d *"openvscode-server"* ];  then
    curl -L  https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v1.85.0/openvscode-server-v1.85.0-linux-x64.tar.gz \
    | tar zxv
else
    echo "openvscode already downloaded, just restart it"
fi

echo "start openvscode"
$OPENVSCODE_PATH/bin/openvscode-server \
 --port 3000 \
 --connection-token $AIRFLOW_OPENVSCODE_TOKEN \
 --host 0.0.0.0 &

# add python path to default vscode settings
mkdir -p /home/airflow/.openvscode-server/data/Machine
echo "{\"python.defaultInterpreterPath\":\"/usr/local/bin/python\"}" > /home/airflow/.openvscode-server/data/Machine/settings.json

echo "install extensions"

$OPENVSCODE_PATH/bin/openvscode-server \
 --install-extension ms-python.python \ \
 --install-extension formulahendry.code-runner \
 --install-extension janisdd.vscode-edit-csv \
 --install-extension ms-toolsai.jupyter'

