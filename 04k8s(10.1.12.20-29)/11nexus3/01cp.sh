
# author:pengrk
# email:546711211@qq.com
# qq group:573283836

ssh root@10.1.12.20 "mkdir /nexus3/"
scp nexus.yaml root@10.1.12.20:/nexus3/nexus.yaml

# scp Dockerfile root@10.1.12.20:/nexus3/Dockerfile
# scp redis.yaml root@10.1.12.20:/nexus3/redis.yaml



# 1、下载nexus及上传到私有镜像库
# docker pull sonatype/nexus3
# docker tag sonatype/nexus3  10.1.11.60:5000/nexus3
# docker push 10.1.11.60:5000/nexus3

# #docker pull registry.cn-hangzhou.aliyuncs.com/devops/nexus3:3.3.1
# docker tag registry.cn-hangzhou.aliyuncs.com/devops/nexus3:3.3.1  10.1.11.60:5000/nexus3

# 2、运行nexus
# #docker run -d -p 8081:8081 --name nexus   10.1.11.60:5000/nexus3
# mkdir /etc/nexus-data && chown -R 200 /etc/nexus-data
# docker run -d -p 8081:8081  --restart=always  --name nexus -v /etc/nexus-data:/nexus-data 10.1.11.60:5000/nexus3

# docker run -d -p 6000:6000 --name nexus   --restart=always -v /etc/nexus-data:/nexus-data 10.1.11.60:5000/nexus3