# Vault Helm template
=======================
- [Vault helm git repo](https://github.com/hashicorp/vault-helm)
- [Vault stable chart repo](https://helm.releases.hashicorp.com)

## Installation
```bash
# Add CNCF Repo
helm repo add hashicorp https://helm.releases.hashicorp.com

# Confirm 
helm search repo vault
```

## Initialisation
```bash
helm template stable-vault-0-6-0 hashicorp/vault \
--set server.dataStorage.accessMode=ReadWriteMany \
--set server.ingress.enabled=true \
--set server.ingress.hosts[0].host="vault.local-1.vm"  \
-n vault --output-dir .

# Manual Activation - REMEMBER to save the root token and unseal keys!!!
kubectl -n vault exec -ti stable-vault-0-6-0-0 -- vault operator init

# Kubernetes integration
kubectl -n vault exec -it stable-vault-0-6-0-0 -- /bin/sh
vault login
vault auth enable kubernetes
vault write auth/kubernetes/config \
    token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
    kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```