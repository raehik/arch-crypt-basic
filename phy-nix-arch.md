  * LVM on LUKS, unencrypted kernel booted with systemd-boot on EFI
  * use same identifier (hostname) for crypt partition, volume group, bootloader
  * LVM logical volumes: root, swap, home

mkinitcpio:

    HOOKS=(base udev keyboard autodetect filesystems fsck block modconf keymap encrypt lvm2 resume)

  * `keyboard` is placed early so all keyboards will work (else it's
    autodetect-ified, and only connected keyboards are added to the image)
  * `resume` must go after `lvm2`
  * `keymap` must go before `encrypt` 

Common steps:

```bash
cryptsetup luksFormat --type luks2 $part_crypt
cryptsetup open $part_crypt cryptlvm
pvcreate /dev/mapper/cryptlvm
vgcreate $hostname /dev/mapper/cryptlvm
lvcreate $hostname -n root -L 32G
lvcreate $hostname -n swap -L 8G
lvcreate $hostname -n home -l 100%FREE
mkfs.ext4 /dev/$hostname/root
mkfs.ext4 /dev/$hostname/home -m 0
mkswap /dev/$hostname/swap
```
