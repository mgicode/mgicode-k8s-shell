http://www.linuxidc.com/Linux/2017-08/146598.htm

http://www.zslin.com/web/article/detail/73



例如我有一台内网为172.16.0.100，可以上网，其他内网都不可以。我们就采用nginx反向代理。

在nginx后面增加以下内容：

 server{
    resolver 202.101.172.35;
    listen 82;
    location / {
        proxy_pass http://$host$request_uri;
    }
    }
 resolver 是DNS地址。与你上网那台DNS一致
 
配置不能上网的WINDOWS服务器
打开IE浏览器->工具->Internet选项->连接->局域网设置->为LAN使用代理服务 地址为172.16.0.100端口为82.
配置不能上网的LINUX服务器
vi /etc/profile后面增加export http_proxy=http://172.16.0.100:82
source /etc/profile就可以了。
最终要在局域网才行

//202.120.2.100





#cat /etc/resolv.conf

最近在研究docker，在架设了几个网站后，发现个问题 宿主机的80端口只可以绑定一个容器，并且没办法实现多域名，所以想到了nginx的反代，以下是使用docker架设nginx反代的笔记。

1.需求：

我的需求，需要将多个域名解析到同一台服务器上（即宿主机），并采用nginx反代的方式，将不同的域名和不同的容器端口号对应映射。

2.技术：

由于现在网站就架设在docker的容器上，所以我将采用docker进行搭建相应的配置，采用nginx服务器做反向代理。

3.实现：

第一步：

安装docker，如果你的服务器上还没有相应的docker,可以参考CentOS安装步骤或者Ubuntu 系列安装 Docker步骤进行安装。（请自行google或者使用DaoCloud管理平台）

第二步：

获取nginx镜像，执行命令：

docker pull nginx

第三步：

创建并启动nginx容器，执行命令：

docker run –name=nginx -p 80:80 -v /nginx/conf.d:/etc/nginx/conf.d -d nginx
此时你已经创建了一下名字为nginx的容器，该容器中/etc/nginx/conf.d目录下的文件将与宿主机中/nginx/conf.d目录下的文件保持同步，而/etc/nginx/conf.d是nginx的站点配置文件夹，下面每一个conf配置文件各自对应一个站点。反代的配置也得写在里面。

第四步：

