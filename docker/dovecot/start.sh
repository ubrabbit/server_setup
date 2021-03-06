#!/bin/bash

. ./common.sh

RUN_NAME=`read_package_config "dovecot" "image"`
LISTEN_IP=`read_package_config "dovecot" "listen_ip"`

LISTEN_ADDRESS1="${LISTEN_IP}:110:110"
LISTEN_ADDRESS2="${LISTEN_IP}:143:143"
LISTEN_ADDRESS3="${LISTEN_IP}:995:995"
LISTEN_ADDRESS4="${LISTEN_IP}:993:993"
LISTEN_ADDRESS5="${LISTEN_IP}:2000:2000"
LISTEN_ADDRESS6="${LISTEN_IP}:1025:1025"
LISTEN_ADDRESS7="${LISTEN_IP}:1490:4190"
LISTEN_ADDRESS8="${LISTEN_IP}:9090:9090"

DATA_ROOT="${DATA_DIR}/dovecot"
mkdir -p ${DATA_ROOT}
echo "RUN: "${RUN_NAME}"  DATA_ROOT:  "${DATA_ROOT}
echo "LISTEN: "${LISTEN_ADDRESS}
docker run -it -d \
        -v "${DATA_ROOT}/mailbox":/data/mailbox \
        -v "${DATA_ROOT}/config":/config/dovecot \
        -p ${LISTEN_ADDRESS1} -p ${LISTEN_ADDRESS2} \
        -p ${LISTEN_ADDRESS3} -p ${LISTEN_ADDRESS4} -p ${LISTEN_ADDRESS5} \
        -p ${LISTEN_ADDRESS6} -p ${LISTEN_ADDRESS7} -p ${LISTEN_ADDRESS8} \
        ${RUN_NAME} 2>&1
