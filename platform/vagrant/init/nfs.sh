#!/bin/bash
apt-get update
apt-get install -y nfs-kernel-server
# mkdir -p /mnt/sharedfolder
# chown nobody:nogroup /mnt/sharedfolder
chmod 777 /mnt/sharedfolder
ls -l /mnt/
echo '/mnt/sharedfolder *(rw,fsid=1,sync,no_subtree_check,no_root_squash,insecure)' > /etc/exports
exportfs -vfa
systemctl restart nfs-server
systemctl status nfs-server

# Monitor nfs through prometheus
apt-get update
apt-get install -y libwww-perl
GET https://s3-eu-west-1.amazonaws.com/deb.robustperception.io/41EFC99D.gpg | apt-key add -
apt-get update
apt-get install -y prometheus prometheus-node-exporter prometheus-pushgateway prometheus-alertmanager
