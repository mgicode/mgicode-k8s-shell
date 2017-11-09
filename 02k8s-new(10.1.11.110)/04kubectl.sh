# author:pengrk
# email:546711211@qq.com
# qq group:573283836


#1、管理机110中安装，初始时只有110给定某一台的证书，之后全都换成HA-VIP的证书

cd /ssl/
cat > admin-csr.json << EOF
{
  "CN": "admin",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "BeiJing",
      "L": "BeiJing",
      "O": "system:masters",
      "OU": "System"
    }
  ]
}
EOF

cfssl gencert -ca=/ssl/ca.pem -ca-key=/ssl/ca-key.pem -config=/ssl/ca-config.json  \
   -profile=kubernetes /ssl/admin-csr.json | cfssljson -bare admin
 ls admin*


#2、创建k8s客户端
mkdir /k8s/
cd /k8s/
wget http://10.1.11.20/k8s/v1.6.2/kubectl
cp -r /k8s/kubectl  /usr/local/bin/
chmod 777  /usr/local/bin/kubectl

cd /k8s/
#3、kubectl kubeconfig 文件 （采用集群之后重新生成）
#生成的 kubeconfig 被保存到 ~/.kube/config 文件；
#export MASTER_IP=10.1.11.123 # 替换为 kubernetes maste 集群任一机器 IP 之后换成VIP
export MASTER_IP=10.1.11.128

export KUBE_APISERVER="https://${MASTER_IP}:6443"

 # 设置集群参数
 kubectl config set-cluster kubernetes \
  --certificate-authority=/ssl/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER}
  #--kubeconfig=bootstrap.kubeconfig
# 设置客户端认证参数
 kubectl config set-credentials admin \
  --client-certificate=/ssl/admin.pem \
  --embed-certs=true \
  --client-key=/ssl/admin-key.pem
 # 设置上下文参数
 kubectl config set-context kubernetes  --cluster=kubernetes   --user=admin
# 设置默认上下文
kubectl config use-context kubernetes

ls ~/.kube/
kubectl config view

