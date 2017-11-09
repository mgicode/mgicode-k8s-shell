# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#  #admin 10.1.11.110  （所有的脚本都在其上运行，
#通过它控制k8s，生成ssh 免密证书，发给所有MASTER、NODE节点，
#可以在虚拟机模板中做好，（最好加上当前自己机器的证书）

#生成ssh证书，把ssh的证书发向到每一台机器上去
#http://www.jb51.net/article/62349.htm
#http://www.cnblogs.com/lzrabbit/p/4298794.html

#FILE_SERVER_IP="10.1.12.200"


yum install  -y  expect
yum install epel-release -y
yum install ansible -y

#在机下生成公钥/私钥对
ssh-keygen -t rsa -P ''
#Your identification has been saved in /root/.ssh/id_rsa.
#Your public key has been saved in /root/.ssh/id_rsa.pub.
# SHA256:IKSZURzP9OhvVocrJ7wCXzeNNcSwxIQPzI5NGJKQyy8 root@k8sadmin

############################################3
#生成k8s ssh的证书
cd /usr/local/bin/
wget http://${FILE_SERVER_IP}/cfssl
wget http://${FILE_SERVER_IP}/cfssljson
wget http://${FILE_SERVER_IP}/cfssl-certinfo
chmod  +x *

ls cfssl*
sleep 5

#export PATH=/usr/local/bin:$PATH


mkdir /ssl/
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

echo -e "检测是否生成：\033[32m /ssl/ca-config.json，/ssl/ca-csr.json \033[0m"
ls /ssl/*.json 
sleep 2

cfssl gencert -initca /ssl/ca-csr.json | cfssljson -bare ca

echo -e "检测是否生成：\033[32m ca-config.json  ca.csr  ca-csr.json  ca-key.pem  ca.pem \033[0m"
ls ca*
mkdir /sslcp/
cp /ssl/* /sslcp/
sleep 5




# echo -e "\033[30m 黑色字 \033[0m"
# echo -e "\033[31m 红色字 \033[0m"
# echo -e "\033[32m 绿色字 \033[0m"
# echo -e "\033[33m 黄色字 \033[0m"
# echo -e "\033[34m 蓝色字 \033[0m"
# echo -e "\033[35m 紫色字 \033[0m"
# echo -e "\033[36m 天蓝字 \033[0m"
# echo -e "\033[37m 白色字 \033[0m"
 

# echo -e "\033[40;37m 黑底白字 \033[0m"
# echo -e "\033[41;37m 红底白字 \033[0m"
# echo -e "\033[42;37m 绿底白字 \033[0m"
# echo -e "\033[43;37m 黄底白字 \033[0m"
# echo -e "\033[44;37m 蓝底白字 \033[0m"
# echo -e "\033[45;37m 紫底白字 \033[0m"
# echo -e "\033[46;37m 天蓝底白字 \033[0m"
# echo -e "\033[47;30m 白底黑字 \033[0m"




 


