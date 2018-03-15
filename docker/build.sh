#!/bin/bash

. ./config.sh

#默认打包函数
default_build_pkg(){
    PACKAGE=$1
    DOCKER_DIR=$2
    if [ -z "${PACKAGE}" ];then
            echo "invalid package_name:  "${PACKAGE}
            return 2
    fi
    if [ -z "${DOCKER_DIR}" ];then
            echo "invalid docker_dir:  "${DOCKER_DIR}
            return 2
    fi
    echo "docker dir:  "${DOCKER_DIR}

    #创建打包目录
    LOCAL_BUILD_DIR="${DOCKER_DIR}/temp/${PACKAGE}/"
    mkdir -p ${LOCAL_BUILD_DIR}
    #同步打包文件，使用全路径
    rsync -avzrl --delete "${DOCKER_DIR}/build/${PACKAGE}/build/" ${LOCAL_BUILD_DIR}

    BuildName=`read_build_name "${PACKAGE}"`
    check_error_exit "read_build_name error"

    #进入打包目录开始打包
    cd ${LOCAL_BUILD_DIR}
    sudo docker build -t "${BuildName}" .
    build_rlt=$?
    echo "build command result:   "${build_rlt}
    cd -
    return ${build_rlt}
}

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

    SRC_DIR="${CUR_PWD}/${pkg}"
    if [ -f "${SRC_DIR}/build.sh" ];then
        \cp -f common.sh "${SRC_DIR}/"
        cd ${CUR_PWD}/${pkg}
        check_error_exit

        chmod 777 *.sh
        ./build.sh ${pkg} ${DOCKER_DIR}
        check_error_exit "build ${pkg} failure"

        cd -
    else
        default_build_pkg ${pkg} ${DOCKER_DIR}
        check_error_exit "build ${pkg} failure"
    fi

done

echo "build finish, install run script"
./install.sh ${PKG_NAME}
check_error_exit "install run script fail"
echo "install run script success"
