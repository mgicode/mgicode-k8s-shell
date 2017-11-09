# author:pengrk
# email:546711211@qq.com
# qq group:573283836

mkdir -p /k8s/
cd /k8s/


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

echo -e "\033[32m ###############生成########### \033[0m"
cat /k8s/kube-scheduler.service
echo -e "\033[32m ###########内容显示完成########### \033[0m"


sleep 5


