# Atlas SaaS Project
## Michael Sanchez

This project demonstrates how to use Terraform and the VirtualBox provider to deploy a Kubernetes cluster running on VirtualBox VMs. It is designed to create a local development environment for learning purposes, using the following tech stack:

### Tech Stack
- **Terraform** for infrastructure as code management.
- **Kubernetes** for container orchestration.
- **Vagrant** for the underlying virtual disk (vbox).
- **Cloud-init** used to configure changes at boot.

### Installed Requirements
- `cloud-utils`
- `curl`
- `terraform`
- `virtualbox`

### Virtual Machine Info
- **OS**: Ubuntu 18.04
- **Network If1**: NAT - Internet access
- **Network If2**: Host-only - Cluster node network

### Cluster Configuration Info
- **ControlPlane**: 192.168.56.10
- **Worker1**: 192.168.56.11
- **Worker2**: 192.168.56.12

### Infrastructure as Code (IaC) - Terraform
- **Path**: `tf_live`
  - **Modules**
    - **Buildiso**: Launches the build of cloud-init ISOs used in place of user_data, curls the OS Vagrant/VirtualBox `.box` image.
    - **Virtualbox**: Launches the VMs using the VirtualBox provider.
    - **Kubernetes**: Launches configurations and initializes the cluster.

### Folders
- **atlas-saas:**
  - **certs:** Future use to distribute CRT.
  - **files:** Cloud-init user_data.
  - **oslib:** ISO / VBox location.
  - **scripts:** Used by Terraform to deploy. Includes a cleanup file for fixes.
  - **tf_live:** IaC location.

### How To
1. `cd tf_live`
2. `terraform init`
3. `terraform plan`
4. `terraform apply`


### ToDo
Need to consolidate vars.  Create tfvars file and move all values there.  

### References
- **Terraform VirtualBox Provider**: [Terraform VirtualBox Provider Documentation](https://registry.terraform.io/providers/terra-farm/virtualbox/latest/docs)
- **Bug**: Cannot mount user_data, must use ISO mount under optical drive mount - [GitHub Issue #150](https://github.com/terra-farm/terraform-provider-virtualbox/issues/150)
- **Source Vagrant Project**: [Vagrant Kubeadm Kubernetes](https://github.com/techiescamp/vagrant-kubeadm-kubernetes)
