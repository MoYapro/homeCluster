Goal
===

Create infrastructure to run local services in a kubernetes cluster and to create documentation / automation to recreate all of it.


TODOs
===

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

- Reboot

- Install kubeadm (which includes kubectl)

echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list && cat /etc/apt/sources.list.d/kubernetes.list
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

apt update
apt install -y kubelet kubeadm kubectl
# hold - kubeadm is used to upgrade
apt-mark hold kubelet kubeadm kubectl

echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' >> /etc/apt/sources.list.d/kubernetes.list && cat /etc/apt/sources.list.d/kubernetes.list
- Install a kubernetes master node

kubeadm config images pull 
kubeadm init --token-ttl=0 --apiserver-advertise-address=0.0.0.0 --pod-network-cidr=10.244.0.0/16

=============== WORKS UP UNTIL HERE ====================

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

use kubeadm token list to display the join token





- Install at least one kubernetes worker node
- Dynamic DNS refresher (DuckDNS)
- Generate Let's Entrypt Certificates
- Deploy Ingress Reverse Proxy
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
