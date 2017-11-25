#把环境变量统一起来
#该token只生成一次即保存起来，每次生成的都不一样的
export BOOTSTRAP_TOKEN=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ')

cp /etc/profile /etc/profile2

cat  >>/etc/profile <<EOF
export BOOTSTRAP_TOKEN="$BOOTSTRAP_TOKEN"
EOF

cat  /etc/profile
cp /etc/profile2 /etc/profile 
cp /etc/profile /etc/profile1



#可以多次运行


#如"10.1.12.21 10.1.12.22  10.1.12.23"
NODE_ETCD_IPS="10.1.12.21"
# etcd 集群服务地址列表
#export ETCD_ENDPOINTS="https://${MASTER_IP1}:2379"
#"https://10.1.11.120:2379,https://10.1.11.121:2379,https://10.1.11.122:2379"
ETCD_ENDPOINTS=""
i=0
for ip in $NODE_ETCD_IPS ;do
   if [ $i -eq 0 ]; then
 	  ETCD_ENDPOINTS="https://$ip:2379"
   else
 	  ETCD_ENDPOINTS="$ETCD_ENDPOINTS,https://$ip:2379"
   fi
   let i++
done

#export MASTER_IP=10.1.11.123 # 替换为 kubernetes maste 集群任一机器 IP 之后换成VIP
NODE_MASTER_VIP="10.1.12.21"


NODE_MASTER_IPS="10.1.12.21"
NODE_MASTER_NAMES="master"

NODE_NODE_IPS="10.1.12.21 10.1.12.22 10.1.12.23  10.1.12.24   10.1.12.25   10.1.12.26  10.1.12.27  10.1.12.28  10.1.12.29"
NODE_NODE_NAMES="master node2  node3 node4  node5  node6  node7 node8  node9"

#多个以空格分隔
ZONE_MASTER_IPS="10.1.12.21"
ZONE_SYS_IPS="10.1.12.22"
ZONE_GW_IPS="10.1.12.23  10.1.12.24"
ZONE_MS_IPS="10.1.12.22 10.1.12.23  10.1.12.24   10.1.12.25   10.1.12.26  10.1.12.27  10.1.12.28  10.1.12.29"

ZONE_MONGODB_IPS="10.1.12.27  10.1.12.28  10.1.12.29"
ZONE_CONSUL_IPS="10.1.12.27  10.1.12.28  10.1.12.29"
ZONE_REDIS_IPS="10.1.12.27  10.1.12.28  10.1.12.29"



cp /etc/profile1 /etc/profile

cat  >>/etc/profile <<EOF
#管理节点的IP
export NODE_ADMIN_IP="10.1.12.20"
#文件服务器的IP
export FILE_SERVER_IP="10.1.12.20"
#模板的IP和初始密码
export TEMPLATE_NODE_IP="10.1.12.129"
export TEMPLATE_NODE_PWD="root@123"

# k8s Master的IP和名称，如"10.1.12.21 10.1.12.22  10.1.12.23"
# 或" master01 master02  master03"
export NODE_MASTER_IPS="${NODE_MASTER_IPS}"
export NODE_MASTER_NAMES="${NODE_MASTER_NAMES}"

export NODE_NODE_IPS="${NODE_NODE_IPS}"
export NODE_NODE_NAMES="${NODE_NODE_NAMES}"

#没有建立vip之前，采用了多master的ip中一个,一般用第一个
export NODE_MASTER_VIP="${NODE_MASTER_VIP}"
#访问master的地址
export KUBE_APISERVER="https://${NODE_MASTER_VIP}:6443"

#k8s ETCD的IP和名称，如"10.1.12.21 10.1.12.22  10.1.12.23"
# 或" master01 master02  master03"
export NODE_ETCD_IPS="${NODE_ETCD_IPS}"
export NODE_ETCD_NAMES="master01"
export ETCD_ENDPOINTS="${ETCD_ENDPOINTS}"

#从文件服务器下载的etcd文件tar.gz的名称，后缀一定以tar.gz为尾
export ETCD_TAR_GZ_NAME=etcd-v3.1.6-linux-amd64
#k8s在文件服务器上下载的目录
export KUBE_VERSION="1.7.6"

# 服务网段 (Service CIDR），部署前路由不可达，部署后集群内使用IP:Port可达
export SERVICE_CIDR="192.169.0.0/16"
# POD 网段 (Cluster CIDR），部署前路由不可达，**部署后**路由可达(flanneld保证)
export CLUSTER_CIDR="172.16.0.0/12"
# kubernetes 服务 IP (一般是 SERVICE_CIDR 中第一个IP)
export CLUSTER_KUBERNETES_SVC_IP="192.169.0.1"
# 集群 DNS 服务 IP (从 SERVICE_CIDR 中预分配)
export CLUSTER_DNS_SVC_IP="192.169.0.2"
# 集群 DNS 域名
export CLUSTER_DNS_DOMAIN="cluster.local."


export ZONE_MASTER_IPS="${ZONE_MASTER_IPS}"
export ZONE_SYS_IPS="${ZONE_SYS_IPS}"
export ZONE_GW_IPS="${ZONE_GW_IPS}"
export ZONE_MS_IPS="${ZONE_MS_IPS}"

export ZONE_MONGODB_IPS="${ZONE_MONGODB_IPS}"
export ZONE_CONSUL_IPS="${ZONE_CONSUL_IPS}"
export ZONE_REDIS_IPS="${ZONE_REDIS_IPS}"

export  DOCKER_LIBS="10.1.12.61:5000"
export PATH=/usr/local/bin:$PATH
EOF

echo -e "\033[32m ###########检测生成的内容########### \033[0m"
cat /etc/profile
echo -e "\033[32m ###########内容显示完成########### \033[0m"

source /etc/profile