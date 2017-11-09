# author:pengrk
# email:546711211@qq.com
# qq group:573283836



cp /calico/calico_tempate.yaml /calico/calico.yaml

CLUSTER_CIDR1=`echo $CLUSTER_CIDR |sed "s/\//\\\\\\\\\//g"`
echo $CLUSTER_CIDR1
ETCD_ENDPOINTS1=`echo $ETCD_ENDPOINTS |sed "s/\//\\\\\\\\\//g"`
echo $ETCD_ENDPOINTS1

sed  -i  "s/{{DOCKER_LIBS}}/$DOCKER_LIBS/g;"   /calico/calico.yaml
sed  -i  "s/{{ETCD_ENDPOINTS}}/$ETCD_ENDPOINTS1/g;"   /calico/calico.yaml
sed  -i  "s/{{CLUSTER_CIDR}}/$CLUSTER_CIDR1/g;"   /calico/calico.yaml

echo -e "\033[32m ###############/calico/calico.yaml  {{DOCKER_LIBS}}  {{ETCD_ENDPOINTS}} {{CLUSTER_CIDR}}不应该存在 ########### \033[0m"
cat /calico/calico.yaml
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 30


cd /ssl/
cp /ssl/ca.pem  /ssl/etcd-ca
cp /ssl/etcdctl.pem  /ssl/etcd-cert
cp /ssl/etcdctl-key.pem /ssl/etcd-key

kubectl delete secret  calico-etcd-secrets -n kube-system
kubectl create secret generic calico-etcd-secrets --from-file=./etcd-key  \
     --from-file=./etcd-cert --from-file=./etcd-ca  --namespace=kube-system

echo -e "\033[32m ###############calico-etcd-secrets ########### \033[0m"
kubectl describe secret calico-etcd-secrets -n kube-system
echo -e "\033[32m ###########内容显示完成########### \033[0m"

#2、创建daemonset的方式，创建calico的容器和控制，加入节点之后，每个节点都自己创建calico的网络
cd /calico/
kubectl delete -f /calico/calico.yaml
kubectl create -f /calico/calico.yaml


echo -e "\033[32m ###############calico ########### \033[0m"
kubectl get po -n kube-system
echo -e "\033[32m ###########内容显示完成########### \033[0m"


echo -e "\033[32m ###############node state ready ########### \033[0m"
kubectl get node -o wide 
echo -e "\033[32m ###########内容显示完成########### \033[0m"