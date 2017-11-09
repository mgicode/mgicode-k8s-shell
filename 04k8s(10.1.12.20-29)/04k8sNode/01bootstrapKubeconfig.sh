# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#kubelet 启动时向 kube-apiserver 发送 TLS bootstrapping 请求，
#需要先将 bootstrap token 文件中的 kubelet-bootstrap 用户赋予 system:node-bootstrapper 角色，
#然后 kubelet 才有权限创建认证请求(certificatesigningrequests)
#--user=kubelet-bootstrap 是文件 /ssl/token.csv 中指定的用户名，
#同时也写入了文件 /ssl/bootstrap.kubeconfig；

rm -rf /ssl/bootstrap.kubeconfig

 echo ${BOOTSTRAP_TOKEN} 
 echo ${KUBE_APISERVER}

kubectl create clusterrolebinding kubelet-bootstrap  \
--clusterrole=system:node-bootstrapper  \
--user=kubelet-bootstrap

 # 设置集群参数
kubectl config set-cluster kubernetes \
  --certificate-authority=/ssl/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=/ssl/bootstrap.kubeconfig
# 设置客户端认证参数
 #--token=${BOOTSTRAP_TOKEN} \
kubectl config set-credentials kubelet-bootstrap \
  --token=${BOOTSTRAP_TOKEN}  \
  --kubeconfig=/ssl/bootstrap.kubeconfig
# 设置上下文参数
kubectl config set-context default \
  --cluster=kubernetes \
  --user=kubelet-bootstrap \
  --kubeconfig=/ssl/bootstrap.kubeconfig
# 设置默认上下文
kubectl config use-context default --kubeconfig=/ssl/bootstrap.kubeconfig


echo -e "\033[32m ###############bootstrap.kubeconfig########### \033[0m"
cat  /ssl/bootstrap.kubeconfig
echo -e "\033[32m ###########内容显示完成########### \033[0m"
