# Vault Helm template
=======================
- [Vault helm git repo](https://github.com/hashicorp/vault-helm)
- [Vault stable chart repo](https://helm.releases.hashicorp.com)

```bash
# Add CNCF Repo
helm repo add hashicorp https://helm.releases.hashicorp.com

# Confirm 
helm search repo vault

helm template hashicorp/vault \
--set server.dataStorage.accessMode=ReadWriteMany \
--set server.ingress.enabled=true \
--set server.ingress.hosts[0].host=test.com \
-n vault --output-dir .

# Manual Activation
kubectl exec -ti vault-0 -- vault operator init
```