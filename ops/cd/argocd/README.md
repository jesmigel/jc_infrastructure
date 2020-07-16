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
argocd login argocd-server --name admin --password `hostname`

# Reset Password
argocd account update-password
```

## Custom configmap considerations
```bash
data:
# Disable polling Ingress for External IP to be loaded
  resource.customizations: |
    networking.k8s.io/Ingress:
      health.lua: |
        hs = {}
        hs.status = "Healthy"
        return hs

# Disable diff checks for mutating webhooks
    admissionregistration.k8s.io/MutatingWebhookConfiguration:
      ignoreDifferences: |
        jsonPointers:
        - /webhooks/0/clientConfig/caBundle
```