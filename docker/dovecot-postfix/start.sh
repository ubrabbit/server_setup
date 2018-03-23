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

MYSQL_HOST="192.168.100.101"
MYSQL_PORT="3306"
MYSQL_PASSWORD="123456"

HOST_NAME="mail-server"
DOMAIN="test.com"
EXTEND_SERVICE="192.168.100.1"

DOVECOT_AUTH_PORT="10026"
POSTFIX_FILTER_PORT="10027"
POSTFIX_RECEIVE_PORT="10035"

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
        -p ${LISTEN_ADDRESS11} \
        -e "MYSQL_HOST=${MYSQL_HOST}" \
        -e "MYSQL_PORT=${MYSQL_PORT}" \
        -e "MYSQL_PASSWORD=${MYSQL_PASSWORD}" \
        -e "HOST_NAME=${HOST_NAME}" \
        -e "DOMAIN=${DOMAIN}" \
        -e "EXTEND_SERVICE=${EXTEND_SERVICE}" \
        -e "DOVECOT_AUTH_PORT=${DOVECOT_AUTH_PORT}" \
        -e "POSTFIX_FILTER_PORT=${POSTFIX_FILTER_PORT}" \
        -e "POSTFIX_RECEIVE_PORT=${POSTFIX_RECEIVE_PORT}" \
        ${RUN_NAME} 2>&1
