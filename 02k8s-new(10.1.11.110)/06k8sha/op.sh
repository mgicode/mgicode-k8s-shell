# author:pengrk
# email:546711211@qq.com
# qq group:573283836

docker build -t 10.1.11.60:5000/ha-k8s-master /root/my/ -f Dockerfile
docker push 10.1.11.60:5000/ha-k8s-master
docker stop ha01
docker rm ha01

docker exec  -it ha01  /bin/bash
haproxy restart





 # server master01 10.1.11.62:6443 check inter 2000 rise 3 fall 3 weight 30
 #    server master02 10.1.11.63:6443 check inter 2000 rise 3 fall 3 weight 30
 #    server master03 10.1.11.64:6443 check inter 2000 rise 3 fall 3 weight 30

 # server master01 ${MASTER01_IP_PORT} check inter 2000 rise 3 fall 3 weight 30
 #    server master02 ${MASTER02_IP_PORT}  check inter 2000 rise 3 fall 3 weight 30
 #    server master03  ${MASTER03_IP_PORT}  check inter 2000 rise 3 fall 3 weight 30