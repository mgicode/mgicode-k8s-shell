
FILE_SERVER_IP=192.168.0.20

mkdir -p /mongodbRecilaSetWorking/
cd /mongodbRecilaSetWorking/

wget http://${FILE_SERVER_IP}/mongodb-linux-x86_64-rhel70-3.4.4.tgz  -q
tar  -zxvf mongodb-linux-x86_64-rhel70-3.4.4.tgz
rm  mongodb-linux-x86_64-rhel70-3.4.4.tgz
cp -r /mongodbRecilaSetWorking/mongodb-linux-x86_64-rhel70-3.4.4/bin/*  /usr/local/bin/
chmod 777 /usr/local/bin/*


#mongo 192.168.0.14:27017