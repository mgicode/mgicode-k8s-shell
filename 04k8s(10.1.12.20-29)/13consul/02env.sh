# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#把环境变量统一起来

cp /etc/profile   /etc/profile_consul

mkdir -p /consul3/
cd /consul3/
wget http://${FILE_SERVER_IP}/consul -q

CONSUL_KEY_TOKEN=`consul keygen`

cat  >>/etc/profile <<EOF
export CONSUL_KEY_TOKEN="$CONSUL_KEY_TOKEN"
EOF


echo -e "\033[32m ###########检测生成的内容########### \033[0m"
cat /etc/profile
echo -e "\033[32m ###########内容显示完成########### \033[0m"

source /etc/profile