# author:pengrk
# email:546711211@qq.com
# qq group:573283836


#1、做免密等处理

#在110上运行
NODE_IPS="10.1.11.200  10.1.11.201  10.1.11.202  10.1.11.203  10.1.11.204  10.1.11.205"
NODE_NAME="ceph-admin  mon1  osd1  osd2  osd3  client"
########3初始化机器###################
/common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"
########3初始化机器###################

#在110上运行
NODE_IPS="10.1.11.200"
NODE_NAME="ceph-admin"
########3初始化机器###################
/common/ssh.sh  "$NODE_IPS"  "$NODE_NAME"
########3初始化机器###################

NAMES=(${NODE_NAME})


for ip in $NODE_IPS ;do 
echo "$ip中加入hostname..."
mhost='  
cat >>/etc/hosts <<EOF
10.1.11.200 ceph-admin  
10.1.11.201  mon1  
10.1.11.202  osd1 
10.1.11.203  osd2
10.1.11.204  osd3
10.1.11.205  client
EOF
'
ssh root@$ip "$mhost"
ssh root@$ip "cat  /etc/hosts "
sleep 5
done

for ip in $NODE_IPS ;do 
  echo "$ip中加入hostname..."
   ssh root@$ip " sed -i s'/Defaults requiretty/#Defaults requiretty'/g /etc/sudoers "
   ssh root@$ip " echo  'Defaults visiblepw' >> /etc/sudoers"
   ssh root@$ip " yum install -y ntp ntpdate ntp-doc"
   ssh root@$ip " ntpdate 0.us.pool.ntp.org"
   ssh root@$ip " hwclock --systohc"
   ssh root@$ip " systemctl enable ntpd.service"
   ssh root@$ip " systemctl start ntpd.service"
   ssh root@$ip " yum install -y open-vm-tools"
    
  sleep 2
done


# Requires: libleveldb.so.1()(64bit) 有一些依赖需要 aliyun的yum才有，不然
for ip in $NODE_IPS ;do 
  echo "$ip中加入基本的epel .."
   ssh root@$ip "  wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo "
   ssh root@$ip " yum clean all "
   ssh root@$ip " yum makecache "
   ssh root@$ip " yum install *argparse* -y "
   ssh root@$ip " yum install snappy leveldb gdisk python-argparse gperftools-libs -y  "
  sleep 2
done


#在200机器上


 cat > ~/.ssh/config <<EOF

Host ceph-admin
        Hostname ceph-admin
        User root
 
Host mon1
        Hostname mon1
        User root
 
Host osd1
        Hostname osd1
        User root
 
Host osd2
        Hostname osd2
        User root
 
Host osd3
        Hostname osd3
        User root
 
Host client
        Hostname client
        User root
EOF

chmod 644 ~/.ssh/config
ssh-keygen
ssh-keyscan osd1 osd2 osd3 mon1 client >> ~/.ssh/known_hosts


ssh-copy-id osd1
ssh-copy-id osd2
ssh-copy-id osd3
ssh-copy-id mon1
ssh-copy-id client

ssh osd1


mkdir cluster
cd cluster/
sudo rpm -Uhv http://cn.ceph.com/rpm-kraken/el7/noarch/ceph-release-1-1.el7.noarch.rpm
sudo yum install ceph-deploy -y


#ceph-deploy new mon1 mon2 mon3
ceph-deploy new mon1

echo  "osd pool default size = 2 " >>/root/cluster/ceph.conf
#echo  "public_network = 192.168.92.0/6789" >>/root/cluster/ceph.conf


#注意这里 需要 指定--repo-url，不然43%  300m超时
ceph-deploy install ceph-admin mon1 osd1 osd2 osd3  client \
--repo-url=http://cn.ceph.com/rpm-kraken/el7/  \
--gpg-url=http://cn.ceph.com/keys/release.asc


ceph-deploy mon create-initial
ceph-deploy gatherkeys mon1


#创建磁盘,手动添加虚拟机盘，然后格式化
ssh osd1
fdisk -l /dev/sdb ;
parted -s /dev/sdb mklabel gpt mkpart primary xfs 0% 100% ;
mkfs.xfs /dev/sdb -f ;
blkid -o value -s TYPE /dev/sdb ;
exit

ssh osd2 
fdisk -l /dev/sdb ;
parted -s /dev/sdb mklabel gpt mkpart primary xfs 0% 100% ;
mkfs.xfs /dev/sdb -f ;
blkid -o value -s TYPE /dev/sdb ;
exit

