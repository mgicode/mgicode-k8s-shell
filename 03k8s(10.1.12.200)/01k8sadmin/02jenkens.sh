# 主要为了测试一下该生成的模板

#1 初始化
sed -i "s/10.1.12.251/10.1.12.204/g" /etc/sysconfig/network-scripts/ifcfg-ens160
hostnamectl set-hostname k8sJenkins
systemctl restart systemd-hostnamed
service network restart
ip addr
reboot

#2 创建jenkins docker
# docker pull registry.cn-hangzhou.aliyuncs.com/base_containers/jenkins
# docker tag  registry.cn-hangzhou.aliyuncs.com/base_containers/jenkins  10.1.11.60:5000/jenkins
# docker push 10.1.12.201:5000/jenkins

mkdir /var/jenkins_home/
chown -R 1000 /var/jenkins_home/
chmod 777 /var/jenkins_home/
docker run -d   --name myjenkins -u root   --restart=always   \
-p 8080:8080 -p 50000:50000 -v /var/jenkins_home:/var/jenkins_home   10.1.12.201:5000/jenkins

#测试时发现没有设定该处，访问不了容器
cat  >/etc/sysctl.conf <<EOF
net.ipv4.ip_forward=1
EOF
systemctl restart network
sysctl net.ipv4.ip_forward


#3 访问 http://10.1.12.204:8080
curl http://10.1.12.204:8080
cat  /var/jenkins_home/secrets/initialAdminPassword


#生成id要不要的问题？
mkdir -p /publish/

ssh root@10.1.12.204
docker exec -it myjenkins  /bin/bash
ssh-keygen -t rsa
ssh-copy-id root@10.1.11.110
