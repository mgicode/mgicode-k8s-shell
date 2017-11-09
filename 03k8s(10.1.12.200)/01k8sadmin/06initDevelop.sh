#开发K8s环境

NODE_IPS="10.1.12.206  10.1.12.207  10.1.12.208 10.1.12.209 10.1.12.210 10.1.12.211 10.1.12.212 10.1.12.213 10.1.12.214"
NODE_NAME="master sys01 sys02 sys03 gw01 gw02 ms01 ms02 ms03"

####################1、初始化etcd机器，免证登录，改名，改ip并重启####################

chmod 777 /common/ssh.sh
/common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"


# NODE_IPS="10.1.12.206  10.1.12.207 "
# NODE_NAME="master sys01"

# ####################1、初始化etcd机器，免证登录，改名，改ip并重启####################

# chmod 777 /common/ssh.sh
# /common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"


# NODE_IPS="10.1.12.208 10.1.12.209 10.1.12.210 10.1.12.211 10.1.12.212 10.1.12.213 10.1.12.214"
# NODE_NAME="sys02 sys03 gw01 gw02 ms01 ms02 ms03"

# ####################1、初始化etcd机器，免证登录，改名，改ip并重启####################

# chmod 777 /common/ssh.sh
# /common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"


# NODE_IPS="10.1.12.206  10.1.12.207  10.1.12.208 10.1.12.209 10.1.12.210 10.1.12.211 10.1.12.212 10.1.12.213 10.1.12.214"
# NODE_NAME="master sys01 sys02 sys03 gw01 gw02 ms01 ms02 ms03"

# for ip in $NODE_IPS ;do
# ssh root@$ip "sudo yum -y install systemd-* ; reboot"
# sleep 10
# done



NODE_IPS="10.1.12.206  10.1.12.207  10.1.12.208 10.1.12.209 10.1.12.210 10.1.12.211 10.1.12.212 10.1.12.213 10.1.12.214"
NODE_NAME="master sys01 sys02 sys03 gw01 gw02 ms01 ms02 ms03"

####################1、初始化etcd机器，免证登录，改名，改ip并重启####################

chmod 777 /common/temp.sh
/common/temp.sh  "$NODE_IPS"  "$NODE_NAME"
