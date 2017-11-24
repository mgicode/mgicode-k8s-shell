#  Spring boot+docker 半自动化部署(六)、免密及初始化每一台机器

ssh的登录是一件很麻烦的事情，每一台机器都需要远程登录，输入密码。也可以手动在初始登录时做免密登录处理，这个还是手动人工的处理方式。本小节采用expect来减化该操作。使用网内的主机和管理机之间不需要录入密码，这个对于批量执行分配到各主机的指令是非常重用。

linux运维有很多方式，可以采用ansible,puppet或者使用python，这里主要使用原生的shell来实现。尽管shell的语法比较怪异，编写起不是十分方便，但是实现简单的运维操作（基于docker的几十台机器）还是最佳的选择方式。

## 初始管理机公钥/私钥对

安装 expect并在本地上生成公钥/私钥对，该公钥接下来通过ssh-copy-id发向每台需要免密的机器上

```
yum install  -y  expect
yum install epel-release -y
yum install ansible -y

#在本机下生成公钥/私钥对
ssh-keygen -t rsa -P ''
#Your identification has been saved in /root/.ssh/id_rsa.
#Your public key has been saved in /root/.ssh/id_rsa.pub.
# 8f:e1:96:6e:e3:71:c0:d1:1c:fd:e9:2b:78:46:4c:e1 root@manage.novalocal

```

## 免密执行脚本 
在管理机上创建/common/ssh.sh，把下面的代码复制到其中上。
初始化时只需要执行该文件带上创建即可。免密执行脚本分四步，先检测是否开机，等待开机，然后通过ssh-copy-id到需要免登录的机器，进行ssh免证登录处理。第三步就是对每台机器进行初始化操作，需要把初始化的相关脚本放在 /common/init.sh的文件中，如果初始化修改了其ip地址进行重启，这里再检测是否开机，确定其能免密访问。


```
NODE_IPS=$1
NODE_NAME=$2

#TEMPLATE_NODE_IP=10.1.12.251
TEMPLATE_NODE_PWD="123456" 
  
i=0
NAMES=(${NODE_NAME})

echo $NODE_IPS
for ip in $NODE_IPS ;do
    #去掉老的证书
    #ssh-keygen -R $TEMPLATE_NODE_IP
    #rm /root/.ssh/known_hosts.old
 
    NAME=${NAMES[$i]}
    echo "name:$NAME,ip:$ip  "
     #1、检测是否开机
    for  index1 in {1..255} ; do
       ping -c 1 -w 1 $ip &>/dev/null
       if [ $? -eq 0 ]; then
        echo "$index1 $ip开机,开始初始化$ip($NAME)... "
        break;
       else  
        echo "$index1 初始化为$ip($NAME)，模板机$ip还没有开机,请开机... "
        sleep 5;
      fi
    done
   echo "sleep: 10"
   sleep 10
   # 2、进行ssh免证登录,ssh-copy-id到需要免登录的机器上
   expect -c " 
    set timeout 5    
    spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@$ip
    expect {  
      "*yes/no" { send "yes\\r"; exp_continue}  
      "*INFO:" { exp_continue }
      "*ERROR:" { exp_continue }
      "*again" { send "$TEMPLATE_NODE_PWD\\r";  }      
      "*assword:" { send "$TEMPLATE_NODE_PWD\\r" }  
     }    
     expect eof  
     exit 
     #expect进程要退出，不然在循环中再次运行报错
  "  
   #该时间需要足够长，不然spawn执行的命令的伪线程还没有关闭，那么第二次就会connect refused!
   echo "sleep: 10"
   sleep 10 

   #3、对每台机器进行初始化操作。其操作在/common/init.sh中定义
   # 执行相关操作，这里主要改名，改ip并重启  
   scp /common/init.sh root@$ip:/root/init.sh
   #ssh -t -p $port $user@$ip "remote_cmd"  
   ssh root@$ip "chmod 777 /root/init.sh; cd /root/; ./init.sh; "
   let i++
      
  #4 检测是否$ip是否开机
  for  index1 in {1..20} ; do
      ping -c 1 -w 1 $ip &>/dev/null
      if [ $? -eq 0 ]; then
      echo "sleep: 40"
      sleep 40
      echo "$ip $NAME重启完成... "
          #初始化$IP认证提示
          expect -c "  
          set timeout 5   
          spawn ssh root@$ip ""
          expect {  
            "*yes/no" { send "yes\\r"; exp_continue}     
            "*assword:" { send "${TEMPLATE_NODE_PWD}\\r" } 
            "*ERROR:" { exp_continue }
            "*inet" { exp_continue }
            }  
          expect eof     
          exit 
          #expect进程要退出，不然在循环中再次运行报错
        "  
      #该时间需要足够长，不然spawn执行的命令的伪线程还没有关闭，那么第二次就会connect refused!
      echo "sleep: 20"
      
      sleep 20
      break;
      else  
      echo "$ip正在重启中... "
      sleep 15;
    fi
  done
   
done


```

## 初始化脚本

在/common/init.sh文件创建初始化相关功能，初始化管理机基本上相似

```
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

yum install wget -y
yum install -y telnet nmap curl
yum install unzip -y
yum install traceroute -y
yum install mtr -y

reboot

EOF

echo -e "\033[32m ###########检测TEMPLATE_NODE_IP及TEMPLATE_NETWORK_NAME 是否替换 $TEMPLATE_NODE_IP $TEMPLATE_NETWORK_NAME########### \033[0m"
cat /common/init.sh
#echo `cat init.sh `
echo -e "\033[32m ###########内容显示完成########### \033[0m"
sleep 10


```


## 执行初始化
指定ip和名称列表，调用/common/ssh.sh，就可以执行指定ip机器的初始化工作。

```
NODE_IPS="192.168.0.2  192.168.0.5 192.168.0.6  192.168.0.7  192.168.0.8  192.168.0.9  192.168.0.10  192.168.0.11 192.168.0.12   192.168.0.13  192.168.0.14   192.168.0.15   192.168.0.16 192.168.0.17  192.168.0.18    192.168.0.19"
NODE_NAME="ms02 ms05 ms06  ms07   ms08   ms09  ms10   ms11  ms12  ms13  ms14  ms15  ms16  ms17   ms18 ms19"
/common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"

``` 

## 每台机器安装Docker

为每一台机器安装脚本

```
 # 安装docker的脚本
 Script="   
    cd /dockerWorking/
    wget http://192.168.0.20/docker/docker-17.06.2-ce.tgz  -q
    tar -xvf docker-17.06.2-ce.tgz
    mkdir  -p /usr/local/bin/
    cp -rf /dockerWorking/docker/docker*  /usr/local/bin/
    chmod 777 /usr/local/bin/*
   
     iptables -F &&  iptables -X &&  iptables -F -t nat &&  iptables -X -t nat

     systemctl daemon-reload
     systemctl enable docker
     systemctl start docker
     systemctl status docker
    sleep 3
  "


for ip in $NODE_IPS ;do
      echo "初始化$ip docker..."
      ssh root@$ip " mkdir -p /dockerWorking/; mkdir -p /etc/docker/; " 
      scp /docker/docker.service   root@$ip:/etc/systemd/system/docker.service
      scp /etc/docker/daemon.json  root@$ip:/etc/docker/daemon.json
      ssh root@$ip "$Script"
      sleep 5
done


```

