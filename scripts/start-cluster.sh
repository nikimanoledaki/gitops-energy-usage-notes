#!/bin/bash
minikube start --container-runtime=containerd --memory=6g --bootstrapper=kubeadm --extra-config=kubelet.authentication-token-webhook=true --extra-config=kubelet.authorization-mode=Webhook --extra-config=scheduler.bind-address=0.0.0.0 --extra-config=controller-manager.bind-address=0.0.0.0
minikube addons disable metrics-server
flux bootstrap github --owner=nikimanoledaki --repository=gitops-energy-usage --path=clusters