# jc_infrastructure
DevOps centric infrastructure

## Walkthrough
* [Host Requirements](./docs/REQUIREMENTS.md)
* [Host Initialisation](./docs/INITIALISATION.md)

## Vagrant
vagrant
up
down
build
clean
status
login_1
login_2
login_3

## DNS
dns
dns_up
dns_down
dns_status

## Inventory Builder
k8s
*** NOTE: kubespray inventory needs to be manually updated for custom cluster builds

## CHEAT SHEET
kubectl run -it --rm --restart=Never --image=infoblox/dnstools:latest dnstools

## Pod Termination
kubectl delete pod <PODNAME> --grace-period=0 --force --namespace <NAMESPACE>