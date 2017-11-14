
NODE_IPS="10.1.12.70  10.1.12.71  10.1.12.72"
NODE_NAME="mongodb01 mongodb02 mongodb03"

#安装集群

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


i=0
for ip in $NODE_IPS ;do
  echo "建立集群$ip..."
  if [ $i -eq 0 ]; then     
     ssh root@$ip "$RS_CODES"         
  fi
done
 sleep 10

#查看集群状态
i=0
for ip in $NODE_IPS ;do
     echo "集群status$ip..." 
     ssh root@$ip "mongo 127.0.0.1:27017/admin  -eval \" rs.status()\" " 
     sleep 10 
done




#mongo 127.0.0.1:17017/test –eval \"rs.status()\"
#mongo 10.1.12.29:27017/test -eval "rs.status()"
#todo mongoAdmin
#mongo 127.0.0.1:3003/test –eval “db.test.find().forEach(printjson);”

#todo: 为mongodb创建用户名和密码

#http://tcrct.iteye.com/blog/2108099

#mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]