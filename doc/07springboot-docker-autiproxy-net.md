 # Spring boot+docker 半自动化部署(七)、反向代理上网

网络安全要求较高，只有192.168.0.20能上外网，其它机器都上不了网，只能使用反向代理上网，建立反向代理：
1、在192.168.0.20 建立nginx代理 
2、每台机器加上http-proxy的指向
3、yum 用不了，需要把yum源换成aliyun的http,同时把其中file协议换成http

## nginx的配置文件
nginx的docker部署非常方便，和前面文件服务器一样，只要拉镜像运行即可，其关键在于配置文件
默认的情况下，nginx没有配置文件，需要在/etc/nginx/nginx.conf位置配置主配置文件，没有主配置文件，直接配置子配置文件在docker中会报错“找不到/etc/nginx/nginx.conf文件”
这里仅仅做反向代理用，就直接配置在主配置文件中即可

在管理机主机创建/etc/nginx/nginx.conf中，然后把该文件映射到docker中，这样就不需要在docker容器中配置

```
worker_processes 1;
master_process off;
#daemon off;
#pid /var/run/nginx.pid;
events {
  worker_connections 768;
 # multi_accept on;
}

http {
    #include mime.types;
    default_type application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
    '$status $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log /var/log/nginx/access.log;
    #error_log /var/log/nginx/error.log;

    sendfile on;
    server {
        #域名服务器
        resolver 202.120.2.100;
        #监听本机端口，其它机器都指向本机的ip该端口上进行代理
        listen 85;
        location / {
            #proxy_pass http://$http_host$request_uri;
            proxy_pass $scheme://$http_host$request_uri;          
        }         
    }
}

```


## nginx的启动

启用反向代理的docker比较简单，拉镜像下载启动

```
docker run -d    -v /etc/nginx:/etc/nginx  -v /usr/local/nginx/conf/:/usr/local/nginx/conf/      --restart=always \
--privileged=true  --net=host  --name nginx-proxy -p 85:85  nginx

```

这里关键是把其位置和本地位置进行映射即可，其配置文件配置的端口也需要在主机上映射出来。
如果不行，那么就docker restart nginx-proxy,重启一下。

## 每台机器指向该端口

在代理机只需要编写http_proxy环境变量，把该变量指指定管理机即可
下面采用批量的形式把http_proxy写入/etc/profile

```
NODE_IPS="192.168.0.2  192.168.0.5 192.168.0.6  192.168.0.7  192.168.0.8  192.168.0.9  192.168.0.10  192.168.0.11 192.168.0.12   192.168.0.13  192.168.0.14   192.168.0.15   192.168.0.16 192.168.0.17  192.168.0.18    192.168.0.19"
NODE_NAME="ms02 ms05 ms06  ms07   ms08   ms09  ms10   ms11  ms12  ms13  ms14  ms15  ms16  ms17   ms18 ms19"

for ip in $NODE_IPS ;do
      echo "初始化$ip proxy..."
       Script=" 
          echo \" export http_proxy=http://192.168.0.20:85 \" >> /etc/profile
          #echo \" export https_proxy=https://192.168.0.20:443 \" >> /etc/profile 
          source /etc/profile
          curl www.google.cn
        "
      ssh root@$ip "$Script"
      sleep 5
done

```


