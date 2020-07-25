# NODES
* Only proceed if [requirements](./REQUIREMENTS.md) has been met.
* Unique VM's are to be deployed consisting of a kubernetes cluster and a proxy node

## Prepare Submodules
```bash
# Initialise submodules. This cleans up if submodules already.
$ make submodules
Clean submodules:./submodule/kubespray
Cleared directory 'submodule/kubespray'
Submodule 'submodule/kubespray' (https://github.com/kubernetes-sigs/kubespray.git) unregistered for path 'submodule/kubespray'
rm 'submodule/kubespray'

Add Submodule https://github.com/kubernetes-sigs/kubespray.git stored to  ./submodule/kubespray
git submodule add -f https://github.com/kubernetes-sigs/kubespray.git  ./submodule/kubespray
Reactivating local git directory for submodule 'submodule/kubespray'.

git submodule update --force --init --recursive
Submodule path 'submodule/kubespray': checked out 'aa21edeb535486f4909274486fc598cceccff368'

 aa21edeb535486f4909274486fc598cceccff368 submodule/kubespray (v2.1.0-3964-gaa21edeb)

# Confirm Submodule status
$ make submodules_status
 aa21edeb535486f4909274486fc598cceccff368 submodule/kubespray (v2.1.0-3964-gaa21edeb)
```

## Generate Kubespray Inventory
NOTE: values of $(_K8S_IPS) in [.makefile.env](../makefile.env) must match the kubernetes ip subnet present in [vagrant_variables.yaml](../platform/vagrant/vagrant_variables.yaml)
```bash
# This command initialises virtualenv, installs requirements and generates the kubespray inventory
$ make kubespray_prereq
virtualenv -p python3  ./venv/k8s
...
...
Successfully installed MarkupSafe-1.1.1 PyYAML-5.3.1 ansible-2.9.6 certifi-2020.6.20 cffi-1.14.0 chardet-3.0.4 cryptography-3.0 hvac-0.10.0 idna-2.10 jinja2-2.11.1 jmespath-0.9.5 netaddr-0.7.19 pbr-5.4.4 pycparser-2.20 requests-2.24.0 ruamel.yaml-0.16.10 ruamel.yaml.clib-0.2.0 six-1.15.0 urllib3-1.25.10
cd ./submodule/kubespray/inventory && cp -r sample k8s
( source  ./venv/k8s/bin/activate;  cd ./submodule/kubespray && declare -a IPS=(10.8.41.101 10.8.41.102 10.8.41.103) && CONFIG_FILE=inventory/k8s/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}  )
...
...
DEBUG: adding host node2 to group kube-node
DEBUG: adding host node3 to group kube-node
rsync -a -v ./submodule/kubespray/inventory/k8s ./platform/inventory/k8s/
sending incremental file list
...
...
k8s/group_vars/k8s-cluster/k8s-net-macvlan.yml
k8s/group_vars/k8s-cluster/k8s-net-weave.yml

sent 42,713 bytes  received 485 bytes  86,396.00 bytes/sec
total size is 40,991  speedup is 0.95
```

## Install Kubernetes to VM nodes
```bash
# Kubespray is triggered by virtualenv ansible-playbook with the generated inventory as its payload
# Sanity Check: Login into the nodes using the auto generated ssh config
$ make login_1
ssh -F  .vagrant.ssh.config  k8s-1
Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.15.0-112-generic x86_64)
...
...
vagrant@k8s-1:~$ exit
$ make login_2
ssh -F  .vagrant.ssh.config  k8s-2
Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.15.0-112-generic x86_64)
...
...
vagrant@k8s-2:~$ exit
$ make login_3
ssh -F  .vagrant.ssh.config  k8s-3
Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.15.0-112-generic x86_64)
...
...
vagrant@k8s-3:~$ exit

# Successful ssh logon ensures that ansible wouldnt encounter connectivity issues against the target nodes
# NOTE: Errors may still occur due to the strict host checking by kubespray.
#    Immediate solution is to clean up ~/.ssh/known_host
$ make kubespray_install
...
...
# SSH Prompts are encountered, 'yes' responses must provided the same number as the node instances.
#    There is a timeout for the answers to be provided. If the timeout occurs, reexection 
#    of make kubespray_install is required.
...
...
PLAY RECAP *****************************************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node1                      : ok=603  changed=133  unreachable=0    failed=0    skipped=1114 rescued=0    ignored=0   
node2                      : ok=529  changed=122  unreachable=0    failed=0    skipped=951  rescued=0    ignored=0   
node3                      : ok=426  changed=100  unreachable=0    failed=0    skipped=626  rescued=0    ignored=0


# Ansible completion is followed by redeploying kube.config within the master nodes as well as rsync of
#     the said config from the guest to host.
ssh -F  .vagrant.ssh.config -t  k8s-1 ' mkdir -p ~/.kube && sudo cp -rf /etc/kubernetes/admin.conf ~/.kube/config && sudo chown $(id -u):$(id -g) ~/.kube/config '
Connection to 127.0.0.1 closed.
ssh -F  .vagrant.ssh.config -t  k8s-2 ' mkdir -p ~/.kube && sudo cp -rf /etc/kubernetes/admin.conf ~/.kube/config && sudo chown $(id -u):$(id -g) ~/.kube/config '
Connection to 127.0.0.1 closed.


# If kubectl is installed in host direct kubernetes interaction can be configured
$ kubectl get nodes
The connection to the server kubernetes.docker.internal:6443 was refused - did you specify the right host or port?
$ make kube_config
execute 'source .init.kube.config.sh' to set KUBECONFIG


# Following the instruction...
source .init.kube.config.sh && printenv 

# Interacting with the provisioned kubernetes cluster
$ kubectl get nodes -o wide
NAME    STATUS   ROLES    AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
node1   Ready    master   10m     v1.18.3   10.8.41.101   <none>        Ubuntu 18.04.4 LTS   4.15.0-112-generic   docker://19.3.12
node2   Ready    master   9m42s   v1.18.3   10.8.41.102   <none>        Ubuntu 18.04.4 LTS   4.15.0-112-generic   docker://19.3.12
node3   Ready    <none>   8m41s   v1.18.3   10.8.41.103   <none>        Ubuntu 18.04.4 LTS   4.15.0-112-generic   docker://19.3.12
```