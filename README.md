## Energy Consumption: Comparing snowflake Kubernetes cluster with Flux-based GitOps clusters

## Aims
- Setting up a reference architecture for how to measure energy consumption
- What is the environmental impact of GitOps?
- Measure energy consumption of Kubernetes components and architectures using cloud-native tools
- Potentially create a reference architecture for how to measure cloud native processes with cloud native tools

## Resources

Some of the technologies, tools, and patterns mentioned in this project:
- [eksctl](https://github.com/weaveworks/eksctl)
- [Flux Garbage Collection](https://fluxcd.io/legacy/flux/references/garbagecollection/)
- [Kepler](https://github.com/sustainable-computing-io/kepler)
- [Vagrant with KVM](https://dev.to/vumdao/create-an-ubuntu-20-04-server-using-vagrant-3d2i)
- [KVM installation on Ubuntu](https://help.ubuntu.com/community/KVM/Installation)
- [Minikube with KVM](https://minikube.sigs.k8s.io/docs/drivers/kvm2/)
- [EC2 instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html)

## Getting Started with Local Development

### OS

#### Linux
If using Linux, KVM can most likely be installed directly - I think? I have not verified this. Help would be appreciated!
So, if using Linux, no need to create VM1 - skip directly to step to [install KVM](#install-kvm).

#### MacOS
If using a Mac (x86 Intel CPU only, M1 is not supported), unfortunately, nested VMs are a must.

Steps to follow:
- Install Virtualbox for your OS
- Install Vagrant
- Configure a Vagrantfile (see example [Vagrantfile](./build/dev/Vagrantfile))

```
vagrant up
vagrant ssh
```

### Install KVM & start a Kubernetes cluster with minikube
Then, run [this](./scripts/install-kvm.sh) script in the first VM (VM1) (in Development) to setup KVM.
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

### Install Kepler, Prometheus & Grafana on the cluster
```
// All of these should be made GitOps-able with Flux and Helm and/or Terraform.
// They should then be added to the repo in ./clusters for Flux to pick them up.

// Install all dependencies
make-dependencies

OR

// Install Kepler as a Daemonset
make kepler

// Start Prometheus to receive data from Kepler and send it to Grafana
make prometheus

// Visualise energy CPU metrics
make grafana
```

