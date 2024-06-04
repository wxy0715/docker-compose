#!/bin/bash

if [[ "$(whoami)" != "root" ]]; then
	echo "please run this script as root ." >&2
	exit 1
fi

# 完成
yum_config(){
  yum -y install wget epel-release && yum clean all && yum makecache
  # 安装自动补全
  yum install -y bash-completion bash-completion-extras tree screen nmap nc dos2unix tcpdump lsof bridge-uti
  yum -y install iotop iftop net-tools httpd-tools kernel-devel lrzsz gcc gcc-c++ make cmake libxml2-devel openssl-devel curl curl-devel unzip sudo ntp libaio-devel vim ncurses-devel autoconf automake zlib-devel python-devel bash-completion python-pip git-core telnet
  yum -y install  bzip2-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
  echo -e "\033[31mconfigure yum source successful...\033[0m"
}

# 完成
install_ftp(){
   yum -y install vsftpd
   service vsftpd start
   systemctl enable vsftpd
   systemctl restart vsftpd
   # ftp
   iptables -I INPUT -p tcp --dport 21 -j ACCEPT
   iptables -I INPUT -p tcp --dport 20 -j ACCEPT
   iptables -I INPUT -p tcp --dport 23 -j ACCEPT
   echo -e "\033[31mftp successful...\033[0m"
}

# 完成
iptables_install(){
  systemctl stop firewalld.service
  systemctl mask firewalld.service
  systemctl disable firewalld.service
  yum -y install iptables-services 
  systemctl enable iptables
  systemctl start iptables
  iptables -F
  service iptables save
  echo -e "\033[31miptables successful...\033[0m"
}

# 完成
install_jdk() {
  yum -y install java-1.8.0-openjdk*
  echo -e "\033[31m java8 successful...\033[0m"
}

# 完成
install_docker() {
 yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
	yum -y install yum-utils device-mapper-persistent-data lvm2
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
	yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
	yum-config-manager --enable docker-ce-edge
	yum-config-manager --enable docker-ce-test
	yum-config-manager --disable docker-ce-edge
	yum -y install docker-ce
	yes | cp -rf /root/init_script/daemon.json /etc/docker
	systemctl start docker
	systemctl enable docker
  echo -e "\033[31mdocker successful...\033[0m"
  # 允许转发
  echo "net.ipv4.ip_forward=1" >>/usr/lib/sysctl.d/00-system.conf
  systemctl restart network && systemctl restart docker
  chkconfig docker on
  #echo "registry-mirrors": ["http://hub-mirror.c.163.com"] >> /etc/docker/daemon.json
  #echo "data-root": "/home/docker" >> /etc/docker/daemon.json
}

# 完成
install_docker_compose() {
	curl -L "https://wxy-oss.oss-cn-beijing.aliyuncs.com/software/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
	# 创建软链
	sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
	docker-compose --version
	echo -e "\033[31m install_docker_compace successful...\033[0m"
}

# 完成
install_docker_portainer() {
  sudo docker pull portainer/portainer-ce:2.19.5
  docker run -d -p 9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v    /mnt/docker/portainer:/data portainer/portainer-ce:2.19.5
  # docker restart portainer
  iptables -I INPUT -p tcp --dport 9000 -j ACCEPT
  service iptables save
}

# 完成
install_mysql8() {
  mkdir -p /docker/docker-compose && cd /docker/docker-compose
  wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/mysql.zip && unzip mysql.zip && rm -f mysql.zip
  cd /docker/docker-compose/mysql
  docker-compose -f docker-compose-mysql8.0.yml -p mysql8 up -d
  iptables -I INPUT -p tcp --dport 3306 -j ACCEPT
  service iptables save
  # 进入mysql mysql -S /docker/mysql8.0/data/mysqld.sock  -u root -p
}

# 完成
install_redis() {
  mkdir -p /docker/docker-compose && cd /docker/docker-compose
  wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/redis.zip && unzip redis.zip && rm -f redis.zip
  chmod 777 /docker/docker-compose/redis/data
  cd /docker/docker-compose/redis
  docker-compose up -d redis
  iptables -I INPUT -p tcp --dport 6379 -j ACCEPT
  service iptables save
}

# 完成
install_zookeeper(){
  mkdir -p /docker/docker-compose && cd /docker/docker-compose
  wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/zookeeper.zip && unzip zookeeper.zip && rm -f zookeeper.zip
  cd /docker/docker-compose/zookeeper
  chmod -R 777 /docker/docker-compose/zookeeper
  docker-compose up -d zookeeper zookeeper-webui
  iptables -I INPUT -p tcp --dport 2181 -j ACCEPT
  iptables -I INPUT -p tcp --dport 9090 -j ACCEPT
  service iptables save
}

# 完成 mongodb://admin:wxy0715..@ip:27017
install_mongodb(){
  mkdir -p /docker/docker-compose && cd /docker/docker-compose
  wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/mongo.zip && unzip mongo.zip && rm -f mongo.zip
  cd /docker/docker-compose/mongo
  chmod -R 777 /docker/docker-compose/mongo
  docker-compose up -d
  iptables -I INPUT -p tcp --dport 27017 -j ACCEPT
  iptables -I INPUT -p tcp --dport 1234 -j ACCEPT
  service iptables save
}

# 完成
install_postgresql(){
  mkdir -p /docker/docker-compose && cd /docker/docker-compose
  wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/postgresql.zip && unzip postgresql.zip && rm -f postgresql.zip
  cd /docker/docker-compose/postgresql
  chmod -R 777 /docker/docker-compose/postgresql
  docker-compose up -d
  iptables -I INPUT -p tcp --dport 5432 -j ACCEPT
  service iptables save
}

