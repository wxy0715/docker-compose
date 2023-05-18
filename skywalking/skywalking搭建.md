## 服务端搭建

依赖于Elasticsearch:https://gitee.com/wxy0715/docker-compose/blob/main/elk/elk%E6%90%AD%E5%BB%BA.md



下载文件:

```sh
mkdir -p /docker/docker-compose && cd /docker/docker-compose
wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/skywalking.zip && unzip skywalking.zip && rm -f skywalking.zip
cd /docker/docker-compose/skywalking
```

修改ip:

![image-20230424124311141](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230424124311141.png)

启动:

```sh
docker-compose up -d sky-oap sky-ui
iptables -I INPUT -p tcp --dport 11800 -j ACCEPT
iptables -I INPUT -p tcp --dport 12800 -j ACCEPT
iptables -I INPUT -p tcp --dport 18080 -j ACCEPT
service iptables save
```

![image-20230420224642111](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230420224642111.png)



## 客户端连接

#### 服务探针

```
skywalking-agent.jar文件可以通过
wget https://wxy-oss.oss-cn-beijing.aliyuncs.com/skywalking.zip && unzip skywalking.zip && rm -f skywalking.zip
获取
```

```
-javaagent:D:\\skywalking-agent.jar
-Dskywalking.agent.service_name=test
-Dskywalking.collector.backend_service=ip:11800

javaagent 探针对应的盘符位置
service_name 服务名
backend_service skywalking的地址
```

![image-20230422211238005](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230422211238005.png)

![image-20230422212242466](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230422212242466.png)

### 日志集成

#### pom.xml

```xml
            <!-- skywalking 整合 logback -->
            <dependency>
                <groupId>org.apache.skywalking</groupId>
                <artifactId>apm-toolkit-logback-1.x</artifactId>
                <version>8.14.0</version>
            </dependency>
            <dependency>
                <groupId>org.apache.skywalking</groupId>
                <artifactId>apm-toolkit-trace</artifactId>
                <version>8.14.0</version>
            </dependency>
```



![image-20230424162615415](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230424162615415.png)

#### logback.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration scan="true" scanPeriod="60 seconds" debug="false">
    <!-- 日志存放路径 -->
    <property name="log.path" value="logs/${project.artifactId}"/>
    <!-- 日志输出格式 -->
    <property name="console.log.pattern"
              value="%red(%d{yyyy-MM-dd HH:mm:ss}) %green([%thread]) %highlight(%-5level) %boldMagenta(%logger{36}%n) - %msg%n"/>
    <property name="log.pattern" value="%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n"/>

    <!-- 控制台输出 -->
    <appender name="console" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>${console.log.pattern}</pattern>
            <charset>utf-8</charset>
        </encoder>
    </appender>

    <!-- 控制台输出 -->
    <appender name="file_console" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${log.path}/console.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- 日志文件名格式 -->
            <fileNamePattern>${log.path}/console.%d{yyyy-MM-dd}.log</fileNamePattern>
            <!-- 日志最大 1天 -->
            <maxHistory>1</maxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>${log.pattern}</pattern>
            <charset>utf-8</charset>
        </encoder>
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <!-- 过滤的级别 -->
            <level>INFO</level>
        </filter>
    </appender>

    <!-- 系统日志输出 -->
    <appender name="file_info" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${log.path}/info.log</file>
        <!-- 循环政策：基于时间创建日志文件 -->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- 日志文件名格式 -->
            <fileNamePattern>${log.path}/info.%d{yyyy-MM-dd}.log</fileNamePattern>
            <!-- 日志最大的历史 60天 -->
            <maxHistory>60</maxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>${log.pattern}</pattern>
        </encoder>
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <!-- 过滤的级别 -->
            <level>INFO</level>
            <!-- 匹配时的操作：接收（记录） -->
            <onMatch>ACCEPT</onMatch>
            <!-- 不匹配时的操作：拒绝（不记录） -->
            <onMismatch>DENY</onMismatch>
        </filter>
    </appender>

    <appender name="file_error" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${log.path}/error.log</file>
        <!-- 循环政策：基于时间创建日志文件 -->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- 日志文件名格式 -->
            <fileNamePattern>${log.path}/error.%d{yyyy-MM-dd}.log</fileNamePattern>
            <!-- 日志最大的历史 60天 -->
            <maxHistory>60</maxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>${log.pattern}</pattern>
        </encoder>
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <!-- 过滤的级别 -->
            <level>ERROR</level>
            <!-- 匹配时的操作：接收（记录） -->
            <onMatch>ACCEPT</onMatch>
            <!-- 不匹配时的操作：拒绝（不记录） -->
            <onMismatch>DENY</onMismatch>
        </filter>
    </appender>

    <!-- info异步输出 -->
    <appender name="async_info" class="ch.qos.logback.classic.AsyncAppender">
        <!-- 不丢失日志.默认的,如果队列的80%已满,则会丢弃TRACT、DEBUG、INFO级别的日志 -->
        <discardingThreshold>0</discardingThreshold>
        <!-- 更改默认的队列的深度,该值会影响性能.默认值为256 -->
        <queueSize>512</queueSize>
        <!-- 添加附加的appender,最多只能添加一个 -->
        <appender-ref ref="file_info"/>
    </appender>

    <!-- error异步输出 -->
    <appender name="async_error" class="ch.qos.logback.classic.AsyncAppender">
        <!-- 不丢失日志.默认的,如果队列的80%已满,则会丢弃TRACT、DEBUG、INFO级别的日志 -->
        <discardingThreshold>0</discardingThreshold>
        <!-- 更改默认的队列的深度,该值会影响性能.默认值为256 -->
        <queueSize>512</queueSize>
        <!-- 添加附加的appender,最多只能添加一个 -->
        <appender-ref ref="file_error"/>
    </appender>

    <include resource="logback-logstash.xml" />

    <!-- 开启 skywalking 日志收集 -->
    <include resource="logback-skylog.xml" />

    <!--系统操作日志-->
    <root level="info">
        <appender-ref ref="console"/>
        <appender-ref ref="async_info"/>
        <appender-ref ref="async_error"/>
        <appender-ref ref="file_console"/>
    </root>
</configuration>
```

#### logback-skylog.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>

<included>

    <!-- 控制台输出 tid -->
    <appender name="console" class="ch.qos.logback.core.ConsoleAppender">
        <encoder class="ch.qos.logback.core.encoder.LayoutWrappingEncoder">
            <layout class="org.apache.skywalking.apm.toolkit.log.logback.v1.x.TraceIdPatternLogbackLayout">
                <pattern>[%tid] ${console.log.pattern}</pattern>
            </layout>
            <charset>utf-8</charset>
        </encoder>
    </appender>

    <!-- skywalking 采集日志 -->
    <appender name="sky_log" class="org.apache.skywalking.apm.toolkit.log.logback.v1.x.log.GRPCLogClientAppender">
        <encoder class="ch.qos.logback.core.encoder.LayoutWrappingEncoder">
            <layout class="org.apache.skywalking.apm.toolkit.log.logback.v1.x.TraceIdPatternLogbackLayout">
                <pattern>[%tid] ${console.log.pattern}</pattern>
            </layout>
            <charset>utf-8</charset>
        </encoder>
    </appender>

    <root level="info">
        <appender-ref ref="console"/>
        <appender-ref ref="sky_log"/>
    </root>
</included>
```



### 查看

![image-20230424162746260](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230424162746260.png)

![image-20230424162752301](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20230424162752301.png)
