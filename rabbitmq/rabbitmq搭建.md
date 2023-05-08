## 执行命令

```sh
  mkdir -p /docker/docker-compose && cd /docker/docker-compose
  wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/rabbitmq.zip && unzip rabbitmq.zip && rm -f rabbitmq.zip
  cd /docker/docker-compose/rabbitmq
  chmod -R 777 /docker/docker-compose/rabbitmq
  docker-compose up -d --build
  iptables -I INPUT -p tcp --dport 5672 -j ACCEPT
  iptables -I INPUT -p tcp --dport 15672 -j ACCEPT
  service iptables save
```

## 访问页面

![image-20230422205526991](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230422205526991.png)

![image-20230422205546656](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230422205546656.png)