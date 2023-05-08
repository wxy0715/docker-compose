## 安装

```sh
sudo docker pull portainer/portainer
docker run -d -p 9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v    /mnt/docker/portainer:/data portainer/portainer
# docker restart portainer
iptables -I INPUT -p tcp --dport 9000 -j ACCEPT
service iptables save
```

