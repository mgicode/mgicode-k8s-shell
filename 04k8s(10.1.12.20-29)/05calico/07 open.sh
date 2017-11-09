# author:pengrk
# email:546711211@qq.com
# qq group:573283836


#这里只开放 130，140，150，160，170，180,190,191,192,193几台机器
for ip in $NODE_NODE_IPS ;do
  echo "$ip开放外网能访问的端口..." 
  ssh root@$ip "iptables -P FORWARD ACCEPT"
 sleep 2
done
