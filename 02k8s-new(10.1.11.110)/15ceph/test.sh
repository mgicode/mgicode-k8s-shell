# author:pengrk
# email:546711211@qq.com
# qq group:573283836


#开始集成ceph和kuberntes
# 1 禁用rbd features

for ip in $NODE_IPS ;do 
echo "$ip中禁用rbd features..."

ssh root@$ip "echo 'rbd_default_features = 1' >>/etc/ceph/ceph.conf "
ssh root@$ip "ceph --show-config|grep rbd|grep features "

sleep 5
done

#在ceph-admin上：
ceph auth get-key client.admin
#resust: AQBiFzlZEWlsGxAAnFLrQXDC/6j12t514Tb9KQ==

echo `ceph auth get-key client.admin`|base64
#reust: QVFCaUZ6bFpFV2xzR3hBQW5GTHJRWERDLzZqMTJ0NTE0VGI5S1E9PQo=

#创建ceph-secret.yaml文件，data下的key字段值即为上面得到的编码值：
#见文件

#在110:
kubectl create -f ceph-secret.yaml
kubectl get secret


#在200上：
rbd create jdk-image -s 1G
rbd info jdk-image


#110上：
#创建jdk-pv.yaml，见文件
kubectl create -f jdk-pv.yaml
kubectl get pv

kubectl create -f jdk-pvc.yaml
kubectl get pvc

#创建 ceph-busyboxpod.yaml
kubectl create -f ceph-busyboxpod.yaml

