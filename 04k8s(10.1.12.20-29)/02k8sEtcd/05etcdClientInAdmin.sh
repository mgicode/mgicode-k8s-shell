# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#ETCD_TAR_GZ_NAME=etcd-v3.1.6-linux-amd64

#################4 本机安装etcd客户端##################
sleep 10
cd /etcd/
wget http://${FILE_SERVER_IP}/${ETCD_TAR_GZ_NAME}.tar.gz
tar -xvf ${ETCD_TAR_GZ_NAME}.tar.gz
mv ${ETCD_TAR_GZ_NAME}/etcd*  /usr/local/bin/

mkdir -p /etc/etcd/ssl/
cp /ssl/etcdctl.pem /etc/etcd/ssl/
cp /ssl/etcdctl-key.pem /etc/etcd/ssl/
cp /ssl/ca.pem /etc/etcd/ssl/

ls /etc/etcd/ssl/

echo "export ETCDCTL_CERT_FILE=/ssl/etcdctl.pem " >> /etc/profile
echo "export ETCDCTL_KEY_FILE=/ssl/etcdctl-key.pem " >> /etc/profile
echo "export ETCDCTL_CA_FILE=/ssl/ca.pem " >> /etc/profile
source /etc/profile

# echo "export ETCDCTL_CERT_FILE=/etc/etcd/ssl/etcdctl.pem" >> /etc/profile
# echo "export ETCDCTL_KEY_FILE=/etc/etcd/ssl/etcdctl-key.pem" >> /etc/profile
# echo "export ETCDCTL_CA_FILE=/etc/etcd/ssl/ca.pem" >> /etc/profile





echo -e "\033[32m ###############etcd是否通了########### \033[0m"
etcdctl --endpoints=https://${NODE_ADMIN_IP}:2379 member list
echo -e "\033[32m ###########内容显示完成########### \033[0m"

#etcdctl --endpoints=https://${NODE_ADMIN_IP}:2379 member list

 #export ETCDCTL_CERT_FILE=/etc/etcd/ssl/etcdctl.pem
 #export ETCDCTL_KEY_FILE=//etc/etcd/ssl/etcdctl-key.pem
 #export ETCDCTL_CA_FILE=/etc/etcd/ssl/ca.pem
 #etcdctl --endpoints=https://10.1.11.21:2379 member list


#  etcdctl --endpoints=https://10.1.12.21:2379  \
#   --ca-file=/ssl/ca.pem \
#   --cert-file=/ssl/etcdctl.pem \
#   --key-file=/ssl/etcdctl-key.pem \
#   member list


#  ssh root@10.1.12.22 "mkdir -p /var/lib/etcd/；mkdir -p /etc/etcd/ssl/;mkdir -p /etcdWorking/"
#  scp /ssl/ca.pem   root@10.1.12.22:/etc/etcd/ssl/ca.pem

#  scp /ssl/etcdctl.pem   root@10.1.12.22:/etc/etcd/ssl/etcdctl.pem
#  scp /ssl/etcdctl-key.pem   root@10.1.12.22:/etc/etcd/ssl/etcdctl-key.pem

