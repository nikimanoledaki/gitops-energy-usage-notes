## Energy-efficient Kubernetes on baremetal

This project aims to measure and compare the energy consumption of snowflake clusters versus that of Flux-based GitOps clusters.

Another aim is to create a reference architecture for measuring the energy consumption of cloud-native processes using cloud-native tools.

While the focus here is on energy usage rather than localized grid system estimates, metrics on energy usage could be used to deduce and estimate carbon emissions.

This could lead to a model fo rLife Cycle Assessment (LCAs) of cloud-native software where the energy consumption of various use cases could be measured.

## Resources

Some of the main tools in this stack:
- [Flux](https://fluxcd.io/)
- [Kepler](https://github.com/sustainable-computing-io/kepler)
- [Flintlock for microVMs](https://github.com/weaveworks-liquidmetal/flintlock)
- [Liquid Metal](https://github.com/weaveworks-liquidmetal)
- [CAPMVM](https://github.com/weaveworks-liquidmetal/cluster-api-provider-microvm)

## Getting Started with Local Development

### OS

#### Linux
For Linux users, create a cluster directly [with minikube](#start-a-kubernetes-cluster-with-minikube).

#### MacOS
For MacOS user, this will only work with Intel x86. M1 is not supported.

Dependencies:
- Virtualbox - `brew install --cask virtualbox`
- Vagrant - `brew install --cask vagrant`

Spin up a Flintlock VM with the provided [Vagrantfile](Vagrantfile):

```
vagrant up
vagrant ssh
```

Note that the Firecracker VM requires about 8GB for a cluster of about 6GB.

### Start a Kubernetes cluster with minikube

```bash
# Create a minikube cluster

# Create a config repo
```

## Getting Started in a Cloud Environment

Use [Liquid Metal](https://github.com/weaveworks-liquidmetal) to create microVMs on an Equinix baremetal machine.

- [Set up Liquid Metal](https://github.com/weaveworks-liquidmetal/getting-started/blob/main/docs/intro.md#terraform-an-environment-on-equinix) with [this Terraform manifest](TODO)
- Set up a Kubernetes cluster using [CAPMVM](https://github.com/weaveworks-liquidmetal/getting-started/blob/main/docs/create.md)