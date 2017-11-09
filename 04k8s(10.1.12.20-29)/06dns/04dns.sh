# author:pengrk
# email:546711211@qq.com
# qq group:573283836

cd /dns/
kubectl delete -f  /dns/dns.yaml
kubectl create -f  /dns/dns.yaml

#dns的文档
#https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/


#Check if the DNS pod is running
kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o wide

kubectl describe `kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name` -n kube-system
#Is DNS service up?
kubectl get svc --namespace=kube-system

#Check for Errors in the DNS pod
kubectl logs --namespace=kube-system $(kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name) -c kubedns
kubectl logs --namespace=kube-system $(kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name) -c dnsmasq
kubectl logs --namespace=kube-system $(kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name) -c sidecar