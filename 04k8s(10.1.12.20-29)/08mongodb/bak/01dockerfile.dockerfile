FROM 10.1.11.60:5000/centos
#/usr/bin/mongo
RUN cd /usr/local \
     && yum install -y wget \
    #&& wget wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-3.4.4.tgz \
    && wget http://10.1.12.20/mongodb-linux-x86_64-rhel70-3.4.4.tgz \
    && tar -zxvf mongodb-linux-x86_64-rhel70-3.4.4.tgz \
    && rm mongodb-linux-x86_64-rhel70-3.4.4.tgz \
    && cp mongodb-linux-x86_64-rhel70-3.4.4/bin/* /usr/bin/  
    #&& cp mongodb-linux-x86_64-rhel70-3.4.4/bin/{mongod,bsondump,mongo,mongodump,mongoexport,mongofiles,mongoimport,mongooplog,mongoperf,mongoreplay,mongorestore,mongos,mongostat,mongotop} /usr/bin/ \
#通过kubectl获得取ips
RUN curl -o kubectl https://storage.googleapis.com/kubernetes-release/release/v1.6.1/bin/linux/amd64/kubectl \
     && cp kubectl /var/run/ \
     && chmod 777 /var/run/kubectl
# SERVICE=`/var/run/kubectl describe service/pxc-server | grep 3306 | grep -i endpoints | awk '{print $2}' | sed s/':3306'/''/g`
#把/root/.kube/config 先copy到当前的目录 ，之后复制到容器中去
RUN mkdir /root/.kube/
COPY config /root/.kube/config
RUN chmod 777 /root/.kube/config

EXPOSE 27017 27018 27019 27020
CMD mongod
#docker build -t 10.1.11.60:5000/mongo:3.4.4 /root/kubernetes-mongodb-cluster-public/my/ -f Dockerfile
#docker push 10.1.11.60:5000/mongo:3.4.4
