## 执行命令

```sh
mkdir -p /docker/docker-compose && cd /docker/docker-compose
wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/rocketmq.zip && unzip rocketmq.zip && rm -f rocketmq.zip
cd /docker/docker-compose/rocketmq
chmod -R 777 /docker/docker-compose/rocketmq
## 需要修改下面截图配置文件的ip
docker-compose up -d mqnamesrv mqbroker1 mqconsole
iptables -I INPUT -p tcp --dport 9876 -j ACCEPT
iptables -I INPUT -p tcp --dport 19876 -j ACCEPT
iptables -I INPUT -p tcp --dport 17890 -j ACCEPT
iptables -I INPUT -p tcp --dport 10911 -j ACCEPT
iptables -I INPUT -p tcp --dport 10909 -j ACCEPT
iptables -I INPUT -p tcp --dport 10912 -j ACCEPT
service iptables save
```

![image-20230422205915327](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230422205915327.png)

## 访问ip:19876

![image-20230422205656167](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230422205656167.png)