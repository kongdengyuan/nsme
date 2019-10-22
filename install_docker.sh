install_docker() {

   docker -v >&/dev/null
   if [ $? -eq 0 ]; then
      echo -e "\e[1;35mDocker already install \e[0m"
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
      sudo apt-get install docker-ce=$docker_version -y && echo -e "\e[1;32mInstall docker success \e[0m"

   fi
}

install_docker-compose() {

   docker-compose -v >&/dev/null
   if [ $? -eq 0 ]; then
      echo -e "\e[1;35mAlready install docker-compose \e[0m"
   else
      echo -e "\e[1;32mBegin to install docker-compose \e[0m"
      sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose && echo -e "\e[1;32mInstall docker-compose success \e[0m"
   fi
}

install_docker
install_docker-compose
