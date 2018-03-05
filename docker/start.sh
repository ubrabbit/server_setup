#!/bin/bash

. ./config.sh

default_start_pkg(){
    PACKAGE=$1
    if [ -z "${PACKAGE}" ];then
            echo "invalid package_name:  "${PACKAGE}
            return 2
    fi

    RUN_NAME=`read_package_config "${PACKAGE}" "image"`
    echo "RUN: "${RUN_NAME}

    docker run -it -d ${RUN_NAME} 2>&1
    return $?
}

login_account
check_error_exit "docker login failure"

PKG_NAME=$1
if [ -z "${PKG_NAME}" ];then
    PKG_NAME=${PKG_LIST}
fi
echo "ready start:  "${PKG_NAME}

cd ${RUN_DIR}
for pkg in ${PKG_NAME};
do
        echo "start  "${pkg}
        if [ -f "${pkg}/start.sh" ];then
                cd ${pkg}
                sh start.sh ${ACCOUNT}
                cd - >/dev/null 2>&1
        else
                default_start_pkg ${pkg}
                check_error_notify "start ${pkg} failure"
        fi
done
