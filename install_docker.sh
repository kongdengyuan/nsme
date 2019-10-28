#!/bin/bash

## Define color 
RED='\e[1;31m'
GREEN='\e[1;32m'
PURPLE='\e[1;35m'
END='\e[0m'

install_docker() {

   docker -v >&/dev/null
   if [ $? -eq 0 ]; then
      echo -e "${PURPLE}Docker already install ${END}"
   else
      apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common -y

      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

      sudo apt-key fingerprint 0EBFCD88

      sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

      sudo apt-get update

      ## apt-cache madison docker-ce  # find docker-ce version
      docker_version=$(apt-cache madison docker-ce | awk -F"|" '{print $2}' | head -1 | sed 's/[[:space:]]*//')

      ## sudo apt-get install docker-ce=5:19.03.3~3-0~ubuntu-xenial -y
      sudo apt-get install docker-ce=$docker_version -y && echo -e "${GREEN}Install docker success ${END}"

   fi
}

install_docker-compose() {

   docker-compose -v >&/dev/null
   if [ $? -eq 0 ]; then
      echo -e "${PURPLE}Already install docker-compose ${END}"
   else
      echo -e "${GREEN}Begin to install docker-compose ${END}"
      sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose && echo -e "${GREEN}Install docker-compose success ${END}"
   fi
}

install_docker
install_docker-compose

## Add non-user to docker group 
CURRENT_USER=`whoami`
if [ $CURRENT_USER != root ];then
id | grep docker >&/dev/null && echo -e "${GREEN}Current user is added to docker group ${END}" || sudo usermod -a -G docker $CURRENT_USER
else 
   echo -e  "${GREEN}Current user is root ${END}"
fi    
