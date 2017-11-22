NODE_IPS="192.168.0.2  192.168.0.5 192.168.0.6  192.168.0.7  192.168.0.8  192.168.0.9  192.168.0.10  192.168.0.11 192.168.0.12   192.168.0.13  192.168.0.14   192.168.0.15   192.168.0.16 192.168.0.17  192.168.0.18    192.168.0.19"
NODE_NAME="ms02 ms05 ms06  ms07   ms08   ms09  ms10   ms11  ms12  ms13  ms14  ms15  ms16  ms17   ms18 ms19"


for ip in $NODE_IPS ;do
      echo "初始化$ip proxy..."
       Script=" 
          echo \" export http_proxy=http://192.168.0.20:85 \" >> /etc/profile
          #echo \" export https_proxy=https://192.168.0.20:443 \" >> /etc/profile         
          source /etc/profile
          curl www.google.cn
        "
      ssh root@$ip "$Script"
      sleep 5
done

#  echo  " export http_proxy=http://192.168.0.20:85 " >> /etc/profile
#  source /etc/profile
