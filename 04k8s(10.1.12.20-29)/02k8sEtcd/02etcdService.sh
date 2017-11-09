# author:pengrk
# email:546711211@qq.com
# qq group:573283836
##################3、生成ectd的安装并进行安装#########################
mkdir -p /etcd/
cd /etcd/

# 3.1环境变量放在/etc/etcd/etcdEnv,证书放在/etc/etcd/ssl/
cd /etcd/
cat > /etcd/etcd.service <<EOF
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
Documentation=https://github.com/coreos

[Service]
EnvironmentFile=/etc/etcd/etcdEnv
Type=notify
WorkingDirectory=/var/lib/etcd/
ExecStart=/usr/local/bin/etcd \\
  --name=\${NODE_NAME} \\
  --cert-file=/etc/etcd/ssl/etcd.pem \\
  --key-file=/etc/etcd/ssl/etcd-key.pem \\
  --peer-cert-file=/etc/etcd/ssl/etcd.pem \\
  --peer-key-file=/etc/etcd/ssl/etcd-key.pem \\
  --trusted-ca-file=/etc/etcd/ssl/ca.pem \\
  --peer-trusted-ca-file=/etc/etcd/ssl/ca.pem \\
  --initial-advertise-peer-urls=https://\${NODE_IP}:2380 \\
  --listen-peer-urls=https://\${NODE_IP}:2380 \\
  --listen-client-urls=https://\${NODE_IP}:2379,http://127.0.0.1:2379 \\
  --advertise-client-urls=https://\${NODE_IP}:2379 \\
  --data-dir=/var/lib/etcd 
  
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

echo -e "\033[32m ###########请检测########### \033[0m"
cat /etcd/etcd.service
echo -e "\033[32m ###########内容显示完成########### \033[0m"
sleep 10