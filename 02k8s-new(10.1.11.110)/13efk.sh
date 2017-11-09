# author:pengrk
# email:546711211@qq.com
# qq group:573283836


kubectl create -f 13efk/efk.yaml

kubectl cluster-info



NODE_IPS="10.1.11.130  10.1.11.131 10.1.11.132  10.1.11.133  10.1.11.134  10.1.11.135  10.1.11.136  10.1.11.137 10.1.11.138  10.1.11.139"
NODE_NAME="sys130 sys131  sys132  sys133  sys134  sys135  sys136  sys137  sys138  sys139"
for ip in $NODE_IPS ;do
    kubectl label nodes $ip  beta.kubernetes.io/fluentd-ds-ready=true
done;

NODE_IPS="10.1.11.140  10.1.11.141 10.1.11.142  10.1.11.143  10.1.11.144  10.1.11.145"
NODE_NAME="msc140 msc141  msc142  msc143  msc144   msc145"
for ip in $NODE_IPS ;do
     kubectl label nodes $ip  beta.kubernetes.io/fluentd-ds-ready=true
done;




NODE_IPS="10.1.11.150  10.1.11.151 10.1.11.152  10.1.11.153 10.1.11.154 10.1.11.155  10.1.11.156"
NODE_NAME="ms150  ms151 ms152  ms153   ms154   ms155   ms156"
for ip in $NODE_IPS ;do
	kubectl label nodes $ip  beta.kubernetes.io/fluentd-ds-ready=true
done;


NODE_IPS="10.1.11.170  10.1.11.171 10.1.11.172  10.1.11.173  10.1.11.174  10.1.11.175  10.1.11.176  10.1.11.177  10.1.11.178   10.1.11.179"
NODE_NAME="base170  base171  base172  base173  base174  base175  base176  base177  base178   base179"
for ip in $NODE_IPS ;do
     kubectl label nodes $ip  beta.kubernetes.io/fluentd-ds-ready=true
done;


NODE_IPS="10.1.11.190  10.1.11.191 10.1.11.192  10.1.11.193"
NODE_NAME="ingress190 ingress191  ingress192  ingress193"
for ip in $NODE_IPS ;do
     kubectl label nodes $ip  beta.kubernetes.io/fluentd-ds-ready=true
done;




