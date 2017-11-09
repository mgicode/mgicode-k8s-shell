# author:pengrk
# email:546711211@qq.com
# qq group:573283836


ZONE_MASTER_IPS="10.1.12.21"
ZONE_SYS_IPS="10.1.12.22"
ZONE_GW_IPS="10.1.12.23  10.1.12.24"
ZONE_MS_IPS="10.1.12.22 10.1.12.23  10.1.12.24   10.1.12.25   10.1.12.26  10.1.12.27  10.1.12.28  10.1.12.29"

ZONE_MONGODB_IPS="10.1.12.27  10.1.12.28  10.1.12.29"
ZONE_CONSUL_IPS="10.1.12.27  10.1.12.28  10.1.12.29"
ZONE_REDIS_IPS="10.1.12.27  10.1.12.28  10.1.12.29"

for ip in $ZONE_MASTER_IPS ;do
    kubectl label nodes $ip zoneMaster=1
done;

for ip in $ZONE_SYS_IPS ;do
    kubectl label nodes $ip zoneSys=1
done;

for ip in $ZONE_GW_IPS ;do
    kubectl label nodes $ip zoneGw=1
done;

for ip in $ZONE_MS_IPS ;do
    kubectl label nodes $ip zoneMs=1
done;

for ip in $ZONE_MONGODB_IPS ;do
    kubectl label nodes $ip zoneMgDb=1
done;


for ip in $ZONE_REDIS_IPS ;do
    kubectl label nodes $ip zoneRedis=1
done;

for ip in $ZONE_CONSUL_IPS ;do
    kubectl label nodes $ip zoneConsul=1
done;

echo -e "\033[32m ###############kubectl get nodes########### \033[0m"
#kubectl get nodes  grep ms* --show-labels 
kubectl get nodes --show-labels
#kubectl label nodes <your-node-name> disktype=ssd
echo -e "\033[32m ###########内容显示完成########### \033[0m"





# Label（标签）作为用户可灵活定义的对象属性，在已创建的对象上，仍然可以随时通过kubectl label命令对其进行增加、修改、删除等操作。


# 例如，我们要给已创建的Pod“redis-master-bobr0”添加一个标签role=backend：

# $ kubectl label pod redis-master-bobr0 role=backend
# 查看该Pod的Label：

# $ kubectl get pods -Lrole
# NAME                 READY     STATUS    RESTARTS   AGE       ROLE
# redis-master-bobr0   1/1       Running   0          3m        backend
# 删除一个Label，只需在命令行最后指定Label的key名并与一个减号相连即可：

# $ kubectl label pod redis-master-bobr0 role-
# 修改一个Label的值，需要加上--overwrite参数：

# $ kubectl label pod redis-master-bobr0 role=master --overwrite