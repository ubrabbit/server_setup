#!/bin/bash

# 输出错误提示
check_error_exit()
{
    RESULT=$?
    if [ ${RESULT} -ne 0 ]; then
        echo "#[ERROR] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo "#[ERROR] "$1
        echo "#[ERROR] <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        exit 1
    fi
}

check_create_folder()
{
    folder=$1
    if [ -z "${folder}" ];then
        echo "create folder input is empty"
        return 1
    fi

    if [ ! -d "${folder}" ];then
        mkdir -p ${folder}
        check_error_exit "create "${folder}" fail "
        echo "create dir:  "${folder}
    fi
    return 0
}

read_config()
{
    cfg_file=$1
    file_path="${CONFIG_DIR}/${cfg_file}.conf"
    file_path2="${CONFIG_DIR}/${cfg_file}"
    if [ -z "${cfg_file}" ];then
        echo "333333333333333333333"
        return 1
    fi

    if [ -f "${file_path}" ];then
        echo `cat ${file_path}`
    elif [ -f "${file_path2}" ];then
        echo `cat ${file_path2}`
    fi
    return 0
}

read_account()
{
    acct_file="${CONFIG_DIR}/account.conf"
    pwd_file="${CONFIG_DIR}/password.conf"
    if [ -f "${acct_file}" ];
    then
        ACCOUNT=`cat ${acct_file}`
    fi
    if [ -f "${pwd_file}" ];
    then
        PASSWORD=`cat ${pwd_file}`
    fi
}

make_runname(){
    #读取帐号密码
    tmp_pkg=$1
    read_account >/dev/null 2>&1
    if [ -z "${ACCOUNT}" ];then
        RUN_NAME="${tmp_pkg}"
    else
        RUN_NAME="${ACCOUNT}/${tmp_pkg}"
    fi
    echo "${RUN_NAME}"
    return 0
}

stop_container()
{
    tmp_pkg=$1
    echo "ready stop "${tmp_pkg}
    docker ps | grep ${tmp_pkg} | awk '{print $1}' | while read line;
    do
        if [ -z "$line" ];
        then
            continue
        fi
        docker stop ${line} >/dev/null 2>&1
        echo "stop "${line}" success"
    done
    echo "stop all "${tmp_pkg}" finish"
}

get_image_name()
{
    image_name=$1
    default_name=${image_name}
    case ${image_name} in
        "mongo")
            image_name="mongo_image"
            ;;
        "redis")
            image_name="redis_image"
            ;;
        "mysql")
            image_name="mysql_image"
            ;;
        *)
            echo "error image_name:  "${image_name}
            exit 2
            ;;
    esac

    IMAGE=`read_config "${image_name}"`
    if [ -z "${IMAGE}" ];then
        RUN_NAME="${default_name}"
    else
        RUN_NAME=`make_runname "${IMAGE}"`
    fi
    echo "${RUN_NAME}"
}

#docker 主目录
DOCKER_DIR="${HOME}/docker"
#数据存放目录
DATA_DIR="${DOCKER_DIR}/data"
#打包目录
BUILD_DIR="${DOCKER_DIR}/build"
#运行脚本存放目录
RUN_DIR="${DOCKER_DIR}/run"
#临时文件夹
TEMP_DIR="${RUN_DIR}/temp"
#配置文件夹
CONFIG_DIR="${TEMP_DIR}/config"

# create folder ----------------------------------------------------------------
#创建运行目录
check_create_folder ${DOCKER_DIR}
check_create_folder ${DATA_DIR}
check_create_folder ${BUILD_DIR}
check_create_folder ${RUN_DIR}
check_create_folder ${TEMP_DIR}
check_create_folder ${CONFIG_DIR}
# create folder end ------------------------------------------------------------

ACCOUNT=""
PASSWORD=""
