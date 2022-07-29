#!/bin/bash
echo "--------------------------------------------------------------------------[ Bootstrap setup ]"
set -euxo pipefail
echo "--------------------------------------------------------------------------[ Server update ]"
sudo apt-get update -y
echo "--------------------------------------------------------------------------[ Disable swap ]"
sudo swapoff -a
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
echo "--------------------------------------------------------------------------[ Enable modules at boot ]"
sudo modprobe overlay
sudo modprobe br_netfilter
echo "--------------------------------------------------------------------------[ Configure sysctl ]"
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system
echo "--------------------------------------------------------------------------[ Update kubernetes repo ]"
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
echo "--------------------------------------------------------------------------[ Update packages ]"
sudo apt-get update -y
echo "--------------------------------------------------------------------------[ Reload services ]"
sudo systemctl daemon-reload
echo "--------------------------------------------------------------------------[ Install dependencies ]"
sudo apt-get install -y apt-transport-https ca-certificates curl docker.io jq net-tools
sudo sed -i -e 's/#DNS=/DNS=8.8.8.8/' /etc/systemd/resolved.conf
sudo apt-get install -y kubelet kubectl kubeadm
sudo apt-mark hold kubelet kubeadm kubectl
echo "--------------------------------------------------------------------------[ Set IP in kubelet ]"
local_ip="$(ip --json a s | jq -r '.[] | if .ifname == "eth1" then .addr_info[] | if .family == "inet" then .local else empty end else if .ifname == "enp0s3" then .addr_info[] | if .family == "inet" then .local else empty end else empty end end')"
cat > /etc/default/kubelet << EOF
KUBELET_EXTRA_ARGS=--node-ip=$local_ip
EOF