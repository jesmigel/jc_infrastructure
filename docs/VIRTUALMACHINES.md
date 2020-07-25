# Virtual Machines
* Only proceed if [requirements](./REQUIREMENTS.md) has been met.
* Unique VM's are to be deployed consisting of a kubernetes cluster and a proxy node

## Prerequisite - VM specifications
* The VM specifications are stated in [vagrant_variables.yaml](../platform/vagrant/vagrant_variables.yaml)
* Refer to the [infrastructure](../INFRASTRUCTURE.md) document for the default specifications

### Field descriptions
#### global
This block contains details propagated to all managed virtual machines
| Field | Description |
| ----- | ----------: |
| api_version | Api version used by vagrant |
| network | Contains network rules intended to be propagated across all VM's |
| network.subnet | Subnet of all the VM's |
| plugins | Global plugin list |

#### nodes
Contains details specific to a node or group of nodes
| Field | Description |
| ----- | ----------: |
| cpu| number of cores allocated to vm(s) |
| bootstrap | shell commands to be executed post VM deployment |
| disk | Unformatted disk(s) block to be attached against VM(s) |
| disk.instances | number of disk(s) to be created and attached |
| disk.size | size of disk(s) |
| gui | GUI enabled/disabled when VM(s) are provisioned |
| instances | Number of VM(s) to be provisioned in the VM group |
| memory | Allocated RAM |
| mounts | Physical host machine path to be mounted on guest (VM) |
| mounts[ 0..n ].host | Host path |
| mounts[ 0..n ].guest | Guest path |
| network | Host part (last 3 digits) with a rang of [1-254] of a subnet |
| node_prefix | Prefix of the name allocated to the VM |
| os | Vagrantbox image to be used for the VM group |

## Vagrant input validation
```bash
# Validate Vagrant configuration
make validate_vm

Vagrant has detected project local plugins configured for this
project which are not installed.

  vagrant-disksize, vagrant-sshfs
Install local plugins (Y/N) [N]: Y  'THIS IS A PROMPT!!!'
Installing the 'vagrant-disksize' plugin. This can take a few minutes...
Fetching vagrant-disksize-0.1.3.gem
Installed the plugin 'vagrant-disksize (0.1.3)'!
Installing the 'vagrant-sshfs' plugin. This can take a few minutes...
Fetching win32-process-0.8.3.gem
Fetching vagrant-sshfs-1.3.5.gem
Installed the plugin 'vagrant-sshfs (1.3.5)'!


Vagrant has completed installing local plugins for the current Vagrant
project directory. Please run the requested command again.
make: *** [validate_vm] Error 255 'Vagrant exits with 255'

# As instructed, re-execute the validation
make validate_vm
Validate Vagrant Specification(s):  ./platform/vagrant/vagrant_variables.yaml
There are errors in the configuration of this machine. Please fix
the following errors and try again:

vm:
* The host path of the shared folder is missing: ./data/nginx/certs
* The host path of the shared folder is missing: ./data/sharedfolder

# The error above is caused by specified folders added 
#   to .gitignore. They are excluded due to contents 
#   being unwanted to be pushed upstream

# The error is fixed by executing the below
make bootstrap_mounts
Initialising path:./platform/vagrant/./data/sharedfolder
Updating Permission as SSHFS from Host to Guests:./platform/vagrant/./data/sharedfolder
Initialising path:./platform/vagrant/./data/nginx/certs
Updating Permission as SSHFS from Host to Guests:./platform/vagrant/./data/nginx/certs

# Now that the path requirements are met, reexecute the vagrant validation
make validate_vm
Validate Vagrant Specification(s):  ./platform/vagrant/vagrant_variables.yaml
Vagrantfile validated successfully.
```
