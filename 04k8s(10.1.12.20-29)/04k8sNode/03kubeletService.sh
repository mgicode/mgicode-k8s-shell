# author:pengrk
# email:546711211@qq.com
# qq group:573283836


#######################################################
# 
mkdir -p /k8s/
cd /k8s/
cat > /k8s/kubelet.service <<EOF
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service
[Service]
EnvironmentFile=/etc/kubernetes/k8sCliEvn
WorkingDirectory=/var/lib/kubelet
ExecStart=/usr/local/bin/kubelet \\
  --address=\${NODE_ADDRESS} \\
  --hostname-override=\${NODE_ADDRESS} \\
  --cluster_domain=\${CLUSTER_DNS_DOMAIN} \\
  --pod-infra-container-image=gcr.io/google_containers/pause-amd64:3.0 \\
  --bootstrap-kubeconfig=/etc/kubernetes/bootstrap.kubeconfig \\
  --kubeconfig=/etc/kubernetes/kubelet.kubeconfig \\
  --require-kubeconfig \\
  --cert-dir=/etc/kubernetes/ssl \\
  --cluster_dns=\${CLUSTER_DNS_SVC_IP} \\
  --allow-privileged=true \\
  --serialize-image-pulls=false \\
  --logtostderr=true \\
  --network-plugin=cni \\
  --cni-conf-dir=/etc/cni/net.d \\
  --cni-bin-dir=/opt/cni/bin \\
  --v=2
ExecStopPost=/sbin/iptables -A INPUT -s 10.0.0.0/8 -p tcp --dport 4194 -j ACCEPT
ExecStopPost=/sbin/iptables -A INPUT -s 172.16.0.0/12 -p tcp --dport 4194 -j ACCEPT
ExecStopPost=/sbin/iptables -A INPUT -s 192.168.0.0/16 -p tcp --dport 4194 -j ACCEPT
ExecStopPost=/sbin/iptables -A INPUT -p tcp --dport 4194 -j DROP
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo -e "\033[32m ############### kubelet.service ########### \033[0m"
cat /k8s/kubelet.service
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 5