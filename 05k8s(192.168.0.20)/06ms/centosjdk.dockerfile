
#todo: 加上wget,telnet等
FROM   10.1.11.60:5000/centos
MAINTAINER  pengrk "546711211@qq.com"


RUN yum update
RUN yum install wget -y 

RUN mkdir /var/tmp/jdk
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  -P /var/tmp/jdk http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.tar.gz
RUN tar xzf /var/tmp/jdk/jdk-8u111-linux-x64.tar.gz -C /var/tmp/jdk
RUN rm -rf /var/tmp/jdk/jdk-8u111-linux-x64.tar.gz

ENV JAVA_HOME /var/tmp/jdk/jdk1.8.0_111
ENV PATH $PATH:$JAVA_HOME/bin:
