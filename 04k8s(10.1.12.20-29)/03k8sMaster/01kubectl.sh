# author:pengrk
# email:546711211@qq.com
# qq group:573283836


#1、管理机200中安装，初始时只有200给定某一台的证书，之后全都换成HA-VIP的证书
#FILE_SERVER_IP="10.1.12.200"
#KUBE_VERSION="1.7.6"

#2、创建k8s客户端
mkdir /k8s/
cd /k8s/
wget http://${FILE_SERVER_IP}/${KUBE_VERSION}/kubectl
cp -r /k8s/kubectl  /usr/local/bin/

echo -e "\033[32m ###############kubectl是否移动到/usr/local/bin/中########### \033[0m"
ls /usr/local/bin/
echo -e "\033[32m ###########内容显示完成########### \033[0m"

chmod 777  /usr/local/bin/kubectl

echo -e "\033[32m ###############/usr/local/bin/kubectl  exist########### \033[0m"
ls /usr/local/bin/ 
kubectl --help
echo -e "\033[32m ###########内容显示完成########### \033[0m"


cd /k8s/
#3、kubectl kubeconfig 文件 （采用集群之后重新生成）
#生成的 kubeconfig 被保存到 ~/.kube/config 文件；
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

echo -e "\033[32m ###############kubeconfig########### \033[0m"
ls ~/.kube/
kubectl config view
kubectl get nodes
echo -e "\033[32m ###########内容显示完成########### \033[0m"
