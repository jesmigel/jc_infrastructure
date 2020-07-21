helm  template stable-nfs-client-provisioner-1-2-8 stable/nfs-client-provisioner \
--set nfs.server=10.8.41.11 \
--set nfs.path=/mnt/sharedfolder/nfs \
--output-dir .

helm template stable-rook-1-3-7 rook-release/rook-ceph \
--set csi.enableRbdDriver=true \
--set csi.enableCephfsDriver=true \
--set csi.logLevel=true \
-n rook-ceph --output-dir .