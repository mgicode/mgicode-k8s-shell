# author:pengrk
# email:546711211@qq.com
# qq group:573283836
cd /nexus3/
docker build -t 10.1.12.61:5000/redis:4.0.2 /redis/ -f Dockerfile
docker push 10.1.12.61:5000/redis:4.0.2


docker run  --name redis    -p 6379:6379  -d 10.1.12.61:5000/redis:4.0.2
docker exec -it redis /bin/bash
docker exec -it mongredisdb  sh

#CONFIG SET protected-mode no