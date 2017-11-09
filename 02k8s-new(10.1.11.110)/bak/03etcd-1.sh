# author:pengrk
# email:546711211@qq.com
# qq group:573283836


#三台ETCD  10.1.11.120   10.1.11.121  10.1.11.122 (先采用物理机的方式安装，之后采用容器实现）

NODE_IPS="10.1.11.120  10.1.11.121  10.1.11.122"
NODE_NAME="ectd-01  etcd-02  etcd-03"
TEMPLATE_NODE_IP=10.1.11.117
password="root@123" 

#生成证书时使用
NODE1_IP="10.1.11.120"
NODE2_IP="10.1.11.121"
NODE3_IP="10.1.11.122"

####################1、初始化etcd机器，免证登录，改名，改ip并重启####################

####################1.1、创建etcd机器中的初始化文件####################
mkdir -p /etcd/
cd /etcd/
cat >init.sh << EOF
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


####################1.2、初始化etcd机器，免证登录，改名，改ip并重启##########
  
i=0
NAMES=(${NODE_NAME})

for ip in $NODE_IPS ;do
    #去掉老的证书
    ssh-keygen -R $TEMPLATE_NODE_IP
    rm /root/.ssh/known_hosts.old
 
    NAME=${NAMES[$i]}
    echo "$NAME  $ip  "
     #检测是否开机
    for  index1 in {1..255} ; do
       ping -c 1 -w 1 $TEMPLATE_NODE_IP &>/dev/null
       if [ $? -eq 0 ]; then
        echo "$index1 $TEMPLATE_NODE_IP开机,开始初始化$ip $NAME... "
        break;
       else  
        echo "$index1 初始化$TEMPLATE_NODE_IP为$ip $NAME，$TEMPLATE_NODE_IP还没有开机,请开机... "
        sleep 5;
      fi
    done
   sleep 60 
   # 进行ssh免证登录,如果在本机中已经有117的记录
   expect -c " 
    set timeout 5    
    spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@$TEMPLATE_NODE_IP
    expect {  
      "*yes/no" { send "yes\\r"; exp_continue}  
      "*INFO:" { exp_continue }
      "*ERROR:" { exp_continue }
      "*again" { send "$password\\r";  }      
      "*assword:" { send "$password\\r" }  
     }    
     expect eof  
     exit 
     #expect进程要退出，不然在循环中再次运行报错
  "  
   #该时间需要足够长，不然spawn执行的命令的伪线程还没有关闭，那么第二次就会connect refused!
   sleep 60 
   #执行相关操作，这里主要改名，改ip并重启  
   scp /etcd/init.sh  root@$TEMPLATE_NODE_IP:/root/init.sh
   #ssh -t -p $port $user@$ip "remote_cmd"  
   ssh root@$TEMPLATE_NODE_IP "chmod 777 /root/init.sh; cd /root/; ./init.sh $ip $NAME $TEMPLATE_NODE_IP ifcfg-ens160; "
   let i++
      
    #检测是否$ip是否开机
    for  index1 in {1..20} ; do
       ping -c 1 -w 1 $ip &>/dev/null
       if [ $? -eq 0 ]; then
        echo "$ip $NAME重启完成... "
           #初始化$IP认证提示
           expect -c "  
            set timeout 5   
            spawn ssh root@$ip "ifconfig"
            expect {  
              "*yes/no" { send "yes\\r"; exp_continue}     
              "*assword:" { send "$password\\r" } 
             }  
            expect eof     
            exit 
            #expect进程要退出，不然在循环中再次运行报错
          "  
        #该时间需要足够长，不然spawn执行的命令的伪线程还没有关闭，那么第二次就会connect refused!
        sleep 60
        break;
       else  
        echo "$ip正在重启中... "
        sleep 15;
      fi
    done
   
done




