
#在k8sadmin 搭建一个静态文件Web服务，方便下载

#curl 10.1.12.61:5000/v2/_catalog
#docker pull 10.1.12.61:5000/nginx:1.7.9

docker pull nginx:1.7.9

mkdir /www
#把相关的文件放到宿主机的/www中，即可直接访问
docker run -d -v  /www:/usr/share/nginx/html --restart=always \
  --name nginx-server -p 80:80  nginx:1.7.9 

  mkdir  -p /www/docker/
  cp /docker/docker-17.06.2-ce.tgz  /www/docker/docker-17.06.2-ce.tgz
  wget http://192.168.0.20/docker/docker-17.06.2-ce.tgz

#9 把需要的文件放到/www上去
