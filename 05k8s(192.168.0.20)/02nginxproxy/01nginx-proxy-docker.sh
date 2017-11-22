
#first step : download nginx docker and install nginx

docker pull nginx
docker tag nginx 192.168.0.20:5000/nginx
docker push 192.168.0.20:5000/nginx

docker run -d    -v /etc/nginx:/etc/nginx  -v /usr/local/nginx/conf/:/usr/local/nginx/conf/      --restart=always \
--privileged=true  --net=host  --name nginx-proxy -p 85:85  nginx
