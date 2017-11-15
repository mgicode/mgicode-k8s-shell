#http://blog.sina.com.cn/s/blog_704836f40102wryu.html

#download consul1.0 from https://releases.hashicorp.com/consul/1.0.0/consul_1.0.0_linux_amd64.zip
#unzip it and put it into 10.1.12.20/www

#搭建三台物理 ReplicaSet MongoDB

NODE_IPS="10.1.12.73  10.1.12.74  10.1.12.75"
NODE_NAME="consul01 consul02 consul03"

####################1、初始化etcd机器，免证登录，改名，改ip并重启####################

chmod 777 /common/ssh.sh
/common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"



# mkdir -p /consul3/
# cd /consul3/
# wget http://${FILE_SERVER_IP}/consul -q

#consul keygen
