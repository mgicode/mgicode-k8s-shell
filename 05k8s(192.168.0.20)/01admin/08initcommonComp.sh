
NODE_IPS="192.168.0.2  192.168.0.5 192.168.0.6  192.168.0.7  192.168.0.8  192.168.0.9  192.168.0.10  192.168.0.11 192.168.0.12   192.168.0.13  192.168.0.14   192.168.0.15   192.168.0.16 192.168.0.17  192.168.0.18    192.168.0.19"
NODE_NAME="ms02 ms05 ms06  ms07   ms08   ms09  ms10   ms11  ms12  ms13  ms14  ms15  ms16  ms17   ms18 ms19"

# for ip in $NODE_IPS ;do
#       echo "$ip reboot..."
#       ssh root@$ip "reboot"
#       sleep 5
# done


 mkdir -p /common/
 cat > /common/yuninit.sh << EOF
    yum makecache ;
    yum install wget -y ;
    yum install -y telnet nmap curl ;
    yum install unzip -y ;
    yum install traceroute -y  ;
    yum install mtr -y  ;

EOF

for ip in $NODE_IPS ;do
      echo "初始化$ip常用组件..."
      ssh root@$ip "$Script"
      ssh root@$ip "mkdir /initCommon/"
      scp /common/yuninit.sh  root@$ip:/initCommon/yuninit.sh
      ssh root@$ip "chmod 777 /initCommon/yuninit.sh; /initCommon/yuninit.sh;"

      sleep 5
done

#192.168.0.2 