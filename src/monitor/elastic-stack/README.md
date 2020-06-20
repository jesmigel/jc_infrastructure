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
--set esJavaOpts="-Xmx128m -Xms128m" \
--set resources.requests.cpu="100m" \
--set resources.requests.memory="512M" \
--set resources.limits.cpu="1000m" \
--set resources.limits.memory="512M" \
--output-dir .
# Kibana
helm template kibana-7-8-0 elastic/kibana \
--set namespace=elk \
--set ingress.enabled=true \
--set ingress.hosts={elk.local-1.vm} \
--set elasticsearchHosts=http://elasticsearch-master-headless.elk.svc.cluster.local:9200 \
--output-dir .
# Metricbeat
helm template metricbeat-7-8-0 elastic/metricbeat \
--set namespace=elk \
--output-dir .
```

## Custom configmap considerations
```bash

```

## ToDO
- Determine how to declare VolumeClaimTemplates[].spec.accessModes