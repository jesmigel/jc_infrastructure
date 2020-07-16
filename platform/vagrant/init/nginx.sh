#!/bin/bash
apt-get -y install nginx
# openssl genrsa 2048 > server.key
# openssl req -new -key server.key -subj "/C=AU/ST=Home/L=Laptop/O=Personal/OU=Local Machine/CN=local-1.vm" > server.csr
# openssl x509 -days 3650 -req -signkey server.key < server.csr > server.crt
# mv server.* /etc/letsencrypt/live/
echo 'Starting NGINX'
systemctl start nginx
systemctl status nginx