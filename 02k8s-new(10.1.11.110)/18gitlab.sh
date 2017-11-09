# author:pengrk
# email:546711211@qq.com
# qq group:573283836

 NODE_IPS="10.1.11.111   10.1.11.112  10.1.11.113  10.1.11.115"
 NODE_NAME="registry  nexus  gitlab jenkins "

#初始化机器
/common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"



docker pull  registry.cn-hangzhou.aliyuncs.com/devops/gitlab-ce:9.1.1-ce.0
docker tag   registry.cn-hangzhou.aliyuncs.com/devops/gitlab-ce:9.1.1-ce.0  10.1.11.60:5000/gitlab-ce:9.1.1-ce.0
docker push  10.1.11.60:5000/gitlab-ce:9.1.1-ce.0

ssh root@10.1.11.113 

#配置文件所在的目录
mkdir -p /etc/gitlab/ 
#日志所在目录
mkdir -p /var/log/gitlab/
#数据所在目录
mkdir -p /var/opt/gitlab/

# -h 10.1.11.113  为了生成其IP相同的路径
docker run -d -p 80:80 \
-h 10.1.11.113  \
-v /etc/gitlab/:/etc/gitlab/ \
-v /var/log/gitlab/:/var/log/gitlab/ \
-v /var/opt/gitlab/:/var/opt/gitlab/ \
--name gitlab \
--restart=always \
--net=host \
10.1.11.60:5000/gitlab-ce:9.1.1-ce.0


#如果开始没有指定其-h 10.1.11.113，那么可以

# docker stop gitlab 

# docker run -d -p 80:80 \
# -h 10.1.11.113  \
# -v /etc/gitlab/:/etc/gitlab/ \
# -v /var/log/gitlab/:/var/log/gitlab/ \
# -v /var/opt/gitlab/:/var/opt/gitlab/ \
# --name gitlab1 \
# --restart=always \
# --net=host \
# 10.1.11.60:5000/gitlab-ce:9.1.1-ce.0

#因为其文件存的地方没有变，所有的数据都没有改变，只是改变了其显示的git路径




# docker run -d -h gitlab.jxgs.com -p 80:80 \
# -v /etc/gitlab/:/etc/gitlab/ \
# -v /var/log/gitlab/:/var/log/gitlab/ \
# -v /var/opt/gitlab/:/var/opt/gitlab/ \
# --name gitlab \
# --restart=always \
# --net=host \
# 10.1.11.60:5000/gitlab-ce:9.1.1-ce.0

