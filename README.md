# k3s-virtualbox-cluster-bootstraper
This project makes it very easy to create single- and multi-node k3s clusters in VirtualBox, e.g. for local development on Kubernetes.

My inspirations for this project:
- [k3d](https://github.com/k3d-io/k3d) (the idea is pretty similar, but it uses containers which are much more lightweight compared to virtual machines)
- [khuedoan/homelab](https://github.com/khuedoan/homelab) (uses physical servers as nodes)


# Usage
- Clone this repository
- Replace `default_interface` in `Vagrantfile` with the name of your host's main network interface  
- Edit `inventory.yml`. Most certainly you will have to adjust IPs to match your home network subnet. You can also change the number of nodes
```yaml
all:
  children:
    masters:
      hosts:
        master0:
          ansible_host: 192.168.100.200
          memory: 1024
          cpu: 1
    workers:
      hosts:
        worker0:
          ansible_host: 192.168.100.201
          memory: 1024
          cpu: 1
        worker1:
          ansible_host: 192.168.100.202
          memory: 1024
          cpu: 1
```
- Linux
    - Install docker, VirtualBox, vagrant, ansible
- Windows 🤦‍♂️😂
    - Install VirtualBox
    - If you are on Windows, ansible won't work. Install Docker Desktop with [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install)
    - Create Ubuntu distribution: `wsl --install -d ubuntu`
    - Convert distribution to use WSL2: `wsl --set-version ubuntu 2`
    - Docker desktop → Settings → Resources → WSL integration → Enable integration for Ubuntu
    - Enter the machine `wsl -d Ubuntu`
    - Check if Docker integration is working: `docker run hello-world`
    - Install ansible
    - Install vagrant and configure it to work with VirtualBox that is installed on the host. Helpful resources:
        - [vagrant up – Running Vagrant under WSL2](https://thedatabaseme.de/2022/02/20/vagrant-up-running-vagrant-under-wsl2/)
        - [Vagrant and Windows Subsystem for Linux](https://www.vagrantup.com/docs/other/wsl)
- `ssh-keygen -C wsl2` - generate `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub` keys. Vagrant will append `id_rsa.pub` to `~/.ssh/authorized_keys` of each VM so that each VM will be accessible over SSH.
- `make` - this command will use Vagrant to create declared virtual machines and then provision them via Ansible
- after a few minutes, the cluster should be set up and in the current directory `kubeconfig` should be created
- install kubectl
- verify the cluster is running:

```bash
$ kubectl get nodes --kubeconfig=./kubeconfig
NAME      STATUS   ROLES                  AGE     VERSION
worker0   Ready    <none>                 4m19s   v1.25.0+k3s1
master0   Ready    control-plane,master   33m     v1.25.0+k3s1
worker1   Ready    <none>                 3m      v1.25.0+k3s1
```

```mermaid
flowchart LR
  M["make"]
  M -- vagrant up --> V
  M -- ansible-playbook site.yml --> A
  V -- create VMs --> VB
  A -- provision VMs --> VB
  
  subgraph Architecture Overview
    direction TB
    M
    subgraph V["Vagrant"]
        direction RL
        V1[Vagrantfile]
    end
    subgraph A["Ansible"]
        direction RL
        A1[site.yml playbook]
        A2[inventory.yml]
    end
    subgraph VB["[VirtualBox] Ubuntu Server VMs"]
        direction BT
        master0[master0 - 192.168.100.200]
        worker0[worker0 - 192.168.100.201]
        worker1[worker1 - 192.168.100.202]
    end
  end
```


# Tech stack

<table>
    <tr>
        <th>Logo</th>
        <th>Name</th>
        <th>Description</th>
    </tr>
    <tr>
        <td><img width="32" src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Tux.svg/84px-Tux.svg.png"></td>
        <td><a href="https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux">WSL2</a></td>
        <td>Windows Subsystem for Linux </td>
    </tr>
    <tr>
        <td><img width="32" src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Virtualbox_logo.png/121px-Virtualbox_logo.png"></td>
        <td><a href="https://www.virtualbox.org/">VirtualBox</a></td>
        <td>Virtualization</td>
    </tr>
    <tr>
        <td><img width="32" src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Vagrant.png/150px-Vagrant.png"></td>
        <td><a href="https://www.vagrantup.com/">Vagrant</a></td>
        <td>Automate VM creation in Virtualbox</td>
    </tr>
    <tr>
        <td><img width="32" src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Ansible_logo.svg/100px-Ansible_logo.svg.png"></td>
        <td><a href="https://www.ansible.com">Ansible</a></td>
        <td>Automate VM provisioning and configuration</td>
    </tr>
    <tr>
        <td><img width="32" src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Logo-ubuntu_cof-orange-hex.svg/2048px-Logo-ubuntu_cof-orange-hex.svg.png"></td>
        <td><a href="https://ubuntu.com/download/server">Ubuntu Server</a></td>
        <td>Base OS for VMs</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cncf-branding.netlify.app/img/projects/k3s/icon/color/k3s-icon-color.svg"></td>
        <td><a href="https://k3s.io">K3s</a></td>
        <td>Lightweight distribution of Kubernetes</td>
    </tr>
    <tr>
        <td><img width="32" src="https://github.com/alexellis/k3sup/raw/master/docs/assets/k3sup.png"></td>
        <td><a href="https://github.com/alexellis/k3sup">k3sup</a></td>
        <td>Bootstrap K3s over SSH</td>
    </tr>
    <tr>
        <td><img width="32" src="https://simpleicons.org/icons/diagramsdotnet.svg"></td>
        <td><a href="https://github.com/mermaid-js/mermaid">mermaid</a></td>
        <td>JavaScript-based diagramming and charting tool</td>
    </tr>
    <!-- <tr>
        <td><img width="32" src="https://cncf-branding.netlify.app/img/projects/helm/icon/color/helm-icon-color.svg"></td>
        <td><a href="https://helm.sh">Helm</a></td>
        <td>The package manager for Kubernetes</td>
    </tr>
    <tr>
        <td><img width="32" src="https://avatars.githubusercontent.com/u/60239468?s=200&v=4"></td>
        <td><a href="https://metallb.org">MetalLB</a></td>
        <td>Bare metal load-balancer for Kubernetes</td>
    </tr>
    <tr>
        <td><img width="32" src="https://avatars.githubusercontent.com/u/1412239?s=200&v=4"></td>
        <td><a href="https://www.nginx.com">NGINX</a></td>
        <td>Kubernetes Ingress Controller</td>
    </tr> -->
</table>