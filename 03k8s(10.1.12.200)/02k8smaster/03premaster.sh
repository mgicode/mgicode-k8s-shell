FILE_SERVER_IP="10.1.12.200"
KUBE_VERSION="1.7.6"

mkdir -p /k8s/
cd /k8s/

cat  > /k8s/kube-apiserver.service <<EOF
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target

[Service]
EnvironmentFile=/etc/kubernetes/k8sEvn
ExecStart=/usr/local/bin/kube-apiserver \\
  --admission-control=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \\
  --advertise-address=\${MASTER_IP} \\
  --service-cluster-ip-range=\${SERVICE_CIDR} \\
  --bind-address=\${MASTER_IP} \\
  --insecure-bind-address=\${MASTER_IP} \\
  --authorization-mode=RBAC \\
  --runtime-config=rbac.authorization.k8s.io/v1alpha1 \\
  --kubelet-https=true \\
  --experimental-bootstrap-token-auth \\
  --token-auth-file=/etc/kubernetes/ssl/token.csv \\
  --tls-cert-file=/etc/kubernetes/ssl/kubernetes.pem \\
  --tls-private-key-file=/etc/kubernetes/ssl/kubernetes-key.pem \\
  --client-ca-file=/etc/kubernetes/ssl/ca.pem \\
  --service-account-key-file=/etc/kubernetes/ssl/ca-key.pem \\
  --etcd-cafile=/etc/kubernetes/ssl/ca.pem \\
  --etcd-certfile=/etc/kubernetes/ssl/kubernetes.pem \\
  --etcd-keyfile=/etc/kubernetes/ssl/kubernetes-key.pem \\
  --etcd-servers=\${ETCD_ENDPOINTS} \\
  --enable-swagger-ui=true \\
  --allow-privileged=true \\
  --apiserver-count=3 \\
  --audit-log-maxage=30 \\
  --audit-log-maxbackup=3 \\
  --audit-log-maxsize=100 \\
  --audit-log-path=/var/lib/audit.log \\
  --event-ttl=1h \\
  --v=2
Restart=on-failure
RestartSec=5
Type=notify
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF
cat  /k8s/kube-apiserver.service
sleep 5


cat >/k8s/kube-controller-manager.service <<EOF
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
EnvironmentFile=/etc/kubernetes/k8sEvn
ExecStart=/usr/local/bin/kube-controller-manager \\
  --address=127.0.0.1 \\
  --master=http://\${MASTER_IP}:8080 \\
  --allocate-node-cidrs=true \\
  --service-cluster-ip-range=\${SERVICE_CIDR} \\
  --cluster-cidr=\${CLUSTER_CIDR} \\
  --cluster-name=kubernetes \\
  --cluster-signing-cert-file=/etc/kubernetes/ssl/ca.pem \\
  --cluster-signing-key-file=/etc/kubernetes/ssl/ca-key.pem \\
  --service-account-private-key-file=/etc/kubernetes/ssl/ca-key.pem \\
  --root-ca-file=/etc/kubernetes/ssl/ca.pem \\
  --leader-elect=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
cat /k8s/kube-controller-manager.service 
sleep 5


cat > /k8s/kube-scheduler.service <<EOF
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
[Service]
EnvironmentFile=/etc/kubernetes/k8sEvn
ExecStart=/usr/local/bin/kube-scheduler \\
  --address=127.0.0.1 \\
  --master=http://\${MASTER_IP}:8080 \\
  --leader-elect=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
cat /k8s/kube-scheduler.service
sleep 5





#3.3 创建安装的shell
cat > /k8s/install.sh <<EOF

mkdir -p /working/
cd /working/
wget http://${FILE_SERVER_IP}/${KUBE_VERSION}/kube-apiserver
wget http://${FILE_SERVER_IP}/${KUBE_VERSION}/kube-controller-manager
wget http://${FILE_SERVER_IP}/${KUBE_VERSION}/kube-scheduler

wget http://${FILE_SERVER_IP}/${KUBE_VERSION}/kubectl
wget http://${FILE_SERVER_IP}/${KUBE_VERSION}/kube-proxy
wget http://${FILE_SERVER_IP}/${KUBE_VERSION}/kubelet

cp -r /working/{kube-apiserver,kube-controller-manager,kube-scheduler} /usr/local/bin/
cp -r /working/{kubectl,kubelet,kube-proxy} /usr/local/bin/

chmod 777 /usr/local/bin/*
touch /var/lib/audit.log


systemctl daemon-reload
systemctl enable kube-apiserver
systemctl start kube-apiserver
systemctl status kube-apiserver

systemctl daemon-reload
systemctl enable kube-controller-manager
systemctl start kube-controller-manager
systemctl status kube-controller-manager

systemctl daemon-reload
systemctl enable kube-scheduler
systemctl start kube-scheduler
systemctl status  kube-scheduler

EOF
cat /k8s/install.sh
sleep 2;
