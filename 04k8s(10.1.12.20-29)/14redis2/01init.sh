NODE_IPS="10.1.12.76  10.1.12.77"
NODE_NAME="redis01 redis02 "

####################1、初始化etcd机器，免证登录，改名，改ip并重启####################

chmod 777 /common/ssh.sh
/common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"
