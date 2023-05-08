## 直接执行命令

```sh
mkdir -p /docker/docker-compose && cd /docker/docker-compose
wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/mongo.zip && unzip mongo.zip && rm -f mongo.zip
cd /docker/docker-compose/mongo
chmod -R 777 /docker/docker-compose/mongo
docker-compose up -d
iptables -I INPUT -p tcp --dport 27017 -j ACCEPT
iptables -I INPUT -p tcp --dport 1234 -j ACCEPT
service iptables save
```

## 访问ip:1234端口图形页面

![image-20230422205240156](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230422205240156.png)