# author:pengrk
# email:546711211@qq.com
# qq group:573283836


#建立第一台模板 10.1.11.117（selinux取消，安装基本docker)

#修改计算机名和ip地址
sed -i "s/10.1.11.70/10.1.11.117/g" /etc/sysconfig/network-scripts/ifcfg-ens160
hostnamectl set-hostname t117
systemctl restart systemd-hostnamed
systemctl stop firewalld.service
systemctl disable firewalld.service
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
reboot
###############################


#docker的安装
wget http://10.1.11.20/docker-17.04.0-ce.tgz
tar -xvf docker-17.04.0-ce.tgz
mkdir /usr/local/bin/
cp -rf docker/docker* /usr/local/bin/
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
 mkdir -p /etc/docker/
 cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors": ["http://2f02dbc7.m.daocloud.io", "https://docker.mirrors.ustc.edu.cn", "hub-mirror.c.163.com"],
  "max-concurrent-downloads": 10,
  "insecure-registries":["10.1.11.111","10.1.11.60:5000"] 
}
EOF
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
