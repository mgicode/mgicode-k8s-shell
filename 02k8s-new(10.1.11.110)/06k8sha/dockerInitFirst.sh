# author:pengrk
# email:546711211@qq.com
# qq group:573283836


mkdir -p /calico/
cd /calico/
#证书文件放在master主机上，需要通过volumn挂到容器上去
cat  > /calico/calico-node.service <<EOF
[Unit]
Description=calico-node
After=docker.service
Requires=docker.service

[Service]
EnvironmentFile=/etc/calico/calico.env
ExecStartPre=-/root/bin/docker rm -f calico-node
ExecStart=/root/bin/docker run --net=host --privileged \\
 --name=calico-node \\
 -e NODENAME=\${CALICO_NODENAME} \\
 -e IP=\${CALICO_IP} \\
 -e IP6=\${CALICO_IP6} \\
 -e CALICO_NETWORKING_BACKEND=\${CALICO_NETWORKING_BACKEND} \\
 -e AS=\${CALICO_AS} \\
 -e NO_DEFAULT_POOLS=\${CALICO_NO_DEFAULT_POOLS} \\
 -e CALICO_LIBNETWORK_ENABLED=\${CALICO_LIBNETWORK_ENABLED} \\
 -e ETCD_ENDPOINTS=\${ETCD_ENDPOINTS} \\
 -e ETCD_CA_CERT_FILE=\${ETCD_CA_FILE} \\
 -e ETCD_CERT_FILE=\${ETCD_CERT_FILE} \\
 -e ETCD_KEY_FILE=\${ETCD_KEY_FILE} \\
 -v /var/log/calico:/var/log/calico \\
 -v /run/docker/plugins:/run/docker/plugins \\
 -v /lib/modules:/lib/modules \\
 -v /var/run/calico:/var/run/calico \\
 -v /etc/calico/ssl/:/etc/calico/ssl/ \\
    10.1.11.60:5000/calico_node:V1.2.1

ExecStop=-/root/bin/docker stop calico-node

Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cat  /calico/calico-node.service 
sleep 5


#3.3 创建安装的shell
cat > /calico/install.sh <<EOF
systemctl daemon-reload
systemctl enable calico-node
systemctl start calico-node
systemctl status  calico-node
EOF
cat /calico/install.sh
sleep 2;


