
ssh root@10.123.8.236 "mkdir /aliyunRepo/"

scp CentOS-Base.repo root@10.123.8.236:/aliyunRepo/CentOS-Base.repo
scp epel.repo root@10.123.8.236:/aliyunRepo/epel.repo
