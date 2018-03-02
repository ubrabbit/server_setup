#!/bin/bash

. ./common.sh

DOCKER_DIR=$1
if [ -z "${DOCKER_DIR}" ];then
        echo "invalid docker_dir:  "${DOCKER_DIR}
        exit 2
fi
echo "docker dir:  "${DOCKER_DIR}

#创建打包目录
LOCAL_BUILD_DIR="${DOCKER_DIR}/temp/dovecot/"
mkdir -p ${LOCAL_BUILD_DIR}
#同步打包文件
rsync -avzrl --delete "build/" ${LOCAL_BUILD_DIR}

BuildName=`read_build_name "dovecot"`
check_error_exit "read_build_name error"

#进入打包目录开始打包
cd ${LOCAL_BUILD_DIR}
sudo docker build -t "${BuildName}" .
cd -
