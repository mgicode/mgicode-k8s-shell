# author:pengrk
# email:546711211@qq.com
# qq group:573283836
#初始化机器，免证登录，改名，改ip并重启####################
#把该文件复制到/common/下ssh.sh
ADMIN_IP=10.1.12.20
scp 06ssh.sh root@$ADMIN_IP:/common/ssh.sh 
 ssh root@$ADMIN_IP "cat /common/ssh.sh"