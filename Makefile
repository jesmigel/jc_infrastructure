.PHONY: init \
up init-ssh down build clean status help \
kubespray_deploy kubespray_prereq kubespray_install kube_config \
login_1 login_2 login_3 \

include .makefile.env

# TOOLTIP
# =======
help: h_common h_bootstrap h_vm_commands h_submodules h_kubespray

h_common:
	@echo "# COMMON"
	@echo "# ======"
	@echo "      up: Brings up a 3 node VM cluster, 1 proxy VM and a dns container"
	@echo "    down: Halts (Shutdowns) the 3 node vm cluster"
	@echo "  status: Shows the VM and DNS status"
	@echo "   clean: Destroys all VMs"
	@echo " login_1: SSH to the node 1 of the VM cluster"
	@echo " login_2: SSH to the node 2 of the VM cluster"
	@echo " login_3: SSH to the node 3 of the VM cluster"
	@echo "login_ng: SSH to the proxy node of the VM cluster"
	@echo ""
	@echo ""

h_bootstrap:
	@echo "# BOOTSTRAP COMMANDS"
	@echo "# =================="
	@echo "bootstrap_mounts: Prepares mounts required prior to building the VM(s)"
	@echo "                : and containers"
	@echo ""
	@echo ""

h_vm_commands: 
	@echo "# VM COMMANDS"
	@echo "# ==========="
	@echo "validate_vm: Validates the vm node specifications"
	@echo ""
	@echo ""

h_submodules:
	@echo "# SUBMODULES"
	@echo "# =========="
	@echo "      submodules: Executes submodules_clean submodules_init submodules_sync"
	@echo "submodules_clean: Cleans up submodules"
	@echo " submodules_init: Initialises submodules"
	@echo " submodules_sync: Syncs up upstream submodules"
	@echo ""
	@echo ""

h_kubespray:
	@echo "# KUBERNETES (KUBESPRAY)"
	@echo "# ======================"
	@echo "kubespray_deploy: Executes kubespray_prereq and kubespray_install"
	@echo ""
	@echo ""
	@echo "# KUBERNETES (KUBESPRAY) - PREREQUISITES"
	@echo "# ======================================"
	@echo "         kubespray_prereq: Executes kubespray_venv kubespray_inventory_init kubespray_inventory_build"
	@echo "           kubespray_venv: Initialises a kubespray dedicated virtualenv directory"
	@echo ""
	@echo ""
	@echo "# KUBERNETES (KUBESPRAY) - INVENTORY"
	@echo "# =================================="
	@echo " kubespray_inventory_init: Initialises a kubespray (ansible) inventory"
	@echo "kubespray_inventory_build: Configures the kubespray inventory based on the parameter _K8S_IPS in .makefile.env"
	@echo "                         : _K8S_IPS in .makefile.env must match subnet and I.P. stated in"
	@echo "                         :      platform/vagrant/vagrant_variables.yaml"
	@echo ""
	@echo ""
	@echo "# KUBERNETES (KUBESPRAY) - INSTALLATION"
	@echo "# =================================="
	@echo "kubespray_install: Executes kubespray_exec and kubespray_post"
	@echo "kubespray_exec: Executes the kubespray ansible-playbook using the generated inventory"
	@echo "kubespray_post: Places the admin kubernetes configuration to the vagrant home directory inside master nodes"
	@echo "kube_config: initialises a shell script to source the admin config that allows the host to interact with the kubecluster in the guest VMs"
	@echo ""
	@echo "# END"

# VM COMMANDS
# ===========
up: up_vm up_dns status_dns
	@cd $(_VAGRANT) && vagrant ssh-config > $(PWD)/$(_VAGRANT_SSH_CONFIG)

validate_vm:
	$(call vm_validate, $(_VAGRANT),$(_VAGRANT_CFG))

bootstrap_mounts:
	$(call bootstrap_mount,$(_VAGRANT)/$(_SHAREDFOLDER))
	$(call bootstrap_mount,$(_VAGRANT)/$(_NGINX_CERTS))

