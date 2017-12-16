#!/bin/bash

#https://github.com/docker-library/mysql/blob/master/5.7

DOCKER_DIR=$1
if [ -z "${DOCKER_DIR}" ];then
        echo "invalid docker_dir:  "${DOCKER_DIR}
        exit 2
fi
echo "docker dir:  "${DOCKER_DIR}

#创建打包目录
LOCAL_BUILD_DIR="${DOCKER_DIR}/temp/mysql/"
TEMP_DIR="data logs conf"
for folder in ${TEMP_DIR};
do
        mkdir -p "${LOCAL_BUILD_DIR}/${folder}"
done

#同步打包文件
PKG_VERSION="debian9"
rsync -avzrl --delete ${PKG_VERSION}/ ${LOCAL_BUILD_DIR}

#同步自定义初始化文件
cp init/init.sql ${LOCAL_BUILD_DIR}
cp init/table.sql ${LOCAL_BUILD_DIR}
cp init/update.sql ${LOCAL_BUILD_DIR}

#同步自定义配置文件
cp config/mysqld.cnf ${LOCAL_BUILD_DIR}

#进入打包目录开始打包
cd ${LOCAL_BUILD_DIR}
sudo docker build -t "mysql_deb:5.7" .
cd -
