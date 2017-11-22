# author:pengrk
# email:546711211@qq.com
# qq group:573283836

NODE_IPS="192.168.0.2"
NODE_NAME="balance01 "
FILE_SERVER_IP=192.168.0.20

#3.3 创建安装的shell
cat > /balanceHaProxy/install-client.sh <<EOF
mkdir -p /balanceHaProxyWorking/
cd /balanceHaProxyWorking/
#创建系统账号
#useradd -r haproxy

#w
# yum install -y wget gcc  make pcre-static pcre-devel
 wget http://${FILE_SERVER_IP}/haproxy-1.7.5.tar.gz 
 tar xzvf haproxy-1.7.5.tar.gz
 cd haproxy-1.7.5 

 make TARGET=linux2628 PREFIX=/usr/local/haproxy 
 make install PREFIX=/usr/local/haproxy

 cp /usr/local/haproxy/sbin/haproxy  /usr/sbin/   
 cp  examples/haproxy.init  /etc/init.d/haproxy 
 chmod 755 /etc/init.d/haproxy

echo -e "\033[32m ###############/usr/sbin/haproxy########### \033[0m"
ls /usr/sbin/haproxy
ls /etc/haproxy/haproxy.cfg
echo -e "\033[32m ###########内容显示完成########### \033[0m"

 systemctl daemon-reload
 systemctl enable haproxy
 systemctl start haproxy
 systemctl status haproxy

 sleep 3

EOF

echo -e "\033[32m ############### /balanceHaProxy/install-client.sh ########### \033[0m"
cat   /balanceHaProxy/install-client.sh
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 2;
