# ROOK
# ====
- [ROOK - CEPH](https://rook.io/docs/rook/v1.3/ceph-quickstart.html)
- [ROOK Helm Repository](https://github.com/rook/rook/blob/master/Documentation/helm-operator.md)

# Installation
```bash
# Add ROOK stable releases Repo
helm repo add rook-release https://charts.rook.io/release

# Confirm 
helm search repo rook-ceph
```

## Initialisation
```bash
# ROOK-CEPH CRD (Custom Resource Definitions)
helm template stable-rook-1-3-7 rook-release/rook-ceph \
--set csi.enableRbdDriver=true \
--set csi.enableCephfsDriver=true \
--set csi.logLevel=true \
-n rook-ceph --output-dir .

# CEPH Manifests
curl -O https://raw.githubusercontent.com/rook/rook/master/cluster/examples/kubernetes/ceph/common.yaml
curl -O https://raw.githubusercontent.com/rook/rook/master/cluster/examples/kubernetes/ceph/operator.yaml
curl -O https://raw.githubusercontent.com/rook/rook/master/cluster/examples/kubernetes/ceph/cluster.yaml

# ceph config-key set mgr/dashboard/server_addr '10.8.41.201'
# ceph config-key set mgr/dashboard/server_port '80'
# ceph mgr module enable dashboard
# ceph config-key set mgr mgr/dashboard/ssl_server_port $PORT
# ceph --cluster ceph daemon mon.ceph-server-1 mon_status 
```