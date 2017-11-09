# author:pengrk
# email:546711211@qq.com
# qq group:573283836


#  #admin 10.1.11.110  （所有的脚本都在其上运行，
#通过它控制k8s，生成ssh 免密证书，发给所有MASTER、NODE节点，
#可以在虚拟机模板中做好，（最好加上当前自己机器的证书）


#修改计算机名和ip地址
sed -i "s/10.1.11.117/10.1.11.110/g" /etc/sysconfig/network-scripts/ifcfg-ens160
hostnamectl set-hostname admin110
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


#生成ssh证书，把ssh的证书发向到每一台机器上去
#http://www.jb51.net/article/62349.htm
#http://www.cnblogs.com/lzrabbit/p/4298794.html

yum install  -y  expect

yum install epel-release
yum install ansible -y

#在机下生成公钥/私钥对
ssh-keygen -t rsa -P ''


############################################3
#生成k8s ssh的证书
mkdir /ssl/ 
cd /ssl/
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
chmod +x cfssl_linux-amd64
sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl

wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x cfssljson_linux-amd64
sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson

wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
chmod +x cfssl-certinfo_linux-amd64
sudo mv cfssl-certinfo_linux-amd64 /usr/local/bin/cfssl-certinfo

export PATH=/usr/local/bin:$PATH
#cfssl print-defaults config > config.json
#cfssl print-defaults csr > csr.json



cd /ssl/

cat  >/ssl/ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "108760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ],
        "expiry": "108760h"
      }
    }
  }
}

EOF

cat  >/ssl/ca-csr.json<<EOF
{
  "CN": "kubernetes",
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

cfssl gencert -initca /ssl/ca-csr.json | cfssljson -bare ca

ls ca*





 


