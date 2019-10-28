#!/bin/bash
## check x4-s4one port

check_nsme_port(){
cat /var/log/x4_s4one/x4_s4one.log | grep 'port 3000' >&/dev/null

if [ $? -eq 0 ];then
      echo "service  start ok ,will be import user ,,,,,,," && bash import_user.sh
 else
   while true;
   do
     sleep 30 && echo "Please be patient to wait service start"
     cat /var/log/x4_s4one/x4_s4one.log | grep 'port 3000' >&/dev/null

     if [ $? -eq 0 ];then
       echo "service  start ok ,will be import user" && bash import_user.sh
       break;
     fi
   done
fi
}
check_nsme_port

