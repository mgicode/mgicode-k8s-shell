# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#该证书是为kubectl使用的
cd /ssl/
cat > admin-csr.json << EOF
{
  "CN": "admin",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "BeiJing",
      "L": "BeiJing",
      "O": "system:masters",
      "OU": "System"
    }
  ]
}
EOF

cfssl gencert -ca=/ssl/ca.pem -ca-key=/ssl/ca-key.pem -config=/ssl/ca-config.json  \
   -profile=kubernetes /ssl/admin-csr.json | cfssljson -bare admin

echo -e "\033[32m ###############生成的admin的ssl证书,admin-key.pem admin.pem  admin.csr########### \033[0m"
ls /ssl/admin*
echo -e "\033[32m ###########内容显示完成########### \033[0m"

