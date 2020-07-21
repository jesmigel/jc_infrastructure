helm  template stable-nfs-client-provisioner-1-2-8 stable/nfs-client-provisioner \
--set storageClass.defaultClass=true \
--set persistence.enabled=true \
--set persistence.storageClass="standard" \
--set nodeSelector="kubernetes.io/hostname: node3" \
--set persistence.size=20Gi \
--set nfs.server=10.8.41.11 \
--set nfs.path=/mnt/sharedfolder/nfs \
-n nfs --output-dir .