#搭建三台物理 ReplicaSet MongoDB

NODE_IPS="10.1.12.70  10.1.12.71  10.1.12.72"
NODE_NAME="mongodb01 mongodb02 mongodb03"

####################1、初始化etcd机器，免证登录，改名，改ip并重启####################

chmod 777 /common/ssh.sh
/common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"

