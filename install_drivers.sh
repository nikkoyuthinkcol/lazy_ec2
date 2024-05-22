#!/bin/bash
# The is a script for installing all the required drivers.

# NVIDIA DRIVERS
if [[ $(cat /proc/driver/nvidia/version) && true ]]; then
	echo 'The driver is already installed.'
elif [[ $(lshw -C display | grep vendor) =~ NVIDIA ]]; then
	sudo apt install nvidia-headless-535-server nvidia-utils-535-server -y
else
	echo 'No Nvidia-GPU Found, skipping...'
fi


# NVIDIA CUDA (v.22.04)
if [[ $(nvidia-smi | grep CUDA | awk '{print $9}') -ne 12.4 ]]; then
	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
	sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
	wget https://developer.download.nvidia.com/compute/cuda/12.4.1/local_installers/cuda-repo-ubuntu2204-12-4-local_12.4.1-550.54.15-1_amd64.deb
	sudo dpkg -i cuda-repo-ubuntu2204-12-4-local_12.4.1-550.54.15-1_amd64.deb
	sudo cp /var/cuda-repo-ubuntu2204-12-4-local/cuda-*-keyring.gpg /usr/share/keyrings/
	sudo apt-get update
	sudo apt-get -y install cuda-toolkit-12-4

	sudo apt-get install -y nvidia-driver-550-open
	sudo apt-get install -y cuda-drivers-550
else
	echo 'CUDA 12.4 is installed already, skipping...'
fi

# NVIDIA CUDNN (v9.1.1)
cudnn_string=$(cat /usr/include/x86_64-linux-gnu/cudnn_v*.h | grep CUDNN_MAJOR -A 2)
if [[ $cudnn_string != *"CUDNN_MAJOR 9"* ]]; then
	echo Downloading CUDNN v9
	wget https://developer.download.nvidia.com/compute/cudnn/9.1.1/local_installers/cudnn-local-repo-ubuntu2204-9.1.1_1.0-1_amd64.deb
	sudo dpkg -i cudnn-local-repo-ubuntu2204-9.1.1_1.0-1_amd64.deb
	sudo cp /var/cudnn-local-repo-ubuntu2204-9.1.1/cudnn-*-keyring.gpg /usr/share/keyrings/
	sudo apt-get update
	sudo apt-get -y install cudnn
else
	echo CUDNN v9 is already installed. Skipping...
fi

# NVIDIA Container-toolkit
if [[ $(nvidia-ctk --version) ]]; then
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