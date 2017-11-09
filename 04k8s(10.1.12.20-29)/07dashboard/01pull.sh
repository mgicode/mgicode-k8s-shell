# author:pengrk
# email:546711211@qq.com
# qq group:573283836

docker pull registry.cn-hangzhou.aliyuncs.com/google-containers/kubernetes-dashboard-amd64:v1.7.1
docker tag registry.cn-hangzhou.aliyuncs.com/google-containers/kubernetes-dashboard-amd64:v1.7.1 \
    10.1.12.61:5000/kubernetes-dashboard-amd64:v1.7.1
docker push  10.1.12.61:5000/kubernetes-dashboard-amd64:v1.7.1

docker pull registry.cn-hangzhou.aliyuncs.com/cbec-k8s/heapster-amd64:v1.4.3
docker tag registry.cn-hangzhou.aliyuncs.com/cbec-k8s/heapster-amd64:v1.4.3 \
 10.1.12.61:5000/heapster-amd64:v1.4.3
docker push  10.1.12.61:5000/heapster-amd64:v1.4.3


docker pull registry.cn-hangzhou.aliyuncs.com/cbec-k8s/heapster-grafana-amd64:v4.4.3
docker tag registry.cn-hangzhou.aliyuncs.com/cbec-k8s/heapster-grafana-amd64:v4.4.3 \
 10.1.12.61:5000/heapster-grafana-amd64:v4.4.3
docker push  10.1.12.61:5000/heapster-grafana-amd64:v4.4.3

docker pull registry.cn-hangzhou.aliyuncs.com/cbec-k8s/heapster-influxdb-amd64:v1.3.3
docker tag registry.cn-hangzhou.aliyuncs.com/cbec-k8s/heapster-influxdb-amd64:v1.3.3 \
10.1.12.61:5000/heapster-influxdb-amd64:v1.3.3
docker push  10.1.12.61:5000/heapster-influxdb-amd64:v1.3.3