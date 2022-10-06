## Cloud Image base on Proxmox


### Download the latest cloud image

First, download the latest cloud image distribution from any where you want. I prefer to download it from the official website of the distribution. For example, I will download the latest Ubuntu cloud image from the official website of Ubuntu.

```bash
wget https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img 
```

### Create a new VM

Create a new VM with the downloaded cloud image. You can use the web interface or the command line interface. For example, I will use the command line interface to create a new VM.

Example:

```bash
qm create 1000 --name cloud-image --memory 1024 --net0 virtio,bridge=vmbr0
```

### Import the cloud image

Import/convert the downloaded cloud image as storage for the new VM.

```bash
qm importdisk 1000 bionic-server-cloudimg-amd64.img local-lvm
```

### Attach the cloud image to the VM

Attach/change the vm storage to the imported cloud image.

```bash
qm set 1000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-1000-disk-0
```

### Add a cloud-init drive

Add a cloud-init drive to the VM. This drive will be used to configure the VM during the first boot.

```bash
qm set 1000 --ide2 local-lvm:cloudinit
```

### Set the VM to boot from the cloud image

```bash
qm set 1000 --boot c --bootdisk scsi0
```

### Set as template

```bash
qm template 1000
```

### Deploying Cloud-Init Templates

Now you can deploy the template as a new VM. You can use the web interface or the command line interface. For example, I will use the command line interface to deploy a new VM.

Example:

```bash
qm clone 1000 456 --name cloud-image-test
```

### Custom cloud-init configuration

Create cloud-init configuration:

```bash
cat <<EOF >> ~/cloud-init.yml
packages_update: true
packages_upgrade: true
packages:
  - qemu-guest-agent
runcmd:
  - [ systemctl, daemon-reload ]
  - [ systemctl, enable, qemu-guest-agent.service ]
  - [ systemctl, start, --no-block, qemu-guest-agent.service ]
EOF
```

```bash
qm set 456 --cicustom "user=ubuntu:password=ubuntu:~/cloud-init.yml"
```