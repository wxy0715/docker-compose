## 直接执行命令

```sh
  mkdir -p /docker/docker-compose && cd /docker/docker-compose
  wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/minio.zip && unzip minio.zip && rm -f minio.zip
  cd /docker/docker-compose/minio
  docker-compose up minio -d
  iptables -I INPUT -p tcp --dport 9003 -j ACCEPT
  iptables -I INPUT -p tcp --dport 9001 -j ACCEPT
  service iptables save
```

