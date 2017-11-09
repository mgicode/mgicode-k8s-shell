# author:pengrk
# email:546711211@qq.com
# qq group:573283836


mkdir -p /k8s/

#1.7中不需要 --cluster_domain=\${CLUSTER_DNS_DOMAIN} \\
#特别要注册该文件 换行的空格
cat > /k8s/kube-proxy.service <<EOF
[Unit]
Description=Kubernetes Kube-Proxy Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target
[Service]
EnvironmentFile=/etc/kubernetes/k8sCliEvn

WorkingDirectory=/var/lib/kube-proxy

ExecStart=/usr/local/bin/kube-proxy \\
  --bind-address=\${NODE_ADDRESS} \\
  --hostname-override=\${NODE_ADDRESS} \\
  --cluster-cidr=\${SERVICE_CIDR} \\
  --kubeconfig=/etc/kubernetes/kube-proxy.kubeconfig \\
  --logtostderr=true \\
  --proxy-mode=iptables \\
  --v=2

Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

echo -e "\033[32m ############### /k8s/kubelet.service ########### \033[0m"
cat  /k8s/kube-proxy.service
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 5


# 多了不支持的参数，不报错，但是不编译${}

# 10月 30 18:33:18 node6 systemd[1]: kube-proxy.service lacks both ExecStart= and ExecStop= setting. Refusing.
# 10月 30 18:33:18 node6 systemd[1]: [/etc/systemd/system/kube-proxy.service:8] Trailing garbage, ignoring.
# 10月 30 18:33:18 node6 systemd[1]: [/etc/systemd/system/kube-proxy.service:9] Unknown lvalue '--kubeconfig' in section 'Service'
# 10月 30 18:33:18 node6 systemd[1]: kube-proxy.service lacks both ExecStart= and ExecStop= setting. Refusing.
# 10月 30 18:33:22 node6 systemd[1]: [/etc/systemd/system/kube-proxy.service:8] Trailing garbage, ignoring.
# 10月 30 18:33:22 node6 systemd[1]: [/etc/systemd/system/kube-proxy.service:9] Unknown lvalue '--kubeconfig' in section 'Service'
# 10月 30 18:33:22 node6 systemd[1]: kube-proxy.service lacks both ExecStart= and ExecStop= setting. Refusing.
# 10月 30 18:33:22 node6 systemd[1]: [/etc/systemd/system/kube-proxy.service:8] Trailing garbage, ignoring.
# 10月 30 18:33:22 node6 systemd[1]: [/etc/systemd/system/kube-proxy.service:9] Unknown lvalue '--kubeconfig' in section 'Service'
# 10月 30 18:33:22 node6 systemd[1]: kube-proxy.service lacks both ExecStart= and ExecStop= setting. Refusing.

