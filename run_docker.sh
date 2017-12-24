#!/bin/bash

. ./shell/public.sh

CMD=$1
case ${CMD} in
    "start")
        CMD="start"
        ;;
    "stop")
        CMD="stop"
        ;;
    "restart")
        CMD="stop start"
        ;;
    *)
        CMD="stop start"
        ;;
esac

dpkg -l docker >/dev/null 2>&1
RESULT=$?
if [ ${RESULT} -ne 0 ]; then
    output_step "未找到现有的docker，尝试安装"
    cd shell
    ./install_docker_deb9.sh
    cd -
fi

output_step "docker run_cmd:  "${CMD}

cd docker
for cmd in ${CMD};
do
    if [ "${cmd}" = "start" ];
    then
        output_step "start docker"
        sh install.sh
        sh start.sh
    else
        output_step "stop docker"
        sh stop.sh
    fi
done
