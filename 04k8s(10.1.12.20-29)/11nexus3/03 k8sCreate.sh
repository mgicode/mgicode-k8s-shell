# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#hostpath的存储需要权限，不然不能读写指定的consuldata目录
for ip in $ZONE_REDIS_IPS ;do
  echo "$ip..."
 ssh root@$ip " mkdir -p /nexusData/data/; chmod 777 /nexusData/data; ls -l;"
 sleep 5

done

ssh root@10.1.12.28   " mkdir -p /nexusData/data/; chmod 777 /nexusData/data; ls -l;"

kubectl delete -f /nexus3/nexus.yaml
kubectl create -f /nexus3/nexus.yaml
