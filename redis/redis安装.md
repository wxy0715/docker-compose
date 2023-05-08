## 直接执行以下命令
```shell
  mkdir -p /docker/docker-compose && cd /docker/docker-compose
  wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/redis.zip && unzip redis.zip && rm -f redis.zip
  chmod 777 /docker/docker-compose/redis/data
  cd /docker/docker-compose/redis
  docker-compose up -d redis
  iptables -I INPUT -p tcp --dport 6379 -j ACCEPT
  service iptables save
```