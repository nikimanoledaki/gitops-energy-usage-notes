#!/bin/bash

# This is a script to run from a VM1 development machine or Ubuntu machine (in Production) to provision KVM.
# It will also install minikube and provision a Kubernetes cluster.

# (optional) Check kvm support.
sudo apt install cpu-checker
kvm-ok

# Instal libvirt & its pre-requisites. For more info, see docs: https://help.ubuntu.com/community/KVM/Installation
sudo apt-get update
sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
sudo adduser `id -un` libvirt
sudo adduser `id -un` kvm

# exit and relogin
exit
vagrant ssh

sudo systemctl restart libvirtd.service

# Install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Provision a test Kubernetes cluster using KVM
minikube start --driver=kvm2 --container-runtime=containerd --memory=1987mb --profile=minikube --wait-timeout=15m0s --wait=all

# Validate KVM support
virt-host-validate

# Validate virtual network using virsh (a command line tool to manage VMs)
sudo virsh net-list --all

# Check minikube virt info
virsh net-info mk-minikube

# Check KVM DHCP
virsh net-dhcp-leases mk-minikube

# Check KVM config
virsh
net-dumpxml default