up_vm:
	$(call vm_up, $(_VAGRANT))

down:
	$(call vm_down, $(_VAGRANT))

build:
	$(call vm_build, $(_VAGRANT))

clean:
	$(call vm_clean, $(_VAGRANT))

status: status_vm status_dns

status_vm:
	$(call vm_status, $(_VAGRANT))

provision_vm:
	$(call vm_provision, $(_VAGRANT))

reload_vm:
	$(call vm_reload, $(_VAGRANT))

# DNS COMMANDS
# ============
up_dns:
	$(call bootstrap_mount, $(_PIHOLE))
	$(call compose_up, $(_COMPOSE))

build_dns:
	$(call compose_build, $(_COMPOSE))

status_dns:
	$(call compose_ps, $(_COMPOSE))

down_dns:
	$(call compose_down, $(_COMPOSE))

logs_dns:
	$(call compose_logs, $(_COMPOSE))

# LOGIN
# =====
login_ng:
	$(call login_ssh, $(_VAGRANT_SSH_CONFIG), local-1)
login_1: init-ssh
	$(call login_ssh, $(_VAGRANT_SSH_CONFIG), k8s-1)
login_2: init-ssh
	$(call login_ssh, $(_VAGRANT_SSH_CONFIG), k8s-2)
login_3: init-ssh
	$(call login_ssh, $(_VAGRANT_SSH_CONFIG), k8s-3)

# SUBMODULES
# ==========
submodules: submodules_clean submodules_init submodules_sync submodules_status

submodules_clean:
	$(call clean_submodule,$(_KUBESPRAY_PATH))
	@echo ""
	

submodules_init:
	$(call add_submodule,$(_KUBESPRAY_REPO), $(_KUBESPRAY_PATH))
	@echo ""
	

submodules_sync:
	git submodule update --force --init --recursive
	@echo ""

submodules_status:
	@git submodule status
	@echo ""


# KUBESPRAY
# =========
kubespray_deploy: kubespray_prereq kubespray_install

kubespray_prereq: kubespray_venv kubespray_inventory_init kubespray_inventory_build
kubespray_venv:
	$(call venv_init, $(_K8S_VENV), $(_KUBESPRAY_PATH))

kubespray_inventory_init:
	cd $(_K8S_INVENTORY_SRC) && cp -r sample $(_K8S)

kubespray_inventory_build:
ifneq ($(wildcard $(_K8S_INVENTORY_DST)),"")
	$(call venv_exec, $(_K8S_VENV), \
		cd $(_KUBESPRAY_PATH) && \
		declare -a IPS=$(_K8S_IPS) && \
		CONFIG_FILE=$(_K8S_CONFIG) python3 $(_K8S_BUILDER_SCRIPT) $${IPS[@]} \
	)
	rsync -a -v $(_K8S_INVENTORY_SRC)/$(_K8S) $(_K8S_INVENTORY_DST)/
else
	@echo "$(_K8S_INVENTORY_DST) exist"
	@ls -l $(_K8S_INVENTORY_DST)
endif

kubespray_install: kubespray_exec kubespray_post
kubespray_exec:
	$(call venv_exec, \
		$(_K8S_VENV), \
		pip install ansible; \
		ansible-playbook -i $(_K8S_INVENTORY_DST)/hosts.yaml \
		$(_KUBESPRAY_PATH)/cluster.yml -u vagrant -b -v --private-key=$(_VAGRANT_KEY) \
	)

kubespray_post:
	$(call vm_exec, \
		$(_VAGRANT_SSH_CONFIG), \
		k8s-1,\
		mkdir -p $(_KUBE_DIR) && sudo cp -rf $(_KUBE_SRC) $(_KUBE_CFG) && sudo chown $$(id -u):$$(id -g) $(_KUBE_CFG) \
	)

	$(call vm_exec, \
		$(_VAGRANT_SSH_CONFIG), \
		k8s-2,\
		mkdir -p $(_KUBE_DIR) && sudo cp -rf $(_KUBE_SRC) $(_KUBE_CFG) && sudo chown $$(id -u):$$(id -g) $(_KUBE_CFG) \
	)
	rsync  -az -e "ssh -F $(_VAGRANT_SSH_CONFIG)" k8s-1:/home/vagrant/.kube/config .vagrant.kube.config

