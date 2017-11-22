
#######################################################
# 这里指定了环境变量的配置文件/etc/sysconfig/consul，如果需要配置GOMAXPROCS这样的Go相关变量，
#可以写在这里。 前边的"-" 意味着没有也可以

cd /consul3/
cat > /consul3/consul.service <<EOF
[Unit]
Description=consul agent
Requires=network-online.target
After=network-online.target

[Service]
EnvironmentFile=-/etc/sysconfig/consul
Restart=on-failure
ExecStart=/usr/local/bin/consul agent -ui -config-dir=/etc/consul.d/server -rejoin
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target
EOF

echo -e "\033[32m ############### consul.service ########### \033[0m"
cat /consul3/consul.service
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 5