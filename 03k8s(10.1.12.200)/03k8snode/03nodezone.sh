
NODE_IPS="10.1.12.207  10.1.12.208 10.1.12.209 10.1.12.210 10.1.12.211 10.1.12.212 10.1.12.213 10.1.12.214"
NODE_NAME="sys01 sys02 sys03 gw01 gw02 ms01 ms02 ms03"

NODE_IPS="10.1.12.206"
NODE_NAME="master"

NODE_IPS="10.1.12.206"
NODE_NAME="master"
for ip in $NODE_IPS ;do
    kubectl label nodes $ip zone=master
done;

NODE_IPS="10.1.12.207  10.1.12.208 10.1.12.209"
NODE_NAME="sys01 sys02 sys03"
for ip in $NODE_IPS ;do
    kubectl label nodes $ip zone=sys
done;


NODE_IPS="10.1.12.207  10.1.12.208 10.1.12.209 10.1.12.210 10.1.12.211 10.1.12.212 10.1.12.213 10.1.12.214"
NODE_NAME="sys01 sys02 sys03 gw01 gw02 ms01 ms02 ms03"
for ip in $NODE_IPS ;do
    kubectl label nodes $ip zone=ms
done;



NODE_IPS="10.1.12.210 10.1.12.211"
NODE_NAME="gw01 gw02"
for ip in $NODE_IPS ;do
    kubectl label nodes $ip ingress=1
done;

ODE_NAME="gw01 gw02"
for ip in $NODE_IPS ;do
    kubectl label nodes $ip gw=1
done;

#kubectl get nodes  grep ms* --show-labels 
kubectl get nodes --show-labels
#kubectl label nodes <your-node-name> disktype=ssd



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