## Proxmox Cloud Init Configuration

This guide is for provisioning vm's for the first time boot. Any kind of configuration user or network can be done using proxmox gui.

### Add a cloud-init drive

Add a cloud-init drive to the VM. This drive will be used to configure the VM during the first boot.

```bash
qm set <vmid> --ide2 <your-storage>:cloudinit
```

### Create cloud-init custom configuration

Create a file named `vendor-data.yml` at `/var/lib/vz/snippets/` and add like the following example:

```yaml
#cloud-config
packages_update: true
packages_upgrade: true
packages:
  - qemu-guest-agent
  - vim
  - htop
```

or you can use my custom configuration:

**Ubuntu Bionic**

```sh
wget https://raw.githubusercontent.com/Script47ph/Linux-Docs/main/Linux/Setup/Debian/Private-Cloud/Proxmox-Virtual-Environment/cloud-init/bionic/vendor-bionic.yml -O /var/lib/vz/snippets/vendor-data.yml
```

**Ubuntu Focal**

```sh
wget https://raw.githubusercontent.com/Script47ph/Linux-Docs/main/Linux/Setup/Debian/Private-Cloud/Proxmox-Virtual-Environment/cloud-init/focal/vendor-focal.yml -O /var/lib/vz/snippets/vendor-data.yml
```

**Ubuntu Jammy**

```sh
wget https://raw.githubusercontent.com/Script47ph/Linux-Docs/main/Linux/Setup/Debian/Private-Cloud/Proxmox-Virtual-Environment/cloud-init/jammy/vendor-jammy.yml -O /var/lib/vz/snippets/vendor-data.yml
```

### Apply cloud-init custom configuration to the VM

```bash
qm set <vmid> --cicustom "vendor=<storage>:snippets/vendor-data.yaml"
```