# author:pengrk
# email:546711211@qq.com
# qq group:573283836

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


cat > /ssl/kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "hosts": [
    "127.0.0.1",
     ${ETCD_MASTER_CSR_IPS},  
    "${CLUSTER_DNS_SVC_IP}",
    "${CLUSTER_KUBERNETES_SVC_IP}",
    "k8s",
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster",
    "kubernetes.default.svc.cluster.local"
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

echo -e "\033[32m ###############生成########### \033[0m"
cat /ssl/kubernetes-csr.json
echo -e "\033[32m ###########内容显示完成########### \033[0m"


cfssl gencert -ca=/ssl/ca.pem -ca-key=/ssl/ca-key.pem -config=/ssl/ca-config.json  \
-profile=kubernetes /ssl/kubernetes-csr.json | cfssljson -bare kubernetes

echo -e "\033[32m ###############生成kubernetes.pem kubernetes-key.pem kubernetes.csr########### \033[0m"
ls /ssl/kubernetes*
echo -e "\033[32m ###########内容显示完成########### \033[0m"
