# author:pengrk
# email:546711211@qq.com
# qq group:573283836

# wget wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-3.4.4.tgz 

#3.3 创建安装的shell
cat > /consul3/install-client.sh <<EOF

echo " export PATH=/usr/local/bin:\$PATH " >> /etc/profile
source /etc/profile

mkdir -p /consul3Working/
cd /consul3Working/

wget http://${FILE_SERVER_IP}/consul -q
cp -r /consul3Working/consul  /usr/local/bin/
chmod 777 /usr/local/bin/*

echo -e "\033[32m ###############至少包括consul文件########### \033[0m"
ls /usr/local/bin/consul
echo -e "\033[32m ###########内容显示完成########### \033[0m"

 # 创建配置文件目录
 #mkdir -p /etc/consul.d/server
 #创建consul存储数据的目录
 #mkdir /var/consul


#启动consul
 systemctl daemon-reload
 systemctl enable consul
 systemctl start consul
 systemctl status consul

 sleep 3

EOF

echo -e "\033[32m ############### /consul3/install-client.sh ########### \033[0m"
cat   /consul3/install-client.sh
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 2;
