# [ELASTIC STACK](https://www.elastic.co/)

## Installation
```bash
# Add CNCF Repo
helm repo add stable https://kubernetes-charts.storage.googleapis.com/ 

# Confirm 
helm search repo elastic-stack
```

## Initialisation
```bash
helm template kibana-7-8-0 elastic/kibana \
--set namespace=elk \
--set ingress.enabled=true \
--set ingress.hosts={elk.local-1.vm} \
--output-dir .
```

## Custom configmap considerations
```bash

```

## ToDO
- Determine how to declare VolumeClaimTemplates[].spec.accessModes