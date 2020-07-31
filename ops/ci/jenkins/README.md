# Jenkins Helm template
=======================
- [Jenkins helm git repo](https://github.com/helm/charts/tree/master/stable/jenkins)
- [CNCF stable chart repo](https://kubernetes-charts.storage.googleapis.com/)
- [CNCF helm git repo](https://github.com/helm/charts)

```bash
# Add CNCF Repo
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

# Confirm 
helm search repo jenkins

helm template stable-jenkins-1-27-0 stable/jenkins \
--set master.ingress.enabled=true \
--set master.ingress.hostName=ci.local-1.vm \
--set master.JCasC.enabled=true \
--set master.JCasC.defaultConfig=true \
--set master.sidecars.configAutoReload.enabled=true \
--set agent.privileged=true \
-n jenkins --output-dir .
```