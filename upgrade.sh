#!/bin/bash

# Define color display
RED='\e[1;31m'
GREEN='\e[1;32m'
PURPLE='\e[1;35m'
END='\e[0m'

## Define variable
CURRENT_DIR=$(cd "$(dirname "$0")";pwd)
export GIT_SSL_NO_VERIFY=1
export HOST_IP=`ip a | grep 'inet ' | grep -v '127.0.0.1\|172.*' | awk '{print $2}' | awk -F"/" '{print $1}'`

##
cd $CURRENT_DIR

## check x4-s4one dir
[ -d x4-s4one ] && git pull || git clone https://github.wdf.sap.corp/BIG/x4-s4one.git

## check x4-app-package.json value
cat $CURRENT_DIR/x4-s4one/src/s4one/base/x4-app-package.json | grep $BYDURL | grep -v 'process.env' >&/dev/null
if [ $? -eq 0 ];then
   echo -e "${GREEN}x4-app-package.json BYDURL is correct ${END}"
else
   sed -i 's#"value": "pro.*$#"value": "https://qch-cust427.dev.sapbydesign.com"#' $CURRENT_DIR/x4-s4one/src/s4one/base/x4-app-package.json && echo -e "${GREEN}Repalce x4-app-package.json BYDURL success ${END}"
fi

## Get the latest commit id
export TAG=$(cd x4-s4one && git log | head -1 | awk '{print $2}' | cut -c -8)

## Start build x4-s4one
docker build -t registry.kkops.cc/x4-s4one:$TAG . && echo -e "${GREEN}Build x4-s4one success ${END}" || exit 2

## Start x4-s4one docker
## Delete old nsme x4-s4one docker
docker rm -f `docker ps | grep "registry.kkops.cc/x4-s4one" | awk '{print $NF}'` >&/dev/null  && \
echo -e "${PURPLE}Delete old nsme docker success${END}"

docker run -d --name nsme -p3000:3000 -v /var/log/x4_s4one:/var/log/x4_s4one -e DB_HOST=${HOST_IP} -e DB_NAME=X4DB registry.kkops.cc/x4-s4one:$TAG && \
echo -e "${GREEN}Start x4-s4one Ok, Please be wait minutes${END}"

## Begin to check port and imort user
echo -e "${PURPLE}Sleep 60 seconds${END}"
sleep 60
bash check_port.sh

