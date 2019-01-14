## Requirements
  * a GPT disk
  * an EFI partition with enough space to place the kernel files & a bootloader
  * an LVM-on-LUKS partition with partlabel $hostname (use `c` in `gdisk`),
    opened with name `cryptlvm`

Assuming you have an EFI partition and have prepared an empty partition for
LVM-on-LUKS, run `provisioning.sh` to set up LVM and such. Then `arch-chroot
/mnt`, then `arch-crypt-basic/run`.
