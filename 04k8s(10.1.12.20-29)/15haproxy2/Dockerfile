FROM 10.1.11.60:5000/centos
# psmisc for killall命令
RUN yum install -y wget gcc  make pcre-static pcre-devel   

RUN wget  http://10.1.11.20/haproxy-1.7.5.tar.gz \
    && tar -xzf haproxy-1.7.5.tar.gz  

RUN cd haproxy-1.7.5  \
    && make TARGET=linux2628 PREFIX=/usr/local/haproxy \
    && make install PREFIX=/usr/local/haproxy

RUN cp /usr/local/haproxy/sbin/haproxy /usr/sbin/ \
    && cd haproxy-1.7.5  \
    && cp ./examples/haproxy.init /etc/init.d/haproxy \
    && chmod 755 /etc/init.d/haproxy

RUN    echo "net.ipv4.ip_nonlocal_bind=1" >> /etc/sysctl.conf
#采用源码编译的找不到网络，vip加不到网卡上去，只能采用yum安装
RUN yum install -y keepalived
# sh: killall: command not found
RUN  yum install -y psmisc
# psmisc for killall命令 IPVS: ipvsadm Can't initialize ipvs: Protocol not available
RUN yum install -y  ipvsadm
ADD start.sh /start.sh 
RUN chmod +x /start.sh

ENTRYPOINT /start.sh
