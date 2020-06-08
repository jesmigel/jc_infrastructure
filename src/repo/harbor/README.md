```bash
helm template -n harbor harbor harbor/harbor \
--set expose.type=ingress \
--set expose.ingress.hosts.core=harbor.k8s-1.vm \
--set expose.ingress.hosts.notary=notary.k8s-1.vm \
--set expose.tls.commonName=k8s-1.vm \
--set externalURL=harbor.k8s-1.vm \
--output-dir .
```