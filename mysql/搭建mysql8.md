## 下载

进入linux 执行  mkdir -p /docker/docker-compose && cd /docker/docker-compose

wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/mysql.zip && unzip mysql.zip && rm -f mysql.zip

## 安装

```sh
cd /docker/docker-compose/mysql && docker-compose -f docker-compose-mysql8.0.yml -p mysql8 up -d
docker ps # 查看mysql是否启动
```