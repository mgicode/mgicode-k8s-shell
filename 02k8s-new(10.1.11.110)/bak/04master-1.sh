# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#三台Master 10.1.11.123   10.1.11.124  10.1.11.125 (先采用物理机的方式安装，之后采用容器实现）


# NODE_IPS="10.1.11.123   10.1.11.124  10.1.11.125"
# NODE_NAME="master-01  master-02  master-03"


####################创建机器中的初始化文件####################
mkdir -p /master/
cd /master/
cat >init.sh << EOF
#!/bin/bash
#REP_IP="\${3:-10.1.11.117}"
#ENS_NAME="\${4:-ifcfg-ens160}"
#修改计算机名和ip地址
sed -i "s/\$3/\$1/g" /etc/sysconfig/network-scripts/\$4
hostnamectl set-hostname \$2
systemctl restart systemd-hostnamed
systemctl stop firewalld.service
systemctl disable firewalld.service
cat /etc/sysconfig/network-scripts/\$4
sed -i "s/=enforcing/=disabled/g" /etc/selinux/config
cat /etc/selinux/config
setenforce 0

chmod +x /etc/rc.d/rc.local
cat /etc/rc.local
sed -i "s/alias/#alias/g" ~/.bashrc
#去掉alias
sed -i "s/alias/#alias/g" ~/.bashrc
cat ~/.bashrc
reboot
EOF

cat init.sh



####################初始化etcd机器，免证登录，改名，改ip并重启####################




TEMPLATE_NODE_IP=10.1.11.117
password="root@123"  
  
i=0
NAMES=(${NODE_NAME})

for ip in $NODE_IPS ;do
    #去掉老的证书
    ssh-keygen -R $TEMPLATE_NODE_IP
    rm /root/.ssh/known_hosts.old
 
    NAME=${NAMES[$i]}
    echo "$NAME  $ip  "
     #检测是否开机
    for  index1 in {1..255} ; do
       ping -c 1 -w 1 $TEMPLATE_NODE_IP &>/dev/null
       if [ $? -eq 0 ]; then
        echo "$index1 $TEMPLATE_NODE_IP开机,开始初始化$ip $NAME... "
        break;
       else  
        echo "$index1 初始化$TEMPLATE_NODE_IP为$ip $NAME，$TEMPLATE_NODE_IP还没有开机,请开机... "
        sleep 5;
      fi
    done
   echo "sleep: 60"
   sleep 60
   # 进行ssh免证登录,如果在本机中已经有117的记录
   expect -c " 
    set timeout 5    
    spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@$TEMPLATE_NODE_IP
    expect {  
      "*yes/no" { send "yes\\r"; exp_continue}  
      "*INFO:" { exp_continue }
      "*ERROR:" { exp_continue }
      "*again" { send "$password\\r";  }      
      "*assword:" { send "$password\\r" }  
     }    
     expect eof  
     exit 
     #expect进程要退出，不然在循环中再次运行报错
  "  
   #该时间需要足够长，不然spawn执行的命令的伪线程还没有关闭，那么第二次就会connect refused!
   echo "sleep: 60"
   sleep 60 
   #执行相关操作，这里主要改名，改ip并重启  
   scp /etcd/init.sh  root@$TEMPLATE_NODE_IP:/root/init.sh
   #ssh -t -p $port $user@$ip "remote_cmd"  
   ssh root@$TEMPLATE_NODE_IP "chmod 777 /root/init.sh; cd /root/; ./init.sh $ip $NAME 10.1.11.117 ifcfg-ens160; "
   let i++
      
    #检测是否$ip是否开机
    for  index1 in {1..20} ; do
       ping -c 1 -w 1 $ip &>/dev/null
       if [ $? -eq 0 ]; then
        echo "sleep: 30"
        sleep 30
        echo "$ip $NAME重启完成... "
           #初始化$IP认证提示
           expect -c "  
            set timeout 5   
            spawn ssh root@$ip ""
            expect {  
              "*yes/no" { send "yes\\r"; exp_continue}     
              "*assword:" { send "$password\\r" } 
              "*ERROR:" { exp_continue }
              "*inet" { exp_continue }
             }  
            expect eof     
            exit 
            #expect进程要退出，不然在循环中再次运行报错
          "  
        #该时间需要足够长，不然spawn执行的命令的伪线程还没有关闭，那么第二次就会connect refused!
        echo "sleep: 20"
        sleep 20
        break;
       else  
        echo "$ip正在重启中... "
        sleep 15;
      fi
    done
   
done


####################生成和初始化etcd的证书####################





