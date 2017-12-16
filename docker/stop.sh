#!/bin/bash

. ./config.sh

PKG_NAME=$1
if [ -z "${PKG_NAME}" ];then
    PKG_NAME=${PKG_LIST}
fi
echo ">>>>>>>>>>>>>>> ready stop:  "${PKG_NAME}

cd ${RUN_DIR}
#docker ps | grep -v 'CONTAINER' | awk '{print $1}' | xargs docker stop
for pkg in ${PKG_NAME};
do
        cd ${pkg}
        sh stop.sh
        cd - >/dev/null 2>&1
done
