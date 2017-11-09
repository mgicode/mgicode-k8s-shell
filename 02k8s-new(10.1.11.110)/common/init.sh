# author:pengrk
# email:546711211@qq.com
# qq group:573283836


####################1.1、创建etcd机器中的初始化文件####################
mkdir -p /common/
cd /common/
cat >/common/init.sh << EOF
#!/bin/bash
#REP_IP="\${3:-10.1.11.117}"
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

cat init.sh