####################2 生成和初始化etcd的证书和客户端证书####################
cd /ssl/
cat > /ssl/etcd-csr.json <<EOF
{
  "CN": "etcd",
  "hosts": [
    "127.0.0.1",
    "$NODE1_IP",
    "$NODE2_IP",  
    "$NODE3_IP"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "BeiJing",
      "L": "BeiJing",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF

cfssl gencert -ca=/ssl/ca.pem  -ca-key=/ssl/ca-key.pem  -config=/ssl/ca-config.json \
  -profile=kubernetes etcd-csr.json | cfssljson -bare etcd
ls etcd*
#cfssl-certinfo -cert etcd.pem

cat > /ssl/etcdctl-csr.json <<EOF
{
  "CN": "etcctl",
  "hosts": [
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "BeiJing",
      "L": "BeiJing",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF

cfssl gencert -ca=/ssl/ca.pem  -ca-key=/ssl/ca-key.pem  -config=/ssl/ca-config.json \
  -profile=kubernetes  /ssl/etcdctl-csr.json | cfssljson -bare etcdctl
ls etcdctl*
#cfssl-certinfo -cert etcdctl.pem


##################3、生成ectd的安装并进行安装#########################

# 3.1环境变量放在/etc/etcd/etcdEnv,证书放在/etc/etcd/ssl/
cd /etcd/
cat > /etcd/etcd.service <<EOF
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
Documentation=https://github.com/coreos

[Service]
EnvironmentFile=/etc/etcd/etcdEnv
Type=notify
WorkingDirectory=/var/lib/etcd/
ExecStart=/usr/local/bin/etcd \\
  --name=\${NODE_NAME} \\
  --cert-file=/etc/etcd/ssl/etcd.pem \\
  --key-file=/etc/etcd/ssl/etcd-key.pem \\
  --peer-cert-file=/etc/etcd/ssl/etcd.pem \\
  --peer-key-file=/etc/etcd/ssl/etcd-key.pem \\
  --trusted-ca-file=/etc/etcd/ssl/ca.pem \\
  --peer-trusted-ca-file=/etc/etcd/ssl/ca.pem \\
  --initial-advertise-peer-urls=https://\${NODE_IP}:2380 \\
  --listen-peer-urls=https://\${NODE_IP}:2380 \\
  --listen-client-urls=https://\${NODE_IP}:2379,http://127.0.0.1:2379 \\
  --advertise-client-urls=https://\${NODE_IP}:2379 \\
  --initial-cluster-token=etcd-cluster-5\\
  --initial-cluster=\${ETCD_NODES} \\
   --initial-cluster-state=new \\
  --data-dir=/var/lib/etcd 
  
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF
cat /etcd/etcd.service


#3.2生成三个环境变量文件 
#ETCD_NODES="ectd-01=https://10.1.11.120:2380,etcd-02=https://10.1.11.121:2380,etcd-03=https://10.1.11.122:2380"
ETCD_NODES=""
i=0
NAMES=(${NODE_NAME})
for ip in $NODE_IPS ;do
   NAME=${NAMES[$i]}
   if [ $i -eq 0 ]; then
 	  ETCD_NODES="$NAME=https://$ip:2380"
   else
 	  ETCD_NODES="$ETCD_NODES,$NAME=https://$ip:2380"
   fi
   let i++
done
echo $ETCD_NODES

#生成三个环境变量文件 
i=0
NAMES=(${NODE_NAME})
for ip in $NODE_IPS ;do
   NAME=${NAMES[$i]} 
cat > /etcd/etcdEnv$i <<EOF
NODE_NAME="${NAME}"
NODE_IP="${ip}"
ETCD_NODES="${ETCD_NODES}"
EOF
   cat /etcd/etcdEnv$i
   sleep 10
   let i++
done;


#3.3 创建安装的shell
cat > /etcd/install.sh <<EOF
mkdir -p /working/
cd /working/
wget http://10.1.11.20/etcd-v3.1.6-linux-amd64.tar.gz
tar -xvf etcd-v3.1.6-linux-amd64.tar.gz
mv etcd-v3.1.6-linux-amd64/etcd* /usr/local/bin/

systemctl daemon-reload
systemctl enable etcd
systemctl start etcd
systemctl status etcd 

#方便etcdctl的使用 etcdctl member list
echo "export ETCDCTL_CERT_FILE=/ssl/etcdctl.pem" >> /etc/profile
echo "export ETCDCTL_KEY_FILE=/ssl/etcdctl-key.pem" >> /etc/profile
echo "export ETCDCTL_CA_FILE=/ssl/ca.pem" >> /etc/profile
source /etc/profile

#etcdctl member list
EOF
cat /etcd/install.sh
sleep 10;

#3.3 把相关文件发送到etcd机器上，并建立集群
i=0;
for ip in $NODE_IPS ;do
 
 ssh root@$ip "mkdir -p /var/lib/etcd/；mkdir -p /etc/etcd/ssl/;mkdir -p /working/"
 scp /etcd/etcdEnv$i  root@$ip:/etc/etcd/etcdEnv 
 scp /etcd/etcd.service   root@$ip:/etc/systemd/system/etcd.service
 scp /etcd/install.sh  root@$ip:/etc/etcd/install.sh

 scp /ssl/etcd.pem   root@$ip:/etc/etcd/ssl/etcd.pem
 scp /ssl/etcd-key.pem   root@$ip:/etc/etcd/ssl/etcd-key.pem
 scp /ssl/ca.pem   root@$ip:/etc/etcd/ssl/ca.pem

 ssh root@$ip "chmod 777 /etc/etcd/install.sh; /etc/etcd/install.sh"
 sleep 10
 let i++;
done


#################4 本机安装etcd客户端##################
sleep 10
cat /etcd/
wget http://10.1.11.20/etcd-v3.1.6-linux-amd64.tar.gz
tar -xvf etcd-v3.1.6-linux-amd64.tar.gz
mv etcd-v3.1.6-linux-amd64/etcd* /usr/local/bin/

echo "export ETCDCTL_CERT_FILE=/ssl/etcdctl.pem" >> /etc/profile
echo "export ETCDCTL_KEY_FILE=/ssl/etcdctl-key.pem" >> /etc/profile
echo "export ETCDCTL_CA_FILE=/ssl/ca.pem" >> /etc/profile
source /etc/profile

etcdctl --endpoints=https://10.1.11.120:2379 member list

 #export ETCDCTL_CERT_FILE=/etc/etcd/ssl/etcd.pem
 #export ETCDCTL_KEY_FILE=//etc/etcd/ssl/etcd-key.pem
 #export ETCDCTL_CA_FILE=/etc/etcd/ssl/ca.pem
 #etcdctl --endpoints=https://10.1.11.120:2379 member list




