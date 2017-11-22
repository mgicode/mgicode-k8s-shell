# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#3.3 创建安装的shell
cat > /consulTemplate/install-client.sh <<EOF
mkdir -p /balanceHaConsulTemplateWorking/
cd /balanceHaConsulTemplateWorking/

 wget http://${FILE_SERVER_IP}/consul-template
 cp /balanceHaConsulTemplateWorking/consul-template  /usr/local/bin/   

chmod 777 /usr/local/bin/* 
 systemctl daemon-reload
 systemctl enable consultemplate
 systemctl start consultemplate
 systemctl status consultemplate

echo -e "\033[32m ###############/usr/local/bin/consul-template########### \033[0m"
ls /usr/local/bin/consul-template
echo -e "\033[32m ###########内容显示完成########### \033[0m"

 sleep 3

EOF

echo -e "\033[32m ############### /consulTemplate/install-client.sh ########### \033[0m"
cat   /consulTemplate/install-client.sh
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 2;

