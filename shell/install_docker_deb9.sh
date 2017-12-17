#!/bin/bash

. ./public.sh


output_step "删除机器上老旧的仓库"
sudo apt-get purge lxc-docker*
sudo apt-get purge docker.io*

output_step "安装依赖包"
sudo apt-get update
sudo apt-get install apt-transport-https

output_step "添加docker的源（debian9）"
sudo /bin/bash -c "echo deb https://apt.dockerproject.org/repo debian-stretch main > /etc/apt/sources.list.d/docker.list"

output_step "确认 apt 能从正确的仓库拉取内容"
apt-cache policy docker-engine

output_step "增加一个新 gpg 密钥"
sudo apt-get install curl
sudo apt-get install dirmngr
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RESULT=$?
if [ ${RESULT} -ne 0 ]; then
    echo "添加 gpg 密钥 58118E89F3A912897C070ADBF76221572C52609D 失败，尝试更换成 sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8C718D3B5072E1F5"
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8C718D3B5072E1F5
    check_error_exit "添加 gpg 密钥失败，请检查错误提示并修改脚本重试"
fi

output_step "开始安装"
sudo apt-get update
sudo apt-get install docker-engine
check_error_exit "安装 docker-engine 失败，请修改脚本尝试安装 docker.io替代"
sudo apt-get install docker-compose
check_error_exit "安装 docker-compose 失败"
echo "安装成功"
sudo docker version

output_step "增加一个docker group，如果它不存在的话"
sudo groupadd docker >/dev/null 2>&1

output_step "增加当前用户到 docker group"
USER_NAME=`whoami`
sudo gpasswd -a ${USER_NAME} docker

output_step "重启docker"
sudo service docker restart

output_step "测试docker是否正确安装"
sudo docker run hello-world
check_error_exit "docker安装失败"

output_step "docker 安装成功，清理现场后脚本结束。"
sudo apt-get autoremove
