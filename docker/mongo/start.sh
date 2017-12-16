#!/bin/bash

. ./common.sh

RUN_NAME=`get_image_name "mongo"`
LISTEN_IP=`read_config "listen_ip"`
LISTEN_PORT=`read_config "mongo_port"`
LISTEN_ADDRESS="${LISTEN_IP}:${LISTEN_PORT}:27017"

DATA_ROOT="${DATA_DIR}/mongo"
echo "RUN: "${RUN_NAME}"  DATA_ROOT:  "${DATA_ROOT}
echo "LISTEN: "${LISTEN_ADDRESS}
docker run -it -d -v "${DATA_ROOT}/data":/data/db -v "${DATA_ROOT}/configdb":/data/configdb -p ${LISTEN_ADDRESS} ${RUN_NAME} 2>&1
