#!/bin/bash

. ./common.sh

IMAGE_MAIN=`read_package_config "mail-service" "image-main"`
IMAGE_MYSQL=`read_package_config "mail-service" "image-mysql"`
IMAGE_REDIS=`read_package_config "mail-service" "image-redis"`
DATA_ROOT="${DATA_DIR}/mail"
mkdir -p ${DATA_ROOT}
python format_config.py ${DATA_ROOT} ${IMAGE_MAIN} ${IMAGE_MYSQL} ${IMAGE_REDIS}

docker-compose stop
