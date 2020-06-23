# [ELASTIC STACK](https://www.elastic.co/)

## Installation
```bash
# Add CNCF Repo
helm repo add stable https://kubernetes-charts.storage.googleapis.com/ 

# Confirm 
helm search repo elastic
```

## Initialisation - Elastic
```bash
# Elastic Search
helm template elasticsearch-7-8-0 elastic/elasticsearch \
--set namespace=elk \
--set esJavaOpts="-Xmx128m -Xms128m" \
--set resources.requests.cpu="500m" \
--set resources.requests.memory="512M" \
--set resources.limits.cpu="1000m" \
--set resources.limits.memory="512M" \
--set rbac=true \
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
--set daemonset.extraEnvs[0].name=ELASTICSEARCH_HOSTS \
--set daemonset.extraEnvs[0].value=elasticsearch-master-headless.elk.svc.cluster.local \
--set deployment.extraEnvs[0].name=ELASTICSEARCH_HOSTS \
--set deployment.extraEnvs[0].value=elasticsearch-master-headless.elk.svc.cluster.local \
--output-dir .
# Logstash
helm template logstash-7-8-0 elastic/logstash \
--set rbac.create=true \
--set service.type=ClusterIP \
--set namespace=elk \
--output-dir .
```

## Initialisation - CNCF
```bash
# Elastic stack
helm template elasticstack-0-11-1 stable/elastic-stack \
--set namespace=elk \
--set elasticsearch.client.resources.requests.cpu="0.5" \
--set elasticsearch.client.resources.requests.memory="512M" \
--set elasticsearch.client.resources.limits.cpu="1" \
--set elasticsearch.client.resources.limits.memory="512M" \
--set elasticsearch.client.resources.requests.cpu="0.5" \
--set elasticsearch.master.resources.requests.memory="512M" \
--set elasticsearch.master.resources.limits.cpu="1" \
--set elasticsearch.master.resources.limits.memory="512M" \
--set elasticsearch.master.resources.requests.cpu="0.5" \
--set elasticsearch.data.resources.requests.memory="512M" \
--set elasticsearch.data.resources.limits.cpu="1" \
--set elasticsearch.data.resources.limits.memory="512M" \
--set kibana.ingress.enabled="true" \
--set kibana.ingress.hosts={"elk.local-1.vm"} \
--output-dir .

```


## Custom configmap considerations
```bash

```

## ToDO
- Determine how to declare VolumeClaimTemplates[].spec.accessModes