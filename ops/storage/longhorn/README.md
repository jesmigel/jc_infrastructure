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