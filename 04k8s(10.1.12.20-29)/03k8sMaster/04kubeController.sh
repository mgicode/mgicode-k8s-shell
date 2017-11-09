# author:pengrk
# email:546711211@qq.com
# qq group:573283836

mkdir -p /k8s/
cd /k8s/


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

echo -e "\033[32m ###############生成########### \033[0m"
cat /k8s/kube-controller-manager.service 
echo -e "\033[32m ###########内容显示完成########### \033[0m"



sleep 5
