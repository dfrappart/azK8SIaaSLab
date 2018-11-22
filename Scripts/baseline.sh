#!/bin/bash
sudo apt-get update
sudo apt-get install -y apt-transport-https
sudo echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" |sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl docker.io
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab