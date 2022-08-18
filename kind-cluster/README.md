**:heart: Kindly support by giving :star:**
># Kubernetes KinD cluster setup using Vagrant and VirtualBox

### Points to note:
1. Keep a note on config.yml file used to bring KinD cluster up.\
[KinD configuration tutorial](https://kind.sigs.k8s.io)
2. Change RAM and vCPU in Vagrantfile based on your requirement.

### Requirements:
```shell
$ vagrant
$ virtualbox
```
Deploy vm's
```shell
$ vagrant up
```
To access the nodes
```shell
$ vagrant ssh master
$ vagrant ssh worker01
$ vagrant ssh worker02
```
Stop vm's gracefully
```shell
$ vagrant halt
```
Terminate cluster
```shell
$ vagrant destroy -f
```
For terminating a specific node
```shell
$ vagrant destroy <NODE_NAME>
```
If you want to view the workers joining.\
_(note: After master created_)
```shell
$ vagrant ssh master
$ watch -n2 kubectl get pods -A
$ watch -n2 kubectl get nodes
```
### KinD config
Example 01: Creating a shared folder connecting HOST and NODE containers
```shell
$ vagrant ssh kind
$ sudo mkdir /nas
```
config.yml
```json
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraMounts:
  - hostPath: /nas/
    containerPath: /share
    propagation: Bidirectional
- role: worker
  extraMounts:
  - hostPath: /nas/
    containerPath: /share
    propagation: Bidirectional
- role: worker
  extraMounts:
  - hostPath: /nas/
    containerPath: /share
    propagation: Bidirectional
```
Example 02: Exposing a specific port from KinD control-plane
config.yml
```json
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30000
    hostPort: 80
- role: worker
- role: worker
```