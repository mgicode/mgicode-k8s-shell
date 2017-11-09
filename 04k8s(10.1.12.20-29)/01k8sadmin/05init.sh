# author:pengrk
# email:546711211@qq.com
# qq group:573283836
#通用的使用ip和主机名

mkdir -p /common/
cd /common/
#TEMPLATE_NODE_IP=10.1.12.251
#TEMPLATE_NETWORK_NAME=ifcfg-ens160

cat >/common/init.sh << EOF
#!/bin/bash
#REP_IP="\${3:-${TEMPLATE_NODE_IP}}"
#ENS_NAME="\${4:-ifcfg-ens160}"
#修改计算机名和ip地址
sed -i "s/\$3/\$1/g" /etc/sysconfig/network-scripts/\$4
hostnamectl set-hostname \$2
systemctl restart systemd-hostnamed
systemctl stop firewalld.service
systemctl disable firewalld.service
cat /etc/sysconfig/network-scripts/\$4
sed -i "s/=enforcing/=disabled/g" /etc/selinux/config
cat /etc/selinux/config
setenforce 0

chmod +x /etc/rc.d/rc.local
cat /etc/rc.local
sed -i "s/alias/#alias/g" ~/.bashrc
#去掉alias
sed -i "s/alias/#alias/g" ~/.bashrc
cat ~/.bashrc
reboot
EOF

echo -e "\033[32m ###########检测TEMPLATE_NODE_IP及TEMPLATE_NETWORK_NAME 是否替换 $TEMPLATE_NODE_IP $TEMPLATE_NETWORK_NAME########### \033[0m"
cat init.sh
#echo `cat init.sh `
echo -e "\033[32m ###########内容显示完成########### \033[0m"
sleep 10