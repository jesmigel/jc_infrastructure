# [ARGOCD](https://argoproj.github.io/argo-cd/getting_started/)

## Installation
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f \
https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## Initialisation
```bash
# Password of argocd
PODNAME=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)

# Execute interactive shell
kubectl -n argocd exec -it $PODNAME bash

# Login
argocd login argocd-server --name admin --password $PODNAME

# Reset Password
argocd account update-password
```