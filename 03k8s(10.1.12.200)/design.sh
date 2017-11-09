# 一、管理机
#   1、admin 10.1.12.200  （建WEB服务器）
#       所有的脚本都在其上运行，通过它控制k8s，生成ssh 免密证书，发给所有MASTER、NODE节点，可以         在虚拟机模板中做好，（最好加上当前自己机器的证书）
#       开发的web服务器，如10.1.11.20一样，方便下载,把通用的下载放到该Web服务器上来
#       (采用docker+jdk+tomcat实现，把webapp volumn到主机
  

# 二、开发部署工具
#    1、私有镜像库 10.1.12.201 ，  以前用的是10.1.11.60:5000
#          一部分公用镜像放到阿里云上去，内部的镜像放到该镜像库中
#          目前只能用一个，之后采用两台（分布式存储）+keeplived高可用
#    2、10.1.12.202    Nexus   Jar包服务器(使用目前的192.168.1.120:8081)
#    3、gitLab 10.1.12.203  (不用，使用192.168.1.120）
#    4、Jenkins  10.1.12.204（手动或自动发布到开发k8s中）    10.1.12.205 （直接发布测试k8s中）
#    5、模板IP   10.1.12.251 ，10.1.12.251

# 三、开发K8s环境
#  1、master 10.1.12.206   （含etcd） 单台
#  2、DNS、DashBoard、Heapster、consul  10.1.12.207~10.1.12.209
#  3、gateway网关 10.1.12.210~10.1.12.211
#  4、微服务：10.1.12.210~10.1.12.211、10.1.12.212~10.1.12.214 

# 四、测试K8s环境（仿生产环境）
#      MASTER:
#             1、三台Master 和ETCD   10.1.12.220   10.1.11.221  10.1.11.222
#                  (先采用物理机安装，采用容器实现，如果需要使用ceph等存储，master最好在物理机上安装）
#             2、二台Keeperalived+Haproxy  10.1.12.223   10.1.12.224  vip:10.1.12.225
#                  (采用docker容器实现，能采用k8s实现最好）
#      System:   10.1.12 226-10.1.12.234     
#            DNS、DashBoard、Heapster、EFK、Consul  
#      Gateway:  10.1.12.235~10.1.12.242 (包括ingress)
#      微服务: 10.1.12.243~10.1.12.249  10.1.12.235~10.1.12.242 

#     存储：mongdb,rabbitmq,redis 集群  (10.1.12.180~10.1.12.199)
#                Ceph、NFS



#linux网络工具：

traceroute nslookup dig  telnet ping ifconfig ip iptables 
lsof tcpdump netstat iftop nc  route brctl mtr ss curl wget axel ipset netstat

