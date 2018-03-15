#!/bin/bash

. ./config.sh

#如果帐号存在，就登录
if [ -z "${ACCOUNT}" ];then
    echo "empty account, commit failure"
    exit 2
fi

login_account
check_error_exit "docker login failure"

PKG_NAME=$1
if [ -z "${PKG_NAME}" ];then
    PKG_NAME=${PKG_LIST}
fi

./stop.sh
for pkg in ${PKG_NAME};
do
    success_notify "pull package: "${DockerName}
    BuildName=`read_build_name "${pkg}"`
    if [ -z "${BuildName}" ];then
        error_notify "package: "${DockerName}" not exists"
        continue
    fi
    DockerName="${ACCOUNT}/${BuildName}"
    success_notify "pull image: "${DockerName}
    docker pull "${DockerName}"
    check_error_notify "docker pull ${pkg} failure"
done


