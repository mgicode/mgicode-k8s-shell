# author:pengrk
# email:546711211@qq.com
# qq group:573283836

cd  /dashboard/

kubectl delete  -f /dashboard/dashboard.yaml
kubectl delete  -f /dashboard/heapster.yaml

kubectl create  -f /dashboard/dashboard.yaml
kubectl create  -f /dashboard/heapster.yaml

kubectl get po -n kube-system -o wide

#https://github.com/opsnull/follow-me-install-kubernetes-cluster/blob/master/09-部署Dashboard插件.md

# scp dashboard.yaml    root@10.1.12.20:/dashboard/dashboard.yaml
# scp heapster.yaml    root@10.1.12.20:/dashboard/heapster.yaml

kubectl cluster-info