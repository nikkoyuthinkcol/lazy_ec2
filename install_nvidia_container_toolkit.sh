#!/bin/bash

# NVIDIA Container-toolkit
docker --version
if [[ $? -eq 127 ]]; then
	echo docker is not installed, please install docker first.
else
	nvidia-ctk --version
	if [[ $? -eq 127 ]]; then
		curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
		&& curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
			sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
			sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

		sudo apt-get update
		sudo apt-get install -y nvidia-container-toolkit

		sudo nvidia-ctk runtime configure --runtime=docker
		sudo systemctl restart docker
	else
		echo NVIDIA container toolkit is already installed.
	fi
fi