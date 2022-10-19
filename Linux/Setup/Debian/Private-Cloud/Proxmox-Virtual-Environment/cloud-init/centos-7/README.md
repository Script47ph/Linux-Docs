## Centos 7 Cloud Image base for Proxmox

### Download the latest cloud image

```bash
wget -o /var/lib/vz/template/iso/CentOS-7-x86_64-GenericCloud-2111.qcow2 https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-2111.qcow2
```

### Create a new VM

```bash
qm create vmid --name Centos-7 --machine q35 --memory 1024 --net0 virtio,bridge=vmbr0
```

### Import the cloud image

```bash
qm importdisk vmid /var/lib/vz/template/iso/CentOS-7-x86_64-GenericCloud-2111.qcow2 local
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
wget -o /var/lib/vz/snippets/vendor-centos-7.yaml https://raw.githubusercontent.com/Script47ph/Linux-Docs/main/Linux/Setup/Debian/Private-Cloud/Proxmox-Virtual-Environment/cloud-init/centos-7/vendor-centos-7.yml
```

### Attach the custom cloud-init configuration to the VM

```bash
qm set vmid --cicustom "vendor=local:snippets/vendor-centos-7.yaml"
```

### Set as template

```bash
qm template vmid
```