ssh osd3
fdisk -l /dev/sdb ;
parted -s /dev/sdb mklabel gpt mkpart primary xfs 0% 100% ;
mkfs.xfs /dev/sdb -f ;
blkid -o value -s TYPE /dev/sdb ;
exit

ceph-deploy disk list osd1 osd2 osd3
ceph-deploy disk zap osd1:/dev/sdb osd2:/dev/sdb osd3:/dev/sdb
#接下来通过admin-node节点的ceph-deploy开启其他节点osd进程，并激活
ceph-deploy  osd prepare osd1：/dev/sdb  osd2:/dev/sdb  osd3:/dev/sdb
ceph-deploy osd  active  osd1：/dev/sdb    osd2:/dev/sdb   osd3:/dev/sdb
ceph-deploy disk list osd1 osd2 osd3


#把配置文件发给每个节点上
ceph-deploy admin ceph-admin mon1 osd1 osd2 osd3 client
for ip in $NODE_IPS ;do 
echo "$ip..."
ssh root@$ip "chmod 644 /etc/ceph/ceph.client.admin.keyring"
sleep 5
done


#Step 6 - Testing the Ceph setup
ssh mon1
ceph health


for ip in $NODE_IPS ;do 
echo "$ip中禁用rbd features..."

ssh root@$ip "echo 'rbd_default_features = 1' >>/etc/ceph/ceph.conf "
ssh root@$ip "ceph --show-config|grep rbd|grep features "

sleep 5
done




####################################################################3
#110上, 从ceph-admin复制相关配置文件
mkdir /ceph/
scp  root@10.1.11.200:/root/cluster/*  /ceph/
ls  /ceph/



NODE_IPS="10.1.11.150  10.1.11.151 10.1.11.152  10.1.11.153 10.1.11.154 10.1.11.155  10.1.11.156"
NODE_NAME="ms150  ms151 ms152  ms153   ms154   ms155   ms156"

NODE_IPS="10.1.11.123   10.1.11.124  10.1.11.125"
NODE_NAME="master-01  master-02  master-03"


NODE_IPS="10.1.11.140  10.1.11.141 10.1.11.142  10.1.11.143  10.1.11.144  10.1.11.145"
NODE_NAME="msc140  msc141  msc142  msc143  msc144   msc145"


NODE_IPS="10.1.11.170  10.1.11.171 10.1.11.172  10.1.11.173  10.1.11.174  10.1.11.175  10.1.11.176  10.1.11.177  10.1.11.178   10.1.11.179"
NODE_NAME="base170  base171  base172  base173  base174  base175  base176  base177  base178   base179"




NODE_IPS="10.1.11.130  10.1.11.131 10.1.11.132  10.1.11.133  10.1.11.134  10.1.11.135  10.1.11.136  10.1.11.137 10.1.11.138  10.1.11.139"
NODE_NAME="sys130 sys131  sys132  sys133  sys134  sys135  sys136  sys137  sys138  sys139"
NODE_IPS="10.1.11.190  10.1.11.191 10.1.11.192  10.1.11.193"
NODE_NAME="ingress190 ingress191  ingress192  ingress193"


for ip in $NODE_IPS ;do

  echo "$ip创建ceph的环境..."
  script=" 
    #rm -f /var/run/yum.pid
    rpm -Uvh http://download.ceph.com/rpm-kraken/el7/noarch/ceph-release-1-1.el7.noarch.rpm
    echo '#############$ip http://mirrors.aliyun.com/repo/epel-7.repo ################\n\n'
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
    yum clean all
    yum makecache
    echo '############$ip yum install snappy leveldb gdisk python-argparse gperftools-libs -y#################\n\n'
    yum install snappy leveldb gdisk python-argparse gperftools-libs -y
    echo '#############$ip yum list ceph-common ################\n\n'
    yum list ceph-common
"
ssh root@$ip  "mkdir -p /etc/ceph/；mkdir -p /etc/ceph/" 
ssh root@$ip "$script"
scp /ceph/ceph.client.admin.keyring  root@$ip:/etc/ceph/ 
scp  /ceph/ceph.conf  root@$ip:/etc/ceph/

done;

for ip in $NODE_IPS ;do

  echo "$ip创建ceph-common..."
  script=" 
    echo '#############$ip yum install  -y  ceph-common.x86_64 ################\n\n'
    yum install  -y  ceph-common.x86_64     
    echo '############## $ip  rbd;rbd;rbd;###############\n\n'
    rbd  -v;
"
ssh root@$ip "$script" &
done;
wait



#restart
 /usr/bin/ceph-mon -f --cluster ceph --id mon1 --setuser ceph --setgroup ceph