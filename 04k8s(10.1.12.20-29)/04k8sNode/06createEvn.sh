# author:pengrk
# email:546711211@qq.com
# qq group:573283836


##3.1 第一次运行时必须先运行07node/initFirst.sh 
#生成/k8s/kubelet.service、/k8s/install-client.sh、/k8s/install-client.sh及相关的证书

# NODE_NODE_IPS=""
# NODE_NODE_NAMES=""
#3.2生成三个环境变量文件 
for ip in $NODE_NODE_IPS ;do
cat > /k8s/k8sCliEvn${ip##*.} <<EOF
NODE_ADDRESS="${ip}"
CLUSTER_DNS_SVC_IP="${CLUSTER_DNS_SVC_IP}"
CLUSTER_DNS_DOMAIN="${CLUSTER_DNS_DOMAIN}"
SERVICE_CIDR="${SERVICE_CIDR}"

EOF

echo -e "\033[32m ###############/k8s/k8sCliEvn${ip##*.} ########### \033[0m"
cat /k8s/k8sCliEvn${ip##*.}
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 5
done;

