#!/bin/bash

. ./common.sh

RUN_NAME=`read_package_config "postfix" "image"`
LISTEN_IP=`read_package_config "postfix" "listen_ip"`
LISTEN_ADDRESS1="${LISTEN_IP}:2525:25"

DATA_ROOT="${DATA_DIR}/postfix"
echo "RUN: "${RUN_NAME}"  DATA_ROOT:  "${DATA_ROOT}
echo "LISTEN: "${LISTEN_IP}

docker run -it -d -p ${LISTEN_ADDRESS1} ${RUN_NAME} 2>&1
