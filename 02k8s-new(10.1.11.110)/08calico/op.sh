docker pull registry.cn-hangzhou.aliyuncs.com/calico_containers/node
docker tag registry.cn-hangzhou.aliyuncs.com/calico_containers/node 10.1.11.60:5000/calico_node:V1.2.1
docker push 10.1.11.60:5000/calico_node:V1.2.1


docker pull registry.cn-hangzhou.aliyuncs.com/calico_containers/cni:v1.8.3
docker tag registry.cn-hangzhou.aliyuncs.com/calico_containers/cni:v1.8.3 10.1.11.60:5000/calico_cni:v1.8.3
docker push 10.1.11.60:5000/calico_cni:v1.8.3


docker pull registry.cn-hangzhou.aliyuncs.com/calico_containers/kube-policy-controller:v0.6.0
docker tag registry.cn-hangzhou.aliyuncs.com/calico_containers/kube-policy-controller:v0.6.0 10.1.11.60:5000/calico_kube-policy-controller:v0.6.0
docker push 10.1.11.60:5000/calico_kube-policy-controller:v0.6.0


base64 /ssl/ca.pem
base64 /ssl/etcdctl.pem
base64 /ssl/etcdctl-key.pem


 kubectl create secret generic calico-etcd-secrets1 --from-file=./etcd-key  \
--from-file=./etcd-cert --from-file=./etcd-ca  --namespace=kube-system

 kubectl describe secrets/calico-etcd-secrets1




kubectl create -f nginx-ds.yml