
NODE_IPS="10.1.12.80  10.1.12.81"
NODE_NAME="balance01 balance02 "

CONSUL_TEMPLATE_IP_PORT="10.1.12.27:8500"

mkdir -p /consulTemplate/
cd /consulTemplate/

cat > /consulTemplate/consultemplate.service <<EOF
[Unit]
Description=consultemplate agent
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
ExecStart=/usr/local/bin/consul-template  \\
      -template "/etc/consul-template/haproxy.ctmpl:/etc/haproxy/haproxy.cfg" \\
      -consul-addr "${CONSUL_TEMPLATE_IP_PORT}"  
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target

EOF


echo -e "\033[32m ############### haproxy.service ########### \033[0m"
cat /consulTemplate/consultemplate.service
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 5
