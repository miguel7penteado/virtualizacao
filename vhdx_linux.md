
[https://openwrt.org/docs/guide-user/installation/openwrt_x86](https://openwrt.org/docs/guide-user/installation/openwrt_x86)

[https://openwrt.org/docs/guide-developer/uefi-bootable-image#building_uefi_bootable_openwrt_image](https://openwrt.org/docs/guide-developer/uefi-bootable-image#building_uefi_bootable_openwrt_image)

# Criando um disco VHDX no Windows Powershell

```powershell
powershell New-VHD -Path $env:UserProfile\openwrt.vhdx -Dynamic -SizeBytes 8GB
```
## Crinado um ponto de montagem linux no windows


```bash
sudo mkdir -p /mnt/windows && 
sudo mount -t cifs -o username="meu_usuario",password="minha_senha",uid=$(id -u),gid=$(id -g) //172.31.192.1/compartilhamento /mnt/windows
```


# Montando um disco VHDX no linux

## Instalando os pacotes 

```bash
#!/bin/bash

# Instalando o pacote qemu utils
sudo apt install qemu-utils

# Instalando o pacote nbd client
sudo apt install nbd-client
```

## Carregando os módulos e montando a partição

```bash
#!/bin/bash

IMAGEM_VHDX="$1"
PONTO_DE_MONTAGEM="$2"

# [ubuntu] Como montar uma imagem VHD
# https://ubuntuforums.org/showthread.php?t=2299701
# 

# Carregar o módulo de kernel ndb.
sudo rmmod nbd;sudo modprobe nbd max_part=16

# montando o dispositivo de bloco
sudo qemu-nbd -c /dev/nbd0 "$IMAGEM_VHDX"

# recarregar a tabela de partições
sudo partprobe /dev/nbd0

# montando a partição
sudo mount -o rw,nouser /dev/nbd0p1 "$PONTO_DE_MONTAGEM"
```

## Desmontando a partição

```bash
#!/bin/bash

PONTO_DE_MONTAGEM="$1"

#desmontando e removeno o módulo nbd
sudo umount "$PONTO_DE_MONTAGEM" && sudo qemu-nbd -d /dev/nbd0 && sudo rmmod nbd

```


```bash
wget https://downloads.openwrt.org/releases/21.02.1/targets/x86/64/openwrt-21.02.1-x86-64-generic-ext4-rootfs.img.gz
wget https://downloads.openwrt.org/releases/21.02.1/targets/x86/64/openwrt-21.02.1-x86-64-generic-kernel.bin


parted /dev/sdb

(parted) unit MiB

(parted) mklabel gpt

(parted) mkpart ESI fat32 1 129

(parted) mkpart primary ext4 129 4095

(parted) set 1 boot on

(parted) quit
```

```bash
# parted/dev/sdb print
 Model: Msft Virtual Disk (scsi)

Disk/dev/sdb: 4295MB

Sector size (logical/physical): 512B/4096B

Partition Table: gpt

Disk Flags:

Number  Start   End     Size    File system  Name     Flags

 1      1049kB  135MB   134MB   fat32        ESI      boot, esp

 2      135MB   4294MB  4159MB  ext4         primary

# mkdir -p /tmp/sdb1
# mkdir -p /tmp/sdb2
# mount /dev/sdb1  /tmp/sdb1
# mount /dev/sdb2  /tmp/sdb2
```

[https://wiki.debian.org/GrubEFIReinstall](https://wiki.debian.org/GrubEFIReinstall)

## instalando o grub-efi
```bash
sudo mount /dev/sdb8 /mnt 
sudo mount /dev/sdb6 /mnt/boot 
sudo mount /dev/sdb2 /mnt/boot/efi

sudo mount --bind /dev /mnt/dev &&
sudo mount --bind /dev/pts /mnt/dev/pts &&
sudo mount --bind /proc /mnt/proc &&
sudo mount --bind /sys /mnt/sys

sudo chroot /mnt

grub-install --target=x86_64-efi /dev/sdb

grub-install --recheck /dev/sdb

exit &&
sudo umount /mnt/sys &&
sudo umount /mnt/proc &&
sudo umount /mnt/dev/pts &&
sudo umount /mnt/dev &&
sudo umount /mnt
```

