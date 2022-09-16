## Troubleshooting Common Issues

```
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
```
