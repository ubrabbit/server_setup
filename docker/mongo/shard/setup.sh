#!/bin/bash

chmod 777 *.sh

#当前执行这个脚本的目录
CUR_PWD=`pwd`
#父目录
PARENT_PWD=`echo "$(dirname ${CUR_PWD})"`
. ${PARENT_PWD}/common.sh

IMAGE=`read_package_config "mongo" "image"`
echo "Use Image:  "${IMAGE}
DATA_ROOT="${DATA_DIR}/mongo/shard"
mkdir -p ${DATA_ROOT}
python format_shard.py ${DATA_ROOT} ${IMAGE}

docker-compose up
