# https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/
curl -L -O https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/master/deployments/common/ns-and-sa.yaml
curl -L -O https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/master/deployments/common/default-server-secret.yaml
curl -L -O https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/master/deployments/common/vs-definition.yaml
curl -L -O https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/master/deployments/common/vsr-definition.yaml
curl -L -O https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/master/deployments/common/ts-definition.yaml
curl -L -O https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/master/deployments/rbac/rbac.yaml
curl -L -O https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/master/deployments/deployment/nginx-ingress.yaml
curl -L -O https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/master/deployments/daemon-set/nginx-ingress.yaml

# ConfigMap should be downloaded only to act as a template
curl -L https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/master/deployments/common/nginx-config.yaml -o template.configmap.yaml

# Annotations are used to Populate configmap data
- https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/
- https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/

*** NOTE: ***
Theres a weird bug where in the configmap documentation `proxy-body-size` is stated to configure `client_max_body_size`.
However, this does not seem to be the case as `client-max-body-size` apears to be the appropriete configmap data key to configure the nginx.conf template

```bash
nginx@nginx-ingress-7kx87:/$ cat /etc/nginx/conf.d/* | grep body
		client_max_body_size 0m;
		client_max_body_size 0m;
		client_max_body_size 0m;
		client_max_body_size 0m;
        client_max_body_size 0m;
        client_max_body_size 0m;
        client_max_body_size 0m;
        client_max_body_size 0m;
        client_max_body_size 0m;
        client_max_body_size 0m;
nginx@nginx-ingress-7kx87:/$ 
```