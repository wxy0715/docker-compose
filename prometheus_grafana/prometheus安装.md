## 配置文件查看地址

https://gitee.com/wxy0715/docker-compose/tree/main/prometheus_grafana

## 下载

```sh
mkdir -p /docker/docker-compose && cd /docker/docker-compose
wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/prometheus_grafana.zip && unzip prometheus_grafana.zip && rm -f prometheus_grafana.zip
cd /docker/docker-compose/prometheus_grafana
chmod -R 777 /docker/docker-compose/prometheus_grafana/grafana
```

## 根据需要配置服务

![image-20230422210517823](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230422210517823.png)

### 目前支持

```
prometheus      指标收集
grafana         指标展示
node-exporter   linux节点信息
cadvisor  			docker性能监控
alertmanager 		告警配置
Mysqlexporter  	mysql监控
redisexporter   redis监控
elasticsearch-exporter  es监控
kafka-exporter  kafka监控
zookeeper-exporter zookeeper监控
```

### docker-compose.yml

```yml
version: '3.5'
services:
  prometheus:
    image: prom/prometheus:v2.40.1
    container_name: prometheus
    restart: always
    ports:
      - "9090:9090"
    volumes:
      - /docker/docker-compose/prometheus_grafana/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
    network_mode: "host"

  grafana:
    image: grafana/grafana:9.2.4
    container_name: grafana
    restart: always
    environment:
      TZ: Asia/Shanghai
      # 服务地址 用于指定外网ip或域名
      GF_SERVER_ROOT_URL: ""
      # admin 管理员密码
      GF_SECURITY_ADMIN_PASSWORD: admin
    ports:
      - "3000:3000"
    volumes:
      - /docker/docker-compose/prometheus_grafana/grafana/grafana.ini:/etc/grafana/grafana.ini
      - /docker/docker-compose/prometheus_grafana/grafana:/var/lib/grafana
    network_mode: "host"

  # 数据收集
  node-exporter:
    hostname: node-exporter
    container_name: node-exporter
    image: prom/node-exporter
    restart: always
    ports:
      - 9100:9100
    environment:
      - SERVER_PORT=9100
    network_mode: "host"

  # Docker容器性能监控工具google/cadvisor
  cadvisor:
    hostname: cadvisor
    container_name: cadvisor
    image: google/cadvisor
    restart: always
    privileged: true
    ports:
      - 8080:8080
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    environment:
      - SERVER_PORT=8080
    network_mode: "host"

  # 告警
  alertmanager:
    hostname: alertmanager
    container_name: alertmanager
    image: prom/alertmanager
    ports:
      - 9093:9093
    environment:
      - SERVER_PORT=9093
    volumes:
      - /docker/docker-compose/prometheus_grafana/alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml
    network_mode: "host"

  Mysqlexporter:
    hostname: Mysqlexporter
    container_name: Mysqlexporter
    image: prom/mysqld-exporter:latest
    privileged: true
    ports:
      - 9104:9104
    environment:
      - DATA_SOURCE_NAME=root:root@(101.43.76.117:3306)/
    network_mode: "host"

  redisexporter:
    hostname: redisexporter
    container_name: redisexporter
    image: oliver006/redis_exporter
    privileged: true
    ports:
      - 9121:9121
    environment:
      - REDIS_ADDR=redis://101.43.76.117:6379
      - REDIS_PASSWORD=redis
    network_mode: "host"

  kafka-exporter:
    hostname: kafka-exporter
    container_name: kafka-exporter
    image: bitnami/kafka-exporter:latest
    command:
      - '--kafka.server=127.0.0.1:9092'
    restart: always
    ports:
      - "9308:9308"
    network_mode: "host"

  elasticsearch-exporter:
    hostname: elasticsearch-exporter
    container_name: elasticsearch-exporter
    image: quay.io/prometheuscommunity/elasticsearch-exporter:latest
    command:
      - '--es.uri=http://127.0.0.1:9200'
    restart: always
    ports:
      - "9114:9114"
    #network_mode: "host"

  zookeeper-exporter:
    container_name: zookeeper-exporter
    image: carlpett/zookeeper_exporter
    restart: always
    command:
      - '-zookeeper=127.0.0.1:2181'
    ports:
      - '9141:9141'
    #network_mode: "host"
```

