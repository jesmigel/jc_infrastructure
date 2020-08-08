# [TRAEFIK](https://docs.traefik.io/getting-started/install-traefik/#use-the-helm-chart)

## Installation
```bash
# Add CNCF Repo
helm repo add traefik https://containous.github.io/traefik-helm-chart

# Confirm 
helm search repo traefik
```

## Initialisation
```bash
helm template stable-traefik-1-87-1 stable/traefik \
-n traefik-v2 --output-dir .
```