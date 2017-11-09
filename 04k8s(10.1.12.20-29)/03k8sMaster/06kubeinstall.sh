# author:pengrk
# email:546711211@qq.com
# qq group:573283836

mkdir -p /k8s/
cd /k8s/


#3.3 创建安装的shell
cat > /k8s/install.sh <<EOF

mkdir -p /masterWorking/
cd /masterWorking/
wget http://${FILE_SERVER_IP}/${KUBE_VERSION}/kube-apiserver  -q
wget http://${FILE_SERVER_IP}/${KUBE_VERSION}/kube-controller-manager  -q
wget http://${FILE_SERVER_IP}/${KUBE_VERSION}/kube-scheduler  -q

wget http://${FILE_SERVER_IP}/${KUBE_VERSION}/kubectl  -q
wget http://${FILE_SERVER_IP}/${KUBE_VERSION}/kube-proxy  -q
wget http://${FILE_SERVER_IP}/${KUBE_VERSION}/kubelet  -q

cp -r /masterWorking/{kube-apiserver,kube-controller-manager,kube-scheduler} /usr/local/bin/
cp -r /masterWorking/{kubectl,kubelet,kube-proxy} /usr/local/bin/

echo -e "\033[32m ###############至少包括kube-apiserver,kube-controller-manager,kube-scheduler，kubectl,kubelet,kube-proxy五个文件########### \033[0m"
ls /usr/local/bin/
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 8

chmod 777 /usr/local/bin/*
touch /var/lib/audit.log


systemctl daemon-reload
systemctl enable kube-apiserver
systemctl start kube-apiserver
systemctl status kube-apiserver

sleep 15

systemctl daemon-reload
systemctl enable kube-controller-manager
systemctl start kube-controller-manager
systemctl status kube-controller-manager

sleep 15

systemctl daemon-reload
systemctl enable kube-scheduler
systemctl start kube-scheduler
systemctl status  kube-scheduler

sleep 15

EOF

echo -e "\033[32m ###############生成########### \033[0m"
cat /k8s/install.sh
echo -e "\033[32m ###########内容显示完成########### \033[0m"


sleep 2;