### prometheus.yml

```yml
# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
# - "first_rules.yml"
# - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  - job_name: 'Prometheus'
    static_configs:
      - targets: ['127.0.0.1:9090']
        labels:
          appname: 'prometheus'

  - job_name: 'Grafana'
    static_configs:
      - targets: ['127.0.0.1:3000']

  - job_name: 'Host'
    static_configs:
      - targets: [ '127.0.0.1:9100' ]  #node-exporter地址

  - job_name: 'Cadvisor'
    static_configs:
      - targets: [ '127.0.0.1:8080' ]

  - job_name: 'alertmanager'
    static_configs:
      - targets: [ '127.0.0.1:9093' ]

  - job_name: 'Mysqlexporter'
    static_configs:
      - targets: [ '127.0.0.1:9104' ]

  - job_name: 'redisexporter'
    static_configs:
      - targets: [ '127.0.0.1:9121' ]

  - job_name: 'node-exporter'
    static_configs:
      - targets: [ '127.0.0.1:9100' ]

#  - job_name: 'nginx'
#    static_configs:
#      - targets: ['127.0.0.1:9113']

  - job_name: "es"
    static_configs:
      - targets: ["127.0.0.1:9114"]

  - job_name: "kafka"
    static_configs:
      - targets: ["127.0.0.1:9308"]

  - job_name: "zookeeper"
    static_configs:
      - targets: [ "127.0.0.1:9141" ]
```

### 告警邮箱配置

```yml
global:
  resolve_timeout: 5m
  smtp_from: '2357191256@qq.com'
  smtp_smarthost: 'smtp.qq.com:465'
  smtp_auth_username: '2357191256@qq.com'
  smtp_auth_password: ''
  smtp_require_tls: false
route:
  group_by: ['alertname']
  group_wait: 60s
  group_interval: 60s
  repeat_interval: 5m
  receiver: 'email'
receivers:
  - name: 'email'
    email_configs:
      - to: '2357191256@qq.com'
        send_resolved: true
inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'dev', 'instance']
```





## 执行

```sh
# 按需执行----------
docker-compose up -d prometheus grafana node-exporter cadvisor alertmanager  Mysqlexporter redisexporter  elasticsearch-exporter kafka-exporter zookeeper-exporter
iptables -I INPUT -p tcp --dport 9090 -j ACCEPT
iptables -I INPUT -p tcp --dport 3000 -j ACCEPT
iptables -I INPUT -p tcp --dport 9100 -j ACCEPT
iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
iptables -I INPUT -p tcp --dport 9093 -j ACCEPT
iptables -I INPUT -p tcp --dport 9308 -j ACCEPT
iptables -I INPUT -p tcp --dport 9121 -j ACCEPT
iptables -I INPUT -p tcp --dport 9104 -j ACCEPT
iptables -I INPUT -p tcp --dport 9114 -j ACCEPT
iptables -I INPUT -p tcp --dport 9113 -j ACCEPT
iptables -I INPUT -p tcp --dport 5557 -j ACCEPT
iptables -I INPUT -p tcp --dport 9141 -j ACCEPT
service iptables save
```



## 访问 ip:9000

![image-20230422210639785](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230422210639785.png)

**这个可以查看收集指标的节点情况**



## 访问 ip:3000

![image-20230422210740356](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230422210740356.png)

**导入模版,地址是:**https://grafana.com/grafana/dashboards/

![image-20230422210903244](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230422210903244.png)

![image-20230422210924144](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230422210924144.png)

![image-20230422210944528](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230422210944528.png)

