# author:pengrk
# email:546711211@qq.com
# qq group:573283836

# 错误1：
# [ceph_deploy][ERROR ] RuntimeError: Failed to execute command: yum -y install ceph ceph-radosgw
# 解决：
# # sudo  wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
# # sudo yum clean all
# # sudo yum makecache
# # yum install *argparse* -y
# # yum install snappy leveldb gdisk python-argparse gperftools-libs -y 
# http://blog.csdn.net/sinat_36023271/article/details/52402028

# http://blog.csdn.net/gjhnorth/article/details/8949361

# 错误2：
# Another app is currently holding the yum lock; waiting for it to exit…”
# 解决：
# rm -rf /var/run/yum.pid


# 错误3： rbd: image index-api-image is locked by other nodes
#http://tonybai.com/2017/02/17/temp-fix-for-pod-unable-mount-cephrbd-volume/
#http://tonybai.com/2016/11/07/integrate-kubernetes-with-ceph-rbd/
#rbd lock list rbd/jdk-image
#rbd info rbd/myjdk-image
#rbd disk-usage rbd/myjdk-image
#rbd lock remove  rbd/jdk-image
# 另外 可能的原因是每台机器上master,node都需要安装ceph-common
