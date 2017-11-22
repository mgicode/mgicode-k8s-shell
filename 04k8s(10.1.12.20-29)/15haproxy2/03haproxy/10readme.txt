http://www.huangxiaobai.com/archives/1554


HAProxy配置中分成五部分内容，当然这些组件不是必选的，可以根据需要选择部分作为配置。
 
global
参数是进程级的，通常和操作系统（OS）相关。这些参数一般只设置一次，如果配置无误，就不需要再次配置进行修改
 
defaults
配置默认参数的，这些参数可以被利用配置到frontend，backend，listen组件
 
frontend
接收请求的前端虚拟节点，Frontend可以根据规则直接指定具体使用后端的 backend(可动态选择)。
 
backend
后端服务集群的配置，是真实的服务器，一个Backend对应一个或者多个实体服务器。
 
listen
Frontend和Backend的组合体。
 
global
#全局的日志配置 其中日志级别是[err warning info debug]，local0 是日志设备，必须为如下24种标准syslog设备的一种:
#kern user mail daemon auth syslog lpr news uucp cron auth2 ftp ntp audit alert cron2 local0 local1 local2 local3 local4 local5 local6 local7
#但是之前在/etc/syslog.conf文件中定义的是local0所以这里也是用local0
 
log 127.0.0.1 local0 info 
#[err warning info debug]
 
#最大连接数
maxconn 4096
 
#用户
user nobody
 
#组
group nogroup
 
#使HAProxy进程进入后台运行。这是推荐的运行模式
daemon
 
#创建4个进程进入deamon模式运行。此参数要求将运行模式设置为"daemon"
nbproc 4
 
#将所有进程的pid写入文件启动进程的用户必须有权限访问此文件。
pidfile /opt/haproxy/logs/haproxy.pid
 
defaults
#默认的模式mode { tcp|http|health }，tcp是4层，http是7层，health只会返回OK
mode http
 
#采用http日志格式
option httplog
 
#三次连接失败就认为是服务器不可用，也可以通过后面设置
retries 3
 
#如果cookie写入了serverId而客户端不会刷新cookie，当serverId对应的服务器挂掉后，强制定向到其他健康的服务器
option redispatch
 
#当服务器负载很高的时候，自动结束掉当前队列处理比较久的链接默认的最大连接数
maxconn 4096
 
#连接超时
contimeout 5000
 
#客户端超时
clitimeout 30000
 
#服务器超时
srvtimeout 30000
 
#=心跳检测超时
timeout check 2000
 
#注：一些参数值为时间，比如说timeout。时间值通常单位为毫秒(ms)，但是也可以通过加#后缀，来使用其他的单位。
#- us : microseconds. 1 microsecond = 1/1000000 second
#- ms : milliseconds. 1 millisecond = 1/1000 second. This is the default.
#- s : seconds. 1s = 1000ms
#- m : minutes. 1m = 60s = 60000ms
#- h : hours. 1h = 60m = 3600s = 3600000ms
#- d : days. 1d = 24h = 1440m = 86400s = 86400000ms
 
 
########统计页面配置############
 
listen admin_stats
 
#监听端口
bind 0.0.0.0:1080
 
#http的7层模式
mode http
 
#日志设置
log 127.0.0.1 local0 err #[err warning info debug]
 
#统计页面自动刷新时间
stats refresh 30s
 
#统计页面url
stats uri /admin?stats
 
#统计页面密码框上提示文本
stats realm Gemini\ Haproxy
 
#统计页面用户名和密码设置
stats auth admin:admin~!@
 
#隐藏统计页面上HAProxy的版本信息
stats hide-version
 
 
#######网站检测listen定义############
 
listen site_status
bind 0.0.0.0:1081
mode http
log 127.0.0.1 local0 err #[err warning info debug]
#网站健康检测URL，用来检测HAProxy管理的网站是否可以用，正常返回200，不正常返回500
monitor-uri /site_status
#定义网站down时的策略
#当挂在负载均衡上的指定backend的中有效机器数小于1台时返回true
acl site_dead nbsrv(img_server) lt 1
acl site_dead nbsrv(idx_server) lt 1
acl site_dead nbsrv(app_server) lt 1
#当满足策略的时候返回500
monitor fail if site_dead
#如果192.168.0.101或者192.168.0.102这两台机器挂了
#认为网站挂了，这时候返回500，判断标准是如果mode是
#http返回200认为是正常的，如果mode是tcp认为端口畅通是好的
monitor-net 192.168.0.101/31
 
 
########frontend配置############
 
