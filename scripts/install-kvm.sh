#!/bin/bash

// This is a script to run from a VM1 development machine or Ubuntu machine (in Production) to provision KVM.
// It is not recommend to try this at home if your dev computer is a laptop. Unless, of course, if it is cold
// and you are trying to warm up your hands.
//
// It will also install minikube and provision a Kubernetes cluster.

// (optional) Check kvm support if needed. Error was solved by configuring the Vagrant file
// to request from Virtualbox to allow nested VMs.
sudo apt install cpu-checker
kvm-ok

// Instal libvirt & its pre-requisites. For more info, see docs: https://help.ubuntu.com/community/KVM/Installation
sudo apt-get update
sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
sudo adduser `id -un` libvirt
sudo adduser `id -un` kvm

// exit and relogin
exit
vagrant ssh

sudo systemctl restart libvirtd.service

// Install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

// Provision a test Kubernetes cluster using KVM
minikube start --driver=kvm2
