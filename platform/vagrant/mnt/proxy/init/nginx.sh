#!/bin/bash
apt-get -y install nginx

CERTS=/etc/letsencrypt/live
KEY=$CERTS/server.key
CRT=$CERTS/server.crt
if [ -f "$CRT" ]; then
    echo "Certificates initialised."
    ls -l $CERTS
else 
    echo "$FILE does not exist."
    openssl genrsa 2048 > server.key
    openssl req -new -key server.key -subj "/C=AU/ST=Home/L=Laptop/O=Personal/OU=Local Machine/CN=local-1.vm" > server.csr
    openssl x509 -days 3650 -req -signkey server.key < server.csr > server.crt
    mv server.* $CERTS/
fi

echo 'Starting NGINX'
systemctl restart nginx