# author:pengrk
# email:546711211@qq.com
# qq group:573283836

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


EXPOSE 27017 27018 27019 27020
CMD mongod

#docker build -t 10.1.11.60:5000/mongo:3.4.4 /root/kubernetes-mongodb-cluster-public/my/ -f Dockerfile
#docker push 10.1.11.60:5000/mongo:3.4.4
