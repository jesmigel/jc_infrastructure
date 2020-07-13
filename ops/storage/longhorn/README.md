# [LONGHORN](https://longhorn.io/docs/0.8.0/install/install-with-helm/)

## Installation
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f \
https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## Initialisation
```bash
# Get Manifest
curl -L -O https://raw.githubusercontent.com/longhorn/longhorn/master/deploy/longhorn.yaml
```