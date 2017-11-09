# author:pengrk
# email:546711211@qq.com
# qq group:573283836


# docker pull registry.cn-hangzhou.aliyuncs.com/kube_containers/k8s-dns-kube-dns-amd64:1.14.6
# docker tag  registry.cn-hangzhou.aliyuncs.com/kube_containers/k8s-dns-kube-dns-amd64:1.14.1  \
# 10.1.12.61:5000/k8s-dns-kube-dns-amd64:1.14.1
# docker push 10.1.12.61:5000/k8s-dns-kube-dns-amd64:1.14.1

# docker pull registry.cn-hangzhou.aliyuncs.com/kube_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.1
# docker tag registry.cn-hangzhou.aliyuncs.com/kube_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.1 \
#  10.1.12.61:5000/k8s-dns-dnsmasq-nanny-amd64:1.14.1
# docker push  10.1.12.61:5000/k8s-dns-dnsmasq-nanny-amd64:1.14.1


# docker pull registry.cn-hangzhou.aliyuncs.com/kube_containers/k8s-dns-sidecar-amd64:1.14.1
# docker tag registry.cn-hangzhou.aliyuncs.com/kube_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.1 \
#   10.1.12.61:5000/k8s-dns-sidecar-amd64:1.14.1
# docker push  10.1.12.61:5000/k8s-dns-sidecar-amd64:1.14.1

#说明 升级到1.7.6之后，kubedns1.14.1有问题
docker pull registry.cn-hangzhou.aliyuncs.com/daniel_kubeadm/k8s-dns-kube-dns-amd64:1.14.5
docker tag registry.cn-hangzhou.aliyuncs.com/daniel_kubeadm/k8s-dns-kube-dns-amd64:1.14.5 \
10.1.12.61:5000/k8s-dns-kube-dns-amd64:1.14.5
docker push  10.1.12.61:5000/k8s-dns-kube-dns-amd64:1.14.5

docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.5
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.5 \
10.1.12.61:5000/k8s-dns-dnsmasq-nanny-amd64:1.14.5
docker push  10.1.12.61:5000/k8s-dns-dnsmasq-nanny-amd64:1.14.5

docker pull registry.cn-hangzhou.aliyuncs.com/wiselyman/k8s-dns-sidecar-amd64:1.14.5
docker tag registry.cn-hangzhou.aliyuncs.com/wiselyman/k8s-dns-sidecar-amd64:1.14.5 \
10.1.12.61:5000/k8s-dns-sidecar-amd64:1.14.5
docker push 10.1.12.61:5000/k8s-dns-sidecar-amd64:1.14.5
