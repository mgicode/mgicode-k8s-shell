NODE_IPS="10.1.12.207  10.1.12.208 10.1.12.209 10.1.12.210 10.1.12.211 10.1.12.212 10.1.12.213 10.1.12.214"
NODE_NAME="sys01 sys02 sys03 gw01 gw02 ms01 ms02 ms03"

NODE_IPS="10.1.12.206"
NODE_NAME="master"


# kubernetes 服务 IP (一般是 SERVICE_CIDR 中第一个IP)
export CLUSTER_KUBERNETES_SVC_IP="192.169.0.1"
# 集群 DNS 服务 IP (从 SERVICE_CIDR 中预分配
export CLUSTER_DNS_SVC_IP="192.169.0.2"
# 集群 DNS 域名
export CLUSTER_DNS_DOMAIN="cluster.local."
# 服务网段 (Service CIDR），部署前路由不可达，部署后集群内使用IP:Port可达
export SERVICE_CIDR="192.169.0.0/16"

cd /k8s/

# author:pengrk
# email:546711211@qq.com
# qq group:573283836

cat /proc/version

#此时没有安装 calico，其node已经加入k8s，但是其status为not ready


#可能其认证通过不了
NODE_IPS="10.1.12.206 10.1.12.207  10.1.12.208 10.1.12.209 10.1.12.210 10.1.12.211 10.1.12.212 10.1.12.213 10.1.12.214"
NODE_NAME="master sys01 sys02 sys03 gw01 gw02 ms01 ms02 ms03"

for ip in $NODE_IPS ;do

  echo "$ip..."
  reset="   
 systemctl daemon-reload
 systemctl enable kubelet
 systemctl start kubelet
 systemctl status kubelet
  "
 ssh root@$ip "$reset"
 sleep 10

 kubectl certificate approve $( kubectl get csr ) 
  sleep 5
done

kubectl get nodes --show-labels
#Linux version 3.10.0-693.el7.x86_64 (builder@kbuilder.dev.centos.org) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-16) (GCC) ) #1 SMP Tue Aug 22 21:09:27 UTC 2017

# Unknown lvalue '' in section 'Service'
#http://tracker.ceph.com/issues/15560   
#http://tracker.ceph.com/issues/15581

#当出现 Unknown lvalue '' in section 'Service'，采用如下语句更新 systemd
#sudo yum install systemd-*
