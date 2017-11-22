# author:pengrk
# email:546711211@qq.com
# qq group:573283836

# wget wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-3.4.4.tgz 
FILE_SERVER_IP=192.168.0.20


#3.3 创建安装的shell
cat > /mongodbRelicaSet3/install-client.sh <<EOF

echo " export PATH=/usr/local/bin:\$PATH " >> /etc/profile
source /etc/profile

mkdir -p /mongodbRecilaSetWorking/
cd /mongodbRecilaSetWorking/

wget http://${FILE_SERVER_IP}/mongodb-linux-x86_64-rhel70-3.4.4.tgz  -q
tar  -zxvf mongodb-linux-x86_64-rhel70-3.4.4.tgz
rm  mongodb-linux-x86_64-rhel70-3.4.4.tgz
cp -r /mongodbRecilaSetWorking/mongodb-linux-x86_64-rhel70-3.4.4/bin/*  /usr/local/bin/
chmod 777 /usr/local/bin/*

echo -e "\033[32m ###############至少包括mongo、mongod文件########### \033[0m"
ls /usr/local/bin/
echo -e "\033[32m ###########内容显示完成########### \033[0m"

 mkdir  -p /var/lib/mongodb/

 systemctl daemon-reload
 systemctl enable mongodb
 systemctl start mongodb
 systemctl status mongodb

 sleep 3

EOF

echo -e "\033[32m ###############  /mongodbRelicaSet3/install-client.sh  ########### \033[0m"
cat  /mongodbRelicaSet3/install-client.sh 
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 2;
