#!/bin/bash
#
# Setup for Node servers

set -euxo pipefail

sudo /bin/bash /tmp/join.sh -v

sudo -i -u vagrant bash << EOF
whoami
mkdir -p /home/vagrant/.kube
sudo cp -i /tmp/atlas-cluster-admin-config /home/vagrant/.kube/config
sudo chown 1000:1000 /home/vagrant/.kube/config
NODENAME=$(hostname -s)
kubectl label node $(hostname -s) node-role.kubernetes.io/worker=worker
EOF
