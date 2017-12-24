#!/bin/bash

docker stop $(docker ps -q) >/dev/null 2>&1
docker rm $(docker ps -aq) >/dev/null 2>&1
echo "remove all container finish"

echo "remove hangout images"
docker rmi $(docker images -aq -f "dangling=true")
echo "remove all images finish"
