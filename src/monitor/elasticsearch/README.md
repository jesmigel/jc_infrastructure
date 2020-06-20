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
helm template stable-elk-2-0-1 stable/elastic-stack \
--set kibana.ingress.enabled=true \
--set kibana.ingress.hosts={elk.local-1.vm}  \
--set logstash.env[2].value=stable-elk-2-0-1.elk.svc.cluster.local \
-n elk --output-dir .
```

## Custom configmap considerations
```bash

```

## ToDO
- Determine how to declare VolumeClaimTemplates[].spec.accessModes