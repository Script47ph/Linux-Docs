## Proxmox Cloud Init Configuration

### Add a cloud-init drive

Add a cloud-init drive to the VM. This drive will be used to configure the VM during the first boot.

```bash
qm set <vmid> --ide2 <your-storage>:cloudinit
```