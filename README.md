# jc_infrastructure

## Motivation
To enable the capability of provisioning a kubernetes based infrastructure replicating key aspects of an onprem environment. This includes the following:
* A kubernetes cluster in a "private" subnet
* A proxy connected to the private and public subnet
* A DNS Server/Sinkhole moderating traffic between the internet and the emulated "onprem" environment

## Documentation
* [Host Requirements](./docs/REQUIREMENTS.md)
* [Infrastructure Overview](./docs/INFRASTRUCTURE.md)
* [NODE Provisioning](./docs/NODES.md)
* [Kubernetes Installation](./docs/KUBERNETES.md)

## Makefile help
```bash
# COMMON
# =======
      up: Brings up a 3 node VM cluster, 1 proxy VM and a dns container
    down: Halts (Shutdowns) the 3 node vm cluster
  status: Shows the VM and DNS status
   clean: Destroys all VMs
 login_1: SSH to the node 1 of the VM cluster
 login_2: SSH to the node 2 of the VM cluster
 login_3: SSH to the node 3 of the VM cluster
login_ng: SSH to the proxy node of the VM cluster


# BOOTSTRAP COMMANDS
# ==================
bootstrap_mounts: Prepares mounts required prior to building the VM(s)
                : and containers


# VM COMMANDS
# ===========
validate_vm: Validates the vm node specifications


# SUBMODULES
# ==========
      submodules: Executes submodules_clean submodules_init submodules_sync
submodules_clean: Cleans up submodules
 submodules_init: Initialises submodules
 submodules_sync: Syncs up upstream submodules


# KUBERNETES (KUBESPRAY)
# ======================
kubespray_deploy: Executes kubespray_prereq and kubespray_install
# KUBERNETES (KUBESPRAY) - PREREQUISITES
         kubespray_prereq: Executes kubespray_venv kubespray_inventory_init kubespray_inventory_build
           kubespray_venv: Initialises a kubespray dedicated virtualenv directory


 kubespray_inventory_init: Initialises a kubespray (ansible) inventory
kubespray_inventory_build: Configures the kubespray inventory based on parameter present in .makefile.env
                         : _K8S_IPS in .makefile.env must match subnet and I.P. stated in
                         : platform/vagrant/vagrant_variables.yaml


# KUBERNETES (KUBESPRAY) - INSTALLATION
kubespray_install: Executes kubespray_exec and kubespray_post
kubespray_exec: Executes the kubespray ansible-playbook using the generated inventory
kubespray_post: Places the admin kubernetes configuration to the vagrant home directory inside master nodes
kube_config: initialises a shell script to source the admin config that allows the host to interact with the kubecluster in the guest VMs

# END
```
