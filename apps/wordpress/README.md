# Wordpress Helm template
=======================
- [Wordpress helm git repo](https://github.com/helm/charts/tree/master/stable/wordpress)

## Installation
```bash
# Add CNCF advised repo - Bitnami
helm repo add bitnami https://charts.bitnami.com/bitnami

# Confirm 
helm search repo wordpress
```

## Initialisation
```bash
helm template bitnami-wordpress-9-3-15 bitnami/wordpress \
--set fullnameOverride=wp1.local-1.vm \
--set service.type=ClusterIP \
--set ingress.enabled=true  \
--set ingress.hostname=wp1.local-1.vm \
-n wpblog --output-dir .

# Manual Activation - REMEMBER to save the root token and unseal keys!!!
kubectl -n vault exec -ti vault-0 -- vault operator init
```