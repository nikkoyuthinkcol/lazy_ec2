#!/bin/bash
# The is a script for installing all the required drivers.
export DEBIAN_FRONTEND="noninteractive"

# Essential libraries
sudo apt install bc  # for floating point compare in bash

# NVIDIA DRIVERS
if [[ $(cat /proc/driver/nvidia/version) && true ]]; then
	echo 'The driver is already installed.'
elif [[ $(lshw -C display | grep vendor) =~ NVIDIA ]]; then
	echo "Install ubuntu-drivers..."
	sudo apt install ubuntu-drivers-common --gpgpu
	sudo ubuntu-drivers install
	#sudo apt install nvidia-headless-535-server nvidia-utils-535-server -y
else
	echo 'No Nvidia-GPU Found, skipping...'
fi


# NVIDIA CUDA (v.22.04)
# Check if nvidia-smi is installed
if command -v nvidia-smi > /dev/null 2>&1; then
	# Get CUDA version from nvidia-smi
	cuda_version=$(nvidia-smi | grep CUDA | awk '{print $9}')
else
	echo "nvidia-smi not found. Please ensure CUDA is installed and nvidia-smi is available in the PATH."
    cuda_version="0.0"
fi
required_version=12.2
cuda_check=$(echo "$cuda_version >= $required_version" | bc -l)
if [[ $cuda_check -eq 0 ]]; then
	echo 'CUDA does not exist or not sufficient, installing CUDA 12.4.1 ...'
	sudo apt install nvidia-cuda-toolkit
	#wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
	#sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
	#wget https://developer.download.nvidia.com/compute/cuda/12.4.1/local_installers/cuda-repo-ubuntu2204-12-4-local_12.4.1-550.54.15-1_amd64.deb
	#sudo dpkg -i cuda-repo-ubuntu2204-12-4-local_12.4.1-550.54.15-1_amd64.deb
	#sudo cp /var/cuda-repo-ubuntu2204-12-4-local/cuda-*-keyring.gpg /usr/share/keyrings/
	#sudo apt-get update
	#sudo apt-get -y install cuda-toolkit-12-4

	#sudo apt-get install -y nvidia-driver-550-open
	#sudo apt-get install -y cuda-drivers-550
else
	echo 'CUDA 12.4 is installed already, skipping...'
fi

# NVIDIA CUDNN (v9.1.1)
echo Checking CUDNN v9 exists...
cudnn_string=$(cat /usr/include/x86_64-linux-gnu/cudnn_v*.h | grep CUDNN_MAJOR -A 2)
if [[ $cudnn_string != *"CUDNN_MAJOR 9"* ]]; then
	echo CUDNN v9 is absent. Downloading CUDNN latest...
	sudo apt nvidia-cudnn
	#wget https://developer.download.nvidia.com/compute/cudnn/9.1.1/local_installers/cudnn-local-repo-ubuntu2204-9.1.1_1.0-1_amd64.deb
	#sudo dpkg -i cudnn-local-repo-ubuntu2204-9.1.1_1.0-1_amd64.deb
	#sudo cp /var/cudnn-local-repo-ubuntu2204-9.1.1/cudnn-*-keyring.gpg /usr/share/keyrings/
	#sudo apt-get update
	#sudo apt-get -y install cudnn
else
	echo CUDNN is already installed. Skipping...
fi
