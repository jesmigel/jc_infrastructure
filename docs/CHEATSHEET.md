# CHEAT SHEET

## Kubernetes
```bash
# Resource template generator
$ kubectl -n $NAMESPACE create $RESOURCETYPE --dry-run -o yaml > $FILE

# DNS troubleshooting
$ kubectl run -it --rm --restart=Never --image=infoblox/dnstools:latest dnstools

# POD immediate termination
$ kubectl -n $NAMESPACE delete pod $PODNAME --grace-period=0 --force
```

## SHELL
```bash
# Recursive string search in file
$ find . -type f -exec grep -H '$PATTERN' {} \;
```