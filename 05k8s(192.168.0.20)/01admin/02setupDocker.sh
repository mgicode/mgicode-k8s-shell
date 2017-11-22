
# 把下载的好的docker放在上面并安装docker
mkdir /docker/
cd   /docker/
wget https://download.docker.com/linux/static/stable/x86_64/docker-17.06.2-ce.tgz
tar -xvf docker-17.06.2-ce.tgz
mkdir /usr/local/bin/
cp -rf docker/docker* /usr/local/bin/

cat > /docker/docker.service << EOF
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
cat  /docker/docker.service


#加速镜像
 mkdir -p /etc/docker/
 cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors": ["https://ap1xf0lr.mirror.aliyuncs.com","http://2f02dbc7.m.daocloud.io", "https://docker.mirrors.ustc.edu.cn", "hub-mirror.c.163.com"],
  "max-concurrent-downloads": 10,
  "insecure-registries":["192.168.0.20:5000","10.1.12.61:5000","10.1.11.60:5000"] 
}
EOF

cat /etc/docker/daemon.json

cp -rf /docker/docker.service /etc/systemd/system/docker.service



sudo iptables -F && sudo iptables -X && sudo iptables -F -t nat && sudo iptables -X -t nat

sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker
#docker version

#测试能够下载文件 
docker pull registry.cn-hangzhou.aliyuncs.com/kube_containers/pause-amd64:3.0
docker tag registry.cn-hangzhou.aliyuncs.com/kube_containers/pause-amd64:3.0 gcr.io/google_containers/pause-amd64:3.0
docker rmi registry.cn-hangzhou.aliyuncs.com/kube_containers/pause-amd64:3.0

