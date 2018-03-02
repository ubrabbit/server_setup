#!/bin/bash

. ./common.sh

RUN_NAME=`read_package_config "mongo" "image"`
LISTEN_IP=`read_package_config "listen_ip"`
LISTEN_PORT=`read_package_config "listen_port"`
LISTEN_ADDRESS="${LISTEN_IP}:${LISTEN_PORT}:27017"

USE_SHARD=`read_package_config "mongo" "shard"`
if [ "${USE_SHARD}" = "1" ];then
    echo "mongo use shard"
    cd shard
    chmod -R 777 *.sh
    ./start.sh
else
    echo "mongo use normal"

    DATA_ROOT="${DATA_DIR}/mongo"
    echo "RUN: "${RUN_NAME}"  DATA_ROOT:  "${DATA_ROOT}
    echo "LISTEN: "${LISTEN_ADDRESS}
    docker run -it -d -v "${DATA_ROOT}/data":/data/db -v "${DATA_ROOT}/configdb":/data/configdb -p ${LISTEN_ADDRESS} ${RUN_NAME} 2>&1
fi
