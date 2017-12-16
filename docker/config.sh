#!/bin/bash

. ./common.sh

#当前执行这个脚本的目录
CUR_PWD=`pwd`
#父目录
PARENT_PWD=`echo "$(dirname ${CUR_PWD})"`

#修改脚本执行权限
chmod 777 ${CUR_PWD}/*.sh

# config start -----------------------------------------------------------------
#所有产品
PKG_LIST="mysql mongo redis"

rm -rf ${CONFIG_DIR}/*.conf >/dev/null 2>&1
python config/format_config.py "${RUN_DIR}" "${CUR_PWD}/config" "${CONFIG_DIR}"
check_error_exit "python读取配置文件失败"

#读取帐号密码
read_account;

echo "account=  "${ACCOUNT}
echo "password=  "${PASSWORD}
# config end ------------------------------------------------------------------
