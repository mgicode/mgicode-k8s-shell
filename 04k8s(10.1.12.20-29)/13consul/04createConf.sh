# author:pengrk
# email:546711211@qq.com
# qq group:573283836

NODE_IPS="10.1.12.73  10.1.12.74  10.1.12.75"
NODE_NAME="consul01 consul02 consul03"

#to /etc/consul.d/server/config.json

cd /consul3/

ips="";
 function calIps()
 {
     #echo $1;
     ips=""
     for ip1 in $NODE_IPS ;do
        if [ ${ip1} = $1 ]; then
         ips="${ips}"
        else         
          ips="${ips},\"${ip1}\""
        fi
     done
     ips=${ips#*,}   
   return 1
 }


# calIps "10.1.12.73"
# echo "${ips}       "

# calIps "10.1.12.74"
# echo "${ips}      "

# calIps "10.1.12.75"
# echo "${ips}      "


for ip in $NODE_IPS ;do

    calIps "$ip"
    cat > /consul3/consulconfig${ip##*.} <<EOF
{
    "advertise_addr": "${ip}",
    "bind_addr": "${ip}",
    "domain": "consul",
    "bootstrap_expect": 3,
    "server": true,
    "datacenter": "dc1",
    "data_dir": "/var/consul",
    "encrypt": "${CONSUL_KEY_TOKEN}",
    "enable_syslog": true,
    "performance": {
      "raft_multiplier": 1
    },
    "dns_config": {
        "allow_stale": true,
        "max_stale": "15s"
    },
    "retry_join": [
        ${ips}
    ],
    "retry_interval": "10s",
    "skip_leave_on_interrupt": true,
    "leave_on_terminate": false,
    "ports": {
        "dns": 53,
        "http": 80
    },
    "recursors": [
        "223.5.5.5",
        "223.6.6.6"
    ],
    "rejoin_after_leave": true,
    "addresses": {
        "http": "0.0.0.0",
        "dns": "0.0.0.0"
    }
}

EOF

    echo -e "\033[32m ###############/consul3/consulconfig${ip##*.} ########### \033[0m"
    cat /consul3/consulconfig${ip##*.}
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
