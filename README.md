## 一键装机
编写目地是在一台centos服务器上通过一行命令完成各种服务的安装过程
system_upgrade.sh 该脚本主要基于压缩包安装各种服务
system_upgrade_docker.sh 该脚本基于docker安装各种服务

![image-20240415154844719](https://wxy-md.oss-cn-shanghai.aliyuncs.com/image-20240415154844719.png)

手动去除# -> 执行命令: sh system_upgrade.sh / sh system_upgrade_docker.sh

## 主要事项
文档示例里面我把文件夹压缩上传至我的阿里云了,大家只需要修改docker-compose.yml里面的配置即可
