# author:pengrk
# email:546711211@qq.com
# qq group:573283836

ssh root@10.1.12.20 "mkdir /redis/"
scp Dockerfile root@10.1.12.20:/redis/Dockerfile

scp redis.yaml root@10.1.12.20:/redis/redis.yaml