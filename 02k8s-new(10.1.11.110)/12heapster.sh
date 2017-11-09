# author:pengrk
# email:546711211@qq.com
# qq group:573283836


kubectl create -f 12heapster/heapster.yaml

kubectl cluster-info
kubectl get deployments -n kube-system | grep -E 'heapster|monitoring'
kubectl get pods -n kube-system | grep -E 'heapster|monitoring'