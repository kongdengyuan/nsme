#!/bin/bash

## Enable debug model, default disable
# set -x 

## Define color display
RED='\e[1;31m'
GREEN='\e[1;32m'
PURPLE='\e[1;35m'
END='\e[0m'

## Check docker component 
bash install_docker.sh 

## Define variable  
CURRENT_DIR=$(cd "$(dirname "$0")";pwd)
BYDURL="https://qch-cust427.dev.sapbydesign.com"
export GIT_SSL_NO_VERIFY=1 ## solve ssl error
export  HOST_IP=`ip a | grep 'inet ' | grep -v '127.0.0.1\|172.*' | awk '{print $2}' | awk -F"/" '{print $1}'` ## Get ip

## 
cd $CURRENT_DIR

## check x4-s4one dir 
[ -d x4-s4one ] && git pull || git clone https://github.wdf.sap.corp/BIG/x4-s4one.git

## Copy start script to x4-s4one
[ -e $CURRENT_DIR/x4-s4one/start-x4-s4one.sh ] || cp start-x4-s4one.sh $CURRENT_DIR/x4-s4one

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
docker build -t registry.kkops.cc/x4-s4one:$TAG .

## Start x4-s4one docker 
if [ $? -eq 0 ];then
   echo -e "${GREEN}Begin start NSME${END}"
   docker ps | grep nsme >&/dev/null

 if [ $? -eq 0 ];then 
    docker-compose down  &&  docker-compose up -d && echo -e "${GREEN}Start x4-s4one Ok, Please be wait minutes${END}"
 else
    docker-compose up -d && echo -e "${GREEN}Start x4-s4one Ok, Please be wait minutes${END}"
 fi 

else
   echo -e "${RED}Build x4-s4one failed${END}"
   exit 2
fi

## Begin to check port and imort user
echo -e "${PURPLE}Sleep 222 seconds${END}"
sleep 222 
bash check_port.sh

