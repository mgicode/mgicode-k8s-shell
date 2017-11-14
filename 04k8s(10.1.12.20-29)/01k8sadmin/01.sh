# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#初始化管理机 （ip:192.168.12.20）

# 1、先下载http://isoredirect.centos.org/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1611.iso
# 2、安装操作系统
      
# 3、编辑ip地址

# vi /etc/sysconfig/network-scripts/ifcfg-[tab两下]
# BOOTPROTO=static #dhcp改为static（修改）
# ONBOOT=yes #开机启用本配置，一般在最后一行（修改）

# IPADDR=192.168.1.20 #静态IP（增加）
# GATEWAY=192.168.1.2 #默认网关，虚拟机安装的话，通常是2，也就是VMnet8的网关设置（增加）
# NETMASK=255.255.255.0 #子网掩码（增加）
# DNS1=180.168.255.118 #DNS 配置，虚拟机安装的话，DNS就网关就行，多个DNS网址的话再增加（增加）

#service network restart
#ip addr

# 4、初始化环境

#sed -i "s/10.1.11.251/10.1.11.204/g" /etc/sysconfig/network-scripts/ifcfg-ens160

yum install wget -y
yum install -y telnet nmap curl
yum install unzip -y
yum install traceroute -y
yum install mtr -y



hostnamectl set-hostname k8sadmin
systemctl restart systemd-hostnamed
systemctl stop firewalld.service
systemctl disable firewalld.service
#w网卡不一样需要修改
cat /etc/sysconfig/network-scripts/ifcfg-ens160
sed -i "s/=enforcing/=disabled/g" /etc/selinux/config
cat /etc/selinux/config
setenforce 0
cat >/etc/rc.local << EOF
#!/bin/bash
touch /var/lock/subsys/local
echo never >/sys/kernel/mm/transparent_hugepage/enabled
echo never >/sys/kernel/mm/transparent_hugepage/defrag
EOF
chmod +x /etc/rc.d/rc.local
cat /etc/rc.local
sed -i "s/alias/#alias/g" ~/.bashrc
#去掉alias
sed -i "s/alias/#alias/g" ~/.bashrc
cat ~/.bashrc

#WARNING: IPv4 forwarding is disabled. Networking will not work.
cat  >/etc/sysctl.conf <<EOF
net.ipv4.ip_forward=1
EOF
systemctl restart network
sysctl net.ipv4.ip_forward

reboot

#source /etc/profile

# 5、把下载的好的docker放在上面并安装docker
mkdir /root/docker/
cd /root/docker/
#wget https://download.docker.com/linux/static/stable/x86_64/docker-17.06.2-ce.tgz
#wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-17.06.2.ce-1.el7.centos.x86_64.rpm
tar -xvf docker-17.06.2-ce.tgz
mkdir /usr/local/bin/
cp -rf docker/docker* /usr/local/bin/
#这行没有作用
cp -rf docker/completion/bash/docker /etc/bash_completion.d/
cat > docker.service << EOF
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.io
[Service]
Environment="PATH=/root/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin"
EnvironmentFile=-/run/flannel/docker
ExecStart=/usr/local/bin/dockerd --log-level=error \$DOCKER_NETWORK_OPTIONS
ExecReload=/bin/kill -s HUP \$MAINPID
Restart=on-failure
RestartSec=5
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
Delegate=yes
KillMode=process
[Install]
WantedBy=multi-user.target
EOF
 sudo iptables -P FORWARD ACCEPT
 cat  docker.service

 mkdir -p /etc/docker/
 cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors": ["http://2f02dbc7.m.daocloud.io", "https://docker.mirrors.ustc.edu.cn", "hub-mirror.c.163.com"],
  "max-concurrent-downloads": 10,
  "insecure-registries":["10.1.12.61:5000","10.1.11.60:5000"] 
}
EOF

cat /etc/docker/daemon.json


cp -rf docker.service /etc/systemd/system/docker.service
sudo systemctl daemon-reload
 sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo iptables -F && sudo iptables -X && sudo iptables -F -t nat && sudo iptables -X -t nat
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker
#docker version

docker pull registry.cn-hangzhou.aliyuncs.com/kube_containers/pause-amd64:3.0
docker tag registry.cn-hangzhou.aliyuncs.com/kube_containers/pause-amd64:3.0 gcr.io/google_containers/pause-amd64:3.0
docker rmi registry.cn-hangzhou.aliyuncs.com/kube_containers/pause-amd64:3.0


#6、把ip修改为10.1.12.129  克隆为模板
sed -i "s/10.1.12.20/10.1.12.129 /g" /etc/sysconfig/network-scripts/ifcfg-ens160
#service network restart
reboot

#7 把ip修改过来
sed -i "s/10.1.12.129/10.1.12.20/g" /etc/sysconfig/network-scripts/ifcfg-ens160
#service network restart
reboot
ip addr

#8 在k8sadmin 搭建一个静态文件Web服务，方便下载

#curl 10.1.12.61:5000/v2/_catalog
#docker pull 10.1.12.61:5000/nginx:1.7.9

mkdir /www
#把相关的文件放到宿主机的/www中，即可直接访问
docker run -d -v  /www:/usr/share/nginx/html --restart=always \
  --name nginx-server -p 80:80  10.1.12.61:5000/nginx:1.7.9 
  #put aa.txt into /www

  curl http://10.1.12.20/aa.txt

#9 把需要的文件放到/www上去








