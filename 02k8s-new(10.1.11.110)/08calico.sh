# author:pengrk
# email:546711211@qq.com
# qq group:573283836


#http://docs.projectcalico.org/v2.2/reference/calicoctl/commands/get
#http://docs.projectcalico.org/v2.2/reference/calicoctl/resources/profile


#注意：在k8s master中 calico的容器不能自动启动，只能手动启动（已经修改了可以自动启动）

##########################k8s的Node安装calico网络############################
#前提：1、Master需要建立，2、然后有一个kubectl客户端。 本次实验在110管理机上运行

#1 创建calico-etcd-secrets，把secrets从原来yaml去掉，采用命令创建
#另外一种方案：把base64 /ssl/ca.pem等生成字符串放到calico-etcd-secrets的data
cd /root/k8s-new/08calico/
cp /ssl/ca.pem  /root/k8s-new/08calico/etcd-ca
cp /ssl/etcdctl.pem  /root/k8s-new/08calico/etcd-cert
cp /ssl/etcdctl-key.pem /root/k8s-new/08calico/etcd-key

kubectl create secret generic calico-etcd-secrets --from-file=./etcd-key  \
     --from-file=./etcd-cert --from-file=./etcd-ca  --namespace=kube-system


#2、创建daemonset的方式，创建calico的容器和控制，加入节点之后，每个节点都自己创建calico的网络
kubectl create -f calico.yaml
#现在所有的节点的状态都变成ready
#测试参考：https://github.com/opsnull/follow-me-install-kubernetes-cluster/blob/master/07-部署Node节点.md



#注意：如果只安装docker的机器需要访问k8s的PO的网络，那么就需要安装，其实其不能访问service IP
#################### 为master的安装calico网络 ###################
NODE_IPS="10.1.11.123   10.1.11.124  10.1.11.125"
NODE_NAME="master-01  master-02  master-03"
ETCD_ENDPOINTS="https://10.1.11.120:2379,https://10.1.11.121:2379,https://10.1.11.122:2379"
mkdir -p /calico/
cd /calico/

##3.1 第一次运行时必须先运行08calico/dockerInitFirst.sh 
#生成/calico/calico-node.service文件和/calico/install.sh


#3.2生成三个环境变量文件 
NAMES=(${NODE_NAME})
for ip in $NODE_IPS ;do
 NAME=${NAMES[$i]}
