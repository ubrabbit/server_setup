#!/bin/bash

. ./common.sh

RUN_NAME=`read_package_config "redis" "image"`
LISTEN_IP=`read_package_config "redis" "listen_ip"`
LISTEN_PORT=`read_package_config "redis" "listen_port"`
LISTEN_ADDRESS="${LISTEN_IP}:${LISTEN_PORT}:6379"

DATA_ROOT="${DATA_DIR}/redis"
echo "RUN: "${RUN_NAME}"  DATA_ROOT:  "${DATA_ROOT}
echo "LISTEN: "${LISTEN_ADDRESS}
docker run -it -d -v "${DATA_ROOT}/data":/data -p ${LISTEN_ADDRESS} ${RUN_NAME} 2>&1
