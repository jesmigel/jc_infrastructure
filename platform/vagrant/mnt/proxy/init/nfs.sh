#!/bin/bash
apt-get install -y nfs-kernel-server
# mkdir -p /mnt/sharedfolder
# chown nobody:nogroup /mnt/sharedfolder
chmod 777 /mnt/sharedfolder
ls -l /mnt/
echo '/mnt/sharedfolder *(rw,fsid=1,sync,no_subtree_check,no_root_squash,insecure)' > /etc/exports
exportfs -vfa
systemctl restart nfs-server
systemctl status nfs-server