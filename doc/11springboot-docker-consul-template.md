 # Spring boot+docker 半自动化部署(十一)、consul-template的安装
consul-template的作用是一般是用来同步负载均衡和服务注册中心的服务，当服务注册中心的网关服务实例增加或减少时，如果没有consul-template,那么就需要手动把其同步到nginx或haproxy的负载均衡中去。不但麻烦，每次修改nginx或haproxy的配置文件，需要手动软启动，人的操作失误有可能导致整个应用都访问不了的风险。采用consul-template则能很好避免这个问题。它按指定的间隔读取consul,如果consul中的网关服务变化了，那么就是修改配置文件，并软启动。应用并不中断。

```

NODE_IPS="192.168.0.2  192.168.0.5"
NODE_NAME="balance01 balance02 "

```
 ## serive文件 
采用服务的形式安装consul-template，并通过 -template 指定模板的位置和生成之后的位置，生成之后的位置就是Haproxy的配置文件的位置

```
CONSUL_TEMPLATE_IP_PORT="192.168.0.14:8500"
mkdir -p /consulTemplate/
cd /consulTemplate/

cat > /consulTemplate/consultemplate.service <<EOF
[Unit]
Description=consultemplate agent
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
ExecStart=/usr/local/bin/consul-template  \\
      -template "/etc/consul-template/haproxy.ctmpl:/etc/haproxy/haproxy.cfg" \\
      -consul-addr "${CONSUL_TEMPLATE_IP_PORT}"  
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target

EOF
sleep 5
```


## 创建配置文件模板
配置文件模板和haproxy的配置文件基本上一样，就是把需要负载均衡动态的那一部分采用模板来编写，到时间会自动根据consul进行变化，这里指定了网关服务的名称为sys-gateway-debug，可以修改成你自己所指定的名称。模板编写的语法创见官方https://github.com/hashicorp/consul-template。

```
HAPROXY_PORT="8081"
GATEWAY_SERVICE_NAME="sys-gateway-debug"

cd /consulTemplate/

for ip in $NODE_IPS ;do
cat > /consulTemplate/haproxyTemplateConfig${ip##*.} <<EOF
#全局配置
global
    #设置日志
    log 127.0.0.1 local3 info
    chroot /usr/local/haproxy
    #用户与用户组
    #user haproxy
    #group haproxy
    user root
    group root
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
listen gateway_cluster
  bind 0.0.0.0:${HAPROXY_PORT}
  mode tcp
  balance roundrobin
  maxconn 20000 
  #server master01 ${MASTER01_IP_PORT} check inter 2000 rise 3 fall 3 weight 30
 {{ range service "${GATEWAY_SERVICE_NAME}" }} 
 server {{ .Name }} {{ .Address }}:{{ .Port }}  check inter 2000 rise 3 fall 3 weight 1 {{ end }}

EOF

done;
```
 

## 创建安装脚本 
安装脚本和之前的安装都一样，先下载，然后copy到bin下面，再之后启动服务。

```
cat > /consulTemplate/install-client.sh <<EOF
mkdir -p /balanceHaConsulTemplateWorking/
cd /balanceHaConsulTemplateWorking/

 wget http://${FILE_SERVER_IP}/consul-template
 cp /balanceHaConsulTemplateWorking/consul-template  /usr/local/bin/   

chmod 777 /usr/local/bin/* 
 systemctl daemon-reload
 systemctl enable consultemplate
 systemctl start consultemplate
 systemctl status consultemplate

 sleep 3

EOF
```


## 执行
执行安装也和前面的类似，不多解释

```
for ip in $NODE_IPS ;do
      echo "清除$ip中的consultemplate安装的所有内容..."
      ssh root@$ip "$clearScript"

      echo "安装$ip的consultemplate..."
      ssh root@$ip "mkdir -p /balanceHaConsulTemplateWorking/; mkdir -p /etc/consul-template/ ;"

      scp /consulTemplate/haproxyTemplateConfig${ip##*.}  root@$ip:/etc/consul-template/haproxy.ctmpl
      scp /consulTemplate/consultemplate.service   root@$ip:/etc/systemd/system/consultemplate.service
      scp /consulTemplate/install-client.sh   root@$ip:/balanceHaConsulTemplateWorking/install-client.sh
      ssh root@$ip "chmod 777 /balanceHaConsulTemplateWorking/install-client.sh; /balanceHaConsulTemplateWorking/install-client.sh;"

      ssh root@$ip "$checkScript"
      sleep 5

done
```

## 查看配置文件 

如果consul已经安装，consul-template也安装成功，那么过一小段时间，查看其/etc/haproxy/haproxy.cfg，其配置文件的内容已经发现了变化。说明成功，可以在consul中增加或减少网关实例，看看/etc/haproxy/haproxy.cfg的地址是否变化。

```
sleep 20
for ip in $NODE_IPS ;do
      echo "查看状态..."     
       ssh root@$ip "cat /etc/haproxy/haproxy.cfg "
       ssh root@$ip "ps -ef "
      sleep 5
done
```



 