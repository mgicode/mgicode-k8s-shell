# author:pengrk
# email:546711211@qq.com
# qq group:573283836


NODE_IPS="10.1.11.190  10.1.11.191"
NODE_NAME="ingress190 ingress191"
for ip in $NODE_IPS ;do
    kubectl label nodes $ip ingress=nginx
    #kubectl label   -h nodes $ip ingress.haproxy=true 
    #kubectl label  nodes $ip ingress.haproxy-
done;



NODE_IPS="10.1.11.192  10.1.11.193"
NODE_NAME="ingress193 ingress193"
for ip in $NODE_IPS ;do
    kubectl label nodes $ip ingress=haproxy
done;



#https://github.com/kubernetes/ingress/blob/master/examples/tcp/nginx/nginx-tcp-ingress-controller.yaml


# This example shows how is possible to use a custom template

# First create a configmap with a template inside running:

# kubectl create configmap nginx-template --from-file=nginx.tmpl=../../nginx.tmpl
# Next create the rc kubectl create -f custom-template.yaml