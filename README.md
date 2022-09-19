## Energy-efficient Kubernetes on baremetal

Case Study: Comparing the energy consumption of snowflake clusters and Flux-based GitOps clusters.

## Aims
- Set up a reference architecture for how to measure energy consumption in cloud-native processes using cloud-native tools.
- Answer the question: What is the environmental impact of GitOps?

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
If using Linux, a cluster can be created directly - have not verified this yet, help would be appreciated!

Skip to the step to [start a Kubernetes cluster with minikube](#start-a-kubernetes-cluster-with-minikube).

#### MacOS
If using a Mac, here is how to use nested VMs.

Note: this is for Intel x86 only. M1 is not supported.

Dependencies:
- Virtualbox - `brew install --cask virtualbox`
- Vagrant - `brew install --cask vagrant`

Spin up a Flintlock VM with the provided [Vagrantfile](Vagrantfile):

```
vagrant up
vagrant ssh
```

### Start a Kubernetes cluster with minikube

```
./scripts/start-cluster.sh
```

### Install Kepler

What is [Kepler](https://github.com/sustainable-computing-io/kepler)?
> Kepler (Kubernetes-based Efficient Power Level Exporter) uses eBPF to probe energy related system stats and exports as Prometheus metrics

It can help us get energy consumption metrics from a cluster.

Kepler requirements as outlined [here](https://github.com/sustainable-computing-io/kepler/tree/main/manifests#prerequisites):
- Support for cgroup v2
- Support for kernel-devel extensions
- Provide the kernel headers (required by eBPF)
- Kernel with eBPF support

For example, [Kepler on Openshift](https://github.com/sustainable-computing-io/kepler/tree/main/manifests#kepler-on-openshift) has already been integrated and works. This integration can be used as an example of what configuration is needed, e.g.:
```
  kernelArguments:
    - systemd.unified_cgroup_hierarchy=1
    - cgroup_no_v1="all"
  extensions:
  - kernel-devel
```

### Install Prometheus & Grafana on the cluster

Install Prometheus & Grafana using the [Makefile](Makefile):
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

### Methodology

In a cloud environment, VM1 represents the host machine or baremetal infrastrcture.
This could, in theory, be an EC2 instance in AWS (which is itself a VM). Testing on a regular EC2 instance has not been successful yet.

Alternatively, it could be done using Liquid Metal on a Flintlock microVM hosted on a Equinix baremetal machine.

Self-hosting in a co-located Data Centre (DC) such as Equinix adds the the benefit from data center economies of scale that
may lead to optimisations on Scope 1 direct emissions.

The aim of this is to be able to do a Lifecycle Assessment of a piece of software architecture in a cloud environment to
determine its energy usage in various scenarios and use cases. 

Estimations for carbon emissions could follow this. However, the focus here is on energy usage rather than localized grid system estimates.

Metrics on energy usage could be combined with carbon emissions estimates.
Energy coefficients would deduce Marginal Carbon Emissions from these CPU-based, Pod-based, energy metrics.
The energy coefficients would be based on the cloud provider, their infrastructure, the region these are running in, etc. 
This would require access to accurate and timely grid energy usage reporting. Cloud providers are not yet prepared to do this however due to security-related concerns.
