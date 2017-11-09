# author:pengrk
# email:546711211@qq.com
# qq group:573283836


#3.3 把相关文件发送到etcd机器上，并建立集群
i=0;
for ip in $NODE_MASTER_IPS ;do

  echo "$ip..."
  clearScript="   
    systemctl stop kube-scheduler; 
    systemctl disable kube-apiserver;
    systemctl stop kube-controller-manager; 
    systemctl disable kube-controller-manager;
    systemctl stop kube-apiserver;
    systemctl disable kube-apiserver;

    rm -rf /masterWorking/;
    rm -rf  /etc/kubernetes/;
    rm -rf /etc/systemd/system/kube-apiserver.service;
    rm -rf /etc/systemd/system/kube-controller-manager.service;
    rm -rf /etc/systemd/system/kube-scheduler.service;
  "
 ssh root@$ip "$clearScript"

 ssh root@$ip "mkdir -p /etc/kubernetes/ssl/; mkdir -p /masterWorking/"
 scp /k8s/k8sEvn$i  root@$ip:/etc/kubernetes/k8sEvn 
 scp /k8s/kube-apiserver.service    root@$ip:/etc/systemd/system/kube-apiserver.service
 scp /k8s/kube-controller-manager.service    root@$ip:/etc/systemd/system/kube-controller-manager.service
 scp /k8s/kube-scheduler.service   root@$ip:/etc/systemd/system/kube-scheduler.service

 scp /k8s/install.sh  root@$ip:/etc/kubernetes/install.sh

 scp /ssl/token.csv    root@$ip:/etc/kubernetes/ssl/token.csv 
 scp /ssl/kubernetes.pem   root@$ip:/etc/kubernetes/ssl/kubernetes.pem 
 scp /ssl/kubernetes-key.pem    root@$ip:/etc/kubernetes/ssl/kubernetes-key.pem 

 scp /ssl/ca.pem   root@$ip:/etc/kubernetes/ssl/ca.pem
 scp /ssl/ca-key.pem  root@$ip:/etc/kubernetes/ssl/ca-key.pem

 checkScript="     
    echo -e \"\033[32m ############### /etc/kubernetes/ssl/至少包括ca-key.pem ca.pem kubernetes-key.pem kubernetes.pem token.csv ########### \033[0m\"
    ls /etc/kubernetes/ssl/
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"

    echo -e \"\033[32m ############### /etc/kubernetes/至少包括k8sEvn install.sh ########### \033[0m\"
    ls /etc/kubernetes/
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"
  "
  ssh root@$ip "$checkScript"
 sleep 15
 ssh root@$ip "chmod 777 /etc/kubernetes/install.sh; /etc/kubernetes/install.sh"
 sleep 10
 let i++;
done

#查看安装的状态
echo -e "\033[32m ################查看安装的状态########### \033[0m"
kubectl get componentstatuses
echo -e "\033[32m ###########内容显示完成########### \033[0m"






