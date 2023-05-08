## 执行命令

```sh
  mkdir -p /docker/docker-compose && cd /docker/docker-compose
  wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/tomcat.zip && unzip tomcat.zip && rm -f tomcat.zip
  cd /docker/docker-compose/tomcat
  docker-compose up -d
  iptables -I INPUT -p tcp --dport 8081 -j ACCEPT
  service iptables save
```

注意端口是8081