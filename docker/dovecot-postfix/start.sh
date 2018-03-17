#!/bin/bash

. ./common.sh

RUN_NAME=`read_package_config "dovecot-postfix" "image"`
LISTEN_IP=`read_package_config "dovecot-postfix" "listen_ip"`

LISTEN_ADDRESS1="${LISTEN_IP}:110:110"
LISTEN_ADDRESS2="${LISTEN_IP}:143:143"
LISTEN_ADDRESS3="${LISTEN_IP}:995:995"
LISTEN_ADDRESS4="${LISTEN_IP}:993:993"

LISTEN_ADDRESS9="${LISTEN_IP}:25:25"
LISTEN_ADDRESS10="${LISTEN_IP}:465:465"
LISTEN_ADDRESS11="${LISTEN_IP}:10025:10025"

DATA_ROOT="${DATA_DIR}/dovecot-postfix"
mkdir -p ${DATA_ROOT}
echo "RUN: "${RUN_NAME}"  DATA_ROOT:  "${DATA_ROOT}
echo "LISTEN: "${LISTEN_ADDRESS}
docker run -it -d \
        -v "${DATA_ROOT}/mailbox":/data/mailbox \
        -v "${DATA_ROOT}/config":/config/dovecot-postfix \
        -p ${LISTEN_ADDRESS1} -p ${LISTEN_ADDRESS2} \
        -p ${LISTEN_ADDRESS3} -p ${LISTEN_ADDRESS4} \
        -p ${LISTEN_ADDRESS9} -p ${LISTEN_ADDRESS10} \
        ${RUN_NAME} 2>&1
