
docker login --username=hi31016710@aliyun.com registry.cn-hangzhou.aliyuncs.com

docker login --username=hi31016710@aliyun.com registry.cn-hangzhou.aliyuncs.com

docker pull 10.1.12.61:5000/centos
docker tag  10.1.12.61:5000/centos   registry.cn-hangzhou.aliyuncs.com/prk/centos
docker push registry.cn-hangzhou.aliyuncs.com/prk/centos


docker pull 10.1.12.61:5000/centos7_jdk1.8
docker tag 10.1.12.61:5000/centos7_jdk1.8  registry.cn-hangzhou.aliyuncs.com/prk/centos7_jdk1.8
docker push registry.cn-hangzhou.aliyuncs.com/prk/centos7_jdk1.8

# {"repositories":["calico_cni","calico_kube-policy-controller","calico_node",
# "centos","centos7_jdk1.8","centos7_ssh","consul","echoserver","gitlab-ce",
# "google_containers/pause-amd64","ha-k8s-master","heapster-amd64",
# "heapster-grafana-amd64","heapster-influxdb-amd64",
# "jenkins","k8s-dns-dnsmasq-nanny-amd64","k8s-dns-kube-dns-amd64",
# "k8s-dns-sidecar-amd64","kubernetes-dashboard-amd64","mongo","nexus3",
# "nginx","nginx-consul","nginx-ingress-controller","pause-amd64",
# "percona_xtradb_cluster_5_6","rabbitmq","redis","registry","ubuntu"]}


#curl 10.1.12.61:5000/v2/_catalog


docker pull 10.1.12.61:5000/calico_cni:v1.8.3
docker tag  10.1.12.61:5000/calico_cni:v1.8.3   registry.cn-hangzhou.aliyuncs.com/prk/k8s/calico_cni:v1.8.3
docker push registry.cn-hangzhou.aliyuncs.com/prk/k8s/calico_cni:v1.8.3


$ sudo docker login --username=hi31016710@aliyun.com registry.cn-hangzhou.aliyuncs.com
$ sudo docker tag [ImageId] registry.cn-hangzhou.aliyuncs.com/prk/k8s:[镜像版本号]
$ sudo docker push registry.cn-hangzhou.aliyuncs.com/prk/k8s:[镜像版本号]


# $ sudo docker login --username=afangxin registry.cn-hangzhou.aliyuncs.com
# $ sudo docker tag [ImageId] registry.cn-hangzhou.aliyuncs.com/testfangxin/fangxin:[镜像版本号]
# $ sudo docker push registry.cn-hangzhou.aliyuncs.com/testfangxin/fangxin:[镜像版本号]