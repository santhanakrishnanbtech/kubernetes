#!/usr/bin/env bash

echo "---------------------[ Update node ]-----------------------"
sudo apt -y update
echo "---------------------[ Install dependencies ]-----------------------"
sudo apt -y install docker.io curl vim wget
echo "---------------------[ Add user to docker group ]-----------------------"
sudo usermod -aG docker $USER
echo "---------------------[ Install KinD ]-----------------------"
sudo curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.12.0/kind-linux-amd64
sudo chmod +x kind
sudo mv kind /usr/bin/kind
echo "---------------------[ Install kubectl ]-----------------------"
sudo curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/bin/kubectl
echo "--------------------------------------------------------------------------[ Configure kubectl for vagrant user ]"
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config
echo "---------------------[ Cluster File ]-----------------------"
sudo tee ./config<<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
EOF
echo "---------------------[ Deploy Cluster ]-----------------------"
sudo kind create cluster --config config
echo "---------------------[ Read Nodes ]-----------------------"
kubectl get nodes
