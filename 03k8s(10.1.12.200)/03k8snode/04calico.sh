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


#################calicoctl.cfg ###############################3

mkdir /etc/calico/
cat > /etc/calico/calicoctl.cfg << EOF
apiVersion: v1
kind: calicoApiConfig
metadata:
spec:
  etcdEndpoints: https://10.1.12.206:2379
  etcdKeyFile: /ssl/etcdctl-key.pem
  etcdCertFile: /ssl/etcdctl.pem
  etcdCACertFile: /ssl/ca.pem

EOF


NODE_IPS="10.1.12.206 10.1.12.207  10.1.12.208 10.1.12.209 10.1.12.210 10.1.12.211 10.1.12.212 10.1.12.213 10.1.12.214"
NODE_NAME="master sys01 sys02 sys03 gw01 gw02 ms01 ms02 ms03"

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
    wget http://10.1.12.200/calicoctl  ;
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
for ip in $NODE_IPS ;do
  echo "$ip安装网络工具..." 
  ssh root@$ip "iptables -P FORWARD ACCEPT"
 sleep 2
done





