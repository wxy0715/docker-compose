## 直接执行命令

```sh
mkdir -p /docker/docker-compose && cd /docker/docker-compose
wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/postgresql.zip && unzip postgresql.zip && rm -f postgresql.zip
cd /docker/docker-compose/postgresql
chmod -R 777 /docker/docker-compose/postgresql
docker-compose up -d
iptables -I INPUT -p tcp --dport 5432 -j ACCEPT
service iptables save
```

