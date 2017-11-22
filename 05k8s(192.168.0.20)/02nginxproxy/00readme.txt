情况：

只有192.168.0.20能上外网，其它的机器不能上外网

1、在192.168.0.20 建立nginx代理 



2、每台机器加上http-proxy的指向



3、yum 用不了，需要把yum源换成aliyun的http,同时把其中file协议换成http



4、docker https用不了,待解决
