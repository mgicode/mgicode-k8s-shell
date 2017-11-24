#  Spring boot+docker 半自动化部署(五)、管理机的安装

管理机对于部署人员来讲是非常重要，是网络集群部署的中枢神经，通过它来联系和管理网络集群中的所有机器，发向指令，安装软件等等。它的权限也是众多，一般只能通过管理机登录到其它的机器上去。其它所有的机器的端口（除负载均衡）都不对外开放。

## 初始化环境 

初始化环境需要安装常用的网络调试及使用工具，关掉防火墙，关于大页内存，也可以有选择关掉。

centos 7 别名了rm等相关指令，删除前需要手动确定，这个对于命令执行很不方便，所以要去掉alias

IPv4 forwarding需要打开，走ipv4的网络不通，特别是keepalive+haproxy做负载均衡或代理时,不打开这样，网络通不过。

```
#安装网络及常用工具
yum install wget -y
yum install -y telnet nmap curl tcping
yum install unzip -y
yum install traceroute -y
yum install mtr -y

#关掉防火墙
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

```

## 安装Docker 
docker是容器安装的基础环境，这个需要先决条件。必须要求


###  下载解压
因为管理机会管理所有机器的安装，对于每一种安装，要分门别类建立目录，把相关的文件存放在对应的目录中

```
# 把下载的好的docker放在上面并安装docker
mkdir /docker/
cd   /docker/
wget https://download.docker.com/linux/static/stable/x86_64/docker-17.06.2-ce.tgz
tar -xvf docker-17.06.2-ce.tgz
mkdir /usr/local/bin/
cp -rf docker/docker* /usr/local/bin/

```

### 创建service文件 

centos7已经默认支持systemd的方式，安装docker采用service安装最佳的方式

```
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

```

### 加速镜像

中国地区下载docker官方很慢，需要加速，需要配置加速镜像，一般现在使用aliyun加速。
另外内网中访问则采用http的方式，docker register 默认采用了https，需要作
http的 insecure-registries的配置

```
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

```
### 启动服务

```
sudo iptables -F && sudo iptables -X && sudo iptables -F -t nat && sudo iptables -X -t nat

sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker

#测试能够下载文件 
docker pull registry.cn-hangzhou.aliyuncs.com/kube_containers/pause-amd64:3.0
docker tag registry.cn-hangzhou.aliyuncs.com/kube_containers/pause-amd64:3.0 gcr.io/google_containers/pause-amd64:3.0
docker rmi registry.cn-hangzhou.aliyuncs.com/kube_containers/pause-amd64:3.0

```

## 安装文件服务器
文件服务器主要为了安装过程使用的内部文件下载的服务器，可以采用tomcat、Apache,这样小型的文件服务采用docker的 nginx安装是最方便的。
首先需要在本地建立一个文件夹，把需要的文件放到该文件夹中，然后wget就可以通过http在内部中下载使用，
该文件服务器是安装过程所必须的，如果没有话，批量安装从外网下（能下的话）非常慢。


```
mkdir -p  /www/
#把相关的文件放到宿主机的/www中，即可直接访问
docker run -d -v  /www:/usr/share/nginx/html --restart=always \
  --name nginx-server -p 80:80  nginx:1.7.9 

  #把docker文件放到文件服务器上去，然后就可以下载
  mkdir  -p /www/docker/
  cp /docker/docker-17.06.2-ce.tgz  /www/docker/docker-17.06.2-ce.tgz
  #本地测试能不能下载
  wget http://192.168.0.20/docker/docker-17.06.2-ce.tgz

接下来就要把自己需要的文件都分门别类地放到/www目录中即可，不用重启nginx

```

## 安装docker镜像库

无论是开发还是生产，无论是高大上还是简单的部署方式，内部镜像库是必不可少，不要被忽悠上传到阿里云，安全不讲，再快的速度也没有内网快和稳定。安装非高可用的docker镜像库与安装文件服务器一样简单。


```
mkdir -p /my_regisitry/
docker run -d -p 5000:5000 --restart=always --name registryV2   \
 -v /my_regisitry:/var/lib/registry  registry:2

```

镜像文件会映射到/my_regisitry/目录中，可以查看。另外这里最好加--restart=always，有时候服务器重启之后，这个不重启，其访问不了镜像，这个在k8s中特别明显，如果该服务死了，所有的k8s重启时都拉不到镜像，出错一大片，如果应用高可用，这个还是需要做成高可用的。





