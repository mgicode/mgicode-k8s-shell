
# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#hostpath的存储需要权限，不然不能读写指定的consuldata目录
for ip in $ZONE_CONSUL_IPS ;do
  echo "$ip..."
 ssh root@$ip "cd /root/; mkdir consuldata; chmod 777 consuldata; ls -l;"
 sleep 5

done

#cp /root/k8s-new/16consul/* /consul/
#把16consul的两个Yaml文件copy to /consul/
mkdir /consul/
cd /consul/

yum install unzip -y

#consul本地安装
wget http://${FILE_SERVER_IP}/consul_0.8.3_linux_amd64.zip
unzip consul_0.8.3_linux_amd64.zip
chmod +x consul
cp consul /usr/local/bin/

#创建证书
cfssl gencert -initca ca/ca-csr.json | cfssljson -bare ca
cfssl gencert  -ca=ca.pem   -ca-key=ca-key.pem   -config=ca/ca-config.json   -profile=default \
  ca/consul-csr.json | cfssljson -bare consul

#创建secret
GOSSIP_ENCRYPTION_KEY=$(consul keygen)
kubectl create secret generic consul \
  --from-literal="gossip-encryption-key=${GOSSIP_ENCRYPTION_KEY}" \
  --from-file=ca.pem  --from-file=consul.pem   --from-file=consul-key.pem

#创建configmap
kubectl create configmap consul --from-file=configs/server.json
kubectl describe configmap consul



kubectl delete -f /consul/consul.yaml
kubectl create -f /consul/consul.yaml

kubectl get pods
kubectl delete -f /consul/consul-join.yaml
kubectl create -f /consul/consul-join.yaml
kubectl get jobs


#Verification
kubectl logs consul-0
kubectl exec  -it consul-0  -- /bin/bash
consul members
exit


#kubectl exec `kubectl get pods  -l run=my-nginx -o name`  -i -t -- /bin/bash




