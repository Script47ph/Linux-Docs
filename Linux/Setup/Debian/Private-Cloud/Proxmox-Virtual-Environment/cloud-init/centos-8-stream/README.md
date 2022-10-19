## Centos 8 Stream Cloud Image base for Proxmox

### Download the latest cloud image

```bash
wget -O /var/lib/vz/template/iso/CentOS-Stream-GenericCloud-8-20220913.0.x86_64.qcow2 https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20220913.0.x86_64.qcow2
```

### Create a new VM

```bash
qm create vmid --name Centos-8-Stream --machine q35 --memory 1024 --net0 virtio,bridge=vmbr0
```

### Import the cloud image

```bash
qm importdisk vmid /var/lib/vz/template/iso/CentOS-Stream-GenericCloud-8-20220913.0.x86_64.qcow2 local
```

### Attach the cloud image to the VM

```bash
qm set vmid --scsihw virtio-scsi-pci --scsi0 local:vmid/vm-vmid-disk-0.raw
```

### Add a cloud-init drive

```bash
qm set vmid --ide2 local:cloudinit
```

### Set the VM to boot from the cloud image

```bash
qm set vmid --boot c --bootdisk scsi0
```

### Set serial console

```bash
qm set vmid --serial0 socket --vga serial0
```

### Get custom cloud-init configuration

```bash
wget -O /var/lib/vz/snippets/vendor-centos-8-stream.yaml https://raw.githubusercontent.com/Script47ph/Linux-Docs/main/Linux/Setup/Debian/Private-Cloud/Proxmox-Virtual-Environment/cloud-init/centos-8-stream/vendor-centos-8-stream.yml
```

### Attach the custom cloud-init configuration to the VM

```bash
qm set vmid --cicustom "vendor=local:snippets/vendor-centos-8-stream.yaml"
```

### Set as template

```bash
qm template vmid
```