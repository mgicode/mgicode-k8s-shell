# author:pengrk
# email:546711211@qq.com
# qq group:573283836

ssh root@10.1.12.20  "mkdir  -p /consul/"
scp consul.yaml    root@10.1.12.20:/consul/consul.yaml
scp consul-join.yaml    root@10.1.12.20:/consul/consul-join.yaml