到此你的nginx容器已经创建成功，我们在此修改对应的配置文件即可，
例如我现在需要将www.aaa.com的域名路径指向一个容器运行端口号8080上，
只需要进入你宿主机中/nginx/conf.d目录中增加一个文件（命令cd /nginx/conf.d），
文件名字要求必须为.conf格式，例如可以改名为：www.aaa.com.conf(命令vi www.aaa.com.conf),
里面的内容如下（自己修改对应的地方，然后粘贴到vi中，按esc 输入:wq来保存文件）：

 server {
    listen       80;
    server_name www.aaa.com自己域名;
    location / {
       proxy_pass http://宿主机ip:容器对外的端口号;
      }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
如果你需要多个域名的配置，只需要在/nginx/conf.d目录下加相应的配置文件即可，
一般只需要修改server_name和proxy_pass即可。然后重启nginx容器，即：

docker restart nginx

打开你的域名即可看到效果，当然你得先把域名解析到宿主机的ip上面




http://www.linuxidc.com/Linux/2015-04/116331.htm
代理上网中Linux下YUM无法使用的解决方法













使用Nginx制作内网yum镜像代理

[日期：2017-08-30]	来源：Linux社区  作者：ygqygq2	[字体：大 中 小]
使用Nginx制作内网yum镜像代理

使用Nginx制作内网yum镜像代理

1. 背景

2. 环境需求

3. Nginx安装配置

1. 背景

公司内网服务器不能直接通过Internet上网，但为了与外网通信和同步时间等，会指定那么几台服务器可以访问Internet。这里就是通过能上网的机器作为代理，制作内网使用的yum仓库。

2. 环境需求

内网dns（推荐，非必须，因为可使用IP代替）

一台能上Internet的服务器A

不能上Internet的服务器能与A服务器通信

这里示例为CentOS7和Ubuntu16

3. Nginx安装配置

Nginx安装在能上网的A服务器上，安装过程略。 
具体一个nginx server配置如下：

# mirrors
server
    {
        listen 80;
        #listen [::]:80;
        server_name mirrors.yourdomain.com;
        index index.html index.htm index.php default.html default.htm default.php;
        root  /home/wwwroot/html;

        location /ubuntu/ {
            proxy_pass http://mirrors.aliyun.com/ubuntu/ ;
        }

        location /centos/ {
            proxy_pass http://mirrors.aliyun.com/centos/ ;
        }

        location /epel/ {
            proxy_pass http://mirrors.aliyun.com/epel/ ;
        }
}
以上使用阿里云镜像，其镜像版本很全，速度也很快。 
http://mirrors.aliyun.com/
CentOS7系统镜像源： 
cat /etc/yum.repos.d/CentOS-7.repo

[base]
name=CentOS-$releasever - Base - mirrors.yourdomain.com
failovermethod=priority
baseurl=http://mirrors.yourdomain.com/centos/$releasever/os/$basearch/
        http://mirrors.yourdomain.com/centos/$releasever/os/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os
gpgcheck=1
gpgkey=http://mirrors.yourdomain.com/centos/RPM-GPG-KEY-CentOS-7

#released updates 
[updates]
name=CentOS-$releasever - Updates - mirrors.yourdomain.com
failovermethod=priority
baseurl=http://mirrors.yourdomain.com/centos/$releasever/updates/$basearch/
        http://mirrors.yourdomain.com/centos/$releasever/updates/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates
gpgcheck=1
gpgkey=http://mirrors.yourdomain.com/centos/RPM-GPG-KEY-CentOS-7

#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras - mirrors.yourdomain.com
failovermethod=priority
baseurl=http://mirrors.yourdomain.com/centos/$releasever/extras/$basearch/
        http://mirrors.yourdomain.com/centos/$releasever/extras/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras
gpgcheck=1
gpgkey=http://mirrors.yourdomain.com/centos/RPM-GPG-KEY-CentOS-7

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus - mirrors.yourdomain.com
failovermethod=priority
baseurl=http://mirrors.yourdomain.com/centos/$releasever/centosplus/$basearch/
        http://mirrors.yourdomain.com/centos/$releasever/centosplus/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus
gpgcheck=1
enabled=0
gpgkey=http://mirrors.yourdomain.com/centos/RPM-GPG-KEY-CentOS-7

#contrib - packages by Centos Users
[contrib]
name=CentOS-$releasever - Contrib - mirrors.yourdomain.com
failovermethod=priority
baseurl=http://mirrors.yourdomain.com/centos/$releasever/contrib/$basearch/
        http://mirrors.yourdomain.com/centos/$releasever/contrib/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=contrib
gpgcheck=1
enabled=0
gpgkey=http://mirrors.yourdomain.com/centos/RPM-GPG-KEY-CentOS-7
EPEL第三方扩展源： 
cat /etc/yum.repos.d/epel.repo

[epel]
name=Extra Packages for Enterprise Linux 7 - $basearch
baseurl=http://mirrors.yourdomain.com/epel/7/$basearch
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

[epel-debuginfo]
name=Extra Packages for Enterprise Linux 7 - $basearch - Debug
baseurl=http://download.yourdomain.com/epel/7/$basearch/debug
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
gpgcheck=1

[epel-source]
name=Extra Packages for Enterprise Linux 7 - $basearch - Source
baseurl=http://download.yourdomain.com/epel/7/SRPMS
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
Ubuntu16 apt镜像源： 
cat /etc/apt/sources.list

deb http://mirrors.yourdomain.com/ubuntu/ xenial main restricted universe multiverse
deb http://mirrors.yourdomain.com/ubuntu/ xenial-security main restricted universe multiverse
deb http://mirrors.yourdomain.com/ubuntu/ xenial-updates main restricted universe multiverse
deb http://mirrors.yourdomain.com/ubuntu/ xenial-proposed main restricted universe multiverse
deb http://mirrors.yourdomain.com/ubuntu/ xenial-backports main restricted universe multiverse
deb-src http://mirrors.yourdomain.com/ubuntu/ xenial main restricted universe multiverse
deb-src http://mirrors.yourdomain.com/ubuntu/ xenial-security main restricted universe multiverse
deb-src http://mirrors.yourdomain.com/ubuntu/ xenial-updates main restricted universe multiverse
deb-src http://mirrors.yourdomain.com/ubuntu/ xenial-proposed main restricted universe multiverse
deb-src http://mirrors.yourdomain.com/ubuntu/ xenial-backports main restricted universe multiverse



