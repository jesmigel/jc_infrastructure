# Consul Helm template
=======================
- [Consul Helm Installation Guide](https://www.consul.io/docs/k8s/installation/overview)
- [Consul helm git repo](https://github.com/hashicorp/consul-helm)
- [Consul stable chart repo](https://helm.releases.hashicorp.com)

## Installation
```bash
# Add CNCF Repo
helm repo add hashicorp https://helm.releases.hashicorp.com

# Confirm 
helm search repo consul
```

## Initialisation
```bash
helm template stable-consul-0-21-0 hashicorp/consul \
--set ingressGateways.enabled=true \
-n consul --output-dir .
```

# Modifications
- 