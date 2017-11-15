
NODE_IPS="10.1.12.76  10.1.12.77"
NODE_NAME="redis01 redis02 "

mkdir -p /redis2/
cd /redis2/
cat > /redis2/redis.service <<EOF
[Unit]
Description=redis agent
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
ExecStart=/usr/local/bin/redis-server /etc/redis2/redis.conf 
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target
EOF

echo -e "\033[32m ############### consul.service ########### \033[0m"
cat /redis2/redis.service
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 5