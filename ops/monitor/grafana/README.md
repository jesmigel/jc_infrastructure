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

## Initialisation - Grafana
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
12019 Loki Dynamic Container Logs

# Guthub OAuth
Can be statically placed in the [configmap](grafana/templates/configmap.yaml)

Can also be enabled as env vars
GF_AUTH_GITHUB_ENABLED = true
GF_AUTH_GITHUB_ALLOW_SIGNUP = true
GF_AUTH_GITHUB_CLIENT_ID = YOUR_GITHUB_APP_CLIENT_ID
GF_AUTH_GITHUB_CLIENT_SECRET = YOUR_GITHUB_APP_CLIENT_SECRET
GF_AUTH_GITHUB_AUTH_URL = https://github.com/login/oauth/authorize
GF_AUTH_GITHUB_TOKEN_URL = https://github.com/login/oauth/access_token
GF_AUTH_GITHUB_API_URL = https://api.github.com/user

References:
[Configmap](https://grafana.com/docs/grafana/latest/auth/github/#enable-github-in-grafana)
[Env Vars](https://grafana.com/docs/grafana/latest/administration/configuration/#configure-with-environment-variables)

# Sample DNS datasource entries
prometheus-11-6-0-server.prometheus.svc.cluster.local
loki.loki-stack.svc.cluster.local