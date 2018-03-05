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
echo "ready commit:  "${PKG_NAME}

./stop.sh
for pkg in ${PKG_NAME};
do
    BuildName=`read_build_name "${pkg}"`
    DockerName="${ACCOUNT}/${BuildName}"
    ./start.sh ${pkg}

    docker container ls | grep ${BuildName} | awk '{print $1}' | xargs -I{} docker commit {} "${DockerName}"
    check_error_exit "docker commit ${pkg} failure"
    echo "docker commit ${pkg} success"

    echo "push to docker hub"
    docker push "${DockerName}"
    check_error_exit "docker push ${pkg} failure"
    echo "docker push ${pkg} success"

done


