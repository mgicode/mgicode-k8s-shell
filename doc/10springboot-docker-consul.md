 # Spring boot+docker 半自动化部署(十)、consul的安装

微服务的注册中心现在主要有 eureka、etcd及consul,现在主流的是使用consul作为服务注册和发现中心，并进行健康检测。

 ```

NODE_IPS="192.168.0.17  192.168.0.18    192.168.0.19"
NODE_NAME="consul01 consul02 consul03"

FILE_SERVER_IP=192.168.0.20

 ```

 ## 生成CONSUL_KEY_TOKEN
consul是微服务的中心，它们三台之间的集群通信是通过token来进行加密通信，所以需要先初始化生成token，并对配置文件中配置该token.

 ```
 #备份管理机的配置文件 
cp /etc/profile   /etc/profile_consul

mkdir -p /consul3/
cd /consul3/
#下载consul和安装
wget http://${FILE_SERVER_IP}/consul -q
cp /consul3/consul /usr/local/bin/
chmod 777 /usr/local/bin/*
#生成key
CONSUL_KEY_TOKEN=`consul keygen`

#写入环境变量，这个只要运行一次，如果每次都变化，那么它们之间通信不了
cat  >>/etc/profile <<EOF
export CONSUL_KEY_TOKEN="$CONSUL_KEY_TOKEN"
EOF

source /etc/profile

 ```


  ## 创建service
采用service的方式来配置consul的服务，如果需要ui显示，需要配置-ui，这里是三台consul都可以通过访问ui界面。-rejoin代表它们会自动组成集群

```
cd /consul3/
cat > /consul3/consul.service <<EOF
[Unit]
Description=consul agent
Requires=network-online.target
After=network-online.target

[Service]
EnvironmentFile=-/etc/sysconfig/consul
Restart=on-failure
ExecStart=/usr/local/bin/consul agent -ui -config-dir=/etc/consul.d/server -rejoin
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target
EOF

sleep 5

```

## 创建配置文件 
创建每台主机的配置文件需要注意的是  "retry_join": [     ${ips}  ],它们会指定除本机的其它两台主机的ip,这样每台主机都根据ip找到其它两者主机，形成集群。

```

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
        "http": 8500
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

done;


```


## 创建 install-client
创建安装脚本，该脚本中下载并安装，然后启动service

```
cat > /consul3/install-client.sh <<EOF

echo " export PATH=/usr/local/bin:\$PATH " >> /etc/profile
source /etc/profile

mkdir -p /consul3Working/
cd /consul3Working/

wget http://${FILE_SERVER_IP}/consul -q
cp -r /consul3Working/consul  /usr/local/bin/
chmod 777 /usr/local/bin/*

 # 创建配置文件目录
 #mkdir -p /etc/consul.d/server
 #创建consul存储数据的目录
 #mkdir /var/consul

#启动consul
 systemctl daemon-reload
 systemctl enable consul
 systemctl start consul
 systemctl status consul

 sleep 3

EOF

```

## 执行
把文件从管理机copy到三台consul主机上，并进行安装。

```
#3.3 安装consul
for ip in $NODE_IPS ;do
      echo "清除$ip中的consul安装的所有内容..."
      ssh root@$ip "$clearScript"

      echo "安装$ip的consul..."
      ssh root@$ip "mkdir -p /consul3Working/; mkdir -p /etc/consul.d/server/;mkdir /var/consul/"

      scp /consul3/consulconfig${ip##*.}  root@$ip:/etc/consul.d/server/config.json
      scp /consul3/consul.service    root@$ip:/etc/systemd/system/consul.service
      scp /consul3/install-client.sh  root@$ip:/consul3Working/install-client.sh
      ssh root@$ip "chmod 777 /consul3Working/install-client.sh; /consul3Working/install-client.sh;"

      ssh root@$ip "$checkScript"
      sleep 5

done



```


## 检查
进入每个consul的主机，查看其集群的成员，如果有三个，说明其自动组建集群成功。
```
for ip in $NODE_IPS ;do
      echo "查看集群状态..."     
      ssh root@$ip "consul members -http-addr=127.0.0.1:8500"
      sleep 5
done


```

