#部署到192.168.0.6
#去掉代理，不然访问不了192.168.0.20:5000/mgicode-echo，然后重启
#  echo  " export http_proxy=http://192.168.0.20:85 " >> /etc/profile
#  source /etc/profile

docker run -d   --name gateway-01  --restart=always  \
 --env ALL_CONF="--spring.application.name=gateway-01  --server.port=8080  --tcp.port=8081 \
   --spring.cloud.consul.discovery.enabled=true  \
 --spring.cloud.consul.host=192.168.0.17 --spring.cloud.consul.port=8500  spring.cloud.consul.discovery.tags=foo=bar,baz "  \
 -p 8080:8080 -p 8081:8081  192.168.0.20:5000/mgicode-echo:1.1
docker logs gateway-01


docker tag   registry.cn-hangzhou.aliyuncs.com/prk/mgicode-echo:1.1   192.168.0.20:5000/mgicode-echo:1.1
docker push 192.168.0.20:5000/mgicode-echo:1.1


docker stop  ms-05
docker rm ms-05
docker run -d   --name ms-05  --restart=always  \
 --env ALL_CONF="--spring.application.name=ms05  \
    --server.port=8080  \
    --tcp.port=8081 \
    --endpoints.health.sensitive=false \
    --management.security.enabled=false \
   --spring.cloud.consul.discovery.enabled=true  \   
   --spring.cloud.consul.discovery.instance-id=\${spring.application.name}-192.168.0.8
   --spring.cloud.consul.discovery.serviceName=ms05
   --spring.cloud.consul.discovery.hostname=192.168.0.8  \
   --spring.cloud.consul.discovery.port=\${server.port} \
   --spring.cloud.consul.host=192.168.0.17 \
   --spring.cloud.consul.port=8500      \
   --spring.cloud.consul.discovery.healthCheckUrl=http://192.168.0.8:8080/health \
   --spring.cloud.consul.discovery.tags=foo=bar,baz "  \
 -p 8080:8080 -p 8081:8081  192.168.0.20:5000/mgicode-echo:1.1
docker logs ms-05
curl http://192.168.0.8:8080/health


docker stop  ms-05
docker rm ms-05
docker run -d   --name ms-05  --restart=always  \
 --env ALL_CONF="--spring.application.name=ms05  \
    --server.port=8080  \
    --tcp.port=8081  \
    --endpoints.health.sensitive=false \
    --management.security.enabled=false \
    --management.health.consul.enabled=false \
   --spring.cloud.consul.discovery.enabled=true  \
   --spring.cloud.consul.host=192.168.0.17 \
   --spring.cloud.consul.port=8500      \
   --spring.cloud.consul.discovery.healthCheckUrl=\${management.contextPath}/health
  " \
 -p 8080:8080 -p 8081:8081  192.168.0.20:5000/mgicode-echo:1.1
docker logs ms-05
curl http://192.168.0.8:8080/health


#consul down的问题：{"status":"DOWN","discoveryComposite":{"description":"Spring Cloud Consul Discovery Client","status":"UP","discoveryClient":{"description":"Spring Cloud Consul Discovery Client","status":"UP","services":["consul","gateway-01","mgicode-echo","ms01","ms02","ms03","ms04","ms05"]}},"diskSpace":{"status":"UP","total":500068036608,"free":284706340864,"threshold":10485760},"refreshScope":{"status":"UP"},"consul":{"status":"DOWN","services":{"consul":[],"gateway-01":["foo=bar","baz"],"mgicode-echo":["foo=bar","baz"],"ms01":["foo=bar","baz"],"ms02":["foo=bar","baz"],"ms03":["foo=bar","baz"],"ms04":["foo=bar","baz"],"ms05":["foo=bar","baz"]},"error":"java.lang.IllegalArgumentException: Value must not be null"},"hystrix":{"status":"UP"}}

# builder.up()
# .withDetail("services", services.getValue())
# .withDetail("advertiseAddress", config.getAdvertiseAddress())
# .withDetail("datacenter", config.getDatacenter())
# .withDetail("domain", config.getDomain())
# .withDetail("nodeName", config.getNodeName())
# .withDetail("bindAddress", config.getBindAddress())
# .withDetail("clientAddress", config.getClientAddress());
