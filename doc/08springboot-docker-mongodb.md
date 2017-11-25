 # Spring boot+docker 半自动化部署(八)、mongodb的安装

mongodb作为nosql的数据库，使用由火热变成平淡，nosql的数据库有它的优势，但是缺点也是很明显。使用nosql越来越理性，这次实验没有采用mysql,而是mongodb。
mongodb作为集群的部署方式是比较简单的。这里采用三台机器的ReplicaSet进行部署。
其实验的ip为：192.168.0.14   192.168.0.15   192.168.0.16

```
NODE_IPS="192.168.0.14   192.168.0.15   192.168.0.16"
NODE_NAME="mongodb01 mongodb02 mongodb03"
```

## 创建 mongodb.service
 采用service的方式进行部署
 下面的代码没有什么好讲的，就是采用启动mongod，其配置采用指定文件/var/lib/mongodb/mongodb.conf
 
```
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
```

## 创建配置文件
对于在三台物理机上部署，其配置文件可以是相同，如果在一台物理机上部署，其端口是动态的。这里则采用
循环的方式分别创建配置文件 

```
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

```
这里需要注意的是其replSet的名称。在加入集群中需要该名称。


## 创建执行脚本

 执行脚本下载mongodb，解压，把相关执行文件放到/usr/local/bin/，之后启动mongodb的 service配置。


```
创建安装的shell
cat > /mongodbRelicaSet3/install-client.sh <<EOF

echo " export PATH=/usr/local/bin:\$PATH " >> /etc/profile
source /etc/profile

mkdir -p /mongodbRecilaSetWorking/
cd /mongodbRecilaSetWorking/

wget http://${FILE_SERVER_IP}/mongodb-linux-x86_64-rhel70-3.4.4.tgz  -q
tar  -zxvf mongodb-linux-x86_64-rhel70-3.4.4.tgz
rm  mongodb-linux-x86_64-rhel70-3.4.4.tgz
cp -r /mongodbRecilaSetWorking/mongodb-linux-x86_64-rhel70-3.4.4/bin/*  /usr/local/bin/
chmod 777 /usr/local/bin/*

mkdir  -p /var/lib/mongodb/

 systemctl daemon-reload
 systemctl enable mongodb
 systemctl start mongodb
 systemctl status mongodb

 sleep 3

EOF

```

## 安装
安装时先清除所在机器已经安装的版本，然后把配置文件、service、conf文件都上传到各台机器上。最后执行安装脚本 进行安装 

```

NODE_IPS="192.168.0.14   192.168.0.15   192.168.0.16"
NODE_NAME="mongodb01 mongodb02 mongodb03"

clearScript="   
    systemctl stop mongodb; 
    systemctl disable mongodb;

    rm -rf /mongodbRecilaSetWorking/;
    rm -rf /usr/local/bin/mongo*;
    rm -rf /usr/local/bin/bsondump;

    rm -rf /var/lib/mongodb/install-client.sh;
    rm -rf /etc/systemd/system/mongodb.service;
    rm -rf /var/lib/mongodb/
  "

checkScript="
    echo -e \"\033[32m ############### /var/lib/mongodb/至少包括install-client.sh ########### \033[0m\"
    ls /var/lib/mongodb/install-client.sh
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"

    echo -e \"\033[32m ############### /etc/systemd/system/至少包括mongodb.service ########### \033[0m\"
    ls /etc/systemd/system/mongodb.service
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"

    echo -e \"\033[32m ############### /var/lib/mongodb/至少包括mongodb.conf ########### \033[0m\"
    ls /var/lib/mongodb/mongodb.conf
    cat /var/lib/mongodb/mongodb.conf
    echo -e \"\033[32m ###############内容显示完成########### \033[0m\"
"

 安装mongodb
for ip in $NODE_IPS ;do
      echo "清除$ip中的mongodb安装的所有内容..."
      ssh root@$ip "$clearScript"

      echo "安装$ip的mongodb..."
      ssh root@$ip "mkdir -p /mongodbRecilaSetWorking/; mkdir -p /var/lib/mongodb/data/db/;mkdir -p /var/lib/mongodb/data/log/"

      scp /mongodbRelicaSet3/mongdbconf${ip##*.} root@$ip:/var/lib/mongodb/mongodb.conf  
      scp /mongodbRelicaSet3/mongodb.service    root@$ip:/etc/systemd/system/mongodb.service
      scp /mongodbRelicaSet3/install-client.sh  root@$ip:/var/lib/mongodb/install-client.sh
      ssh root@$ip "chmod 777 /var/lib/mongodb/install-client.sh; /var/lib/mongodb/install-client.sh;"

      ssh root@$ip "$checkScript"
      sleep 5

done


```
安装过程中可以看到服务active的标识，说明服务启动了。

## 安装集群
   
 ### 生成集群的脚本

 ```
#--eval -eval都可以 
#rs.initiate({"_id" : "mongodbRS${ip##*.}", "members" : [{_id: ${i1}, host: "127.0.0.1:17017"}, {_id: 1, host: "xxxhost: 20002"}]})
RS_CODES="mongo 127.0.0.1:27017/admin  --eval \"rs.initiate({'_id' : 'mongodbRS', 'members' : ["
i=0
for ip in $NODE_IPS ;do
   if [ $i -eq 0 ]; then
 	  RS_CODES="${RS_CODES}{_id: ${i}, host: '${ip}:27017'}"
   else
 	  RS_CODES="$RS_CODES,{_id: ${i}, host: '${ip}:27017'}"
   fi
   let i++
done

RS_CODES="${RS_CODES}]}) \""
echo -e "\033[32m ###############建立集群的脚本########### \033[0m"
echo "建立集群的脚本:${RS_CODES}"
echo -e "\033[32m ###############内容显示完成########### \033[0m"

sleep 5
 
 ```

 ### 第一台机器上运行建集群脚本

 ```
i=0
for ip in $NODE_IPS ;do
  echo "建立集群$ip..."
  if [ $i -eq 0 ]; then     
     ssh root@$ip "$RS_CODES"         
  fi
done
 sleep 10


 ```

 ### 查看集群状态
i=0
for ip in $NODE_IPS ;do
     echo "集群status$ip..." 
     ssh root@$ip "mongo 127.0.0.1:27017/admin  -eval \" rs.status()\" " 
     sleep 10 
done

