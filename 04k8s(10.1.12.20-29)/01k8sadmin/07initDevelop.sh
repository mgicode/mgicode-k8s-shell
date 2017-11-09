# author:pengrk
# email:546711211@qq.com
# qq group:573283836

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

NODE_IPS="10.1.12.21  10.1.12.22"
NODE_NAME="master sys "

####################1、初始化etcd机器，免证登录，改名，改ip并重启####################

chmod 777 /common/ssh.sh
echo -e "\033[32m ###########检查/common/是否包含 init.sh  ssh.sh ########### \033[0m"
ls /common/
echo -e "\033[32m ###########内容显示完成########### \033[0m"
/common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"


NODE_NODE_IPS="10.1.12.23  10.1.12.24   10.1.12.25   10.1.12.26  10.1.12.27  10.1.12.28  10.1.12.29"
NODE_NODE_NAMES="node3 node4  node5  node6  node7 node8  node9"
echo -e "\033[32m ###########检查/common/是否包含 init.sh  ssh.sh ########### \033[0m"
ls /common/
echo -e "\033[32m ###########内容显示完成########### \033[0m"
/common/ssh.sh  "$NODE_NODE_IPS"  "$NODE_NODE_NAMES"


NODE_NODE_IPS="10.1.12.63  10.1.12.64 "
NODE_NODE_NAMES="test-tools1 test-tools2"
echo -e "\033[32m ###########检查/common/是否包含 init.sh  ssh.sh ########### \033[0m"
ls /common/
echo -e "\033[32m ###########内容显示完成########### \033[0m"
/common/ssh.sh  "$NODE_NODE_IPS"  "$NODE_NODE_NAMES"


NODE_NODE_IPS="10.1.12.60 "
NODE_NODE_NAMES="nexus"
echo -e "\033[32m ###########检查/common/是否包含 init.sh  ssh.sh ########### \033[0m"
ls /common/
echo -e "\033[32m ###########内容显示完成########### \033[0m"
/common/ssh.sh  "$NODE_NODE_IPS"  "$NODE_NODE_NAMES"
