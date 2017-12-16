#!/bin/bash

. ./public.sh

USER_NAME=`whoami`
if [ "${USER_NAME}" != "root" ]; then
    echo "初始化脚本需要以root帐号执行"
    exit 2
fi

output_step "安装sudo"
apt-get update
apt-get install sudo
apt-get install apt-transport-https


output_step "配置当前默认sh"
dpkg-reconfigure dash
Cur_Shell=`echo $SHELL`
echo "default shell is  "${Cur_Shell}
echo "配置结束"
