
#  Spring boot+docker 半自动化部署(三)、使用演示  

  半自动化部署区别自动化部署在于对于代码合并检测都在于人工完成，而自动化部署需要编写大量的单元测试，通过自动化的运行来检测代码的可用性，采用github等版本库进行合并。实际情况是要求的单元测试都不会去哪里,正常的功能业务代码都没有时间去编写，怎么会好好去写单元测试。没有过硬的单元测试，难于保证持续集成的代码的正确性。即使有了单元测试，其合并的代码基本上永远通不过单元测试，jenkins发布出来的系统永远都是编译出错。
  半自动化部署从现实出发，把合并及简单的检测交给了开发微服务小组的技术负责人，他下载并合成代码，基本的检测通过之后，一键打包到服务器上去。

 ## 执行一键发布
![ideal exec](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/01pic/20171122-1723512x.png)
  图1 开发工具一键执行

在项目中建立一个发布文件夹（如图上的autoDeploy),然后直接使用工具的运行，对于windows的环境，只需要在xshell的命令中运行即可。

## 执行流程
一键发布首先在本机上编译并把编译的jar、dockerfile及startup.sh等文件上传到管理机，在管理机上运行相关指令，运行dockerfile编译成镜像文件，并上传，上传完成之后，根据配置的要求分发各自的安装指令到指定的机器上进行docker的安装，并运行起来。如下图2所示。

![flow](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/01pic/20171122-2121312x.png)

图2 运行流程

为什么需要这样来设计，尽管这样只需要一键运行，但是这样的过程有点麻烦，而springboot-docker-maven插件只需要在maven配置即可生成docker镜像，并上传到私有或公有镜像库。看起来很方便，实际上还是有一些问题，一是在maven中配置也是十分麻烦，需要在本地安装docker，安装docker如果不存在问题，那么其上传到私有镜像库则是会是有点问题，大部分情况下镜像库和开发并不在同一个网络，要把docker镜像push到只能通过ssh的连通的网络上去，需要进行的沟通太多了。

## 执行步骤

### 上传完成之后在管理机构建docker镜像
![build docker images](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/01pic/20171122-1752362x.png)
图2 构建镜像过程

### 发向到每台机器上启动过程
![tomcat startup](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/01pic/20171122-1752362x.png)

### 向consul中注册
![consul pic](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/01pic/20171122-1744532x.png)

### 测试http服务之间连通性
![http test](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/01pic/20171122-1746242x.png)

其代码可以参见 https://github.com/mgicode/mgicode-echo,这一个简单的地址，其实是经过负载均衡到api网关、再到微服务取得数据并返回，可见一键发布的Http之间是连通的。

### 测试tcp服务之间连通性

![tcp test2](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/01pic/20171122-1748372x.png)
其代码可以参见 https://github.com/mgicode/mgicode-echo, 这里通过了telnet,进行了tcp调用，实是经过负载均衡到api网关、再到微服务取得数据并返回，可见一键发布的Tcp之间是连通的。

只要在程序中配置数据库和redis，那么一个完整的微服务可以跑起来了。


