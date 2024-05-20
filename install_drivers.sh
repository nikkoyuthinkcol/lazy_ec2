#!/bin/sh
# The is a script for installing all the required drivers.

# NVIDIA DRIVERS
if [[ $(cat /proc/driver/nvidia/version) && true ]]; then
	echo 'The driver is already installed.'
else
	if [[ $(lshw -C display | grep vendor) =~ NVIDIA ]]; then
		sudo apt install nvidia-headless-535-server nvidia-utils-535-server -y
	else
		echo 'No Nvidia-GPU Found, skipping...'
	fi
fi
