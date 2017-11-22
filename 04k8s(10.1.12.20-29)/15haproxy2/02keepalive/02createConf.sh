# author:pengrk
# email:546711211@qq.com
# qq group:573283836

NODE_IPS="10.1.12.80  10.1.12.81"
NODE_NAME="balance01 balance02 "

KEEPALIVE_MASTER_IP="10.1.12.80"
KEEPALIVE_VIP="10.1.12.90"
ETH_NAME="ens160" #eth0

# iptables -I INPUT -i eth0 -d 224.0.0.0/8 -p vrrp -j ACCEPT
# iptables -I OUTPUT -o eth0 -d 224.0.0.0/8 -p vrrp -j ACCEPT
# service iptables save

cd /balanceKeepAlive/

KEEPALIVE_STATE=""
KEEPALIVE_PRIORITY=""
nopreempt=""
function calSlaveConf()
 {
    if [ ${KEEPALIVE_MASTER_IP} = $1 ]; then
         KEEPALIVE_STATE="MASTER"
         KEEPALIVE_PRIORITY="150"
         nopreempt=""
        else         
          KEEPALIVE_STATE="BACKUP"
          KEEPALIVE_PRIORITY="100"
          nopreempt="nopreempt"
        fi     
   return 1
 }



for ip in $NODE_IPS ;do

calSlaveConf "$ip"
cat > /balanceKeepAlive/keepAliveConfig${ip##*.} <<EOF
global_defs {
   router_id Haproxy${ip##*.}　　#当前节点名
}
vrrp_script chk_haproxy  {
   script  "killall -0 haproxy"   
   interval  2                    
   weight  2                      
 }
vrrp_instance VI_1 {
    state  ${KEEPALIVE_STATE}     #指定Haproxy节点为主节点 备用节点上设置为BACKUP即可
    interface  ${ETH_NAME}         #绑定虚拟IP的网络接口
    virtual_router_id  51          #VRRP组名，两个节点的设置必须一样，以指明各个节点属于同一VRRP组
    priority  ${KEEPALIVE_PRIORITY}         #主节点的优先级（1-254之间），备用节点必须比主节点优先级低
    ${nopreempt}
    advert_int  1             #组播信息发送间隔，两个节点设置必须一样    
    virtual_ipaddress   {   #指定虚拟IP, 两个节点设置必须一样,可以多个
           ${KEEPALIVE_VIP}
          }
}

track_script {
       chk_haproxy
}

EOF

    echo -e "\033[32m ###############/balanceKeepAlive/keepAliveConfig${ip##*.} ########### \033[0m"
    cat /balanceKeepAlive/keepAliveConfig${ip##*.} 
    echo -e "\033[32m ###########内容显示完成########### \033[0m"

    sleep 5

done;

 
# vrrp_script chk_haproxy {
#    script "killall -0 haproxy"   
#    interval 2                    
#    weight 2                      
# }
# vrrp_instance VI_1 {
#    interface ens160               
#    state MASTER
#    virtual_router_id 27         
#    priority 101                  # 101 on master, 100 on backup (Make sure to change this on HAPROXY node2)
#    virtual_ipaddress {
#         ${VIP}          # the virtual IP's
# }
#    track_script {
#        chk_haproxy
#    }
# }



