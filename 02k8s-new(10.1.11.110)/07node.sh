# author:pengrk
# email:546711211@qq.com
# qq group:573283836

NODE_IPS="10.1.11.130  10.1.11.131 10.1.11.132  10.1.11.133  10.1.11.134  10.1.11.135  10.1.11.136  10.1.11.137 10.1.11.138  10.1.11.139"
NODE_NAME="sys130 sys131  sys132  sys133  sys134  sys135  sys136  sys137  sys138  sys139"
########3初始化机器###################
/common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"
########3初始化机器###################


NODE_IPS="10.1.11.140  10.1.11.141 10.1.11.142  10.1.11.143  10.1.11.144  10.1.11.145"
NODE_NAME="msc140  msc141  msc142  msc143  msc144   msc145"
########3初始化机器###################
/common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"
########3初始化机器###################


NODE_IPS="10.1.11.150  10.1.11.151 10.1.11.152  10.1.11.153 10.1.11.154 10.1.11.155  10.1.11.156"
NODE_NAME="ms150  ms151 ms152  ms153   ms154   ms155   ms156"
########3初始化机器###################
/common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"
########3初始化机器###################


NODE_IPS="10.1.11.170  10.1.11.171 10.1.11.172  10.1.11.173  10.1.11.174  10.1.11.175  10.1.11.176  10.1.11.177  10.1.11.178   10.1.11.179"
NODE_NAME="base170  base171  base172  base173  base174  base175  base176  base177  base178   base179"
########3初始化机器###################
/common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"
########3初始化机器###################


NODE_IPS="10.1.11.190  10.1.11.191 10.1.11.192  10.1.11.193"
NODE_NAME="ingress190 ingress191  ingress192  ingress193"
########3初始化机器###################
/common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"
########3初始化机器###################







# kubernetes 服务 IP (一般是 SERVICE_CIDR 中第一个IP)
export CLUSTER_KUBERNETES_SVC_IP="192.169.0.1"
# 集群 DNS 服务 IP (从 SERVICE_CIDR 中预分配)
export CLUSTER_DNS_SVC_IP="192.169.0.2"
# 集群 DNS 域名
export CLUSTER_DNS_DOMAIN="cluster.local."
# 服务网段 (Service CIDR），部署前路由不可达，部署后集群内使用IP:Port可达
export SERVICE_CIDR="192.169.0.0/16"

cd /k8s/


##3.1 第一次运行时必须先运行07node/initFirst.sh 
#生成/k8s/kubelet.service、/k8s/install-client.sh、/k8s/install-client.sh及相关的证书

#3.2生成三个环境变量文件 
for ip in $NODE_IPS ;do
cat > /k8s/k8sCliEvn${ip##*.} <<EOF
NODE_ADDRESS="${ip}"
CLUSTER_DNS_SVC_IP="${CLUSTER_DNS_SVC_IP}"
CLUSTER_DNS_DOMAIN="${CLUSTER_DNS_DOMAIN}"
SERVICE_CIDR="${SERVICE_CIDR}"

EOF
echo "############################3"
cat /k8s/k8sCliEvn${ip##*.}
sleep 5
done;


#3.3 把相关文件发送到etcd机器上，并建立集群
for ip in $NODE_IPS ;do

  echo "$ip..."
  clearScript="   
    systemctl stop kube-proxy; 
    systemctl disable kube-proxy;
    systemctl stop kubelet; 
    systemctl disable kubelet;
    rm -rf /working/;
    rm -rf /etc/kubernetes/;
    rm -rf /etc/systemd/system/kubelet.service;
    rm -rf /etc/systemd/system/kube-proxy.service;
  "
 ssh root@$ip "$clearScript"

 ssh root@$ip "mkdir -p /etc/kubernetes/ssl/; mkdir -p /root/.kube/"
 scp /k8s/k8sCliEvn${ip##*.} root@$ip:/etc/kubernetes/k8sCliEvn 
 scp /k8s/kubelet.service    root@$ip:/etc/systemd/system/kubelet.service
 scp /k8s/kube-proxy.service    root@$ip:/etc/systemd/system/kube-proxy.service

 scp /k8s/install-client.sh  root@$ip:/etc/kubernetes/install-client.sh

 scp /ssl/bootstrap.kubeconfig    root@$ip:/etc/kubernetes/bootstrap.kubeconfig 
 scp /ssl/kube-proxy.kubeconfig    root@$ip:/etc/kubernetes/kube-proxy.kubeconfig 

 scp ~/.kube/config   root@$ip:/root/.kube/config


 ssh root@$ip "chmod 777 /etc/kubernetes/install-client.sh; /etc/kubernetes/install-client.sh"
 sleep 10
done


#此时没有安装 calico，其node已经加入k8s，但是其status为not ready





#后面的ceph

