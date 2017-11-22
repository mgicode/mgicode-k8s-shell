# author:pengrk
# email:546711211@qq.com
# qq group:573283836


NODE_IPS="192.168.0.17  192.168.0.18    192.168.0.19"
NODE_NAME="consul01 consul02 consul03"

#t重新运行，需要生成CONSUL_KEY_TOKEN
clearScript="   
    systemctl stop consul; 
    systemctl disable consul;

    rm -rf /consul3Working/;
    rm -rf /usr/local/bin/consul;

    rm -rf /consul3Working/;
    rm -rf /etc/consul.d/server;
    rm -rf mkdir /var/consul/
  "

checkScript="
    echo -e \"\033[32m ############### /consul3Working/install-client.sh ########### \033[0m\"
    ls /consul3Working/install-client.sh
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"

    echo -e \"\033[32m ############### /etc/systemd/system/consul.service至少包括mongodb.service ########### \033[0m\"
    ls /etc/systemd/system/consul.service
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"

    echo -e \"\033[32m ############### /etc/consul.d/server/config.json ########### \033[0m\"
    ls /etc/consul.d/server/config.json
    cat /etc/consul.d/server/config.json
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"
"


#清除mongodb安装的所有内容
# for ip in $NODE_IPS ;do
#       echo "清除$ip中的consul安装的所有内容..."
#       ssh root@$ip "$clearScript"
#  done

#3.3 安装consul
for ip in $NODE_IPS ;do
      echo "清除$ip中的consul安装的所有内容..."
      ssh root@$ip "$clearScript"

      echo "安装$ip的consul..."
      ssh root@$ip "mkdir -p /consul3Working/; mkdir -p /etc/consul.d/server/;mkdir /var/consul/"

      scp /consul3/consulconfig${ip##*.}  root@$ip:/etc/consul.d/server/config.json
      scp /consul3/consul.service    root@$ip:/etc/systemd/system/consul.service
      scp /consul3/install-client.sh  root@$ip:/consul3Working/install-client.sh
      ssh root@$ip "chmod 777 /consul3Working/install-client.sh; /consul3Working/install-client.sh;"

      ssh root@$ip "$checkScript"
      sleep 5

done


sleep 20

for ip in $NODE_IPS ;do
      echo "查看集群状态..."     
      ssh root@$ip "consul members -http-addr=127.0.0.1:8500"
      sleep 5

done





