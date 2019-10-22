#!/bin/bash
set -ex
export GIT_SSL_NO_VERIFY=1 ## solve ssl error

CURRENT_DIR=$(
  cd "$(dirname "$0")"
  pwd
)

cd $CURRENT_DIR

[ -d x4-s4one ] && git pull || git clone https://github.wdf.sap.corp/BIG/x4-s4one.git

[ -e $CURRENT_DIR/x4-s4one/start-x4-s4one.sh ] || cp start-x4-s4one.sh $CURRENT_DIR/x4-s4one

TAG=$(cd x4-s4one && git log | head -1 | awk '{print $2}' | cut -c -8)

## If prompt permission denied issues , try to usermod -a -G docker username

docker build -t registry.kkops.cc/x4-s4one:$TAG .

# docker push registry.kkops.cc/x4-s4one:$TAG  
if [ $? -eq 0 ];then 
   echo "Begin start NSME"
   docker-compose up -d && echo "\e[1;32mStart x4-s4one first need to import some pkg, so maybe take 20-30 minutes to up\e[0m"
 else 
   echo "Build x4-s4one failed" 
   exit 2

# docker push registry.kkops.cc/x4-s4one:$TAG
if [ $? -eq 0 ]; then
  echo "\e[1;32mBegin start NSME \e[0m"
  docker-compose up -d && echo "\e[1;32mStart x4-s4one first need to import some pkg, so maybe take 20-30 minutes to up\e[0m"
else
  echo "\e[1;31mBuild x4-s4one failed\e[0m"
  exit 2
fi

# docker run -d --name nsme -p3000:3000 -e DB_HOST=$(hostname -i) -e DB_NAME=X4DB -v /var/log/x4_s4one:/var/log/x4_s4one registry.kkops.cc/x4-s4one:$TAG
