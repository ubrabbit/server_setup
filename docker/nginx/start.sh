#!/bin/bash

. ./common.sh

RUN_NAME=`read_package_config "nginx" "image"`
LISTEN_IP=`read_package_config "nginx" "listen_ip"`
LISTEN_ADDRESS1="${LISTEN_IP}:8090:80"

DATA_ROOT="${DATA_DIR}/nginx"
echo "RUN: "${RUN_NAME}"  DATA_ROOT:  "${DATA_ROOT}
echo "LISTEN: "${LISTEN_IP}

docker run -it -d -p ${LISTEN_ADDRESS1} ${RUN_NAME} 2>&1
