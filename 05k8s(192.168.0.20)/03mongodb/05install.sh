# author:pengrk
# email:546711211@qq.com
# qq group:573283836

NODE_IPS="192.168.0.14   192.168.0.15   192.168.0.16"
NODE_NAME="mongodb01 mongodb02 mongodb03"

clearScript="   
    systemctl stop mongodb; 
    systemctl disable mongodb;

    rm -rf /mongodbRecilaSetWorking/;
    rm -rf /usr/local/bin/mongo*;
    rm -rf /usr/local/bin/bsondump;

    rm -rf /var/lib/mongodb/install-client.sh;
    rm -rf /etc/systemd/system/mongodb.service;
    rm -rf /var/lib/mongodb/
  "

checkScript="
    echo -e \"\033[32m ############### /var/lib/mongodb/至少包括install-client.sh ########### \033[0m\"
    ls /var/lib/mongodb/install-client.sh
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"

    echo -e \"\033[32m ############### /etc/systemd/system/至少包括mongodb.service ########### \033[0m\"
    ls /etc/systemd/system/mongodb.service
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"

    echo -e \"\033[32m ############### /var/lib/mongodb/至少包括mongodb.conf ########### \033[0m\"
    ls /var/lib/mongodb/mongodb.conf
    cat /var/lib/mongodb/mongodb.conf
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"
"


#清除mongodb安装的所有内容
# for ip in $NODE_IPS ;do
#       echo "清除$ip中的mongodb安装的所有内容..."
#       ssh root@$ip "$clearScript"
#  done

#3.3 安装mongodb
for ip in $NODE_IPS ;do
      echo "清除$ip中的mongodb安装的所有内容..."
      ssh root@$ip "$clearScript"

      echo "安装$ip的mongodb..."
      ssh root@$ip "mkdir -p /mongodbRecilaSetWorking/; mkdir -p /var/lib/mongodb/data/db/;mkdir -p /var/lib/mongodb/data/log/"

      scp /mongodbRelicaSet3/mongdbconf${ip##*.} root@$ip:/var/lib/mongodb/mongodb.conf  
      scp /mongodbRelicaSet3/mongodb.service    root@$ip:/etc/systemd/system/mongodb.service
      scp /mongodbRelicaSet3/install-client.sh  root@$ip:/var/lib/mongodb/install-client.sh
      ssh root@$ip "chmod 777 /var/lib/mongodb/install-client.sh; /var/lib/mongodb/install-client.sh;"

      ssh root@$ip "$checkScript"
      sleep 5

done




