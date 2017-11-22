

NODE_IPS="192.168.0.2  192.168.0.5 192.168.0.6  192.168.0.7  192.168.0.8  192.168.0.9  192.168.0.10  192.168.0.11 192.168.0.12   192.168.0.13  192.168.0.14   192.168.0.15   192.168.0.16 192.168.0.17  192.168.0.18    192.168.0.19"
NODE_NAME="ms02 ms05 ms06  ms07   ms08   ms09  ms10   ms11  ms12  ms13  ms14  ms15  ms16  ms17   ms18 ms19"

#3.3 安装
for ip in $NODE_IPS ;do
      echo "初始化$ip aliyu 的..."
      ssh root@$ip "cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak1"
      ssh root@$ip "cp /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.bak1"
     
      scp /aliyunRepo/CentOS-Base.repo root@$ip:/etc/yum.repos.d/CentOS-Base.repo
      scp /aliyunRepo/epel.repo root@$ip:/etc/yum.repos.d/epel.repo

      ssh root@$ip " ls /etc/yum.repos.d/"
      
      sleep 10
done

#/etc/yum.repos.d/

# NODE_IPS="192.168.0.20"
# NODE_NAME="ms02"

# #3.3 安装
# for ip in $NODE_IPS ;do
#       echo "初始化$ip aliyu 的..."
#       ssh root@$ip "yum install make"     
     
# done

