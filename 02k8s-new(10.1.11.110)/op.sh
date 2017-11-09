# author:pengrk
# email:546711211@qq.com
# qq group:573283836

vi /etc/systemd/system/flanneld.service
 sudo systemctl daemon-reload
 sudo systemctl enable flanneld
sudo systemctl start flanneld
systemctl status flanneld



netstat -tnl | grep 31817


yum install -y telnet
yum install -y nmap


(sleep 1; echo "GET / HTTP/1.1"; echo "Host: 172.16.63.6:9000"; echo;echo;sleep 2) | telnet 172.16.63.6 9000