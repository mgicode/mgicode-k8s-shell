# author:pengrk
# email:546711211@qq.com
# qq group:573283836
#3.2生成三个环境变量文件 
#ETCD_NODES="ectd-01=https://10.1.11.120:2380,etcd-02=https://10.1.11.121:2380,etcd-03=https://10.1.11.122:2380"
ETCD_NODES=""
i=0
NAMES=(${NODE_ETCD_NAMES})
for ip in $NODE_ETCD_IPS ;do
   NAME=${NAMES[$i]}
   if [ $i -eq 0 ]; then
 	  ETCD_NODES="$NAME=https://$ip:2380"
   else
 	  ETCD_NODES="$ETCD_NODES,$NAME=https://$ip:2380"
   fi
   let i++
done
#echo $ETCD_NODES
echo -e "\033[32m ###########ETCD_NODESIPS:$ETCD_NODES########### \033[0m"
echo -e "\033[32m ###########For Example:ectd-01=https://10.1.11.120:2380,etcd-02=https://10.1.11.121:2380,etcd-03=https://10.1.11.122:2380########### \033[0m"

#生成三个环境变量文件 
i=0
NAMES=(${NODE_ETCD_NAMES})
for ip in $NODE_ETCD_IPS ;do
   NAME=${NAMES[$i]} 
cat > /etcd/etcdEnv$i <<EOF
NODE_NAME="${NAME}"
NODE_IP="${ip}"
ETCD_NODES="${ETCD_NODES}"
EOF
   #cat /etcd/etcdEnv$i
   echo -e "\033[32m ###############生成的文件/etcd/etcdEnv$i内容########### \033[0m"
   cat /etcd/etcdEnv$i
   echo -e "\033[32m ###########内容显示完成########### \033[0m"
   sleep 10
   let i++
done;

echo -e "\033[32m ###############生成的文件个数，每个etcd ip分别生成一个########### \033[0m"
ls /etcd/etcdEnv*
echo -e "\033[32m ###########内容显示完成########### \033[0m"
sleep 10