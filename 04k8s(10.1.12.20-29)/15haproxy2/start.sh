# author:pengrk
# email:546711211@qq.com
# qq group:573283836


modprobe ip_vs
modprobe ip_vs_wrr

#创建系统账号
useradd -r haproxy
#创建配置文件
mkdir /etc/haproxy/

cat > /etc/haproxy/haproxy.cfg <<EOF
#全局配置
global
    #设置日志
    log 127.0.0.1 local3 info
    chroot /usr/local/haproxy
    #用户与用户组
    user haproxy
    group haproxy
    #守护进程启动
    daemon
    #最大连接数
    maxconn 4000

#默认配置
defaults
    log global
    mode http
    #option httplog
    option dontlognull
    timeout connect 5000
    timeout client 50000
    timeout server 50000

 ####################################################################
listen http_front
        bind 0.0.0.0:1080           #监听端口  
        stats refresh 30s           #统计页面自动刷新时间  
        stats uri /haproxy?stats            #统计页面url  
        stats realm Haproxy Manager #统计页面密码框上提示文本  
        stats auth admin:admin      #统计页面用户名和密码设置  
        #stats hide-version         #隐藏统计页面上HAProxy的版本信息

 ####################################################################

 frontend master-https       
    bind *:6443
    mode tcp
    default_backend k8s-masters
		
backend k8s-masters
    #stats enable
	mode tcp
	option ssl-hello-chk
    server master01 ${MASTER01_IP_PORT} check inter 2000 rise 3 fall 3 weight 30
    server master02 ${MASTER02_IP_PORT}  check inter 2000 rise 3 fall 3 weight 30
    server master03 ${MASTER03_IP_PORT}  check inter 2000 rise 3 fall 3 weight 30

EOF

 # server master01 10.1.11.62:6443 check inter 2000 rise 3 fall 3 weight 30

cat /etc/haproxy/haproxy.cfg

sleep 3
haproxy -f /etc/haproxy/haproxy.cfg &

sleep 20
echo "sleep:20"

mkdir /etc/keepalived/
cat > /etc/keepalived/keepalived.conf <<EOF
vrrp_script chk_haproxy {
   script "killall -0 haproxy"   
   interval 2                    
   weight 2                      
}
vrrp_instance VI_1 {
   interface ens160               
   state MASTER
   virtual_router_id 27         
   priority 101                  # 101 on master, 100 on backup (Make sure to change this on HAPROXY node2)
   virtual_ipaddress {
        ${VIP}          # the virtual IP's
}
   track_script {
       chk_haproxy
   }
}
EOF

cat /etc/keepalived/keepalived.conf 
sleep 20

/usr/sbin/keepalived -P -C -d -D -S 7 -f /etc/keepalived/keepalived.conf --dont-fork --log-console 


