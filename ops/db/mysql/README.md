# MYSQL Helm Template
- [MYSQL helm git repo](https://github.com/helm/charts/tree/master/stable/mysql)
- [CNCF stable chart repo](https://kubernetes-charts.storage.googleapis.com/)
- [CNCF helm git repo](https://github.com/helm/charts)

```bash
# Add CNCF Repo
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

# Confirm 
helm search repo mysql

# Generate Template
helm template stable-mysql-1-6-4 stable/mysql \
--set imageTag=8.0 \
-n db --output-dir .
```