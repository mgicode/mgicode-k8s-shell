
当一堆业务系统互相之间使用RPC调用时，为了提高可用性，每个模块一般会做多台主机，然后用haproxy负载均衡，规模小还可以，但当规模大了以后，更改haproxy配置文件对于运维人员来说就比较痛苦了。
为了解决这样的问题，阿里出了一个dubbo，用于服务注册和查找管理，不过只支持java。
在研究dubbo和zookeeper的时候，偶然看到了consul，按官方说法，consul就是为了服务注册和发现而生的，非常感兴趣，遂研究了一下，现记录一些点。
本文不讲consul是什么，能做什么，也不讲如何配置监控，如何注册服务，也不讲如何配置图形监控界面，只讲讲如何在生产环境配置consul集群，我只是综合了参考文档中的内容，没有太多原创，而且也不涉及加密RPC通信部分，那部分其实就是生成CA和证书放到配置文件中。
下图是官网提供的集群大小和容错间的关系，可以参考。本文是以3个节点举例。
consul的生产集群配置说明

1.到consul官网下载最新版本
]# wget https://releases.hashicorp.com/consul/0.8.2/consul_0.8.2_linux_amd64.zip

2.解压缩
]# unzip consul_0.8.2_linux_amd64.zip -d /usr/local/bin
]# rm consul_0.8.2_linux_amd64.zip

3.增加consul用户，创建配置文件目录和数据文件目录
]# useradd consul

创建配置文件目录：
]# mkdir -p /etc/consul.d/server

创建consul存储数据的目录
]# mkdir /var/consul
]# chown consul:consul /var/consul

生成consul节点间通讯使用的共享密钥提高安全性
]# consul keygen
h1QXEtj8sdrFWmtmhES9lQ==

4.创建consul配置文件
consul节点默认的名字就是本机的hostname，所以尽量起一个含义清晰的名字。
当然也可以在配置文件中使用node指定。

假设我们要创建3个节点的集群，IP为：
node01: 10.0.0.1
node02: 10.0.0.2
node03: 10.0.0.3

node01的配置文件如下：
]# vi /etc/consul.d/server/config.json
{
    "advertise_addr": "10.0.0.1",
    "bind_addr": "10.0.0.1",
    "domain": "consul",
    "bootstrap_expect": 3,
    "server": true,
    "datacenter": "dc1",
    "data_dir": "/var/consul",
    "encrypt": "h1QXEtj8sdrFWmtmhES9lQ==",
    "enable_syslog": true,
    "performance": {
      "raft_multiplier": 1
    },
    "dns_config": {
        "allow_stale": true,
        "max_stale": "15s"
    },
    "retry_join": [
        "10.0.0.2",
        "10.0.0.3"
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
而node02，node03的配置文件与node01基本一样，除了以下两处要修改。
一是ip地址相应修改：
    "advertise_addr": "10.0.0.1",
    "bind_addr": "10.0.0.1",
二是retry_join这里要改成其他2个节点IP：
node02: "retry_join"  -->  "10.0.0.1","10.0.0.3"
node03: "retry_join"  -->  "10.0.0.1","10.0.0.2"

这里要说明的是bootstrap_expect，这是consul官方新推荐的形成集群的方法。
这个参数指定了要形成集群需要几个节点，当所需的节点都就位以后，集群自动开始选举leader。
如果没有达到指定数量，则不会开始组成集群，例如我们只启动node01，会看到如下输出：

[WARN] raft: EnableSingleNode disabled, and no known peers. Aborting election.

至于其他参数的含义，请自行参考官方文档。

5.创建consul的systemd启动文件
]# vi /usr/lib/systemd/system/consul.service

[Unit]
Description=consul agent
Requires=network-online.target
After=network-online.target

[Service]
EnvironmentFile=-/etc/sysconfig/consul
Restart=on-failure
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d/server -rejoin
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target

这里指定了环境变量的配置文件/etc/sysconfig/consul，如果需要配置GOMAXPROCS这样的Go相关变量，可以写在这里。
前边的"-"，意味着没有也可以，具体写法可以参考systemd的man文档。

6.当3个node都安装完毕以后，在3个节点上都启动consul服务
]# systemctl start consul
]# systemctl enable consul

集群开始进入选举过程，当leader选举完成后，集群即可开始正常工作，使用如下命令查看集群状态：
]# consul members -http-addr=127.0.0.1:80

参考文档：
https://www.digitalocean.com/community/tutorials/an-introduction-to-using-consul-a-service-discovery-system-on-ubuntu-14-04
https://www.digitalocean.com/community/tutorials/how-to-configure-consul-in-a-production-environment-on-ubuntu-14-04
https://www.digitalocean.com/community/tutorials/how-to-secure-consul-with-tls-encryption-on-ubuntu-14-04
http://www.adambonny.com/installing-consul-server-on-centos/
http://l-w-i.net/t/consul/0install_001.txt