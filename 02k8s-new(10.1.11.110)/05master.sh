# author:pengrk
# email:546711211@qq.com
# qq group:573283836


#三台Master 10.1.11.123   10.1.11.124  10.1.11.125 (先采用物理机的方式安装，之后采用容器实现）
NODE_IPS="10.1.11.123   10.1.11.124  10.1.11.125"
NODE_NAME="master-01  master-02  master-03"
TEMPLATE_NODE_IP=10.1.11.117
password="root@123"  

MASTER_IP1="10.1.11.123"
MASTER_IP2="10.1.11.124"
MASTER_IP3="10.1.11.125"
HA_IP1="10.1.11.126"
HA_IP2="10.1.11.127"
HA_VIP="10.1.11.128"
CLUSTER_IP="192.169.0.1"
DNS_IP="192.169.0.2"

export BOOTSTRAP_TOKEN=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ')


# 服务网段 (Service CIDR），部署前路由不可达，部署后集群内使用IP:Port可达
export SERVICE_CIDR="192.169.0.0/16"
# POD 网段 (Cluster CIDR），部署前路由不可达，**部署后**路由可达(flanneld保证)
export CLUSTER_CIDR="172.16.0.0/12"
# etcd 集群服务地址列表
export ETCD_ENDPOINTS="https://10.1.11.120:2379,https://10.1.11.121:2379,https://10.1.11.122:2379"
# kubernetes 服务 IP (一般是 SERVICE_CIDR 中第一个IP)
export CLUSTER_KUBERNETES_SVC_IP="192.169.0.1"
# 集群 DNS 服务 IP (从 SERVICE_CIDR 中预分配)
export CLUSTER_DNS_SVC_IP="192.169.0.2"
# 集群 DNS 域名
export CLUSTER_DNS_DOMAIN="cluster.local."



####################初始化机器############################

/common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"

####################生成和初始化证书####################
cd /ssl/

cat > /ssl/kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "hosts": [
    "127.0.0.1",
    "${MASTER_IP1}",
    "${MASTER_IP2}",
    "${MASTER_IP3}",
    "${HA_IP1}",
    "${HA_IP2}",
    "${HA_VIP}",
    "${CLUSTER_IP}",
    "${DNS_IP}",
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

cat /ssl/kubernetes-csr.json

cfssl gencert -ca=/ssl/ca.pem -ca-key=/ssl/ca-key.pem -config=/ssl/ca-config.json  \
-profile=kubernetes /ssl/kubernetes-csr.json | cfssljson -bare kubernetes
ls kubernetes*


cat > /ssl/token.csv <<EOF
${BOOTSTRAP_TOKEN},kubelet-bootstrap,10001,"system:kubelet-bootstrap"
EOF
cat /ssl/token.csv


#######################################################

mkdir -p /k8s/
cd /k8s/
##3.1 第一次运行时必须先运行05master/initFirst.sh 
#生成/k8s/kube-apiserver.service 、/k8s/kube-controller-manager.service、
#/k8s/kube-scheduler.service、/k8s/install.sh


#3.2生成三个环境变量文件 
i=0
for ip in $NODE_IPS ;do
cat > /k8s/k8sEvn$i <<EOF
SERVICE_CIDR="${SERVICE_CIDR}"
CLUSTER_CIDR="${CLUSTER_CIDR}"
MASTER_IP="${ip}"
ETCD_ENDPOINTS="${ETCD_ENDPOINTS}"
EOF
cat /k8s/k8sEvn$i
sleep 5
let i++
done;


#3.3 把相关文件发送到etcd机器上，并建立集群
i=0;
for ip in $NODE_IPS ;do

  echo "$ip..."
  clearScript="   
    systemctl stop kube-scheduler; 
    systemctl disable kube-apiserver;
    systemctl stop kube-controller-manager; 
    systemctl disable kube-controller-manager;
    systemctl stop kube-apiserver;
    systemctl disable kube-apiserver;

    rm -rf /working/;

    rm -rf /etc/systemd/system/kube-apiserver.service;;
    rm -rf /etc/systemd/system/kube-controller-manager.service;
    rm -rf /etc/systemd/system/kube-scheduler.service;
  "
 ssh root@$ip "$clearScript"

 ssh root@$ip "mkdir -p /etc/kubernetes/ssl/;"
 scp /k8s/k8sEvn$i  root@$ip:/etc/kubernetes/k8sEvn 
 scp /k8s/kube-apiserver.service    root@$ip:/etc/systemd/system/kube-apiserver.service
 scp /k8s/kube-controller-manager.service    root@$ip:/etc/systemd/system/kube-controller-manager.service
 scp /k8s/kube-scheduler.service   root@$ip:/etc/systemd/system/kube-scheduler.service

 scp /k8s/install.sh  root@$ip:/etc/kubernetes/install.sh

 scp /ssl/token.csv    root@$ip:/etc/kubernetes/ssl/token.csv 
 scp /ssl/kubernetes.pem   root@$ip:/etc/kubernetes/ssl/kubernetes.pem 
 scp /ssl/kubernetes-key.pem    root@$ip:/etc/kubernetes/ssl/kubernetes-key.pem 

 scp /ssl/ca.pem   root@$ip:/etc/kubernetes/ssl/ca.pem
 scp /ssl/ca-key.pem  root@$ip:/etc/kubernetes/ssl/ca-key.pem

 ssh root@$ip "chmod 777 /etc/kubernetes/install.sh; /etc/kubernetes/install.sh"
 sleep 10
 let i++;
done


#查看安装的状态
kubectl get componentstatuses



#3.4 每台主机kubectl连接自己
i=0;
for ip in $NODE_IPS ;do
 echo "$ip"
 KUBE_APISERVER="https://${ip}:6443"
 kubectl config set-cluster kubernetes  --certificate-authority=/ssl/ca.pem \
  --embed-certs=true   --server=${KUBE_APISERVER}   --kubeconfig=/ssl/master-config$i

 kubectl config set-credentials admin --client-certificate=/ssl/admin.pem \
  --embed-certs=true   --client-key=/ssl/admin-key.pem  --kubeconfig=/ssl/master-config$i

 kubectl config set-context kubernetes  --cluster=kubernetes   --user=admin \
  --kubeconfig=/ssl/master-config$i

 kubectl config use-context kubernetes  --kubeconfig=/ssl/master-config$i

 ssh root@$ip "mkdir -p /root/.kube/;"
 scp /ssl/master-config$i   root@$ip:/root/.kube/config

 sleep 10
 let i++;
done






