## Debian Buster Cloud Image base for Proxmox

### Export VM variables

```bash
export VMID=
export VMNAME=debian-10
export VMMACHINE=q35
export VMMEMORY=1024
export VMNET0=virtio,bridge=vmbr0
export PROXMOXSTRG=local
export OUTPUTDIR=/var/lib/vz/template/iso
export OUTPUTFILE=debian-10-generic-amd64-daily-20221019-1173.qcow2
export CLOUDIMGURL=https://cloud.debian.org/images/cloud/buster/daily/20221019-1173/debian-10-generic-amd64-daily-20221019-1173.qcow2
export CLOUDINITDIR=/var/lib/vz/snippets
export CLOUDINITFILE=vendor-debian-10.yaml
export CLOUDINITURL=https://raw.githubusercontent.com/Script47ph/Linux-Docs/main/Linux/Setup/Debian/Private-Cloud/Proxmox-Virtual-Environment/cloud-init/debian-10/vendor-debian-10.yml
```

### Download the latest cloud image

```bash
wget -O ${OUTPUTDIR}/${OUTPUTFILE} ${CLOUDIMGURL}
```

### Create a new VM

```bash
qm create ${VMID} --name ${VMNAME} --machine ${VMMACHINE} --memory ${VMMEMORY} --net0 ${VMNET0}
```

### Import the cloud image

```bash
qm importdisk ${VMID} ${OUTPUTDIR}/${OUTPUTFILE} ${PROXMOXSTRG}
```

### Attach the cloud image to the VM

```bash
qm set ${VMID} --scsihw virtio-scsi-pci --scsi0 ${PROXMOXSTRG}:${VMID}/vm-${VMID}-disk-0.raw
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