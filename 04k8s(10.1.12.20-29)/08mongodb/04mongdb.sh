# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#hostpath的存储需要权限，不然不能读写指定的consuldata目录
for ip in $ZONE_MONGODB_IPS ;do
  echo "$ip..."
 ssh root@$ip " mkdir -p /mongodbData/data/; chmod 777 /mongodb/data; ls -l;"
 sleep 5

done

kubectl delete -f /mongodb/mongdb.yaml
kubectl create -f /mongodb/mongdb.yaml

kubectl describe po  mongo-db-0
#通过docker能运行
docker run  --name mongodb  -v /data/db/:/data/db/  -p 27017:27017  -d  10.1.12.61:5000/mongo:3.4.4
docker exec -it mongodb /bin/bash
docker exec -it mongodb  sh