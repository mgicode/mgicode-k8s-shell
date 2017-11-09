cd /root/k8s-new/10dns/
kubectl create -f .

#dns的文档
#https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/


#Check if the DNS pod is running
kubectl get pods --namespace=kube-system -l k8s-app=kube-dns

#Is DNS service up?
kubectl get svc --namespace=kube-system

#Check for Errors in the DNS pod
kubectl logs --namespace=kube-system $(kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name) -c kubedns
kubectl logs --namespace=kube-system $(kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name) -c dnsmasq
kubectl logs --namespace=kube-system $(kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name) -c sidecar