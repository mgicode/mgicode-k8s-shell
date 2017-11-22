# author:pengrk
# email:546711211@qq.com
# qq group:573283836

NODE_IPS="192.168.0.12   192.168.0.13"
NODE_NAME="redis01 redis02 "

#to /etc/consul.d/server/config.json

REDIS_MASTER_IP="192.168.0.12"
cd /redis2/

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

    echo -e "\033[32m ###############/redis2/redisconfig${ip##*.} ########### \033[0m"
    cat //redis2/redisconfig${ip##*.}
    echo -e "\033[32m ###########内容显示完成########### \033[0m"

    sleep 5

done;






# 而node02，node03的配置文件与node01基本一样，除了以下两处要修改。
# 一是ip地址相应修改：
#     "advertise_addr": "10.0.0.1",
#     "bind_addr": "10.0.0.1",
# 二是retry_join这里要改成其他2个节点IP：
# node02: "retry_join"  -->  "10.0.0.1","10.0.0.3"
# node03: "retry_join"  -->  "10.0.0.1","10.0.0.2"

# 这里要说明的是bootstrap_expect，这是consul官方新推荐的形成集群的方法。
# 这个参数指定了要形成集群需要几个节点，当所需的节点都就位以后，集群自动开始选举leader。
# 如果没有达到指定数量，则不会开始组成集群，例如我们只启动node01，会看到如下输出：

# [WARN] raft: EnableSingleNode disabled, and no known peers. Aborting election.

# 至于其他参数的含义，请自行参考官方文档。
