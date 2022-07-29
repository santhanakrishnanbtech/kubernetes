#!/usr/bin/env bash
echo "--------------------------------------------------------------------------[ Setup Worker nodes ]"
set -euxo pipefail
/bin/bash /vagrant/configs/join.sh -v
echo "--------------------------------------------------------------------------[ Configuring kubectl for vagrant user]"
sudo -i -u vagrant bash << EOF
mkdir -p /home/vagrant/.kube
sudo cp -i /vagrant/configs/config /home/vagrant/.kube/
sudo chown vagrant:vagrant /home/vagrant/.kube/config
kubectl label node $(hostname -s) node-role.kubernetes.io/worker=worker
EOF
echo "--------------------------------------------------------------------------[ Worker deployed ]"