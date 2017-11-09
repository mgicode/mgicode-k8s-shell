# author:pengrk
# email:546711211@qq.com
# qq group:573283836


#3.3 创建安装的shell
cat > /k8s/install-client.sh <<EOF

echo " export PATH=/usr/local/bin:$PATH " >> /etc/profile
source /etc/profile

mkdir -p /nodeWorking/
cd /nodeWorking/

chmod 777 /etc/kubernetes/*
wget http://${FILE_SERVER_IP}/${KUBE_VERSION}/kubectl  -q
wget http://${FILE_SERVER_IP}/${KUBE_VERSION}/kube-proxy   -q
wget http://${FILE_SERVER_IP}/${KUBE_VERSION}/kubelet   -q
cp -r /nodeWorking/{kubectl,kube-proxy,kubelet} /usr/local/bin/
chmod 777 /usr/local/bin/*

echo -e "\033[32m ###############至少包括{kubectl,kube-proxy,kubelet三个文件########### \033[0m"
ls /usr/local/bin/
echo -e "\033[32m ###########内容显示完成########### \033[0m"

 mkdir  -p /var/lib/kubelet/ 
 mkdir -p /var/lib/kube-proxy/


 systemctl daemon-reload
 systemctl enable kubelet
 systemctl start kubelet
 systemctl status kubelet

 sleep 3

 systemctl daemon-reload
 systemctl enable kube-proxy
 systemctl start kube-proxy
 systemctl status kube-proxy

 sleep 3

 #授权加入k8s网络
 #kubectl certificate approve \$( kubectl get csr ) 

echo -e \"\033[32m ###############check kubeconfig########### \033[0m\"
ls ~/.kube/
kubectl config view
kubectl get componentstatuses
#显示
kubectl get nodes --show-labels
echo -e \"\033[32m ###############内容显示完成########### \033[0m\"

#journalctl -f
ip addr

EOF

echo -e "\033[32m ############### /k8s/install-client.sh ########### \033[0m"
cat /k8s/install-client.sh
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 2;



#--cluster_domain=\${CLUSTER_DNS_DOMAIN} \\ 
#--cluster_domain=${CLUSTER_DNS_DOMAIN} \


#  vi /etc/systemd/system/kubelet.service
#  cat /etc/systemd/system/kubelet.service


 systemctl daemon-reload
 systemctl restart kube-proxy
 systemctl status kube-proxy