#!/bin/bash


# 输出错误提示
output_usage()
{
    echo
    echo "#[USAGE] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo "cmd.sh 1            docker container ls"
    echo "cmd.sh 2            docker images"
    echo "cmd.sh 3            docker rmi"
    echo "#[USAGE] <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
}


CMD=$1
case ${CMD} in
    "1")
        CMD="container ls"
        ;;
    "2")
        CMD="images"
        ;;
    "3")
        CMD="rmi "$2
        ;;
    *)
        output_usage
        exit
        ;;
esac

echo "CMD:  docker "${CMD}

docker ${CMD}