frontend http_80_in
#监听端口
bind 0.0.0.0:80
#http的7层模式
mode http
#应用全局的日志配置
log global
#启用http的log
option httplog
#每次请求完毕后主动关闭http通道，HA-Proxy不支持keep-alive模式
option httpclose
#如果后端服务器需要获得客户端的真实IP需要配置次参数，将可以从Http Header中
#获得客户端IP
option forwardfor
 
###########HAProxy的日志记录内容配置##########
capture request header Host len 40
capture request header Content-Length len 10
capture request header Referer len 200
capture response header Server len 40
capture response header Content-Length len 10
capture response header Cache-Control len 8
 
####################acl策略定义#########################
#如果请求的域名满足正则表达式返回true -i是忽略大小写
acl idx_policy hdr_reg(host) -i idx.anjuke.com
acl img_policy hdr_dom(host) -i img.anjuke.com
 
#当请求的header中Content-length等于0时返回 true
acl missing_cl hdr_cnt(Content-length) eq 0
 
######################acl策略匹配相应###################
block if missing_cl
use_backend idx_server if idx_policy
use_backend img_server if img_policy
default_backend www_server
#HAProxy错误页面设置
errorfile 400 /opt/haproxy/errorfiles/400.http
errorfile 403 /opt/haproxy/errorfiles/403.http
errorfile 408 /opt/haproxy/errorfiles/408.http
errorfile 500 /opt/haproxy/errorfiles/500.http
errorfile 502 /opt/haproxy/errorfiles/502.http
errorfile 503 /opt/haproxy/errorfiles/503.http
errorfile 504 /opt/haproxy/errorfiles/504.http
 
 
##########backend的设置##############
 
backend app_server
#http的7层模式
mode http
#负载均衡的方式，roundrobin平均方式
balance roundrobin
#允许插入serverid到cookie中，serverid后面可以定义
cookie SERVERID
#心跳检测的URL,HTTP/1.1¥r¥nHost:XXXX,指定了心跳检测HTTP的版本，XXX为检测时请求
#服务器的request中的域名是什么，这个在应用的检测URL对应的功能有对域名依赖的话需要设置
option httpchk GET /index.php HTTP/1.1\r\nHost:www.anjuke.com
#服务器定义，cookie 1表示serverid为1，check inter 1500 是检测心跳频率
#rise 3是3次正确认为服务器可用，fall 3是3次失败认为服务器不可用，weight代表权重
server app1 192.168.1.101:80 cookie 1 check inter 1500 rise 3 fall 3 weight 1
server app2 192.168.1.102:80 cookie 2 check inter 1500 rise 3 fall 3 weight 2
 
backend idx_server
mode http
#负载均衡的方式，source根据客户端IP进行哈希的方式
balance source
#但设置了backup的时候，默认第一个backup会优先，设置option allbackups后
#所有备份服务器权重一样
option allbackups
#心跳检测URL设置
option httpchk GET /search.php HTTP/1.1\r\nHost:idx.anjuke.com
#可以根据机器的性能不同，不使用默认的连接数配置而使用自己的特殊的连接数配置
#如minconn 10 maxconn 20
server idx1 192.168.1.103:80 maxconn 12 check inter 1500 rise 3 fall 3
server idx2 192.168.1.104:80 maxconn 20 check inter 1500 rise 3 fall 3
#备份机器配置，正常情况下备机不会使用，当主机的全部服务器都down的时候备备机会启用
server idx-back1 192.168.1.105:80 check backup inter 1500 rise 3 fall 3
server idx-back2 192.168.1.106:80 check backup inter 1500 rise 3 fall 3
 
backend img_server
mode http
#负载均衡的方式，leastconn根据服务器当前的请求数，取当前请求数最少的服务器
balance leastconn
option httpchk GET /index.php HTTP/1.1\r\nHost:img.anjuke.com
server img1 192.168.1.107:80 check inter 1500 rise 3 fall 3
server img2 192.168.1.108:80 check inter 1500 rise 3 fall 3