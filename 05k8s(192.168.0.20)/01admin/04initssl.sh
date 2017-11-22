yum install  -y  expect
yum install epel-release -y
yum install ansible -y

#在机下生成公钥/私钥对
ssh-keygen -t rsa -P ''
#Your identification has been saved in /root/.ssh/id_rsa.
#Your public key has been saved in /root/.ssh/id_rsa.pub.
# 8f:e1:96:6e:e3:71:c0:d1:1c:fd:e9:2b:78:46:4c:e1 root@manage.novalocal
