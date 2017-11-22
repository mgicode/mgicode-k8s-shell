docker pull registry.cn-hangzhou.aliyuncs.com/prk/centos
docker tag  registry.cn-hangzhou.aliyuncs.com/prk/centos  192.168.0.20:5000/centos
docker push 192.168.0.20:5000/centos

docker pull registry.cn-hangzhou.aliyuncs.com/prk/centos7_jdk1.8
docker tag  registry.cn-hangzhou.aliyuncs.com/prk/centos7_jdk1.8  192.168.0.20:5000/centos7_jdk1.8
docker push 192.168.0.20:5000/centos7_jdk1.8

#mac telnet ://curl -v telnet://127.0.0.1:8081

