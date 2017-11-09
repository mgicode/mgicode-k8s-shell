
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