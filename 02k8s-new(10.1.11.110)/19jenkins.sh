docker pull registry.cn-hangzhou.aliyuncs.com/base_containers/jenkins
docker tag  registry.cn-hangzhou.aliyuncs.com/base_containers/jenkins  10.1.11.60:5000/jenkins
docker push 10.1.11.60:5000/jenkins

ssh root@10.1.11.115

mkdir /var/jenkins_home/
chown -R 1000 /var/jenkins_home/
chmod 777 /var/jenkins_home/
docker run -d   --name myjenkins -u root   --restart=always   \
-p 8080:8080 -p 50000:50000 -v /var/jenkins_home:/var/jenkins_home   10.1.11.60:5000/jenkins


# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#访问 http://10.1.11.15:8080

curl http://10.1.11.15:8080
cat  /var/jenkins_home/secrets/initialAdminPassword

mkdir -p /publish/

ssh root@10.1.11.115
docker exec -it myjenkins  /bin/bash
ssh-keygen -t rsa
ssh-copy-id root@10.1.11.110

#2.生成key
# ssh-keygen -t rsa //多按几个回车,不要给key加密码,当然也可以加密码,后面jenkins里可以设置
# cd /var/lib/jenkins/ && mkdirsshkey //切换到jenkins工作目录并创建sshkey用于存密钥
# cp /home/deploy/.ssh/id_rsa* ./sshkey/    //把刚才生成的密钥拷贝过来
# chown jenkins.jenkins ./sshkey/ -R    //个性key的权限为jenkins用户.即运行jenkins程序的用户
# su - deploy //切换到deploy用户
# ssh-copy-idroot@192.168.199.212  //把密钥拷贝到远程服务器上.这里远程使用了root,不过建议使用普通用户,即运行tomcat的用户身份去做更安全一些.