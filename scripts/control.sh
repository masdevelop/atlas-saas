#!/bin/bash
#
# Setup for Control Plane (Master) servers
set -euxo pipefail

API_NET_IP=$1
POD_NET_CIDR=$2

NODENAME=$(hostname -s)
sudo kubeadm config images pull
echo "Preflight Check Passed: Downloaded All Required Images"

# Deploy kubernetes controlplane and first cluster
sudo kubeadm init --apiserver-advertise-address=$API_NET_IP --pod-network-cidr=$POD_NET_CIDR

# Copy config for cluster access
mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

# Save Configs to shared location
sudo cp -i /etc/kubernetes/admin.conf /tmp/admin.conf

# Generate join command for sharing
kubeadm token create --print-join-command >> /tmp/join.sh

# Install Calico Network Plugin
echo "Installing Calico"
curl https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml -O
kubectl apply -f calico.yaml

# Configure kube access for vagrant user
sudo -i -u vagrant bash << EOF
whoami
mkdir -p /home/vagrant/.kube
sudo cp -i /tmp/admin.conf /home/vagrant/.kube/config
sudo chown 1000:1000 /home/vagrant/.kube/config
EOF

# Install Metrics Server
echo "Installing Metrics Server"
kubectl apply -f https://raw.githubusercontent.com/techiescamp/kubeadm-scripts/main/manifests/metrics-server.yaml

#######################
# Setup lab admin user#
####################### 
mkdir -p /home/vagrant/user_certs
cd /home/vagrant/user_certs
openssl genrsa -out atlas-cluster-admin.key 2048
openssl req -new -key atlas-cluster-admin.key -out atlas-cluster-admin.csr -subj "/CN=atlas-cluster-admin/O=Atlas"
BASE64_CSR=$(cat atlas-cluster-admin.csr | base64 | tr -d '\n')
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: atlas-cluster-admin
spec:
  request: $BASE64_CSR
  signerName: kubernetes.io/kubelet-apiserver-client
  usages:
  - digital signature
  - key encipherment
  - client auth
EOF
kubectl get csr
kubectl certificate approve atlas-cluster-admin
kubectl get csr atlas-cluster-admin -o jsonpath='{.spec.request}' | base64 --decode > atlas-cluster-admin.crt