Goal
===

Create infrastructure to run local services in a kubernetes cluster and to create documentation / automation to recreate all of it.


TODOs
===

Install Raspbian light on all SD cards
---

Insert your SD card into your computer.
Locate the device, by running sudo fdisk -l. It will probably be the only disk about the right size. Note down the device name; let us suppose it is /dev/sdx. If you are in any doubt, remove the card, run sudo fdisk -l again and note down what disks are there. Insert the SD card again, run sudo fdisk -l and it is the new disk.
Unmount the partitions by running sudo umount /dev/sdx*. It may give an error saying the disk isn't mounted - that's fine.
Copy the contents of the image file onto the SD card by running
Of course, you'll need to change the name of the image file above as appropriate.
sudo dd bs=1M if=your_image_file_name.img of=/dev/sdx

Connect hdmi and keyboard to the pis and run raspi-config to enable ssh and set hostname

Configure a static ip address by editing /etc/dhcpcd.conf. At the end there is an example config for the static address. 


- Update system

apt update && apt upgrade

- Install git

apt instal git

- Install docker

curl -sSL get.docker.com | sh && \
usermod pi -aG docker && \
newgrp docker

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

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker

- Install kubeadm (which includes kubectl)

Swap need to be disabled
dphys-swapfile swapoff && \
dphys-swapfile uninstall && \
update-rc.d dphys-swapfile remove

Add 'deb http://apt.kubernetes.io/ kubernetes-xenial main' to /etc/apt/sources.list.d/kubernetes.list and download key with:
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

apt-get update
apt-get install -qy kubeadm

- Install a kubernetes master node

kubeadm config images pull -v3
kubeadm init --token-ttl=0
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
