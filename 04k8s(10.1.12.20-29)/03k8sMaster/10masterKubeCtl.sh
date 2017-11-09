# author:pengrk
# email:546711211@qq.com
# qq group:573283836


#3.4 每台主机kubectl连接自己
i=0;
for ip in $NODE_MASTER_IPS ;do
 echo "$ip"
 KUBE_APISERVER="https://${ip}:6443"
 
 #在admin的机器上为每一台master创建自己的kubeconfig的配置文件
 #这样kubectl就可以连接到自己所在master的机器
 kubectl config set-cluster kubernetes  --certificate-authority=/ssl/ca.pem \
  --embed-certs=true   --server=${KUBE_APISERVER}   --kubeconfig=/ssl/master-config$i

 kubectl config set-credentials admin --client-certificate=/ssl/admin.pem \
  --embed-certs=true   --client-key=/ssl/admin-key.pem  --kubeconfig=/ssl/master-config$i

 kubectl config set-context kubernetes  --cluster=kubernetes   --user=admin \
  --kubeconfig=/ssl/master-config$i

 kubectl config use-context kubernetes  --kubeconfig=/ssl/master-config$i

 ssh root@$ip "mkdir -p /root/.kube/;"
 scp /ssl/master-config$i   root@$ip:/root/.kube/config

kubeCtlScript="
    mkdir -p /kubectlWorking/
    cd /kubectlWorking/
    wget http://${FILE_SERVER_IP}/${KUBE_VERSION}/kubectl
    cp -r /kubectlWorking/kubectl  /usr/local/bin/

    echo -e \"\033[32m ###############kubectl是否移动到/usr/local/bin/中########### \033[0m\"
    ls /usr/local/bin/
    echo -e \"\033[32m ###########内容显示完成########### \033[0m\"

    chmod 777  /usr/local/bin/kubectl
    sleep 5
"
ssh root@$ip "$kubeCtlScript"

checkScript="
    echo -e \"\033[32m ###############kubeconfig########### \033[0m\"
     ls ~/.kube/
     kubectl config view
     kubectl get componentstatuses
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"
  "
ssh root@$ip "$checkScript"

sleep 10
let i++;
done










