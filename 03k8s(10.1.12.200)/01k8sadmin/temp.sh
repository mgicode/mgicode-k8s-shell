#初始化机器，免证登录，改名，改ip并重启####################
#把该文件复制到/common/下ssh.sh

NODE_IPS=$1

NODE_NAME=$2

TEMPLATE_NODE_IP=10.1.12.251
password="root@123"  
  
i=0
NAMES=(${NODE_NAME})

echo $NODE_IPS
for ip in $NODE_IPS ;do
    #去掉老的证书
    ssh-keygen -R $ip
    rm /root/.ssh/known_hosts.old
 
    NAME=${NAMES[$i]}
    echo "name:$NAME,ip:$ip  "
     #检测是否开机
    for  index1 in {1..255} ; do
       ping -c 1 -w 1 $ip &>/dev/null
       if [ $? -eq 0 ]; then
        echo "$index1 $ip开机,开始初始化$ip($NAME)... "
        break;
       else  
        echo "$index1 初始化为$ip($NAME)，模板机$ip还没有开机,请开机... "
        sleep 5;
      fi
    done
   echo "sleep: 60"
   sleep 60
   # 进行ssh免证登录,如果在本机中已经有117的记录
   expect -c " 
    set timeout 5    
    spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@$ip
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
   echo "sleep: 30"
   sleep 30 
    
   
done



