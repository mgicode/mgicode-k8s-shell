# author:pengrk
# email:546711211@qq.com
# qq group:573283836


mkdir -p /k8s/
cd /k8s/

#3.2生成三个环境变量文件 
i=0
for ip in $NODE_MASTER_IPS ;do
cat > /k8s/k8sEvn$i <<EOF
SERVICE_CIDR="${SERVICE_CIDR}"
CLUSTER_CIDR="${CLUSTER_CIDR}"
MASTER_IP="${ip}"
ETCD_ENDPOINTS="${ETCD_ENDPOINTS}"
EOF
echo -e "\033[32m ###############生成/k8s/k8sEvn$i########### \033[0m"
cat /k8s/k8sEvn$i
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 5
let i++
done;
