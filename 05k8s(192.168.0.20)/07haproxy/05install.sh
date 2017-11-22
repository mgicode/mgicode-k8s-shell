# author:pengrk
# email:546711211@qq.com
# qq group:573283836

NODE_IPS="192.168.0.2"
NODE_NAME="balance01 "

#重新运行
clearScript="   
    systemctl stop haproxy; 
    systemctl disable haproxy;

    rm -rf /etc/systemd/system/haproxy.service

    rm -rf /balanceHaProxyWorking/;
    rm -rf /usr/local/haproxy/;
    rm -rf  /etc/init.d/haproxy ; 
      "

checkScript="
    echo -e \"\033[32m #######/balanceHaProxyWorking/install-client.sh ####### \033[0m\"
    ls /balanceHaProxyWorking/install-client.sh
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"

    echo -e \"\033[32m ######## /etc/systemd/system/haproxy.service ###### \033[0m\"
    ls /etc/systemd/system/haproxy.service
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"

    echo -e \"\033[32m ##########/etc/haproxy/haproxy.cfg ######## \033[0m\"
    ls /etc/haproxy/haproxy.cfg 
    cat /etc/haproxy/haproxy.cfg
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"
"

#3.3 安装haproxy
for ip in $NODE_IPS ;do
      echo "清除$ip中的haproxy安装的所有内容..."
      ssh root@$ip "$clearScript"

      echo "安装$ip的haproxy..."
      ssh root@$ip "mkdir -p /balanceHaProxyWorking/; mkdir -p /etc/haproxy/;"

      scp /balanceHaProxy/haproxyConfig${ip##*.}  root@$ip:/etc/haproxy/haproxy.cfg
      scp /balanceHaProxy/haproxy.service   root@$ip:/etc/systemd/system/keepalive.service
      scp /balanceHaProxy/install-client.sh  root@$ip:/balanceHaProxyWorking/install-client.sh
      ssh root@$ip "chmod 777 /balanceHaProxyWorking/install-client.sh; /balanceHaProxyWorking/install-client.sh;"

      ssh root@$ip "$checkScript"
      sleep 5

done


sleep 20

for ip in $NODE_IPS ;do
      echo "查看状态..."     
       #ssh root@$ip "cat /var/log/messages ; "
       curl http:${ip}:1080/haproxy?stats
      sleep 5
done


 #查看consul http://10.123.8.249:8500/v1/catalog/service/ms01