kube_config:
	@echo "#!/bin/bash" > .init.kube.config.sh
	@echo export KUBECONFIG=\`pwd\`/.vagrant.kube.config >> .init.kube.config.sh
	@echo "execute 'source .init.kube.config.sh' to set KUBECONFIG"


# KUBE COMMANDS
# =============
kube_dns:
	kubectl run -it --rm --restart=Never --image=infoblox/dnstools:latest dnstools

# FUNCTIONS
# =========
# BOOTSTRAPS
define bootstrap_mount
	@if [ ! -a $(1) ]; then \
		echo "Initialising path:$(1)" && \
		mkdir -p $(1) && \
		echo "Updating Permission of SSHFS mount:$(1)" && \
		chmod 777 $(1); fi;
endef

# SUBMODULES
define clean_submodule
	@if [ -a $(1) ]; then \
		echo "Clean submodules:$(1)" && \
		git submodule deinit -f $(1) && \
		git rm -f -r $(1); fi;
endef

define add_submodule
	@echo "Add Submodule $(1) stored to $(2)"
	git submodule add -f $(1) $(2)
endef

define sync_submodule
	git submodule update --force --init --recursive
endef

define status_submodule
	git submodule status
endef

# VAGRANT SSH to Node
define login_vagrant
	cd $(1) && vagrant ssh
endef

define login_ssh
	ssh -F $(1) $(2)
endef


# VM EXEC
define vm_exec
	ssh -F $(1) -t $(2) '$(3)'
endef

# VENV FUNCTIONS
define venv_init
	$(if [ ! -f "$($(1)/bin/activate)" ], virtualenv -p python3 $(1))
	( \
    	source $(1)/bin/activate; \
    	pip install -r $(2)/requirements.txt \
	)
endef

define venv_exec
	( \
    	source $(1)/bin/activate; \
    	$(2) \
	)
endef

# VAGRANT FUNCTIONS
define vm_validate
	@echo "Validate Vagrant Specification(s): $(1)/$(2)"
	@export $$(grep 'VAGRANT' .makefile.env | xargs) && cd $(1) && vagrant validate
	
endef

define vm_up
	@echo "Provisioning Vagrant VM: $(1)"
	@export $$(grep 'VAGRANT' .makefile.env | xargs) && cd $(1) && vagrant up
endef

define vm_down
	@echo "Suspending Vagrant VM: $(1) $(2)"
	@export $$(grep 'VAGRANT' .makefile.env | xargs) && cd $(1) && vagrant halt $(2)
endef

define vm_build
	@echo "Building Vagrant VM: $(1)"
	@export $$(grep 'VAGRANT' .makefile.env | xargs) && cd $(1) && vagrant provision
endef

define vm_clean
	@echo "Destroying Vagrant VM: $(1) $(2)"
	@export $$(grep 'VAGRANT' .makefile.env | xargs) && cd $(1) && vagrant destroy $(2)
endef

define vm_provision
	@echo "Provisioning Vagrant VM: $(1)"
	@export $$(grep 'VAGRANT' .makefile.env | xargs) && cd $(1) && vagrant provision
endef

define vm_reload
	@echo "Provisioning Vagrant VM: $(1)"
	@export $$(grep 'VAGRANT' .makefile.env | xargs) && cd $(1) && vagrant reload
endef

define vm_status
	@echo "Vagrant Status in: $(1)"
	@export $$(grep 'VAGRANT' .makefile.env | xargs) && cd $(1) && vagrant status
endef

# COMPOSE FUNCTIONS
define compose_up
    cd $(1) && docker-compose up -d
endef

define compose_down
    cd $(1) && docker-compose down
endef

define compose_build
    cd $(1) && docker-compose build
endef

define compose_ps
	cd $(1) && docker-compose ps
endef

define compose_logs
	cd $(1) && docker-compose logs $(2)
endef