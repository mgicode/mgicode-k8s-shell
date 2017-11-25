 # Spring boot+docker 半自动化部署(九)、redis的安装

作为分布式缓存使用有的有redis、memcached等，好像现在redis已经成为了分布式或微服务的标准缓存。这里采用master-slave的模式进行。

```
NODE_IPS="192.168.0.12   192.168.0.13"
NODE_NAME="redis01 redis02 "
FILE_SERVER_IP=192.168.0.20
```


 ## 创建service文件
采用service的方式来部署redis，先创建文件，其配置文件存放在/etc/redis2/redis.conf的位置上

 ```
mkdir -p /redis2/
cd /redis2/
cat > /redis2/redis.service <<EOF
[Unit]
Description=redis agent
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
ExecStart=/usr/local/bin/redis-server /etc/redis2/redis.conf 
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target
EOF 
 ```


 ## 创建配置
redis也是需要采用配置文件进行配置的，master和slave的配置文件的内容有一点不一样，slave的配置文件需要指定其master节点的ip和端口配置：
slaveof $REDIS_MASTER_IP  6379
所以下面的脚本需要特别处理这两者的区别

 ```
REDIS_MASTER_IP="192.168.0.12"
cd /redis2/

#slave需要指定其master
SLAVE_CONF="slaveof $REDIS_MASTER_IP  6379"
function calSlaveConf()
 {
    if [ ${REDIS_MASTER_IP} = $1 ]; then
         SLAVE_CONF=""
        else         
          SLAVE_CONF="slaveof $REDIS_MASTER_IP  6379"
        fi     
   return 1
 }

for ip in $NODE_IPS ;do

calSlaveConf "$ip"
cat > /redis2/redisconfig${ip##*.} <<EOF

#bind ${ip}
protected-mode no
port 6379

tcp-backlog 511
timeout 0
tcp-keepalive 300
daemonize no
supervised no
pidfile /var/run/redis_6379.pid
loglevel notice
logfile ""
databases 16
always-show-logo yes

save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir ./

slave-serve-stale-data yes
slave-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
slave-priority 100
appendonly no

appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb

aof-load-truncated yes
aof-use-rdb-preamble no
lua-time-limit 5000
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events ""

hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2

list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60

hz 10
aof-rewrite-incremental-fsync yes

${SLAVE_CONF}
# slaveof $REDIS_MASTER_IP  6379
EOF

sleep 5

done;

```


 ## 创建安装脚本
安装redis需要安装gcc等相关的编译环境，还需要安装ruby等。
然后下载redis-4.0.2.tar.gz,最后编译安装并启动服务

```
cat > /redis2/install-client.sh <<EOF

echo " export PATH=/usr/local/bin:\$PATH " >> /etc/profile
source /etc/profile

mkdir -p /redis2Working/
cd /redis2Working/
yum -y install gcc openssl-devel libyaml-devel libffi-dev
yum -y install gcc automake autoconf libtool make
yum -y install ruby 
yum -y install wget 
gem sources --remove https://rubygems.org/
gem sources -a https://ruby.taobao.org/

#wget http://download.redis.io/releases/redis-4.0.2.tar.gz 
wget http://${FILE_SERVER_IP}/redis-4.0.2.tar.gz 

tar xvf redis-4.0.2.tar.gz 
cd redis-4.0.2/ && make MALLOC=libc && make install  \
    &&   cp src/redis-trib.rb /usr/bin/ \
    &&   chmod 777 /usr/bin/redis-trib.rb  

 systemctl daemon-reload
 systemctl enable redis
 systemctl start redis
 systemctl status redis

 sleep 3

EOF


```


## 执行安装脚本
先清除原来的安装的内部，再把三个文件复制到指定的机器上，最后执行安装脚本进行安装。

 ```
for ip in $NODE_IPS ;do
      echo "清除$ip中的redis安装的所有内容..."
      ssh root@$ip "$clearScript"

      echo "安装$ip的redis..."
      ssh root@$ip "mkdir -p /redis2Working/; mkdir -p /etc/redis2/;"

      scp /redis2/redisconfig${ip##*.}   root@$ip:/etc/redis2/redis.conf
      scp /redis2/redis.service    root@$ip:/etc/systemd/system/redis.service
      scp /redis2/install-client.sh  root@$ip:/redis2Working/install-client.sh
      ssh root@$ip "chmod 777 /redis2Working/install-client.sh; /redis2Working/install-client.sh;"

      ssh root@$ip "$checkScript"
      sleep 5

done

 ```

 ## 检查
进入每台机器采用redis-cli 看看能不能连接到其当前的redis,如果能说明安装成功。
可以在master上写入key-value,在slave看看能不能查到，如果能，那说明集群成功。

 ```
for ip in $NODE_IPS ;do
      echo "查看集群状态..."     
      ssh root@$ip "redis-cli -h ${ip} -p 6379 ; "
      sleep 5

done

 ```



