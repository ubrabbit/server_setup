#!/bin/bash

/docker-config.sh
/usr/local/postfix/sbin/postfix set-permissions
echo "start mail-server"
supervisord -n -c /etc/supervisor/supervisord.conf
