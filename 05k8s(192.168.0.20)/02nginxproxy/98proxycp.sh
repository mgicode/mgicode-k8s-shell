
#first step : download nginx docker and install nginx
docker run -d    -v /etc/nginx:/etc/nginx  -v /usr/local/nginx/conf/:/usr/local/nginx/conf/      --restart=always \
--privileged=true  --net=host  --name nginx-proxy2 -p 85:85  nginx

docker run -d    -v /etc/nginx:/etc/nginx  -v /usr/local/nginx/conf/:/usr/local/nginx/conf/      --restart=always \
--privileged=true  --net=host  --name nginx-proxy2 -p 84:84  nginx:1.7.9 

 #-v /etc/nginx/:/etc/nginx/
#/usr/local/nginx/conf/

# docker run -d   -v /nginx:/etc/nginx --restart=always \
#  --name nginx-proxy -p 80:80  nginx:1.7.9 

#docker exec -it nginx-proxy  /bin/bash

# second step: add the conf
scp 00proxy.conf root@10.123.8.236:/usr/local/nginx/conf/proxy.conf

scp 00proxy.conf root@10.123.8.236:/etc/nginx/nginx.conf

# third step: restart
docker restart nginx-proxy

#forth step: modefy every computer
#初始化能上网的代理 
NODE_IPS="192.168.0.2  192.168.0.5 192.168.0.6  192.168.0.7  192.168.0.8  192.168.0.9  192.168.0.10  192.168.0.11 192.168.0.12   192.168.0.13  192.168.0.14   192.168.0.15   192.168.0.16 192.168.0.17  192.168.0.18    192.168.0.19"
NODE_NAME="ms02 ms05 ms06  ms07   ms08   ms09  ms10   ms11  ms12  ms13  ms14  ms15  ms16  ms17   ms18 ms19"

for ip in $NODE_IPS ;do
      echo "初始化$ip proxy..."
       Script=" 
          echo \" export http_proxy=http://192.168.0.20:85 \" >> /etc/profile
          #echo \" export https_proxy=https://192.168.0.20:443 \" >> /etc/profile 
          source /etc/profile
          curl www.google.cn
        "
      ssh root@$ip "$Script"
      sleep 5
done




#  echo  " export http_proxy=http://192.168.0.20:85 " >> /etc/profile
#  source /etc/profile
