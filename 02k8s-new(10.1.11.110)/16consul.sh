# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#1、安装cfssl 

#前提按15ceph中创建ceph-secret.yaml和ceph-storageClass.yaml

#cp /root/k8s-new/16consul/* /consul/
#把16consul的两个Yaml文件copy to /consul/
mkdir /consul/
cd /consul/
wget http://10.1.11.20/cfssl
wget http://10.1.11.20/cfssl-certinfo
wget http://10.1.11.20/cfssljson
chmod +x cfssl
chmod +x cfssl-certinfo
chmod +x cfssljson
mv cfssl* /usr/local/bin/
ls /usr/local/bin/

#consul本地安装
wget http://10.1.11.20/consul_0.8.3_linux_amd64.zip
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


kubectl create -f consul.yaml

kubectl get pods
kubectl create -f jobs/consul-join.yaml
kubectl get jobs


#Verification
kubectl logs consul-0
kubectl exec  -it consul-0  /bin/bash
consul members
exit





