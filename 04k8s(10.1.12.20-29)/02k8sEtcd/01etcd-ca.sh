# author:pengrk
# email:546711211@qq.com
# qq group:573283836

# NODE_MASTER_IPS="10.1.12.21  10.1.11.122 "
# NODE_MASTER_NAMES="master01 master02 "

# NODE_ETCD_IPS="10.1.12.21  10.1.11.122"
# NODE_ETCD_NAMES="master02  master02"

####################2 生成和初始化etcd的证书和客户端证书####################
cd /ssl/

ETCD_MASTER_CSR_IPS=""
i=0
for ip in $NODE_MASTER_IPS ;do 
   if [ $i -eq 0 ]; then
 	  ETCD_MASTER_CSR_IPS="\"$ip\""
   else
 	  ETCD_MASTER_CSR_IPS="$ETCD_MASTER_CSR_IPS,\"$ip\""
   fi
   let i++
done
echo $ETCD_MASTER_CSR_IPS
echo -e "\033[32m ###ETCD_MASTER_CSR_IPS:$ETCD_MASTER_CSR_IPS###### \033[0m"

ETCD_ETCD_CSR_IPS=""
i=0
for ip in $NODE_ETCD_IPS ;do 
   if [ $i -eq 0 ]; then
 	  ETCD_ETCD_CSR_IPS="\"$ip\""
   else
 	  ETCD_ETCD_CSR_IPS="$ETCD_ETCD_CSR_IPS,\"$ip\""
   fi
   let i++
done
echo $ETCD_ETCD_CSR_IPS
echo -e "\033[32m #####ETCD_ETCD_CSR_IPS:$ETCD_ETCD_CSR_IPS######## \033[0m"
rm /ssl/etcd*

cat > /ssl/etcd-csr.json <<EOF
{
  "CN" : "etcd",
  "hosts" : [
    "127.0.0.1",
    "$NODE_ADMIN_IP",
    $ETCD_MASTER_CSR_IPS,
    $ETCD_ETCD_CSR_IPS
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
echo -e "\033[32m ###########请检测########### \033[0m"
cat  /ssl/etcd-csr.json 
echo -e "\033[32m ###########内容显示完成########### \033[0m"
sleep 5


cfssl gencert -ca=/ssl/ca.pem  -ca-key=/ssl/ca-key.pem  -config=/ssl/ca-config.json \
  -profile=kubernetes etcd-csr.json | cfssljson -bare etcd
ls etcd*
#cfssl-certinfo -cert etcd.pem
echo -e "\033[32m ###########请检测etcd.csr  etcd-csr.json  etcd-key.pem  etcd.pem ########### \033[0m"
ls etcd*
echo -e "\033[32m ###########内容显示完成########### \033[0m"
sleep 10



rm /ssl/etcdctl*
cat > /ssl/etcdctl-csr.json <<EOF
{
  "CN": "etcdctl",
  "hosts": [""],
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

echo -e "\033[32m ###########请检测/ssl/etcdctl-csr.json内容########### \033[0m"
cat  /ssl/etcdctl-csr.json
echo -e "\033[32m ###########内容显示完成########### \033[0m"
sleep 5


cfssl gencert -ca=/ssl/ca.pem  -ca-key=/ssl/ca-key.pem  -config=/ssl/ca-config.json \
  -profile=kubernetes  /ssl/etcdctl-csr.json | cfssljson -bare etcdctl
ls /ssl/etcdctl*
#cfssl-certinfo -cert etcdctl.pem


echo -e "\033[32m ###########请检测etcdctl.csr  etcdctl-csr.json  etcdctl-key.pem  etcdctl.pem ########### \033[0m"
ls /ssl/etcdctl*
echo -e "\033[32m ###########内容显示完成########### \033[0m"
sleep 10


#备份
mkdir /sslEtcd/
cp /ssl/* /sslEtcd/
ls /sslEtcd/

#http://www.cnblogs.com/Tempted/p/7737361.html

# openssl x509 -in ca.pem -text -noout
# openssl x509 -in server.pem -text -noout
# openssl x509 -in client.pem -text -noout


 