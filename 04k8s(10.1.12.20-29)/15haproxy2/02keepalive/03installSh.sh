# author:pengrk
# email:546711211@qq.com
# qq group:573283836

# wget wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-3.4.4.tgz 


#/usr/local/bin/redis-cli

#3.3 创建安装的shell
cat > /balanceKeepAlive/install-client.sh <<EOF

#echo " export PATH=/usr/local/bin:\$PATH " >> /etc/profile
#source /etc/profile

mkdir -p /balanceKeepAliveWorking/
cd /balanceKeepAliveWorking/

yum -y install gcc openssl-devel libyaml-devel libffi-dev
yum -y install gcc automake autoconf libtool make wget
yum -y install libnl3-devel ipset-devel iptables-devel libnfnetlink-devel net-snmp-devel 
#wget wget http://www.keepalived.org/software/keepalived-1.3.9.tar.gz
wget http://${FILE_SERVER_IP}/keepalived-1.3.9.tar.gz
tar xzvf keepalived-1.3.9.tar.gz 

#make MALLOC=libc
cd keepalived-1.3.9/&&./configure&& make MALLOC=libc  && make install 

echo -e "\033[32m ###############/usr/local/sbin至少包括keepalived文件########### \033[0m"
ls /usr/sbin/keepalived
ls /etc/keepalived/keepalived.conf 
echo -e "\033[32m ###########内容显示完成########### \033[0m"

#keepalive
mkdir -p /usr/local/etc/keepalived/
cp /etc/keepalived/keepalived.conf   /usr/local/etc/keepalived/keepalived.conf

#VRRP协议也需要设置防火墙,需要和ip相类似
#-d 10.0.0.0/8 ，ens160 需要修改############
#****************important****************########
#iptables -I INPUT -i ens160 -d 10.0.0.0/8 -p vrrp -j ACCEPT
#iptables -I OUTPUT -o ens160 -d 10.0.0.0/8 -p vrrp -j ACCEPT
#iptables-save >/etc/iptables-script
#echo '/sbin/iptables-restore /etc/iptables-script' >>/etc/rc.d/rc.local

sysctl -w net.ipv6.conf.eth0.accept_dad=0

#chkconfig --add keepalived
#chkconfig --level 12345 keepalived on

 systemctl daemon-reload
 systemctl enable keepalive
 systemctl start keepalive
 systemctl status keepalive

 sleep 3

EOF

echo -e "\033[32m ############### /balanceKeepAlive/install-client.sh ########### \033[0m"
cat   /balanceKeepAlive/install-client.sh
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 2;



# iptables的配置文件保存在/etc/sysconfig/iptables-config下，书写了iptables规则以后如果需要保存规则，则可以使用命令：iptables-save，使用此命令保存的规则位置可以是任意的，此时保存的规则在重启机器后无法自动生效，需要使用命令iptables-restore恢复，或者写入开机启动脚本/etc/rc.d/rc.local里面。
# 以下为教材里使用的命令：
# 保存规则：#iptables-save >/etc/iptables-script
# 恢复规则：#iptables-restore>/etc/iptables-script
# 保存和恢复的位置只要是两者一致就可以了，如果iptables-script没有则需要创建。
# 若想开机自动启用脚本，则可以使用以下命令放到系统初始化Shell脚本/etc/rc.d/rc.local中
# #echo '/sbin/iptables-restore /etc/iptables-script' >>/etc/rc.d/rc.local
# 但近日查看一些资料，发现规则保存的位置在/etc/sysconfig/iptables下，所以一些资料就有了
# 保存规则：#iptables-save >/etc/sysconfig/iptables
# 恢复规则：#iptables-restore>/etc/sysconfig/iptables
# 若想开机自动启用脚本，则可以使用以下命令放到系统初始化Shell脚本/etc/rc.d/rc.local中
# #echo '/sbin/iptables-restore /etc/sysconfig/iptables' >>/etc/rc.d/rc.local
# 此外还有一命令保存规则 #service iptables save，如下图：
# 规则自动保存到了/etc/sysconfig/iptables，用此命令保存的规则开机会自动生效，所以为了统一期间，建议以后规则的保存都保存在/etc/sysconfig/iptables下。