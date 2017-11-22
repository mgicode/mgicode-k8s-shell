
NODE_IPS="10.1.12.80  10.1.12.81"
NODE_NAME="balance01 balance02 "


#/usr/sbin/keepalived -P -C -d -D -S 7 -f /etc/keepalived/keepalived.conf 

mkdir -p /balanceKeepAlive/
cd /balanceKeepAlive/
cat > /balanceKeepAlive/keepalive.service <<EOF
[Unit]
Description=balanceKeepAlive agent
Requires=network-online.target
After=network-online.target

#
[Service]
Restart=on-failure
#ExecStart=/usr/local/sbin/keepalived   -f /etc/keepalived/keepalived.conf
ExecStart=/usr/local/sbin/keepalived  -P -C -d -D -S 7 --dont-fork --log-console  -f /etc/keepalived/keepalived.conf
#ExecStart=/usr/local/sbin/keepalived  -f /etc/keepalived/keepalived.conf  --dont-fork --log-console  
#ExecStart=/usr/local/sbin/keepalived   -P -C -d -D --log-console  -f /etc/keepalived/keepalived.conf


ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target
EOF

echo -e "\033[32m ############### keepalive.service ########### \033[0m"
cat /balanceKeepAlive/keepalive.service
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 5