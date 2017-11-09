# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#3.3 创建安装的shell
cat > /etcd/install.sh <<EOF
mkdir -p /etcdWorking/
cd /etcdWorking/
wget http://${FILE_SERVER_IP}/${ETCD_TAR_GZ_NAME}.tar.gz
tar -xvf ${ETCD_TAR_GZ_NAME}.tar.gz
mv ${ETCD_TAR_GZ_NAME}/etcd* /usr/local/bin/

echo -e "\033[32m ###############/etc/etcd/etcdEnv的环境变量文件内容########### \033[0m"
  cat /etc/etcd/etcdEnv 
echo -e "\033[32m ###########内容显示完成########### \033[0m"
sleep 5

echo -e "\033[32m ###############至少包括etcdctl.pem etcdctl-key.pem  ca.pem 证书文件########### \033[0m"
 ls /etc/etcd/ssl/*
echo -e "\033[32m ###########内容显示完成########### \033[0m"
sleep 5

systemctl daemon-reload
systemctl enable etcd
systemctl start etcd
systemctl status etcd 

#方便etcdctl的使用 etcdctl member list
echo "export ETCDCTL_CERT_FILE=/etc/etcd/ssl/etcdctl.pem" >> /etc/profile
echo "export ETCDCTL_KEY_FILE=/etc/etcd/ssl/etcdctl-key.pem" >> /etc/profile
echo "export ETCDCTL_CA_FILE=/etc/etcd/ssl/ca.pem" >> /etc/profile
source /etc/profile

echo -e "\033[32m ###############etcd是否通了########### \033[0m"
etcdctl member list
echo -e "\033[32m ###########内容显示完成########### \033[0m"
sleep 5

EOF

echo -e "\033[32m ###############/etcd/install.sh的内容########### \033[0m"
cat /etcd/install.sh
echo -e "\033[32m ###############内容显示完成########### \033[0m"
sleep 10;

#3.3 把相关文件发送到etcd机器上，并建立集群
i=0;
for ip in $NODE_ETCD_IPS ;do
 
 clearScript="   
    systemctl stop etcd; 
    systemctl disable etcd;
    rm -rf /etcdWorking/;
    rm -rf /etc/etcd/;
    rm -fr /var/lib/etcd/ 
    rm -rf /etc/systemd/system/etcd.service;
  "
 ssh root@$ip "$clearScript"


 ssh root@$ip "mkdir -p /var/lib/etcd/；mkdir -p /etc/etcd/ssl/;mkdir -p /etcdWorking/"
 scp /etcd/etcdEnv$i  root@$ip:/etc/etcd/etcdEnv 
 scp /etcd/etcd.service   root@$ip:/etc/systemd/system/etcd.service
 scp /etcd/install.sh  root@$ip:/etc/etcd/install.sh

 scp /ssl/etcd.pem   root@$ip:/etc/etcd/ssl/etcd.pem
 scp /ssl/etcd-key.pem   root@$ip:/etc/etcd/ssl/etcd-key.pem
 scp /ssl/ca.pem   root@$ip:/etc/etcd/ssl/ca.pem

 scp /ssl/etcdctl.pem   root@$ip:/etc/etcd/ssl/etcdctl.pem
 scp /ssl/etcdctl-key.pem   root@$ip:/etc/etcd/ssl/etcdctl-key.pem

 ssh root@$ip "chmod 777 /etc/etcd/install.sh; /etc/etcd/install.sh"
 sleep 10
 let i++;
done
