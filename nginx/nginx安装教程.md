## 执行命令

```sh
mkdir -p /docker/docker-compose && cd /docker/docker-compose
wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/nginx.zip && unzip nginx.zip && rm -f nginx.zip
cd /docker/docker-compose/nginx
docker-compose up -d
iptables -I INPUT -p tcp --dport 80 -j ACCEPT
service iptables save
```