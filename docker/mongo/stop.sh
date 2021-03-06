#!/bin/bash

. ./common.sh

USE_SHARD=`read_package_config "mongo" "shard"`
if [ "${USE_SHARD}" = "1" ];then
    cd shard
    chmod -R 777 *.sh
    ./stop.sh
else
    stop_container "mongo"
fi
