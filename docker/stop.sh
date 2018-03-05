#!/bin/bash

. ./config.sh

default_stop_pkg(){
        PACKAGE=$1
        if [ -z "${PACKAGE}" ];then
                echo "invalid package_name:  "${PACKAGE}
                return 2
        fi

        stop_container "${PACKAGE}"
        return $?
}


PKG_NAME=$1
if [ -z "${PKG_NAME}" ];then
    PKG_NAME=${PKG_LIST}
fi
echo ">>>>>>>>>>>>>>> ready stop:  "${PKG_NAME}

cd ${RUN_DIR}
#docker ps | grep -v 'CONTAINER' | awk '{print $1}' | xargs docker stop
for pkg in ${PKG_NAME};
do
        if [ -f "${pkg}/stop.sh" ];then
                cd ${pkg}
                sh stop.sh
                cd - >/dev/null 2>&1
        else
                default_stop_pkg ${pkg}
                check_error_notify "stop ${pkg} failure"
        fi
done
