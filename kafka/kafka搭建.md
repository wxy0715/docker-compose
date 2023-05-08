## 需要先安装zookeeper

安装教程:https://gitee.com/wxy0715/project/blob/master/docker-compose/zookeeper/zookeeper%E5%AE%89%E8%A3%85.md

## 执行命令

```sh
mkdir -p /docker/docker-compose && cd /docker/docker-compose
wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/kafka.zip && unzip kafka.zip && rm -f kafka.zip
cd /docker/docker-compose/kafka
## 修改配置文件docker-compose.yml的ip
chmod -R 777 /docker/docker-compose/kafka
docker-compose up -d kafka kafka-manager
iptables -I INPUT -p tcp --dport 9092 -j ACCEPT
iptables -I INPUT -p tcp --dport 19092 -j ACCEPT
service iptables save
```

## 访问 ip:19092

![image-20230422205757327](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230422205757327.png)