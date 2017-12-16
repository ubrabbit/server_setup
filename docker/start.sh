#!/bin/bash

. ./config.sh

#如果帐号存在，就登录
if [ ! -z "${ACCOUNT}" ];then
    echo "login "${ACCOUNT}
    docker login -u "${ACCOUNT}" -p "${PASSWORD}"
    check_error_exit "docker login failure"
fi

PKG_NAME=$1
if [ -z "${PKG_NAME}" ];then
    PKG_NAME=${PKG_LIST}
fi
echo "ready start:  "${PKG_NAME}

cd ${RUN_DIR}
for pkg in ${PKG_NAME};
do
        echo "start  "${pkg}
        cd ${pkg}
        sh start.sh ${ACCOUNT}
        cd - >/dev/null 2>&1
done
