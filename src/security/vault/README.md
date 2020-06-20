# Vault Helm template
=======================
- [Vault helm git repo](https://github.com/hashicorp/vault-helm)
- [Vault stable chart repo](https://helm.releases.hashicorp.com)

```bash
# Add CNCF Repo
helm repo add hashicorp https://helm.releases.hashicorp.com

# Confirm 
helm search repo vault

helm template stable-vault-0-6-0 hashicorp/vault \
--set server.dataStorage.accessMode=ReadWriteMany \
--set server.ingress.enabled=true \
--set server.route.host=vault.local-1.vm \
-n vault --output-dir .
```