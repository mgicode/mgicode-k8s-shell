# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#################calicoctl.cfg ###############################3

mkdir -p /etc/calico/
cat > /etc/calico/calicoctl.cfg << EOF
apiVersion: v1
kind: calicoApiConfig
metadata:
spec:
  etcdEndpoints: ${ETCD_ENDPOINTS}
  etcdKeyFile: /ssl/etcdctl-key.pem
  etcdCertFile: /ssl/etcdctl.pem
  etcdCACertFile: /ssl/ca.pem

EOF

cat /etc/calico/calicoctl.cfg



#############安装calicoctl####################
for ip in $NODE_NODE_IPS ;do

  echo "$ip安装calicoctl..."
 
 ssh root@$ip "mkdir -p /ssl/; mkdir -p /etc/calico/;"
 scp /etc/calico/calicoctl.cfg  root@$ip:/etc/calico/calicoctl.cfg 

 scp /ssl/etcdctl-key.pem   root@$ip:/ssl/etcdctl-key.pem 
 scp /ssl/etcdctl.pem    root@$ip:/ssl/etcdctl.pem 
 scp /ssl/ca.pem    root@$ip:/ssl/ca.pem

 script="   
    echo -e \"\033[32m ###############check ca文件，至少包括etcdctl-key.pem  etcdctl.pem ca.pem ########### \033[0m\"
    ls /ssl/
    echo -e \"\033[32m ###########内容显示完成########### \033[0m\"

    rm -rf /calicoWorking/;
    rm -rf /usr/local/bin/calicoctl ;
    mkdir /calicoWorking/ ;
    cd /calicoWorking/ ;
    wget http://${FILE_SERVER_IP}/calicoctl  -q ;
    mv /calicoWorking/calicoctl   /usr/local/bin/ ;
    chmod 777  /usr/local/bin/calicoctl
    echo -e \"\033[32m ###############calicoctl get profile########### \033[0m\"
    calicoctl get profile ;
    echo -e \"\033[32m ###########内容显示完成########### \033[0m\"
  " 
 ssh root@$ip "$script"

 sleep 2

done



for ip in $NODE_NODE_IPS ;do
  echo "$ip安装calicoctl..."
  script="   
    echo -e \"\033[32m ###############check ca文件，至少包括etcdctl-key.pem  etcdctl.pem ca.pem ########### \033[0m\"
    ls /ssl/
    echo -e \"\033[32m ###########内容显示完成########### \033[0m\"
    echo -e \"\033[32m ###############calicoctl get profile########### \033[0m\"
    calicoctl get profile ;
    echo -e \"\033[32m ###########内容显示完成########### \033[0m\"
  " 
 ssh root@$ip "$script"
 sleep 5
done
