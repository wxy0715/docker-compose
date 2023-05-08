## 直接执行以下命令
```shell
  mkdir -p /docker/docker-compose && cd /docker/docker-compose
  wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/zookeeper.zip && unzip zookeeper.zip && rm -f zookeeper.zip
  cd /docker/docker-compose/zookeeper
  chmod -R 777 /docker/docker-compose/zookeeper
  docker-compose up -d zookeeper zookeeper-webui
  iptables -I INPUT -p tcp --dport 2181 -j ACCEPT
  iptables -I INPUT -p tcp --dport 9090 -j ACCEPT
  service iptables save
```