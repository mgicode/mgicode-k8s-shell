cat >/root/my-nginx.yaml << EOF 
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: my-nginx
spec:
  replicas: 2
  template:
    metadata:
      labels:
        run: my-nginx
    spec:
      nodeSelector:
        zone: ms
      containers:
      - name: my-nginx
        image: 10.1.12.201:5000/nginx:1.7.9
        ports:
        - containerPort: 80
EOF

kubectl delete svc my-nginx
kubectl delete dp my-nginx

kubectl create -f /root/my-nginx.yaml

kubectl expose deploy my-nginx

kubectl get services --all-namespaces |grep my-nginx

kubectl exec my-nginx cat /etc/resolv.conf

# create other pod 
cat >/root/pod-nginx.yaml<< EOF 
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  nodeSelector:
    zone: ms
  containers:
  - name: nginx
    image: 10.1.12.201:5000/nginx:1.7.9
    ports:
    - containerPort: 80
EOF

kubectl delete pod nginx
kubectl create -f /root/pod-nginx.yaml


kubectl exec  nginx -i -t -- /bin/bash


kubectl cluster-info dump

kubectl exec -ti nginx -- nslookup kubernetes.default
