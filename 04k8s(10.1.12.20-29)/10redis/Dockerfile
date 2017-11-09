# author:pengrk
# email:546711211@qq.com
# qq group:573283836

FROM 10.1.12.61:5000/centos


RUN yum -y install gcc openssl-devel libyaml-devel libffi-dev
RUN yum -y install gcc automake autoconf libtool make
RUN yum -y install ruby 
RUN yum -y install wget 
RUN gem sources --remove https://rubygems.org/
RUN gem sources -a https://ruby.taobao.org/
#RUN gem sources --add http://gems.ruby-china.org/ --remove https://rubygems.org/
#RUN gem install  redis
RUN wget http://download.redis.io/releases/redis-4.0.2.tar.gz 
RUN tar xvf redis-4.0.2.tar.gz 

# enter the dir must
RUN cd redis-4.0.2/ && make MALLOC=libc && make install  \
    &&   cp src/redis-trib.rb /usr/bin/ \
    &&   chmod 777 /usr/bin/redis-trib.rb  
     
RUN mkdir -p /usr/local/etc/redis-cluster/conf/  
RUN mkdir -p /usr/local/etc/redis-cluster/logs/ 
RUN mkdir -p /usr/local/etc/redis-cluster/data/node-6379/
RUN mkdir -p /usr/local/etc/redis-cluster/pid/


RUN mkdir /data 
VOLUME /data

WORKDIR /root/k8s-redis

#EXPOSE 6379
#CMD [ "/usr/bin/redis-server" ]

EXPOSE 6379
CMD [ "/usr/local/bin/redis-server","--protected-mode no" ]

#docker build -t 10.1.11.60:5000/mongo:3.4.4 /root/kubernetes-mongodb-cluster-public/my/ -f Dockerfile
#docker push 10.1.11.60:5000/mongo:3.4.4


# redis-cli
# redis> set foo bar
# OK
# redis> get foo
# "bar"





