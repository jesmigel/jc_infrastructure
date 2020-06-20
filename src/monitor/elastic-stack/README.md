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
# Elastic Search
helm template elasticsearch-7-8-0 elastic/elasticsearch \
--set namespace=elk \
--output-dir .
# Kibana
helm template kibana-7-8-0 elastic/kibana \
--set namespace=elk \
--set ingress.enabled=true \
--set ingress.hosts={elk.local-1.vm} \
--set elasticsearchHosts=http://elasticsearch-master-headless.elk.svc.cluster.local:9200 \
--output-dir .
```

## Custom configmap considerations
```bash

```

## ToDO
- Determine how to declare VolumeClaimTemplates[].spec.accessModes