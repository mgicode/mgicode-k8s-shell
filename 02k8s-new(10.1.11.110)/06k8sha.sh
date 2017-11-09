 # author:pengrk
# email:546711211@qq.com
# qq group:573283836

 
 NODE_IPS="10.1.11.126   10.1.11.127"
 NODE_NAME="k8s-ha-01  k8s-ha-02"

#初始化机器
/common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"


#构建ha的镜像
#docker build -t 10.1.11.60:5000/ha-k8s-master /root/k8s-new/05k8sha/  -f Dockerfile
#docker push 10.1.11.60:5000/ha-k8s-master

#运行
i=1;
for ip in $NODE_IPS ;do
  echo "$ip..."
  ssh root@$ip "/root/bin/docker stop k8s-ha;"
  ssh root@$ip "/root/bin/docker rm k8s-ha;"
  ssh root@$ip "/root/bin/docker rmi 10.1.11.60:5000/ha-k8s-master -f;"
  
  #主机要安装这个，不然不能VIP 报ipvsadm Can't initialize ipvs: Protocol not available
  #ssh root@$ip "yum install -y keepalived"
  ssh root@$ip "yum install -y  ipvsadm; ipvsadm;"

  clearScript='  
  /root/bin/docker run -d  --privileged=true  --net=host  --name k8s-ha  --restart=always --env VIP="10.1.11.128"  \
   --env MASTER01_IP_PORT="10.1.11.123:6443" 	--env MASTER02_IP_PORT="10.1.11.124:6443" 	--env MASTER03_IP_PORT="10.1.11.125:6443"   10.1.11.60:5000/ha-k8s-master ;
   '

ssh root@$ip "$clearScript"
let i++;
done

