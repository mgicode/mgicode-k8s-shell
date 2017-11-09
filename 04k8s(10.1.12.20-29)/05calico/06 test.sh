# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#https://github.com/opsnull/follow-me-install-kubernetes-cluster/blob/master/07-部署Node节点.md

cat >> /calico/nginx-ds.yml<<EOF
apiVersion: v1
kind: Service
metadata:
  name: nginx-ds
  labels:
    app: nginx-ds
spec:
  type: NodePort
  selector:
    app: nginx-ds
  ports:
  - name: http
    port: 80
    targetPort: 80

---

apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: nginx-ds
  labels:
    addonmanager.kubernetes.io/mode: Reconcile
spec:
  template:
    metadata:
      labels:
        app: nginx-ds
    spec:
      containers:
      - name: my-nginx
        image: 10.1.12.61:5000/nginx:1.7.9
        ports:
        - containerPort: 80

EOF

kubectl delete  -f /calico/nginx-ds.yml

kubectl create -f /calico/nginx-ds.yml

kubectl get nodes
 kubectl get pods  -o wide|grep nginx-ds 
 kubectl get svc |grep nginx-ds

  kubectl exec  nginx-ds-cs63x  -i -t -- /bin/bash