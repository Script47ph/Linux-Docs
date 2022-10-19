## Rockylinux 9 Cloud Image base for Proxmox

### Download the latest cloud image

```bash
wget -o /var/lib/vz/template/iso/Rocky-9-GenericCloud.latest.x86_64.qcow2 https://download.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2
```

### Create a new VM

```bash
qm create vmid --name Rocky-9 --machine q35 --memory 1024 --net0 virtio,bridge=vmbr0
```

### Import the cloud image

```bash
qm importdisk vmid /var/lib/vz/template/iso/Rocky-9-GenericCloud.latest.x86_64.qcow2 local
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
wget -o /var/lib/vz/snippets/vendor-rhel-9-based.yaml https://raw.githubusercontent.com/Script47ph/Linux-Docs/main/Linux/Setup/Debian/Private-Cloud/Proxmox-Virtual-Environment/cloud-init/rhel-based/vendor-rhel-9-based.yml
```

### Attach the custom cloud-init configuration to the VM

```bash
qm set vmid --cicustom "vendor=local:snippets/vendor-rhel-9-based.yaml"
```

### Set as template

```bash
qm template vmid
```