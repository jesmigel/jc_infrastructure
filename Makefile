.PHONY: init \
kubespray kubespray_clean kubespray_init kubespray_sync \
vagrant up init-ssh down build clean status \
vagrant_ng up_ng status_ng down_ng build_ng clean_ng status_ng \
vagrant_k8 up_k8 status_k8 down_k8 build_k8 clean_k8 status_k8 \
login_1 login_2 login_3 \
dns dns_up dns_init dns_down dns_clean dns_status \
k8_inventory k8_inventory_init k8_inventory_venv k8_inventory_init k8_inventory_build


include .makefile.env

kubespray: kubespray_clean kubespray_init kubespray_sync

kubespray_clean:
	@echo "Clean directory:$(_KUBESPRAY)"
	# rm -rf $(_KUBESPRAY)

kubespray_init:
	@echo "Update kubespray submodule"
	git submodule add $(_KUBESPRAY_GIT) $(_KUBESPRAY)

kubespray_sync:
	git submodule update --force --init --recursive


vagrant: up status

up: up_ng up_k8 init-ssh

init-ssh:
	@cd $(_VAGRANT_K8S) && vagrant ssh-config > $(PWD)/$(_VAGRANT_SSH_CONFIG)

down: down_ng down_k8

build: build_ng build_k8

clean: clean_ng clean_k8

up_k8:
	$(call vm_up, $(_VAGRANT_K8S))
	$(call dns_build, $(_VAGRANT_K8S))

down_k8:
	$(call dns_down, $(_VAGRANT_K8S))
	$(call vm_down, $(_VAGRANT_K8S))

build_k8:
	$(call vm_build, $(_VAGRANT_K8S))
	$(call dns_build, $(_VAGRANT_K8S))

clean_k8:
	$(call vm_clean, $(_VAGRANT_K8S))
	$(call dns_clean, $(_VAGRANT_K8S))

status_k8:
	$(call vm_status, $(_VAGRANT_K8S))
	$(call dns_status, $(_VAGRANT_K8S))

up_ng:
	$(call vm_up, $(_VAGRANT_NG))
	$(call dns_build, $(_VAGRANT_NG))

down_ng:
	$(call dns_down, $(_VAGRANT_NG))
	$(call vm_down, $(_VAGRANT_NG))

build_ng:
	$(call vm_build, $(_VAGRANT_NG))
	$(call dns_build, $(_VAGRANT_NG))

clean_ng:
	$(call vm_clean, $(_VAGRANT_NG))
	$(call dns_clean, $(_VAGRANT_NG))

status_ng:
	$(call vm_status, $(_VAGRANT_NG))
	$(call dns_status, $(_VAGRANT_NG))

login_ng: init-ssh
	ssh -F $(_VAGRANT_SSH_CONFIG) local.vm

login_1: init-ssh
	ssh -F $(_VAGRANT_SSH_CONFIG) k8s-1
login_2: init-ssh
	ssh -F $(_VAGRANT_SSH_CONFIG) k8s-2
login_3: init-ssh
	ssh -F $(_VAGRANT_SSH_CONFIG) k8s-3

k8_inventory: k8_inventory_venv k8_inventory_build

k8_inventory_venv:
	$(call venv_init, $(_K8S_VENV), $(_KUBESPRAY)/$(_K8S_BUILDER))

k8_inventory_init:
	cd $(_K8S_INVENTORY_SRC) && cp -r sample $(_K8S)

k8_inventory_build: k8_inventory_init
ifneq ($(wildcard $(_K8S_INVENTORY_DST)),"")
	$(call venv_exec, $(_K8S_VENV), \
		cd $(_KUBESPRAY) && \
		declare -a IPS=$(_K8S_IPS) && \
		CONFIG_FILE=$(_K8S_CONFIG) python3 $(_K8S_BUILDER_SCRIPT) $${IPS[@]} \
	)
	mv $(_K8S_INVENTORY_SRC)/$(_K8S) $(_K8S_INVENTORY_DST)/
else
	@echo "$(_K8S_INVENTORY_DST) exist"
	@ls -l $(_K8S_INVENTORY_DST)
endif
	
cluster: cluster_venv cluster_configure

cluster_venv:
	$(call venv_init, $(_K8S_VENV), $(_KUBESPRAY))

cluster_configure:
	$(call venv_exec, \
		$(_K8S_VENV), \
		pip install ansible; \
		ansible-playbook -i $(_K8S_INVENTORY_DST)/hosts.yaml \
		$(_KUBESPRAY)/cluster.yml -u vagrant -b -v --private-key=$(_VAGRANT_KEY) \
	)

cluster_init:
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

cluster_rsync:
	rsync  -az -e "ssh -F $(_VAGRANT_SSH_CONFIG)" k8s-1:/home/vagrant/.kube/config .vagrant.kube.config
	@echo "export KUBECONFIG=.vagrant.kube.config"

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
define vm_up
	@echo "Provisioning Vagrant VM: $(1)"
	cd $(1) && vagrant up
endef

define vm_down
	@echo "Suspending Vagrant VM: $(1)"
	cd $(1) && vagrant suspend
endef

define vm_build
	@echo "Building Vagrant VM: $(1)"
	cd $(1) && vagrant provision
endef

define vm_clean
	@echo "Destroying Vagrant VM: $(1)"
	cd $(1) && vagrant destroy
endef

define vm_status
	@echo "Destroying Vagrant VM: $(1)"
	cd $(1) && vagrant status
endef

# DNS FUNCTIONS
define dns_up
    cd $(1) && vagrant dns --restart
endef

define dns_down
    cd $(1) && vagrant dns --stop
endef

define dns_build
    cd $(1) && vagrant dns --install
endef

define dns_status
	@cd $(1) && vagrant dns --status
	@cd $(1) && vagrant dns --list
endef

define dns_clean
	@cd $(1) && vagrant dns --uninstall
endef