# author:pengrk
# email:546711211@qq.com
# qq group:573283836

docker pull consul:0.9.1
docker tag consul:0.9.1 10.1.12.61:5000/consul:0.9.1
docker push 10.1.12.61:5000/consul:0.9.1