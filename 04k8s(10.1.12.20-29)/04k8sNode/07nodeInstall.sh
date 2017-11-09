# author:pengrk
# email:546711211@qq.com
# qq group:573283836

# NODE_NODE_IPS=""
# NODE_NODE_NAMES=""

#3.3 把相关文件发送到etcd机器上，并建立集群
for ip in $NODE_NODE_IPS ;do

  echo "$ip..."
  clearScript="   
    systemctl stop kube-proxy; 
    systemctl disable kube-proxy;
    systemctl stop kubelet; 
    systemctl disable kubelet;

    rm -rf /nodeWorking/;
    rm -rf /etc/kubernetes/k8sCliEvn;
    rm -rf /etc/kubernetes/install-client.sh;
    rm -rf /etc/kubernetes/bootstrap.kubeconfig;
    rm -rf /etc/kubernetes/kube-proxy.kubeconfig;

    rm -rf /etc/systemd/system/kubelet.service;
    rm -rf /etc/systemd/system/kube-proxy.service;
  "
 ssh root@$ip "$clearScript"

 ssh root@$ip "mkdir -p /etc/kubernetes/ssl/; mkdir -p /root/.kube/"
 scp /k8s/k8sCliEvn${ip##*.} root@$ip:/etc/kubernetes/k8sCliEvn 
 scp /k8s/kubelet.service    root@$ip:/etc/systemd/system/kubelet.service
 scp /k8s/kube-proxy.service    root@$ip:/etc/systemd/system/kube-proxy.service

 scp /k8s/install-client.sh  root@$ip:/etc/kubernetes/install-client.sh

 scp /ssl/bootstrap.kubeconfig    root@$ip:/etc/kubernetes/bootstrap.kubeconfig 
 scp /ssl/kube-proxy.kubeconfig    root@$ip:/etc/kubernetes/kube-proxy.kubeconfig 

 scp ~/.kube/config   root@$ip:/root/.kube/config

 checkScript="     
    echo -e \"\033[32m ############### /etc/kubernetes/ssl/至少包括install-client.sh k8sCliEvn bootstrap.kubeconfig kube-proxy.kubeconfig ########### \033[0m\"
    ls /etc/kubernetes/ssl/
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"

    echo -e \"\033[32m ############### /etc/kubernetes/至少包括k8sEvn install.sh ########### \033[0m\"
    ls /etc/kubernetes/
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"
  "
  ssh root@$ip "$checkScript"
 sleep 5

 ssh root@$ip "chmod 777 /etc/kubernetes/install-client.sh; /etc/kubernetes/install-client.sh"
 #sleep 10
done




for ip in $NODE_NODE_IPS ;do
  echo "$ip..."
   checkScript=" 
   systemctl status kubelet
   systemctl status kube-proxy
 "
 ssh root@$ip "$checkScript"
 sleep 5
done



echo -e "\033[32m ###############kubectl get nodes ########### \033[0m"
kubectl get nodes
echo -e "\033[32m ###########内容显示完成########### \033[0m"




for ip in $NODE_NODE_IPS ;do

  echo "$ip..."
  reset="   
 systemctl daemon-reload
 systemctl enable kubelet
 systemctl start kubelet
 systemctl status kubelet
  "
 ssh root@$ip "$reset"
 sleep 10

 kubectl certificate approve $( kubectl get csr ) 
  sleep 5
done

#sudo yum install systemd-*