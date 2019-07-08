Goal
===

Create infrastructure to run local services in a kubernetes cluster and to create documentation / automation to recreate all of it.

Disclaimer
---

This is only for my personal pleasure. Feel free to use at your own risk.


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


✔ Create namespace for home assistant - just deployed it
✔ Dynamic DNS refresher (DuckDNS) - deployed cron job with token as secret
- Generate Let's Entrypt Certificates
- Deploy Ingress Reverse Proxy (Traefik?)
- Create Port forwarding for 443 (possibly 80)
- Create Endpoint reachable from Internet 
- Create Endpoint reachable only from LAN
- Create store for secrets (certificates, api-keys, etc)
- Create deployment for HomeAssistant
- Create config for HomeAssistant in a configMap
- Create deployment for NodeRed
- Create config for NodeRead in configMap
- Find out how to save changes from NodeRed in Backup
- Find out how to restore backup of NodeRed data
- Create deployment for PiHole
- Create configMap for PiHole
