
#  Spring boot+docker 半自动化部署 （一）、引言

微服务十分流行，基于微服务开发的项目越来越多，如何把开发的微服务部署到服务器上是一个不小的难题。现在有很多解决方案:

## (1)	gitlab+jenkens  

采用gitlab+jenkens等实现自动编译发布，无论是采用触发式（提交代码、定时）还是手动到jenkens的发布，对于开发者来讲都是不方便，需要部署集成gitlab+jenkens，而且很多时候公司使用的是svn。

另外在一般的公司很难保证提交的代码都能运行得起来。我所在的公司大部分情况下自动发布的项目是跑不起来（当然和公司的制度的有关），在我接触的某大型公司中技术负责人讲过，他花了一年时才把提交代码这件 事弄得较顺。

所以很多人讲Devops（包括自动发布）看上去很美。
## （2）购买一站式的DEVOPS  

该种方式没有什么好讲，只能讲有钱什么事都好解决，这个对于我们这等程序员来讲，不愿接受也不太现实的。  


本文给出一种简单的方式，从小公司更实用的角度出发，先采用半自动化的方式来进行微服务的部署。然后过渡到gitlab+Jenkins这种全自动化的部署方案。
微服务的部署可以直接部署在物理机，当然现在更流行的是部署在Docker环境中，如果需要更进一步的话，那么就是部署在kubernetes的网络上（之后的章节会详细讲解）。

只要通过shell脚本，就可以直接把你开发的微服务发布你需要发布的服务器上。

[Spring boot+docker 半自动化部署 （一）、引言 ](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/01springboot-docker-starter.md)

[Spring boot+docker 半自动化部署(二)、环境说明 ](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/02springboot-docker-evn.md)

[Spring boot+docker 半自动化部署(三)、使用演示 ](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/03springboot-docker-demonate.md)

[Spring boot+docker 半自动化部署(四)、网络设计 ](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/04springboot-docker-net-design.md)

[Spring boot+docker 半自动化部署(五)、管理机的安装 ](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/05springboot-docker-admin-init.md)

[Spring boot+docker 半自动化部署(六)、免密及初始化每一台机器](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/06springboot-docker-ssl-init.md)

[Spring boot+docker 半自动化部署(七)、反向代理上网](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/07springboot-docker-autiproxy-net.md)


[Spring boot+docker 半自动化部署(八)、mongodb的安装](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/08springboot-docker-mongodb.md)


[Spring boot+docker 半自动化部署(九)、redis的安装](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/09springboot-docker-redis.md)


[Spring boot+docker 半自动化部署(十)、consul的安装](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/10springboot-docker-consul.md)


[Spring boot+docker 半自动化部署(十一)、consul-template的安装](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/11springboot-docker-consul-template.md)


[Spring boot+docker 半自动化部署(十二)、测试连通程序的设计](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/12springboot-docker-echo-code.md)


[Spring boot+docker 半自动化部署(十三)、一键发布的代码处理](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/13springboot-docker-auto.md)

[Spring boot+docker 半自动化部署(十四)、consul和docker的问题](https://github.com/mgicode/mgicode-k8s-shell/blob/master/doc/14springboot-docker-consul-question.md)
