## Almalinux 9 Cloud Image base for Proxmox

### Export VM variables

```bash
export VMID=
export VMNAME=AlmaLinux-9
export VMMACHINE=q35
export VMHOST=host
export VMMEMORY=1024
export VMNET0=virtio,bridge=vmbr0
export PROXMOXSTRG=
export OUTPUTDIR=/var/lib/vz/template/iso
export OUTPUTFILE=AlmaLinux-9-GenericCloud-latest.x86_64.qcow2
export OUTPUTFORMAT="--format qcow2"
export CLOUDIMGURL=https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2
export CLOUDINITDIR=/var/lib/vz/snippets
export CLOUDINITFILE=vendor-rhel-9-based.yaml
export CLOUDINITURL=https://raw.githubusercontent.com/Script47ph/Linux-Docs/main/Linux/Setup/Debian/Private-Cloud/Proxmox-Virtual-Environment/cloud-init/rhel-based/vendor-rhel-9-based.yml
```

### Download the latest cloud image

```bash
wget -O ${OUTPUTDIR}/${OUTPUTFILE} ${CLOUDIMGURL}
```

### Create a new VM

```bash
qm create ${VMID} --name ${VMNAME} --machine ${VMMACHINE} --memory ${VMMEMORY} --net0 ${VMNET0} --cpu ${VMHOST}
```

### Import the cloud image

```bash
qm importdisk ${VMID} ${OUTPUTDIR}/${OUTPUTFILE} ${PROXMOXSTRG} ${OUTPUTFORMAT}
```

### Attach the cloud image to the VM

```bash
qm set ${VMID} --scsihw virtio-scsi-pci --scsi0 ${PROXMOXSTRG}:${VMID}/vm-${VMID}-disk-0.qcow2
```

### Add a cloud-init drive

```bash
qm set ${VMID} --ide2 ${PROXMOXSTRG}:cloudinit
```

### Set the VM to boot from the cloud image

```bash
qm set ${VMID} --boot c --bootdisk scsi0
```

### Set serial console

```bash
qm set ${VMID} --serial0 socket --vga serial0
```

### Get custom cloud-init configuration

```bash
wget -O ${CLOUDINITDIR}/${CLOUDINITFILE} ${CLOUDINITURL}
```

### Attach the custom cloud-init configuration to the VM

```bash
qm set ${VMID} --cicustom "vendor=${PROXMOXSTRG}:snippets/${CLOUDINITFILE}"
```

### Set as template

```bash
qm template ${VMID}
```