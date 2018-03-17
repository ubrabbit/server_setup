#!/bin/bash

POSTFIX_CONFIG_DIR="/etc/postfix"
DOVECOT_CONFIG_DIR="/usr/local/etc/dovecot"


MYSQL_HOST_DEFAULT="192.168.100.101"
MYSQL_PORT_DEFAULT="3306"
MYSQL_PASSWORD_DEFAULT="123456"

HOST_NAME_DEFAULT="mail-server"
DOMAIN_DEFAULT="test.com"
EXTEND_SERVICE_DEFAULT="192.168.100.1"

POSTFIX_FILTER_PORT_DEFAULT="10026"
POSTFIX_RECEIVE_PORT_DEFAULT="10027"
DOVECOT_AUTH_PORT_DEFAULT="10035"

MAIL_SAVE_ROOT_DEFAULT="/home/mailbox"

MYSQL_HOST=$1
MYSQL_PORT=$2
MYSQL_PASSWORD=$3

HOST_NAME=$4
DOMAIN=$5
EXTEND_SERVICE=$6

DOVECOT_AUTH_PORT=$7
POSTFIX_FILTER_PORT=$8
POSTFIX_RECEIVE_PORT=$9

MAIL_SAVE_ROOT=$10

#mysql 地址
if [ -z "${MYSQL_HOST}" ];then
    MYSQL_HOST=${MYSQL_HOST_DEFAULT}
fi
#mysql 端口
if [ -z "${MYSQL_PORT}" ];then
    MYSQL_PORT=${MYSQL_PORT_DEFAULT}
fi
#mysql 密码
if [ -z "${MYSQL_PASSWORD}" ];then
    MYSQL_PASSWORD=${MYSQL_PASSWORD_DEFAULT}
fi

#主机名
if [ -z "${HOST_NAME}" ];then
    HOST_NAME=${HOST_NAME_DEFAULT}
fi
#主域名
if [ -z "${DOMAIN}" ];then
    DOMAIN=${DOMAIN_DEFAULT}
fi
#拓展服务IP
if [ -z "${EXTEND_SERVICE}" ];then
    EXTEND_SERVICE=${EXTEND_SERVICE_DEFAULT}
fi

#POSTFIX SMTP过滤端口
if [ -z "${POSTFIX_FILTER_PORT}" ];then
    POSTFIX_FILTER_PORT=${POSTFIX_FILTER_PORT_DEFAULT}
fi
#POSTFIX 邮件投递端口
if [ -z "${POSTFIX_RECEIVE_PORT}" ];then
    POSTFIX_RECEIVE_PORT=${POSTFIX_RECEIVE_PORT_DEFAULT}
fi
#DOVECOT 帐号认证端口
if [ -z "${DOVECOT_AUTH_PORT}" ];then
    DOVECOT_AUTH_PORT=${DOVECOT_AUTH_PORT_DEFAULT}
fi
#邮件存储根目录
if [ -z "${MAIL_SAVE_ROOT}" ];then
    MAIL_SAVE_ROOT=${MAIL_SAVE_ROOT_DEFAULT}
fi

sed -i "s/{MYSQL_HOST}/${MYSQL_HOST}/g" `grep -rl {MYSQL_HOST} ${POSTFIX_CONFIG_DIR}/mysql/*.cf`
sed -i "s/{MYSQL_PORT}/${MYSQL_PORT}/g" `grep -rl {MYSQL_PORT} ${POSTFIX_CONFIG_DIR}/mysql/*.cf`
sed -i "s/{MYSQL_PASSWORD}/${MYSQL_PASSWORD}/g" `grep -rl {MYSQL_PASSWORD} ${POSTFIX_CONFIG_DIR}/mysql/*.cf`

for file in "main.cf master.cf";
do
    sed -i "s/{HOST_NAME}/${HOST_NAME}/g" `grep -rl {HOST_NAME} ${POSTFIX_CONFIG_DIR}/${file}`
    sed -i "s/{DOMAIN}/${DOMAIN}/g" `grep -rl {DOMAIN} ${POSTFIX_CONFIG_DIR}/${file}`
    sed -i "s/{EXTEND_SERVICE}/${EXTEND_SERVICE}/g" `grep -rl {EXTEND_SERVICE} ${POSTFIX_CONFIG_DIR}/${file}`
    sed -i "s/{POSTFIX_FILTER_PORT}/${POSTFIX_FILTER_PORT}/g" `grep -rl {POSTFIX_FILTER_PORT} ${POSTFIX_CONFIG_DIR}/${file}`
    sed -i "s/{POSTFIX_RECEIVE_PORT}/${POSTFIX_RECEIVE_PORT}/g" `grep -rl {POSTFIX_RECEIVE_PORT} ${POSTFIX_CONFIG_DIR}/${file}`
done

sed -i "s/{DOMAIN}/${DOMAIN}/g" `grep -rl {DOMAIN} ${DOMAIN}/dovecot.conf`
sed -i "s/{MAIL_SAVE_ROOT}/${MAIL_SAVE_ROOT}/g" `grep -rl {MAIL_SAVE_ROOT} ${MAIL_SAVE_ROOT}/dovecot.conf`
sed -i "s/{EXTEND_SERVICE}/${EXTEND_SERVICE}/g" `grep -rl {EXTEND_SERVICE} ${DOVECOT_CONFIG_DIR}/dict-default.conf`
sed -i "s/{DOVECOT_AUTH_PORT}/${DOVECOT_AUTH_PORT}/g" `grep -rl {DOVECOT_AUTH_PORT} ${DOVECOT_CONFIG_DIR}/dict-default.conf`

chmod -R 644 ${POSTFIX_CONFIG_DIR}

/usr/local/postfix/sbin/postfix set-permissions
echo "start mail-server"
supervisord -n -c /etc/supervisor/supervisord.conf
