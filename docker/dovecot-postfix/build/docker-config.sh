#!/bin/bash

error_exit(){
        COLOR='\E[1;31m' #32:绿 31:红
        RES='\E[0m'
        echo -e "${COLOR}"$1" ${RES}"
        exit 2
}


POSTFIX_CONFIG_DIR="/etc/postfix"
DOVECOT_CONFIG_DIR="/usr/local/etc/dovecot"

#mysql 地址
if [ -z "${MYSQL_HOST}" ];then
    error_exit "'MYSQL_HOST' ENV Not Exists"
fi
#mysql 端口
if [ -z "${MYSQL_PORT}" ];then
    error_exit "'MYSQL_PORT' ENV Not Exists"
fi
#mysql 密码
if [ -z "${MYSQL_PASSWORD}" ];then
    error_exit "'MYSQL_PASSWORD' ENV Not Exists"
fi
#主机名
if [ -z "${HOST_NAME}" ];then
    error_exit "'HOST_NAME' ENV Not Exists"
fi
#主域名
if [ -z "${DOMAIN}" ];then
    error_exit "'DOMAIN' ENV Not Exists"
fi
#拓展服务IP
if [ -z "${EXTEND_SERVICE}" ];then
    error_exit "'EXTEND_SERVICE' ENV Not Exists"
fi
#POSTFIX SMTP过滤端口
if [ -z "${POSTFIX_FILTER_PORT}" ];then
    error_exit "'POSTFIX_FILTER_PORT' ENV Not Exists"
fi
#POSTFIX 邮件投递端口
if [ -z "${POSTFIX_RECEIVE_PORT}" ];then
    error_exit "'POSTFIX_RECEIVE_PORT' ENV Not Exists"
fi
#DOVECOT 帐号认证端口
if [ -z "${DOVECOT_AUTH_PORT}" ];then
    error_exit "'DOVECOT_AUTH_PORT' ENV Not Exists"
fi

sed -i "s/{MYSQL_HOST}/${MYSQL_HOST}/g" `grep -rl {MYSQL_HOST} ${POSTFIX_CONFIG_DIR}/mysql/*.cf`
sed -i "s/{MYSQL_PORT}/${MYSQL_PORT}/g" `grep -rl {MYSQL_PORT} ${POSTFIX_CONFIG_DIR}/mysql/*.cf`
sed -i "s/{MYSQL_PASSWORD}/${MYSQL_PASSWORD}/g" `grep -rl {MYSQL_PASSWORD} ${POSTFIX_CONFIG_DIR}/mysql/*.cf`

for file in main.cf master.cf;
do
    sed -i "s/{HOST_NAME}/${HOST_NAME}/g" `grep -rl {HOST_NAME} ${POSTFIX_CONFIG_DIR}/${file}`
    sed -i "s/{DOMAIN}/${DOMAIN}/g" `grep -rl {DOMAIN} ${POSTFIX_CONFIG_DIR}/${file}`
    sed -i "s/{EXTEND_SERVICE}/${EXTEND_SERVICE}/g" `grep -rl {EXTEND_SERVICE} ${POSTFIX_CONFIG_DIR}/${file}`
    sed -i "s/{POSTFIX_FILTER_PORT}/${POSTFIX_FILTER_PORT}/g" `grep -rl {POSTFIX_FILTER_PORT} ${POSTFIX_CONFIG_DIR}/${file}`
    sed -i "s/{POSTFIX_RECEIVE_PORT}/${POSTFIX_RECEIVE_PORT}/g" `grep -rl {POSTFIX_RECEIVE_PORT} ${POSTFIX_CONFIG_DIR}/${file}`
done

sed -i "s/{DOMAIN}/${DOMAIN}/g" `grep -rl {DOMAIN} ${DOMAIN}/dovecot.conf`
sed -i "s/{EXTEND_SERVICE}/${EXTEND_SERVICE}/g" `grep -rl {EXTEND_SERVICE} ${DOVECOT_CONFIG_DIR}/dict-default.conf`
sed -i "s/{DOVECOT_AUTH_PORT}/${DOVECOT_AUTH_PORT}/g" `grep -rl {DOVECOT_AUTH_PORT} ${DOVECOT_CONFIG_DIR}/dict-default.conf`

chmod -R 644 ${POSTFIX_CONFIG_DIR}