cat > /calico/calico${ip##*.}.env <<EOF
ETCD_ENDPOINTS="${ETCD_ENDPOINTS}"
ETCD_CA_FILE="/etc/calico/ssl/ca.pem"
ETCD_CERT_FILE="/etc/calico/ssl/etcdctl.pem"
ETCD_KEY_FILE="/etc/calico/ssl/etcdctl-key.pem"
CALICO_NODENAME="${NAME}"
CALICO_NO_DEFAULT_POOLS=""
CALICO_IP=""
CALICO_IP6=""
CALICO_AS=""
CALICO_LIBNETWORK_ENABLED=true
CALICO_NETWORKING_BACKEND=bird
EOF
echo "############################3"
cat /calico/calico${ip##*.}.env
sleep 5
done;



#3.3 把相关文件发送到etcd机器上，并建立集群
for ip in $NODE_IPS ;do
 echo "$ip..."

  clearScript="   
    systemctl stop calico-node; 
    systemctl disable calico-node;
    rm -rf /etc/systemd/system/calico-node.service;
    rm -rf /etc/calico/;
  "
 ssh root@$ip "$clearScript"

 ssh root@$ip "mkdir -p /etc/calico/ssl/;"
 scp /calico/calico${ip##*.}.env root@$ip:/etc/calico/calico.env 
 scp /calico/calico-node.service    root@$ip:/etc/systemd/system/calico-node.service

 scp /calico/install.sh  root@$ip:/etc/calico/install.sh

 scp /ssl/ca.pem    root@$ip:/etc/calico/ssl/ca.pem
 scp /ssl/etcdctl.pem  root@$ip:/etc/calico/ssl/etcdctl.pem
 scp /ssl/etcdctl-key.pem  root@$ip:/etc/calico/ssl/etcdctl-key.pem
  

 ssh root@$ip "chmod 777 /etc/calico/install.sh; /etc/calico/install.sh"
 sleep 10

done



#################calicoctl.cfg ###############################3

mkdir /etc/calico/
cat >/etc/calico/calicoctl.cfg <<EOF
apiVersion: v1
kind: calicoApiConfig
metadata:
spec:
  etcdEndpoints: https://10.1.11.120:2379,https://10.1.11.121:2379,https://10.1.11.122:2379
  etcdKeyFile: /ssl/etcdctl-key.pem
  etcdCertFile: /ssl/etcdctl.pem
  etcdCACertFile: /ssl/ca.pem

EOF


NODE_IPS="10.1.11.123   10.1.11.124  10.1.11.125"
NODE_NAME="master-01  master-02  master-03"

NODE_IPS="10.1.11.130  10.1.11.131 10.1.11.132  10.1.11.133  10.1.11.134  10.1.11.135  10.1.11.136  10.1.11.137 10.1.11.138  10.1.11.139"
NODE_NAME="sys130 sys131  sys132  sys133  sys134  sys135  sys136  sys137  sys138  sys139"

NODE_IPS="10.1.11.140  10.1.11.141 10.1.11.142  10.1.11.143  10.1.11.144  10.1.11.145"
NODE_NAME="msc140  msc141  msc142  msc143  msc144   msc145"

NODE_IPS="10.1.11.150  10.1.11.151 10.1.11.152  10.1.11.153 10.1.11.154 10.1.11.155  10.1.11.156"
NODE_NAME="ms150  ms151 ms152  ms153   ms154   ms155   ms156"

NODE_IPS="10.1.11.170  10.1.11.171 10.1.11.172  10.1.11.173  10.1.11.174  10.1.11.175  10.1.11.176  10.1.11.177  10.1.11.178   10.1.11.179"
NODE_NAME="base170  base171  base172  base173  base174  base175  base176  base177  base178   base179"

NODE_IPS="10.1.11.190  10.1.11.191 10.1.11.192  10.1.11.193"
NODE_NAME="ingress190 ingress191  ingress192  ingress193"



#############安装calicoctl####################
for ip in $NODE_IPS ;do

  echo "$ip安装calicoctl..."
 
 ssh root@$ip "mkdir -p /ssl/; mkdir -p /etc/calico/;"
 scp /etc/calico/calicoctl.cfg  root@$ip:/etc/calico/calicoctl.cfg 

 scp /ssl/etcdctl-key.pem   root@$ip:/ssl/etcdctl-key.pem 
 scp /ssl/etcdctl.pem    root@$ip:/ssl/etcdctl.pem 
 scp /ssl/ca.pem    root@$ip:/ssl/ca.pem

 script="   
    rm -rf /working/;
    rm -rf /usr/local/bin/calicoctl ;
    mkdir /working/ ;
    cd /working/ ;
    wget http://10.1.11.20/calicoctl  ;
    mv /working/calicoctl   /usr/local/bin/ ;
    chmod 777  /usr/local/bin/calicoctl
    calicoctl get profile ;
  "
 
 ssh root@$ip "$script"

 sleep 2
done

#############安装网络工具####################
for ip in $NODE_IPS ;do
  echo "$ip安装网络工具..."
  ssh root@$ip "yum install -y telnet nmap curl"
 sleep 2
done


##########开向NodePort#####################
#注意：默认的情况下，通过外部机器访问不了k8s开放的NodePort，但是在k8s的任何机器上都可以通过
# localip:NodePort来访问，是因为每台k8s Node节点都加了 -P FORWARD DROP路由，说明其不开放外
#部接口，可以在所有机器运行iptables -P FORWARD ACCEPT来开放，也可以在几台机器上进行开放

#这里只开放 130，140，150，160，170，180,190,191,192,193几台机器

ssh root@10.1.11.130 "iptables -P FORWARD ACCEPT"
ssh root@10.1.11.140 "iptables -P FORWARD ACCEPT"
ssh root@10.1.11.150 "iptables -P FORWARD ACCEPT"
ssh root@10.1.11.160 "iptables -P FORWARD ACCEPT"
ssh root@10.1.11.170 "iptables -P FORWARD ACCEPT"
ssh root@10.1.11.180 "iptables -P FORWARD ACCEPT"
ssh root@10.1.11.190 "iptables -P FORWARD ACCEPT"
ssh root@10.1.11.191 "iptables -P FORWARD ACCEPT"
ssh root@10.1.11.192 "iptables -P FORWARD ACCEPT"
ssh root@10.1.11.193 "iptables -P FORWARD ACCEPT"



