#!/bin/bash

. ./common.sh

RUN_NAME=`read_package_config "rabbitmq" "image"`
LISTEN_IP=`read_package_config "rabbitmq" "listen_ip"`
LISTEN_ADDRESS1="${LISTEN_IP}:4369:4369"
LISTEN_ADDRESS2="${LISTEN_IP}:5671:5671"
LISTEN_ADDRESS3="${LISTEN_IP}:5672:5672"
LISTEN_ADDRESS4="${LISTEN_IP}:25672:25672"
LISTEN_ADDRESS5="${LISTEN_IP}:15671:15671"
LISTEN_ADDRESS6="${LISTEN_IP}:15672:15672"

DATA_ROOT="${DATA_DIR}/rabbitmq"
echo "RUN: "${RUN_NAME}"  DATA_ROOT:  "${DATA_ROOT}
echo "LISTEN: "${LISTEN_IP}

#rabbitmq的数据库名称规则是，NODENAME@hostname，Docker每次从Docker image启动容器的时候会自动生成hostname，
#这样一来，你保存在主机上的数据库就会没用了，包括之前创建的用户也会没有了。
#所以在创建容器的时候必须指定--hostname=rabbitmqhostone，这样docker环境启动后rabbitmq就会一直读取固定目录中的数据了

# 设置host和初始账户
#USER_ADMIN="rabbitmq"
#PWD_ADMIN="rabbitmq"
#HOSTNAME="rabbitmq"
#rabbitmqctl add_user ${USER_ADMIN} ${PWD_ADMIN} && rabbitmqctl set_user_tags ${USER_ADMIN} administrator
#rabbitmqctl add_vhost ${HOSTNAME} && rabbitmqctl set_permissions -p ${USER_ADMIN} ${HOSTNAME} ".*" ".*" ".*"

docker run -it -d -v "${DATA_ROOT}":/var/lib/rabbitmq \
        -p ${LISTEN_ADDRESS1} -p ${LISTEN_ADDRESS2} \
        -p ${LISTEN_ADDRESS3} -p ${LISTEN_ADDRESS4} \
        -p ${LISTEN_ADDRESS5} -p ${LISTEN_ADDRESS6} \
        --hostname rabbitmq \
        -e "RABBITMQ_USER=rabbitmq" \
        -e "RABBITMQ_PASSWORD=rabbitmq" \
        -e "HOSTNAME=rabbitmq" \
        ${RUN_NAME} 2>&1
