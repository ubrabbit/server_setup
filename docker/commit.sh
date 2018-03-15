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
    RESULT=$?
    if [ ${RESULT} -ne 0 ]; then
        error_notify "docker commit ${pkg} failure"
        continue
    fi
    success_notify "docker commit ${pkg} success"

    success_notify "push to docker hub"
    docker push "${DockerName}"
    if [ ${RESULT} -ne 0 ]; then
        error_notify "docker push ${pkg} failure"
        continue
    fi
    success_notify "docker push ${pkg} success"

done


