# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#初始化机器，免证登录，改名，改ip并重启####################
#把该文件复制到/common/下ssh.sh

NODE_IPS=$1
NODE_NAME=$2

#TEMPLATE_NODE_IP=10.1.12.251
TEMPLATE_NODE_PWD="dddddd" 

  
i=0
NAMES=(${NODE_NAME})

echo $NODE_IPS
for ip in $NODE_IPS ;do
    #去掉老的证书
    #ssh-keygen -R $TEMPLATE_NODE_IP
    #rm /root/.ssh/known_hosts.old
 
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
   echo "sleep: 10"
   sleep 10
   # 进行ssh免证登录,如果在本机中已经有117的记录
   expect -c " 
    set timeout 5    
    spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@$ip
    expect {  
      "*yes/no" { send "yes\\r"; exp_continue}  
      "*INFO:" { exp_continue }
      "*ERROR:" { exp_continue }
      "*again" { send "$TEMPLATE_NODE_PWD\\r";  }      
      "*assword:" { send "$TEMPLATE_NODE_PWD\\r" }  
     }    
     expect eof  
     exit 
     #expect进程要退出，不然在循环中再次运行报错
  "  
   #该时间需要足够长，不然spawn执行的命令的伪线程还没有关闭，那么第二次就会connect refused!
   echo "sleep: 10"
   sleep 10 
   #执行相关操作，这里主要改名，改ip并重启  
   scp /common/init.sh root@$ip:/root/init.sh
   #ssh -t -p $port $user@$ip "remote_cmd"  
   ssh root@$ip "chmod 777 /root/init.sh; cd /root/; ./init.sh; "
   let i++
      
    #检测是否$ip是否开机
    for  index1 in {1..20} ; do
       ping -c 1 -w 1 $ip &>/dev/null
       if [ $? -eq 0 ]; then
        echo "sleep: 40"
        sleep 40
        echo "$ip $NAME重启完成... "
           #初始化$IP认证提示
           expect -c "  
            set timeout 5   
            spawn ssh root@$ip ""
            expect {  
              "*yes/no" { send "yes\\r"; exp_continue}     
              "*assword:" { send "${TEMPLATE_NODE_PWD}\\r" } 
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



