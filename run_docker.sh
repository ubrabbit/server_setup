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

output_step "docker run_cmd:  "${CMD}

cd docker
for cmd in ${CMD};
do
    if [ "${cmd}" = "start" ];
    then
        output_step "start docker"
        sudo sh install.sh
        sudo sh start.sh
    else
        output_step "stop docker"
        sudo sh stop.sh
    fi
done
