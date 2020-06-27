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
# Get Sources - Update as needed
curl -L https://raw.githubusercontent.com/helm/charts/master/stable/elasticsearch/values.yaml > values/elasticsearch.yaml
curl -L https://raw.githubusercontent.com/helm/charts/master/stable/logstash/values.yaml > values/logstash.yaml

# Elastic search
helm template elasticstack-0-11-1 stable/elasticsearch \
--set namespace=elk \
-f values/elasticsearch.yaml \
--output-dir .

# Logstash
helm template logstash-2-4-0 stable/logstash \
--set namespace=elk \
-f values/logstash.yaml \
--output-dir .
```


## Custom configmap considerations
```bash

```

## ToDO
- Determine how to declare VolumeClaimTemplates[].spec.accessModes