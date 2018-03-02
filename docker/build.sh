#!/bin/bash

. ./config.sh

PKG_NAME=$1
if [ -z "${PKG_NAME}" ];then
    PKG_NAME=${PKG_LIST}
fi
echo "pkg name:  "${PKG_NAME}

for pkg in ${PKG_NAME};
do
    PKG_RUN_DIR="${RUN_DIR}/${pkg}"
    mkdir -p ${PKG_RUN_DIR}
    check_error_exit

    \cp -f common.sh "${CUR_PWD}/${pkg}/"
    cd ${CUR_PWD}/${pkg}
    check_error_exit

    chmod 777 *.sh
    ./build.sh ${pkg} ${DOCKER_DIR}
    check_error_exit

    cd -
done

echo "build finish, install run script"
./install.sh ${PKG_NAME}
check_error_exit "install run script fail"
echo "install run script success"
