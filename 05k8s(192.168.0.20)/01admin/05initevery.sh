mkdir -p /common/
cd /common/

cat >/common/init.sh << EOF
#!/bin/bash

systemctl stop firewalld.service
systemctl disable firewalld.service

sed -i "s/=enforcing/=disabled/g" /etc/selinux/config
cat /etc/selinux/config
setenforce 0

chmod +x /etc/rc.d/rc.local
cat /etc/rc.local
#去掉alias
sed -i "s/alias/#alias/g" ~/.bashrc
cat ~/.bashrc

systemctl restart network
sysctl net.ipv4.ip_forward

#yum install wget -y
#yum install -y telnet nmap curl
#yum install unzip -y
#yum install traceroute -y
#yum install mtr -y

#reboot

EOF

echo -e "\033[32m ###########检测TEMPLATE_NODE_IP及TEMPLATE_NETWORK_NAME 是否替换 $TEMPLATE_NODE_IP $TEMPLATE_NETWORK_NAME########### \033[0m"
cat /common/init.sh
#echo `cat init.sh `
echo -e "\033[32m ###########内容显示完成########### \033[0m"
sleep 10