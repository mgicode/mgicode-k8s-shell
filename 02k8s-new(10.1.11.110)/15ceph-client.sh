# author:pengrk
# email:546711211@qq.com
# qq group:573283836

#初始化client

rbd create disk01 --size 40960
rbd ls -l
modprobe rbd
rbd feature disable disk01 exclusive-lock object-map fast-diff deep-flatten
rbd map disk01
rbd showmapped

mkfs.xfs /dev/rbd0 #这里需要换掉

mkdir -p /mnt/mydisk
mount /dev/rbd0 /mnt/mydisk
df -hT


cd /usr/local/bin/
cat >/usr/local/bin/rbd-mount <<EOF
#!/bin/bash
# Script Author: http://bryanapperson.com/
# Change with your pools name
export poolname=rbd
 
# CHange with your disk image name
export rbdimage=disk01
 
# Mount Directory
export mountpoint=/mnt/mydisk
 
# Image mount/unmount and pool are passed from the systems service as arguments
# Determine if we are mounting or unmounting
if [ "\$1" == "m" ]; then
   modprobe rbd
   rbd feature disable $rbdimage exclusive-lock object-map fast-diff deep-flatten
   rbd map \$rbdimage --id admin --keyring /etc/ceph/ceph.client.admin.keyring
   mkdir -p \$mountpoint
   mount /dev/rbd/$poolname/$rbdimage $mountpoint
fi
if [ "\$1" == "u" ]; then
   umount \$mountpoint
   rbd unmap /dev/rbd/\$poolname/\$rbdimage
fi
EOF

chmod +x /usr/local/bin/rbd-mount

cat  >/etc/systemd/system/rbd-mount.service  <<EOF
[Unit]
Description=RADOS block device mapping for $rbdimage in pool \$poolname"
Conflicts=shutdown.target
Wants=network-online.target
After=NetworkManager-wait-online.service
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/rbd-mount m
ExecStop=/usr/local/bin/rbd-mount u
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable rbd-mount.service


