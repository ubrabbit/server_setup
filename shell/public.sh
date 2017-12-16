#!/bin/bash

SCRIPT_STEP=0                              # 步骤计数器


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

output_step()
{
    let SCRIPT_STEP=SCRIPT_STEP+1
    echo
    echo
    echo "# Step_$SCRIPT_STEP:  "$1
    echo
    echo
}