# 完成 需要配置数据库
install_nacos(){
  mkdir -p /docker/docker-compose && cd /docker/docker-compose
  wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/nacos.zip && unzip nacos.zip && rm -f nacos.zip
  cd /docker/docker-compose/nacos
  docker-compose up -d
  # 开端口
  iptables -I INPUT -p tcp --dport 8848 -j ACCEPT
  iptables -I INPUT -p tcp --dport 9848 -j ACCEPT
  iptables -I INPUT -p tcp --dport 9849 -j ACCEPT
  service iptables save
}

# 完成
install_elk(){
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
}

# 完成
install_skywalking(){
    mkdir -p /docker/docker-compose && cd /docker/docker-compose
    wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/skywalking.zip && unzip skywalking.zip && rm -f skywalking.zip
    cd /docker/docker-compose/skywalking
    docker-compose up -d sky-oap sky-ui
    iptables -I INPUT -p tcp --dport 11800 -j ACCEPT
    iptables -I INPUT -p tcp --dport 12800 -j ACCEPT
    iptables -I INPUT -p tcp --dport 18080 -j ACCEPT
    service iptables save
}

# 完成 端口15672
install_rabbitmq(){
  mkdir -p /docker/docker-compose && cd /docker/docker-compose
  wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/rabbitmq.zip && unzip rabbitmq.zip && rm -f rabbitmq.zip
  cd /docker/docker-compose/rabbitmq
  chmod -R 777 /docker/docker-compose/rabbitmq
  docker-compose up -d --build
  iptables -I INPUT -p tcp --dport 5672 -j ACCEPT
  iptables -I INPUT -p tcp --dport 15672 -j ACCEPT
  service iptables save
}

# 完成  页面:ip:19876
install_rocketmq(){
  mkdir -p /docker/docker-compose && cd /docker/docker-compose
  wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/rocketmq.zip && unzip rocketmq.zip && rm -f rocketmq.zip
  cd /docker/docker-compose/rocketmq
  chmod -R 777 /docker/docker-compose/rocketmq
  docker-compose up -d mqnamesrv mqbroker1 mqconsole
  iptables -I INPUT -p tcp --dport 9876 -j ACCEPT
  iptables -I INPUT -p tcp --dport 19876 -j ACCEPT
  iptables -I INPUT -p tcp --dport 17890 -j ACCEPT
  iptables -I INPUT -p tcp --dport 10911 -j ACCEPT
  iptables -I INPUT -p tcp --dport 10909 -j ACCEPT
  iptables -I INPUT -p tcp --dport 10912 -j ACCEPT
  service iptables save
}

# 完成 端口19092
install_kafka(){
  mkdir -p /docker/docker-compose && cd /docker/docker-compose
  wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/kafka.zip && unzip kafka.zip && rm -f kafka.zip
  cd /docker/docker-compose/kafka
  chmod -R 777 /docker/docker-compose/kafka
  docker-compose up -d kafka kafka-manager
  iptables -I INPUT -p tcp --dport 9092 -j ACCEPT
  iptables -I INPUT -p tcp --dport 19092 -j ACCEPT
  service iptables save
}

# 完成
install_prometheus_grafana(){
    mkdir -p /docker/docker-compose && cd /docker/docker-compose
    wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/prometheus_grafana.zip && unzip prometheus_grafana.zip && rm -f prometheus_grafana.zip
    cd /docker/docker-compose/prometheus_grafana
    chmod -R 777 /docker/docker-compose/prometheus_grafana/grafana
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
}

# 完成
install_minio(){
  mkdir -p /docker/docker-compose && cd /docker/docker-compose
  wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/minio.zip && unzip minio.zip && rm -f minio.zip
  cd /docker/docker-compose/minio
  docker-compose up minio -d
  iptables -I INPUT -p tcp --dport 9003 -j ACCEPT
  iptables -I INPUT -p tcp --dport 9001 -j ACCEPT
  service iptables save
}

# 完成
install_tomcat() {
  mkdir -p /docker/docker-compose && cd /docker/docker-compose
  wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/tomcat.zip && unzip tomcat.zip && rm -f tomcat.zip
  cd /docker/docker-compose/tomcat
  docker-compose up -d
  iptables -I INPUT -p tcp --dport 8081 -j ACCEPT
  service iptables save
}

# 完成
install_nginx() {
  mkdir -p /docker/docker-compose && cd /docker/docker-compose
  wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/nginx.zip && unzip nginx.zip && rm -f nginx.zip
  cd /docker/docker-compose/nginx
  docker-compose up -d
  iptables -I INPUT -p tcp --dport 80 -j ACCEPT
  service iptables save
}

# 推荐根据文档按需安装
main(){
  # yum_config  # 只需执行一次
  # iptables_install # 只需执行一次
  ################################## 以下是服务,可以自行选择下载
  #install_ftp
  #install_jdk
  #install_docker
  #install_docker_compose
  #install_docker_portainer
  #install_mysql8
  #install_nacos
  #install_skywalking # 需要改compose的ip
  #install_postgresql
  #install_redis
  #install_zookeeper
  #install_minio
  #install_elk
  #install_rabbitmq
  #install_rocketmq # 需要改配置文件ip
  #install_kafka # 需要改compose的ip & 一定先安装zookeeper
  #install_nginx
  #install_mongodb
  #install_tomcat
  #install_sentinel
  install_prometheus_grafana # 需要改compose的ip
  ##################################
}
main
