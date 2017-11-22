# author:pengrk
# email:546711211@qq.com
# qq group:573283836



NODE_IPS="192.168.0.14   192.168.0.15   192.168.0.16"
NODE_NAME="mongodb01 mongodb02 mongodb03"


# dbpath:数据库文件路径
# logpath:日志文件路径
# logappend:是否追加日志
# port:端口
# fork:是否以后台进程启动
# auth:是否启动授权认证
# nohttpinterface:是否支持HTTP形式访问

# copy to /var/lib/mongodb/mongodb.conf 

#3.2生成三个配置文件 
for ip in $NODE_IPS ;do
cat > /mongodbRelicaSet3/mongdbconf${ip##*.} <<EOF
dbpath=/var/lib/mongodb/data/db/
logpath=/var/lib/mongodb/data/log/mongodb.log
logappend=true
port=27017
fork=true
#nohttpinterface=true
#auth=true
#副本集名称，同一个副本集，名称必须一致  
replSet=mongodbRS 

EOF

echo -e "\033[32m ###############/mongodbRelicaSet3/mongdbconf${ip##*.} ########### \033[0m"
cat /mongodbRelicaSet3/mongdbconf${ip##*.}
echo -e "\033[32m ###########内容显示完成########### \033[0m"

sleep 5
done;

