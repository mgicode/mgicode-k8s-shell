NODE_IPS="10.1.12.206"
NODE_NAME="master"

for ip in $NODE_IPS ;do


 scp /ssl/token.csv    root@$ip:/etc/kubernetes/ssl/token.csv 
 scp /ssl/kubernetes.pem   root@$ip:/etc/kubernetes/ssl/kubernetes.pem 
 scp /ssl/kubernetes-key.pem    root@$ip:/etc/kubernetes/ssl/kubernetes-key.pem 

 scp /ssl/ca.pem   root@$ip:/etc/kubernetes/ssl/ca.pem
 scp /ssl/ca-key.pem  root@$ip:/etc/kubernetes/ssl/ca-key.pem
 sleep 10
 let i++;
done