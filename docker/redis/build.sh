#!/bin/bash

#https://github.com/docker-library/redis.git

DOCKER_DIR=$1
if [ -z "${DOCKER_DIR}" ];then
        echo "invalid docker_dir:  "${DOCKER_DIR}
        exit 2
fi
echo "docker dir:  "${DOCKER_DIR}

#创建打包目录
LOCAL_BUILD_DIR="${DOCKER_DIR}/temp/redis/"
mkdir -p ${LOCAL_BUILD_DIR}
#同步打包文件
PKG_VERSION="debian8"
rsync -avzrl --delete ${PKG_VERSION}/ ${LOCAL_BUILD_DIR}

#进入打包目录开始打包
cd ${LOCAL_BUILD_DIR}
sudo docker build -t "redis_deb:4.0" .
cd -
