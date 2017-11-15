http://blog.csdn.net/qq_36633811/article/details/53084493

redis master/slave 配置
创建配置文件
在redis目录下有redis.conf 和sentinel.conf 文件，为了便于维护，在redis目录下创建conf文件夹，
将redis.conf和sentinel.conf 文件转移到此目录.(可以放到任意目录)
将conf目录下 redis.conf 复制为2份，并分别重命名为：
redis_master_16319.conf 和redis_slave_26319.conf 
分别当作 master和slave的配置文件.
修改配置文件内容
  redis_master_16319.conf修改
a、修改原有默认端口 
#port 6379 
改为 
port 16319 
b、同时将默认的profile 配置修改为：
pidfile /var/run/redis_6379.pid 
改为 
pidfile /var/run/redis_16319.pid
c、后台运行。
#daemonize no
改为
daemonize yes
此属性标识以守护进程的方式运行。
d、在文件中找到  
#bind 127.0.0.1 ， 
将这一行注释取消，并修改为
bind [你的master机器ip]
注意：如果master/slave在同一服务器，这里必须修改，如果在不同服务器，可以跳过此步骤。
redis_slave_26319.con修改
a、同样修改默认端口 
#port 6379 
取消注释并改为
port 26319
b、同时将默认的profile 配置修：
pidfile /var/run/redis_6379.pid
改为
pidfile /var/run/redis_26319.pid
c、找到文件中 
# slaveof <masterip> <masterport> 
 改为
   slaveof 10.xxx.xxx.xxx 16319。
d、同样修改
#daemonize no
改为
daemonize yes
e、在文件中找到  
#bind 127.0.0.1 ， 
将这一行注释取消，并修改为
bind [你的master机器ip]

注意：如果master/slave在同一服务器，这里必须修改，如果在不同服务器，可以跳过此步骤。
此属性标识以守护进程的方式运行。
至此，conf文件配置完成，N 组master/slave 参照改配置更改不通的ip和端口即可。
启动以及测试
启动:
     进入redis src 目录，分别启动master and slave ，命令如下：
# ./redis-server ../conf/redis_master_16319.conf 
# ./redis-server ../conf/redis_slave_26319.conf
命令即 ./redis-server 加上配置文件的目录
    查看进程是否存在：
    # ps -ef|grep redis
root     32325     1  0 18:12 ?        00:00:00 ./redis-server 10.27.xxx.xxx:16319
root     32335     1  0 18:13 ?        00:00:00 ./redis-server 10.27.xxx.xxx.:26319
root     32345 32216  0 18:17 pts/2    00:00:00 grep --color=auto redis
ok, 说明进程已经存在。
测试master 和slave 数据同步
分别登入redis 控制台，并作如下测试：