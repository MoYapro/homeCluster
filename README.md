Goal
===

Create infrastructure to run local services in a kubernetes cluster and to create documentation / automation to recreate all of it.

Disclaimer
---

This is only for my personal pleasure. Feel free to use at your own risk.

Structure
---
This file describes how to set up the cluster and maintains a todo-list of stuff I'd like to realise. 
In the installments directory are all application configurations each in a separate folder. To deploy one of the applications on your cluster do

`kubectl apply -f ./installments/[application]`



Install Hypriot on all SD cards
---

Insert your SD card into your computer.
Locate the device, by running sudo fdisk -l. It will probably be the only disk about the right size. Note down the device name; let us suppose it is /dev/sdx. If you are in any doubt, remove the card, run sudo fdisk -l again and note down what disks are there. Insert the SD card again, run sudo fdisk -l and it is the new disk.
Unmount the partitions by running sudo umount /dev/sdx*. It may give an error saying the disk isn't mounted - that's fine.
Copy the contents of the image file onto the SD card by running
Of course, you'll need to change the name of the image file above as appropriate.
sudo dd bs=1M if=your_image_file_name.img of=/dev/sdx

default username: pirate
default password: hypriot

Configure a static ip address by editing /etc/dhcpcd.conf. At the end there is an example config for the static address. 
changehostname by editing /boot/user-data and /etc/hostname

- Update system

apt update && apt upgrade -y

###### update docker daemon to use systemd as cgroup driver
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF


- Reboot

# Install kubeadm (which includes kubectl)

echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list && cat /etc/apt/sources.list.d/kubernetes.list
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

apt update
apt install -y kubelet kubeadm kubectl
###### hold - kubeadm is used to upgrade
apt-mark hold kubelet kubeadm kubectl

# Install a kubernetes master node

kubeadm config images pull 
kubeadm init --token-ttl=0 --apiserver-advertise-address=0.0.0.0 --pod-network-cidr=10.244.0.0/16

exit root and continue as default user

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

- Install a pod network
kubectl apply -f installment/kube-flannel.yaml

use kubeadm token list to display the join token


- Install at least one kubernetes worker node
You can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.1.100:6443 --token ltn2dr.o4tav7d4isjb1t36 \
    --discovery-token-ca-cert-hash sha256:aa9d3d164ea11094f20cc9ac757818d870ebd56b9e4ca022e0c288975c92fbbf
    
###### to print the join command do to following on the master node
IPCLUSTER=192.168.1.100:6443;echo "kubeadm join --token $(kubeadm token list | sed '1d' | head -1| awk '{print $1}') $IPCLUSTER --discovery-token-ca-cert-hash sha256:$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | awk '{print $2}')"; unset IPCLUSTER
     


- ✔ Create store for secrets (certificates, api-keys, etc) - using git-secret
- ✔ Dynamic DNS refresher (DuckDNS) - deployed cron job with token as secret - installments/duckdns
- ✔ Deploy Ingress Reverse Proxy - installments/traefik
- ✔ Create deployment for HomeAssistant - installments/homeAssistant
- ✔ Create config for HomeAssistant in a configMap - installments/homeAssistant
- ✔ Create deployment for mqtt server - installments/mosquitto
- ✔ Create deployment for NodeRed - installments/node-red
- ✔ Create deployment for PiHole - installments/pihole (using daemonset to expose dns port 53)
- ✔ Setup memory limits for pods (as derived from values got by docker stats on nodes)
- ✔ Create configMap for PiHole (used to resolv all external cluster routes)
- ✔ Configure mqtt server in home assistant (using pod network and port 1883)
- ✔ Generate Let's Entrypt Certificates (by using traefik's feature to use lets encrypt)
- ✔ Find out how to save changes from NodeRed in Backup (settings and flows in configMaps - node_modules in nfs volume)
- ✔ Create Endpoint reachable from Internet (created router port forward to traefik) 
- ✔ Create Endpoint reachable only from LAN (kube system is not routed only traefik load balancer)
- ✔ Create Port forwarding to make home assistant api available for google cloud (to controll devices via assistant) (created ingress for external domain)
- use priority and preemption for most important services
- Update api versions of yaml files to use non beta version and no deprecated api
- Setup basic monitoring
- Use central logging service
- Create config for NodeRead in configMap
- Install git server (e.g. https://github.com/stevenaldinger/k8s-gogs/tree/master/k8s)
