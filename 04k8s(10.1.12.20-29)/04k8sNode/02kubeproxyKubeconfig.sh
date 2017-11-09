# author:pengrk
# email:546711211@qq.com
# qq group:573283836


cd /ssl/

cat  > /ssl/kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
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
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF

echo -e "\033[32m ############### /ssl/kube-proxy-csr.json ########### \033[0m"
cat  /ssl/kube-proxy-csr.json 
echo -e "\033[32m ###########内容显示完成########### \033[0m"

cfssl gencert -ca=/ssl/ca.pem -ca-key=/ssl/ca-key.pem -config=/ssl/ca-config.json \
-profile=kubernetes  /ssl/kube-proxy-csr.json | cfssljson -bare kube-proxy
echo -e "\033[32m ###############生成kube-proxy-csr.pem kube-proxy-csr-key.pem kube-proxy-csr.csr########### \033[0m"
ls /ssl/kube-proxy*
echo -e "\033[32m ###########内容显示完成########### \033[0m"


echo ${KUBE_APISERVER}
#创建 kube-proxy kubeconfig 文件
rm -rf /ssl/kube-proxy.kubeconfig
# 设置集群参数
kubectl config set-cluster kubernetes \
  --certificate-authority=/ssl/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=/ssl/kube-proxy.kubeconfig
# 设置客户端认证参数
kubectl config set-credentials kube-proxy \
  --client-certificate=/ssl/kube-proxy.pem \
  --client-key=/ssl/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=/ssl/kube-proxy.kubeconfig
# 设置上下文参数
kubectl config set-context default \
  --cluster=kubernetes \
  --user=kube-proxy \
  --kubeconfig=/ssl/kube-proxy.kubeconfig
# 设置默认上下文
kubectl config use-context default --kubeconfig=/ssl/kube-proxy.kubeconfig

echo -e "\033[32m ###############kube-proxy.kubeconfig########### \033[0m"
cat  /ssl/kube-proxy.kubeconfig
echo -e "\033[32m ###########内容显示完成########### \033[0m"
