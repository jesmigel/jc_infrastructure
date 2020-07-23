# [LOKI](https://grafana.com/oss/loki/)
=================================
- [Loki Helm](https://github.com/grafana/loki/tree/master/production/helm)

## Installation
```bash
# Add LOKI Repo
helm repo add loki https://grafana.github.io/loki/charts

# Confirm 
helm search repo loki
```

## Initialisation - Elastic
```bash
# Grafana
helm template loki-stack-0-38-2 loki/loki-stack \
-n loki-stack \
--output-dir .
```