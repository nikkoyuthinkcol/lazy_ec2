#!/bin/bash

if [[ $? -eq 127 ]]; then
	echo docker is not installed, unless you have other container runtime solutions such as virtualbox, please install docker.
fi

# minikube (local k8, an all-in-one solution)
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

# kubectl (tool to access k8s)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# test
kubectl version --client