# [GRAFANA](https://grafana.com/)
=================================
- [Grafana Helm](https://github.com/helm/charts/tree/master/stable/grafana)

## Installation
```bash
# Add CNCF Repo
helm repo add stable https://kubernetes-charts.storage.googleapis.com/ 

# Confirm 
helm search repo grafana
```

## Initialisation - Elastic
```bash
# Grafana
helm template grafana-5-3-0 stable/grafana \
-n grafana \
--set replicas=1 \
--set service.type=ClusterIP \
--set ingress.enabled=true \
--set ingress.hosts[0]=mon.local-1.vm \
--set persistence.enabled=true \
--set persistence.type=statefulset \
--output-dir .
```

# DASHBOARD TEMPLATES
9797 Kube Cluster
1860 Kube Node Exporter
22 Single Node Exporter

