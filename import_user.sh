#!/bin/bash

## Define color display
RED='\e[1;31m'
GREEN='\e[1;32m'
END='\e[0m'

HOST_IP=`ip a | grep 'inet ' | grep -v '127.0.0.1\|172.*' | awk '{print $2}' | awk -F"/" '{print $1}'`
SQL="psql -h ${HOST_IP} -Upostgres -d X4DB"

## Install pgsql client 
psql -V >&/dev/null

if [ $? -eq 0 ];then
   echo -e  "${GREEN}postgresql client already install${END}"	
else    

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - && sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' && sudo  apt-get update && sudo apt install postgresql-client-common  postgresql-client-11 -y  && echo -e "${GREEN}postgresql client install success${END}"

fi 

## Begin to import user
$SQL -f USER.sql 

if [ $? -eq 0 ];then 
   echo -e "${GREEN}Import User success${END}"
else 
   echo -e "${RED}Import User Falied${END}"   
fi   

