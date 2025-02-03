SHELL=/bin/bash
.PHONY : all docker docker_compose nvidia_container_runtime kubernetes terraform

all: post_install_cpu

gpu: post_install_gpu

driver:
	./install_drivers.sh

docker:
	./install_docker.sh

docker_compose: docker
	./install_docker_compose.sh

kubernetes: docker
	./install_k8.sh

terraform:
	./install_terraform.sh

nvidia_container_runtime: docker_compose driver
	./install_nvidia_container_toolkit.sh

terminal:
	./install_terminal.sh

post_install_gpu: nvidia_container_runtime terminal kubernetes terraform
	newgrp docker

post_install_cpu: terminal kubernetes terraform
	newgrp docker