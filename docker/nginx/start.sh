#!/bin/bash

. ./common.sh

RUN_NAME=`read_package_config "nginx" "image"`
LISTEN_IP=`read_package_config "nginx" "listen_ip"`
LISTEN_ADDRESS1="${LISTEN_IP}:8090:80"

DATA_ROOT="${DATA_DIR}/nginx"
echo "RUN: "${RUN_NAME}"  DATA_ROOT:  "${DATA_ROOT}
echo "LISTEN: "${LISTEN_IP}

#nginx的数据库名称规则是，NODENAME@hostname，Docker每次从Docker image启动容器的时候会自动生成hostname，
#这样一来，你保存在主机上的数据库就会没用了，包括之前创建的用户也会没有了。
#所以在创建容器的时候必须指定--hostname=nginxhostone，这样docker环境启动后nginx就会一直读取固定目录中的数据了

# 设置host和初始账户

docker run -it -d -p ${LISTEN_ADDRESS1} ${RUN_NAME} 2>&1
