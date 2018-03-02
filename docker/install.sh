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

    \cp -f "common.sh" ${PKG_RUN_DIR}/

    cd ${CUR_PWD}/${pkg}
    check_error_exit

    chmod 777 *.sh
    \cp -f *.sh ${PKG_RUN_DIR}/ >/dev/null 2>&1
    if [ "${pkg}" = "mongo" ];then
        rsync -avzrl --delete shard/ ${PKG_RUN_DIR}/shard/
    fi

    cd -
done
