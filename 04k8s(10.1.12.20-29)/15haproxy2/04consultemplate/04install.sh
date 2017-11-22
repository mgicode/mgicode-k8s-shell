# author:pengrk
# email:546711211@qq.com
# qq group:573283836

NODE_IPS="10.1.12.80  10.1.12.81"
NODE_NAME="balance01 balance02 "

#重新运行
clearScript="   
    systemctl stop consultemplate; 
    systemctl disable consultemplate;
    sleep 2
    rm -rf /etc/systemd/system/consultemplate.service
    sleep 2
    rm -rf  /balanceHaConsulTemplateWorking/;
    rm -rf  /usr/local/bin/consul-template;
    rm -rf  /etc/consul-template/haproxy.ctmpl ; 
      "

checkScript="
    echo -e \"\033[32m #######/balanceHaConsulTemplateWorking/install-client.sh ####### \033[0m\"
    ls /balanceHaConsulTemplateWorking/install-client.sh
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"

    echo -e \"\033[32m ######## /etc/systemd/system/consultemplate.service ###### \033[0m\"
    ls /etc/systemd/system/consultemplate.service
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"

    echo -e \"\033[32m ##########/etc/consul-template/haproxy.ctmpl ######## \033[0m\"
    ls  /etc/consul-template/haproxy.ctmpl
    cat /etc/consul-template/haproxy.ctmpl
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"
"

#3.3 安装consultemplate
for ip in $NODE_IPS ;do
      echo "清除$ip中的consultemplate安装的所有内容..."
      ssh root@$ip "$clearScript"

      echo "安装$ip的consultemplate..."
      ssh root@$ip "mkdir -p /balanceHaConsulTemplateWorking/; mkdir -p /etc/consul-template/ ;"

      scp /consulTemplate/haproxyTemplateConfig${ip##*.}  root@$ip:/etc/consul-template/haproxy.ctmpl
      scp /consulTemplate/consultemplate.service   root@$ip:/etc/systemd/system/consultemplate.service
      scp /consulTemplate/install-client.sh   root@$ip:/balanceHaConsulTemplateWorking/install-client.sh
      ssh root@$ip "chmod 777 /balanceHaConsulTemplateWorking/install-client.sh; /balanceHaConsulTemplateWorking/install-client.sh;"

      ssh root@$ip "$checkScript"
      sleep 5

done


for ip in $NODE_IPS ;do
      echo "查看状态..."     
       ssh root@$ip "cat /etc/haproxy/haproxy.cfg "
       ssh root@$ip "ps -ef "
      sleep 5
done
