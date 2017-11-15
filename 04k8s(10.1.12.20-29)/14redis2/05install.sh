# author:pengrk
# email:546711211@qq.com
# qq group:573283836


NODE_IPS="10.1.12.76  10.1.12.77"
NODE_NAME="redis01 redis02 "
#t重新运行，需要生成CONSUL_KEY_TOKEN
clearScript="   
    systemctl stop redis; 
    systemctl disable redis;

    rm -rf /etc/systemd/system/consul.service

    rm -rf /redis2Working/;
    rm -rf /usr/local/bin/redis*;

    rm -rf /etc/redis2/; 
  "

checkScript="
    echo -e \"\033[32m ############### /redis2Working/install-client.sh ########### \033[0m\"
    ls /redis2Working/install-client.sh
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"

    echo -e \"\033[32m ############### //etc/systemd/system/redis.service ########### \033[0m\"
    ls /etc/systemd/system/redis.service
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"

    echo -e \"\033[32m ############### /etc/redis2/redis.conf ########### \033[0m\"
    ls /etc/redis2/redis.conf
    cat /etc/redis2/redis.conf
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"
"

#3.3 安装redis
for ip in $NODE_IPS ;do
      echo "清除$ip中的redis安装的所有内容..."
      ssh root@$ip "$clearScript"

      echo "安装$ip的redis..."
      ssh root@$ip "mkdir -p /redis2Working/; mkdir -p /etc/redis2/;"

      scp /redis2/redisconfig${ip##*.}   root@$ip:/etc/redis2/redis.conf
      scp /redis2/redis.service    root@$ip:/etc/systemd/system/redis.service
      scp /redis2/install-client.sh  root@$ip:/redis2Working/install-client.sh
      ssh root@$ip "chmod 777 /redis2Working/install-client.sh; /redis2Working/install-client.sh;"

      ssh root@$ip "$checkScript"
      sleep 5

done


sleep 20

for ip in $NODE_IPS ;do
      echo "查看集群状态..."     
      ssh root@$ip "redis-cli -h ${ip} -p 6379 ; "
      sleep 5

done





