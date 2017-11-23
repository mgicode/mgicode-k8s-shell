# author:pengrk
# email:546711211@qq.com
# qq group:573283836

yum install wget -y
yum install -y telnet nmap curl tcping
yum install unzip -y
yum install traceroute -y
yum install mtr -y

systemctl stop firewalld.service
systemctl disable firewalld.service

#关掉selinux enforcing：强制模式 permissive：宽容模式 disabled：关闭
sed -i "s/=enforcing/=disabled/g" /etc/selinux/config
cat /etc/selinux/config
setenforce 0

#关掉大页内存
cat >/etc/rc.local << EOF
#!/bin/bash
touch /var/lock/subsys/local
echo never >/sys/kernel/mm/transparent_hugepage/enabled
echo never >/sys/kernel/mm/transparent_hugepage/defrag
EOF
chmod +x /etc/rc.d/rc.local
cat /etc/rc.local

#去掉alias
sed -i "s/alias/#alias/g" ~/.bashrc
cat ~/.bashrc

#WARNING: IPv4 forwarding is disabled. Networking will not work.
cat  >/etc/sysctl.conf <<EOF
net.ipv4.ip_forward=1
EOF
systemctl restart network
#查看
sysctl net.ipv4.ip_forward











