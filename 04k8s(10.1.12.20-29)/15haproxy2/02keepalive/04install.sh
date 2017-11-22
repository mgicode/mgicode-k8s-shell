# author:pengrk
# email:546711211@qq.com
# qq group:573283836

NODE_IPS="10.1.12.80  10.1.12.81"
NODE_NAME="balance01 balance02 "

#t重新运行，需要生成CONSUL_KEY_TOKEN
clearScript="   
    systemctl stop keepalive; 
    systemctl disable keepalive;

    rm -rf /etc/systemd/system/keepalive.service

    rm -rf /balanceKeepAliveWorking/;
    rm -rf /usr/local/sbin/keepalived;
    rm -rf /usr/local/etc/keepalived/; 
    rm -rf /etc/keepalived/keepalived.conf 

  "

checkScript="
    echo -e \"\033[32m #######/balanceKeepAlive/install-client.sh ####### \033[0m\"
    ls /balanceKeepAlive/install-client.sh
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"

    echo -e \"\033[32m ######## /etc/systemd/system/keepalive.service ###### \033[0m\"
    ls /etc/systemd/system/keepalive.service
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"

    echo -e \"\033[32m ##########/etc/keepalived/keepalived.conf ######## \033[0m\"
    ls /etc/keepalived/keepalived.conf 
    cat /etc/keepalived/keepalived.conf 
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"
"

#3.3 安装keepalive
for ip in $NODE_IPS ;do
      echo "清除$ip中的keepalive安装的所有内容..."
      ssh root@$ip "$clearScript"

      echo "安装$ip的keepalive..."
      ssh root@$ip "mkdir -p /balanceKeepAliveWorking/; mkdir -p /etc/keepalived/;"

      scp /balanceKeepAlive/keepAliveConfig${ip##*.}  root@$ip:/etc/keepalived/keepalived.conf
      scp /balanceKeepAlive/keepalive.service   root@$ip:/etc/systemd/system/keepalive.service
      scp /balanceKeepAlive/install-client.sh  root@$ip:/balanceKeepAliveWorking/install-client.sh
      ssh root@$ip "chmod 777 /balanceKeepAliveWorking/install-client.sh; /balanceKeepAliveWorking/install-client.sh;"

      ssh root@$ip "$checkScript"
      sleep 5

done


sleep 20

for ip in $NODE_IPS ;do
      echo "查看状态..."     
      ssh root@$ip "ip addr ; "
      #查看日志
       ssh root@$ip "cat /var/log/messages ; "
       
      sleep 5
done







#stop a, look the b has the vip
#stop b start a look the a has the vip

# ps -ef

#/usr/local/sbin/keepalived -D




