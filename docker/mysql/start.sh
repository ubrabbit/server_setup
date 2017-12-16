#!/bin/bash

. ./common.sh

RUN_NAME=`get_image_name "mysql"`
LISTEN_IP=`read_config "listen_ip"`
LISTEN_PORT=`read_config "mysql_port"`
LISTEN_ADDRESS="${LISTEN_IP}:${LISTEN_PORT}:3306"

PASSWORD=`read_config "mysql_password"`
DATA_ROOT="${DATA_DIR}/mysql"
echo "RUN: "${RUN_NAME}"  DATA_ROOT:  "${DATA_ROOT}
echo "LISTEN: "${LISTEN_ADDRESS}
docker run -it -d -e MYSQL_ROOT_PASSWORD=${PASSWORD} -v ${DATA_ROOT}:/var/lib/mysql -p ${LISTEN_ADDRESS} ${RUN_NAME} 2>&1
