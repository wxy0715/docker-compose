## 下载

进入linux 执行

```sh
# 获取文件
mkdir -p /docker/docker-compose && cd /docker/docker-compose
wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/elk.zip && unzip elk.zip && rm -f elk.zip

# 开权限
chmod 777 /docker/docker-compose/elk/elasticsearch/data
chmod 777 /docker/docker-compose/elk/elasticsearch/logs
chmod 777 /docker/docker-compose/elk/elasticsearch/plugins

# 启动
cd /docker/docker-compose/elk
docker-compose up -d elasticsearch kibana logstash

# 开端口
# logstash
iptables -I INPUT -p tcp --dport 9600 -j ACCEPT
# logstash-tcp模式
iptables -I INPUT -p tcp --dport 5000 -j ACCEPT
# filebeat
iptables -I INPUT -p tcp --dport 5044 -j ACCEPT
# elasticsearch
iptables -I INPUT -p tcp --dport 9200 -j ACCEPT
# kibana
iptables -I INPUT -p tcp --dport 5601 -j ACCEPT
service iptables save
```

## 访问页面

![image-20230420224016274](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230420224016274.png)

![image-20230420223953088](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230420223953088.png)