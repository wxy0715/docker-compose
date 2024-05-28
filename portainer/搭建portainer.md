## 安装

```sh
sudo docker pull portainer/portainer-ce:2.19.5
docker run -d -p 9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v    /mnt/docker/portainer:/data portainer/portainer-ce:2.19.5
# docker restart portainer
iptables -I INPUT -p tcp --dport 9000 -j ACCEPT
service iptables save
```

