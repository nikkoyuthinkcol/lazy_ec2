SHELL=/bin/bash
.PHONY : all docker docker_compose nvidia_container_runtime

all: post_install terminal

driver:
	./install_drivers.sh

docker:
	./install_docker.sh

docker_compose: docker
	./install_docker_compose.sh

nvidia_container_runtime: docker_compose driver
	./install_nvidia_container_toolkit.sh

terminal:
	./install_terminal.sh

post_install: nvidia_container_runtime
	newgrp docker