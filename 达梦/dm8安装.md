## 官方镜像

 [达梦数据库](https://eco.dameng.com/download/)

## 命令

docker load -i dm8_20220822_rev166351_x86_rh6_64_ctm.tar
## docker images

```sh
REPOSITORY     TAG                               IMAGE ID        CREATED             SIZE
dm8_single     v8.1.2.128_ent_x86_64_ctm_pack4   ccb727ce9dce    3 weeks ago         432MB
```

## 编写docker-compose

```yml
# docker-compose.yml
version: '3.7'
services:
  dm8:
    image: ccb727ce9dce
    restart: always
    hostname: 'localhost'
    container_name: dm8
    environment:
      TZ: Asia/Shanghai
    ports:
      - '5236:5236'
    volumes:
      - '/apps/dm8/data:/opt/dmdbms/data'
    network_mode: "bridge"
```

## 执行

```sh
docker-compose up -d  
```

## 用DM管理工具测试，连接默认密码： 

SYSDBA

SYSDBA001