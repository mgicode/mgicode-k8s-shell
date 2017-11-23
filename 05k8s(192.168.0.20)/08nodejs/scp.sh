scp Dockerfile root@202.121.178.167:/root/nodejs/Dockerfile 

docker build -t 192.168.0.20:5000/nodejs  /root/nodejs/  -f Dockerfile