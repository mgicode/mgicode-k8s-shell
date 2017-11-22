NODE_IPS="10.1.12.80  10.1.12.81"
NODE_NAME="balance01  balance02 "

####################1、初始化etcd机器，免证登录，改名，改ip并重启####################

chmod 777 /common/ssh.sh
/common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"


#第一步先做 KeepAlived、HAProxy、consulTemplate