# author:pengrk
# email:546711211@qq.com
# qq group:573283836

# wget wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-3.4.4.tgz 

FILE_SERVER_IP=192.168.0.20

#/usr/local/bin/redis-cli

#3.3 创建安装的shell
cat > /redis2/install-client.sh <<EOF

echo " export PATH=/usr/local/bin:\$PATH " >> /etc/profile
source /etc/profile

mkdir -p /redis2Working/
cd /redis2Working/
yum -y install gcc openssl-devel libyaml-devel libffi-dev
yum -y install gcc automake autoconf libtool make
yum -y install ruby 
yum -y install wget 
gem sources --remove https://rubygems.org/
gem sources -a https://ruby.taobao.org/

#wget http://download.redis.io/releases/redis-4.0.2.tar.gz 
wget http://${FILE_SERVER_IP}/redis-4.0.2.tar.gz 

tar xvf redis-4.0.2.tar.gz 
cd redis-4.0.2/ && make MALLOC=libc && make install  \
    &&   cp src/redis-trib.rb /usr/bin/ \
    &&   chmod 777 /usr/bin/redis-trib.rb  


echo -e "\033[32m ###############/usr/local/bin/至少包括redis-server redis-cli文件########### \033[0m"
ls /usr/local/bin/redis-server
echo -e "\033[32m ###########内容显示完成########### \033[0m"


#redis
 systemctl daemon-reload
 systemctl enable redis
 systemctl start redis
 systemctl status redis

 sleep 3

EOF

echo -e "\033[32m ############### /redis2/install-client.sh ########### \033[0m"
cat   /redis2/install-client.sh
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 2;
