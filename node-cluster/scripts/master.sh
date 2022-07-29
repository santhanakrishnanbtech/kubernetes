#!/usr/bin/env bash
echo "--------------------------------------------------------------------------[ Master Control Plane setup ]"
set -euxo pipefail
echo "--------------------------------------------------------------------------[ Variables ]"
MASTER_IP="10.0.0.10"
NODENAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"
echo "--------------------------------------------------------------------------[ Enable kubelet ]"
sudo systemctl enable kubelet
echo "--------------------------------------------------------------------------[ Pulling required images ]"
sudo kubeadm config images pull
echo "Preflight Check Passed: Downloaded All Required Images"
sudo kubeadm init --apiserver-advertise-address=$MASTER_IP --apiserver-cert-extra-sans=$MASTER_IP --pod-network-cidr=$POD_CIDR --node-name "$NODENAME" --ignore-preflight-errors Swap --ignore-preflight-errors=NumCPU
echo "--------------------------------------------------------------------------[ Configure kubectl for root user ]"
mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config
echo "--------------------------------------------------------------------------[ Backup configs to /vagrant shared folder ]"
echo "--------------------------------------------------------------------------[ Deleting existing configurations ]"
config_path="/vagrant/configs"
if [ -d $config_path ]; then
  rm -f $config_path/*
else
  mkdir -p $config_path
fi
echo "--------------------------------------------------------------------------[ Storing worker configurations ]"
cp -i /etc/kubernetes/admin.conf /vagrant/configs/config
touch /vagrant/configs/join.sh
chmod +x /vagrant/configs/join.sh
kubeadm token create --print-join-command > /vagrant/configs/join.sh
echo "--------------------------------------------------------------------------[ Installing Calico Network Plugin ]"
curl https://docs.projectcalico.org/manifests/calico.yaml -O
kubectl apply -f calico.yaml
echo "--------------------------------------------------------------------------[ Configure kubectl for vagrant user]"
sudo -i -u vagrant bash << EOF
whoami
mkdir -p /home/vagrant/.kube
sudo cp -i /vagrant/configs/config /home/vagrant/.kube/
sudo chown vagrant:vagrant /home/vagrant/.kube/config
EOF
echo "--------------------------------------------------------------------------[ Master deployed ]"