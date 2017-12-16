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

    SCRIPT_LIST="start.sh stop.sh"
    for file in ${SCRIPT_LIST};
    do
        if [ -f ${file} ];
        then
            \cp -f ${file} ${PKG_RUN_DIR}/ >/dev/null 2>&1
        fi
    done

    cd -
done
