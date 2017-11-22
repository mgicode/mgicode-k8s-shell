http://blog.csdn.net/xuejiazhi/article/details/8941227
http://blog.csdn.net/xuejiazhi/article/details/8941227
https://www.cnblogs.com/pricks/p/3822232.html



另外一台Slave(192.168.187.132)做为备用服务器的机器按照同样的配置
 
5.KeepAlived安装配置
5.1 KeepAlived的安装方法
下载keepalived
[root@localhost /]:wget http://www.keepalived.org/software/keepalived-1.3.9.tar.gz
解压缩
[root@localhost /]:tar xzvf keepalived-1.2.7.tar.gz                                
安装
[root@localhost /]cd keepalived-1.2.7                                               
[root@localhost keepalived-1.2.7]./configure                                       
[root@localhost keepalived-1.2.7]make                                             
[root@localhost keepalived-1.2.7]make install                                     
5.2 将keepalived加入服务
按照上述安装方法，keepalived安装完成后，自动安装在/usr/local/sbin目录下面,配置文件
位置在/usr/local/etc/keepalived目录下面,具体操作如下:
/*在配置文件夹/etc下面建立keepalived文件夹*/
Mkdir /etc/keepalived 
/*将配置文件复制过去*/
Cp /usr/local/etc/keepalived/keepalived.conf  /etc/keepalived/   
/*将keepalived文件复制到/etc/init.d文件夹，这个文件夹存放可执行的服务程序*/
Cp /usr/local/etc/rc.d/init.d/keepalived   /etc/init.d  
/*将安装目录下面的系统配置文件复制到/etc/sysconfig,这是一个存放系统配文件的目录*/
Cp /usr/local/etc/sysconfig/keepalived  /etc/sysconfig/
/*开启服务*/
Service keepalived start
/*停止服务*/
Service keepalived stop
/*重启服务*/
Service keepalived restart
5.3  KeepAlived的配置

安装好以后，对其进行配置如下：
有两台机器(MASTER)所在的192.168.187.129与(SLAVE)192.168.187.132,用(VRRP)192.168.187.61做虚拟ＩＰ，在两台服务器中飘动,如下图:

在两台服各器中的/etc/keepalived文件夹中的keepalived.conf下进行配置:
Master的设置  
192.168.187.129
global_defs {
   router_id Haproxy　　#当前节点名
}
vrrp_instance VI_1{
    state MASTER       #指定Haproxy节点为主节点 备用节点上设置为BACKUP即可
interface eth0       #绑定虚拟IP的网络接口
virtual_router_id 51 #VRRP组名，两个节点的设置必须一样，以指明各个节点属于同一VRRP组
priority 150         #主节点的优先级（1-254之间），备用节点必须比主节点优先级低
acvert_int 1         #组播信息发送间隔，两个节点设置必须一样
authentication{      #设置验证信息，两个节点必须一致
    auth_type  PASS
    auth_pass  1111
}
Virtual_ipaddress{   #指定虚拟IP, 两个节点设置必须一样
192.168.187.61
     }
   }
 
Slave的设置 
192.168.187.132
global_defs {
   router_id Haproxy　　#当前节点名
}
vrrp_instance VI_1{
    state BACKUP       #指定Haproxy节点为备用节点 备用节点上设置为Master即可
interface eth0       #绑定虚拟IP的网络接口
virtual_router_id 51 #VRRP组名，两个节点的设置必须一样，以指明各个节点属于同一VRRP组
priority 100         #主节点的优先级（1-254之间），备用节点必须比主节点优先级低
acvert_int 1         #组播信息发送间隔，两个节点设置必须一样
authentication{      #设置验证信息，两个节点必须一致
    auth_type  PASS
    auth_pass  1111
}
Virtual_ipaddress{   #指定虚拟IP, 两个节点设置必须一样
192.168.187.61
     }
   }
5.4 KeepAlived测试

No1:第一种情况，双机都正常的情况
在(Master)192.168.187.129服务器上面查看ＩＰ，可以看到一个192.168.187.61的虚拟IP

而这时用IP addr在备机192.168.187.132上面查看，可以发现不存在192.168.187.61的虚拟IP

No2:第二种情况，Master已经宕机的情况
，再用 IP addr 查看，发现虚拟IP已经漂移到192.168.187.132这台机子上面来了，响应速度非常快，
实现了高可用性,如下图:
 
No3:第三种情况，Master已经恢复的情况
当Master恢复的情况下,用IP addr 再进行查看,发现虚拟IP再次漂移到192.168.187.129上面来了，
如下图：
