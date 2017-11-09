# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#hostpath的存储需要权限，不然不能读写指定的consuldata目录
for ip in $ZONE_REDIS_IPS ;do
  echo "$ip..."
 ssh root@$ip " mkdir -p /redisData/data/; chmod 777 /mongodb/data; ls -l;"
 sleep 5

done

kubectl delete -f /redis/redis.yaml
kubectl create -f /redis/redis.yaml
