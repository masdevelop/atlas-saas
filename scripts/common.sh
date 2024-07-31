#!/bin/bash
#
# Common setup for all servers (Control Plane and Nodes)

set -euxo pipefail

# Variable Declaration

# DNS Setting
if [ ! -d /etc/systemd/resolved.conf.d ]; then
	sudo mkdir /etc/systemd/resolved.conf.d/
fi
cat <<EOF | sudo tee /etc/systemd/resolved.conf.d/dns_servers.conf
[Resolve]
DNS=8.8.8.8,1.1.1.1
EOF

sudo systemctl restart systemd-resolved

# disable swap
sudo swapoff -a

# keeps the swaf off during reboot
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true
sudo apt-get update -y


# Create the .conf file to load the modules at bootup
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

## Install CRIO Runtime

sudo apt-get update -y
sudo apt-get install -y software-properties-common curl apt-transport-https ca-certificates

sudo curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/Release.key |
    sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/cri-o-apt-keyring.gpg
sudo echo "deb [signed-by=/etc/apt/trusted.gpg.d/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/ /" |
    sudo tee /etc/apt/sources.list.d/cri-o.list

sudo apt-get update -y
sudo apt-get install -y cri-o

# Add the cgroup_manager setting to use systemd
sudo sed -i '/\[crio.runtime\]/a cgroup_manager = "systemd"' /etc/crio/crio.conf.d/10-crio.conf

sudo systemctl daemon-reload
sudo systemctl enable crio --now
sudo systemctl start crio.service

echo "CRI runtime installed successfully"

######## K8s prep

sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/kubernetes-apt-keyring.gpg
sudo echo 'deb [signed-by=/etc/apt/trusted.gpg.d/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubelet kubectl kubeadm
sudo apt-get install -y jq

# Disable auto-update services
sudo apt-mark hold kubelet kubectl kubeadm cri-o

# Double down on netplan
cd /etc/netplan
sudo netplan apply

local_ip="$(ip --json a s | jq -r '.[] | if .ifname == "enp0s17" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"
sudo tee /etc/default/kubelet > /dev/null << EOF
KUBELET_EXTRA_ARGS=--node-ip=$local_ip
EOF