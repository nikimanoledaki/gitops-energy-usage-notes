## Energy Consumption Research
## Comparing snowflake Kubernetes cluster with Flux-based GitOps clusters

## Aims
- Setting up a reference architecture for how to measure energy consumption
- What is the environmental impact of GitOps?
- Measure energy consumption of Kubernetes components and architectures using cloud-native tools

## Resources

Some of the technologies, tools, and patterns mentioned in this project:
- [eksctl](https://github.com/weaveworks/eksctl)
- [Flux Garbage Collection](https://fluxcd.io/legacy/flux/references/garbagecollection/)
- [Kepler](https://github.com/sustainable-computing-io/kepler)
- [Vagrant with KVM](https://dev.to/vumdao/create-an-ubuntu-20-04-server-using-vagrant-3d2i)
- [KVM installation on Ubuntu](https://help.ubuntu.com/community/KVM/Installation)
- [Minikube with KVM](https://minikube.sigs.k8s.io/docs/drivers/kvm2/)
- [EC2 instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html)

### Local Development

### Linux
If using Linux, KVM can most likely be installed directly - I think? I have not verified this. Help would be appreciated!
So, if using Linux, no need to create VM1 - skip directly to step to [install KVM](#install-kvm).

### MacOS
If using a Mac (x86 Intel CPU only, M1 is not supported), unfortunately, nested VMs are a must.

Steps to follow:
- Install Virtualbox for your OS
- Install Vagrant
- Configure a Vagrantfile (see example [Vagrantfile](TODO))

```
vagrant up
vagrant ssh
```

#### Install KVM
Then, run [this](TODO) script in the first VM (VM1) (in Development) to setup KVM.
In Production (Liquid Metal or AWS) this would be a new Ubuntu machine.

From the Linux VM1, the next step is to provision a Linux-based Kernel VM (KVM) as a second VM (VM2).

This creates two nested VMs. Virtualbox, which is hosting the second VM, must be enabled to allow nesting VMs.

In a cloud environment, VM1 represents the host machine or baremetal infrastrcture.
It could be an EC2 instance in AWS, which is itself a VM. This is more likely to work on a baremetal one in theory.
I have not successfully tested if it works, or if it works on a regular EC2 instance or if it works at all.

Or, it could be on Liquid Metal (a Flintlock microVM). The latter would be hosted on Equinix baremetal machines.
The advantage of self-hosting in a co-located Data Centre (DC) such as what is offered by Equinix is
the benefit from data center economies of scale. This may lead to optimisations on Scope 1 direct emissions.

This could be part of a Lifecycle Assessment of a piece of software architecture in a cloud environment to
determine its energy usage in various scenarios and use cases. Perhaps estimations for carbon emissions could be done as well.
However, the focus here is on energy usage rather than localization and grid system estimates.

It could be possible, however, to start from energy usage and combine this with carbon emissions estimations.
Energy coefficients would have to determine how to deduce Marginal Carbon Emissions from CPU-based, Pod-based, energy metrics
based on the cloud provider, their infrastructure, the region these are running in, and access to accurate and timely
grid energy usage reporting. Cloud hyperscalers are not prepared to do that - some quote security issues.

### Getting started with local development

```shell
This is a script to run in a new  VM1 (Development) or Ubuntu machine (Production) to provision KVM.

Do not try this at home if your dev computer is a laptop unless it is cold and you are trying to warm up your hands.

// (optional) Check kvm support if needed. Error was solved by configuring the Vagrant file to request that Virtualbox allows nested VMs.
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
minikube start --driver=kvm2
```
