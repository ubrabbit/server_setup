#!/bin/bash

./stop.sh
./rm_container.sh
docker images | grep -v "REPOSITORY" | awk '{print $3}' | xargs -I{} docker rmi -f {}
