#!/bin/bash

IMAGE_MAIN=`read_package_config "mail-service" "image-main"`
IMAGE_MYSQL=`read_package_config "mail-service" "image-mysql"`
IMAGE_REDIS=`read_package_config "mail-service" "image-redis"`
IMAGE_RABBITMQ=`read_package_config "mail-service" "image-rabbitmq"`

MYSQL_HOST=`read_package_config "mail-service" "mysql_host"`
MYSQL_PORT=`read_package_config "mail-service" "mysql_port"`
MYSQL_PASSWORD=`read_package_config "mail-service" "mysql_password"`
HOST_NAME=`read_package_config "mail-service" "hostname"`
DOMAIN=`read_package_config "mail-service" "domain"`

EXTEND_SERVICE=`read_package_config "mail-service" "extend_service"`
DOVECOT_AUTH_PORT=`read_package_config "mail-service" "dovecot_auth_port"`
POSTFIX_FILTER_PORT=`read_package_config "mail-service" "postfix_filter_port"`
POSTFIX_RECEIVE_PORT=`read_package_config "mail-service" "postfix_receive_port"`

RABBITMQ_HOSTNAME=`read_package_config "mail-service" "rabbitmq_hostname"`
RABBITMQ_USER=`read_package_config "mail-service" "rabbitmq_user"`
RABBITMQ_PASSWORD=`read_package_config "mail-service" "rabbitmq_password"`

YMLFILE="docker-compose.yml"
DATA_DIR="${DATA_DIR}/mail-service"
mkdir -p ${DATA_DIR}

python replace_param.py "{DATA_DIR}" "${DATA_DIR}" "${YMLFILE}"

python replace_param.py "{IMAGE_MAIN}" "${IMAGE_MAIN}" "${YMLFILE}"
python replace_param.py "{IMAGE_MYSQL}" "${IMAGE_MYSQL}" "${YMLFILE}"
python replace_param.py "{IMAGE_REDIS}" "${IMAGE_REDIS}" "${YMLFILE}"
python replace_param.py "{IMAGE_RABBITMQ}" "${IMAGE_RABBITMQ}" "${YMLFILE}"

python replace_param.py "{MYSQL_HOST}" "${MYSQL_HOST}" "${YMLFILE}"
python replace_param.py "{MYSQL_PORT}" "${MYSQL_PORT}" "${YMLFILE}"
python replace_param.py "{MYSQL_PASSWORD}" "${MYSQL_PASSWORD}" "${YMLFILE}"
python replace_param.py "{HOST_NAME}" "${HOST_NAME}" "${YMLFILE}"
python replace_param.py "{DOMAIN}" "${DOMAIN}" "${YMLFILE}"

python replace_param.py "{EXTEND_SERVICE}" "${EXTEND_SERVICE}" "${YMLFILE}"
python replace_param.py "{DOVECOT_AUTH_PORT}" "${DOVECOT_AUTH_PORT}" "${YMLFILE}"
python replace_param.py "{POSTFIX_FILTER_PORT}" "${POSTFIX_FILTER_PORT}" "${YMLFILE}"
python replace_param.py "{POSTFIX_RECEIVE_PORT}" "${POSTFIX_RECEIVE_PORT}" "${YMLFILE}"

python replace_param.py "{RABBITMQ_HOSTNAME}" "${RABBITMQ_HOSTNAME}" "${YMLFILE}"
python replace_param.py "{RABBITMQ_USER}" "${RABBITMQ_USER}" "${YMLFILE}"
python replace_param.py "{RABBITMQ_PASSWORD}" "${RABBITMQ_PASSWORD}" "${YMLFILE}"

#以下用sed 的方式在变量包含特殊字符时会有BUG
#sed -i s/{DATA_DIR}/${DATA_DIR}/g `grep -rl {DATA_DIR} ${YMLFILE}`

