# MYSQL Helm Template
- [MYSQL helm git repo](https://github.com/helm/charts/tree/master/stable/mysql)
- [CNCF stable chart repo](https://kubernetes-charts.storage.googleapis.com/)
- [CNCF helm git repo](https://github.com/helm/charts)

# Mysql Primary DB
```bash
# Add CNCF Repo
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

# Confirm 
helm search repo mysql

# Generate Template
helm template stable-mysql-1-6-4 stable/mysql \
--set imageTag=8.0.21 \
-n db --output-dir .
```

# Mysql Dumps
```bash
# Add CNCF Repo
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

# Confirm 
helm search repo mysqldump

# Generate Template
helm template stable-mysqldump-2-6-0 stable/mysqldump \
--set image.repository=mysql \
--set image.tag=8.0.21 \
--set mysql.host='stable-mysql-1-6-4.db.svc.cluster.local'
-n db --output-dir .
```