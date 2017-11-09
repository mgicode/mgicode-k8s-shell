# author:pengrk
# email:546711211@qq.com
# qq group:573283836


#每次重启都都需要运行
ipvsadm
docker restart 


docker exec -it  k8s-ha  /bin/bash

把 docker运行的改成service的文件来运行，其前提是先运行ipvsadm ，参考 cilico的docker的service文档