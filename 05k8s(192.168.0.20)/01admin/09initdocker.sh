
NODE_IPS="192.168.0.2  192.168.0.5 192.168.0.6  192.168.0.7  192.168.0.8  192.168.0.9  192.168.0.10  192.168.0.11 192.168.0.12   192.168.0.13  192.168.0.14   192.168.0.15   192.168.0.16 192.168.0.17  192.168.0.18    192.168.0.19"
NODE_NAME="ms02 ms05 ms06  ms07   ms08   ms09  ms10   ms11  ms12  ms13  ms14  ms15  ms16  ms17   ms18 ms19"


#3.3 安装
 Script="   
    cd /dockerWorking/
    wget http://192.168.0.20/docker/docker-17.06.2-ce.tgz  -q
    tar -xvf docker-17.06.2-ce.tgz
    mkdir  -p /usr/local/bin/
    cp -rf /dockerWorking/docker/docker*  /usr/local/bin/
    chmod 777 /usr/local/bin/*
   
     iptables -F &&  iptables -X &&  iptables -F -t nat &&  iptables -X -t nat

     systemctl daemon-reload
     systemctl enable docker
     systemctl start docker
     systemctl status docker
    sleep 3

  "

for ip in $NODE_IPS ;do
      echo "初始化$ip docker..."
      ssh root@$ip " mkdir -p /dockerWorking/; mkdir -p /etc/docker/; " 
      scp /docker/docker.service   root@$ip:/etc/systemd/system/docker.service
      scp /etc/docker/daemon.json  root@$ip:/etc/docker/daemon.json
      ssh root@$ip "$Script"
      sleep 5
done

