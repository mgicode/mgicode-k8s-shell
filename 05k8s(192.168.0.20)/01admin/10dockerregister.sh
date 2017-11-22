
docker run -d -p 5000:5000 --restart=always --name registryV2   \
 -v my_regisitry:/var/lib/registry  registry:2

docker tag registry:2  192.168.0.20:5000/registry:2
docker push 192.168.0.20:5000/registry:2