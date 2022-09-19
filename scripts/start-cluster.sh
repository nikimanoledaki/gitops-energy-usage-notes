#!/bin/bash
minikube start --driver=kvm2 --container-runtime=containerd --memory=1987mb --profile=minikube --wait-timeout=15m0s --wait=all
flux bootstrap github --owner=nikimanoledaki --repository=gitops-energy-usage --path=clusters