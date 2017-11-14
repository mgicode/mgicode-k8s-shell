
# must create dir :/var/lib/mongodb
#must put mongod into /usr/local/bin/
#must create conf file in  /var/lib/mongodb/mongodb.conf 

#######################################################
# 
mkdir -p /mongodbRelicaSet3/
cd /mongodbRelicaSet3/
cat > /mongodbRelicaSet3/mongodb.service <<EOF
[Unit]
Description=mongodb 
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
WorkingDirectory=/var/lib/mongodb
ExecStart=/usr/local/bin/mongod \\
     --config=/var/lib/mongodb/mongodb.conf 
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/var/lib/mongodb --shutdown \\
     --config=/var/lib/mongodb/mongodb.conf 
PrivateTmp=true
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo -e "\033[32m ############### mongodb.service ########### \033[0m"
cat /mongodbRelicaSet3/mongodb.service
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 5