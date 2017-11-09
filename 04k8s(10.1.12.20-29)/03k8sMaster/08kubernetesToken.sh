# author:pengrk
# email:546711211@qq.com
# qq group:573283836


cat > /ssl/token.csv <<EOF
${BOOTSTRAP_TOKEN},kubelet-bootstrap,10001,"system:kubelet-bootstrap"
EOF
cat /ssl/token.csv
