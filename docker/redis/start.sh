#!/bin/bash

. ./common.sh

RUN_NAME=`get_image_name "redis"`
LISTEN_IP=`read_config "listen_ip"`
LISTEN_PORT=`read_config "redis_port"`
LISTEN_ADDRESS="${LISTEN_IP}:${LISTEN_PORT}:6379"

DATA_ROOT="${DATA_DIR}/redis"
echo "RUN: "${RUN_NAME}"  DATA_ROOT:  "${DATA_ROOT}
echo "LISTEN: "${LISTEN_ADDRESS}
docker run -it -d -v "${DATA_ROOT}/data":/data -p ${LISTEN_ADDRESS} ${RUN_NAME} 2>&1
