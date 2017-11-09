# author:pengrk
# email:546711211@qq.com
# qq group:573283836

cat >>/dns/my-nginx.yaml<<EOF
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
      containers:
      - name: my-nginx
        image: 10.1.12.61:5000/nginx:1.7.9
        ports:
        - containerPort: 80


EOF

kubectl delete -f /dns/my-nginx.yaml
kubectl create -f /dns/my-nginx.yaml
kubectl expose deploy my-nginx

kubectl get services --all-namespaces |grep my-nginx

#kubectl get pods  -l run=my-nginx -o name

kubectl exec `kubectl get pods  -l run=my-nginx -o name`  -i -t -- /bin/bash