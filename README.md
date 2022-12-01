## Energy-efficient Kubernetes

This project aims to measure and compare the energy consumption of snowflake clusters versus that of Flux-based GitOps clusters.

Another aim is to create a reference architecture for measuring the energy consumption of cloud-native processes using cloud-native tools.

The focus here is on energy usage rather than, for example, [marginal emissions estimates](https://www.electricitymaps.com/blog/marginal-emissions-what-they-are-and-when-to-use-them). That being said, energy metrics could be used to deduce carbon emissions.

This project could be used as the base model for conducting Life Cycle Assessment (LCAs) of any cloud-native software that runs on a Pod.

---

## [Update] The final version of this project can be found here: https://github.com/nikimanoledaki/sustainability-journey-with-gitops

---

## Resources

- [Flux](https://fluxcd.io/)
- [Kepler](https://github.com/sustainable-computing-io/kepler)
- [Flintlock for microVMs](https://github.com/weaveworks-liquidmetal/flintlock)
- [Liquid Metal](https://github.com/weaveworks-liquidmetal)
- [CAPMVM](https://github.com/weaveworks-liquidmetal/cluster-api-provider-microvm)

## Get Started with Local Development

### OS

#### Linux
For Linux users, create a cluster directly [with minikube](#start-a-kubernetes-cluster-with-minikube).

#### MacOS
For MacOS user, the dependencies are:
- Virtualbox - `brew install --cask virtualbox`
- Vagrant - `brew install --cask vagrant`

Then, use [this Vagrantfile](Vagrantfile), and spin up a microVM with [Flintlock](https://github.com/weaveworks-liquidmetal/flintlock):

```
vagrant up
vagrant ssh
```

Note: The Vagrantfile allocates 8GB for the microVM. The microVM itself is very lightweight but the cluster that will be allocated 6GB. Ensure you have enough RAM.

### Start a Kubernetes cluster with minikube

First, create a minikube cluster:
```bash
minikube start --container-runtime=containerd --memory=6g --bootstrapper=kubeadm --extra-config=kubelet.authentication-token-webhook=true --extra-config=kubelet.authorization-mode=Webhook --extra-config=scheduler.bind-address=0.0.0.0 --extra-config=controller-manager.bind-address=0.0.0.0
minikube addons disable metrics-server
```

You will need to install kube-prometheus and kepler on your cluster.

To do this in a GitOps way, [bootstrap Flux](https://fluxcd.io/flux/get-started/) on your cluster.

Then, copy the Flux manifests for [kube-prometheus](clusters/kube-prometheus.yaml) and [kepler](clusters/kepler) to your config repo. Flux will automatically reconcile these for you.

## Get Started in a Cloud Environment

### Example: Use Equinix for the Baremetal Host
[Liquid Metal](https://github.com/weaveworks-liquidmetal) can be used to create microVMs on any baremetal machine. 

Follow [thse instructions](https://github.com/weaveworks-liquidmetal/getting-started/blob/main/docs/intro.md#terraform-an-environment-on-equinix) for how to use Equinix as a host baremetal machine.

Use [this Terraform manifest](TODO), which contains the necessary configuration to be used as a host for [Kepler](https://github.com/sustainable-computing-io/kepler).

Set up a Kubernetes management cluster locally with CAPI. Then, set up more clusters hosted on microVMs with [CAPMVM](https://github.com/weaveworks-liquidmetal/getting-started/blob/main/docs/create.md).
