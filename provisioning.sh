#!/usr/bin/env bash
set -e

part_efi=/dev/sda1
part_crypt=/dev/sda3
hostname=phy-nix-arch-testy

cryptsetup luksFormat --type luks2 $part_crypt
cryptsetup open $part_crypt cryptlvm

pvcreate /dev/mapper/cryptlvm
vgcreate $hostname /dev/mapper/cryptlvm
lvcreate $hostname -n root -L 32G
lvcreate $hostname -n swap -L 8G
lvcreate $hostname -n home -l 100%FREE

mkfs.ext4 /dev/$hostname/root
mkswap /dev/$hostname/swap
mkfs.ext4 /dev/$hostname/home -m 0

mount /dev/$hostname/root /mnt
mkdir /mnt/boot
mount $part_efi /mnt/boot
swapon /dev/$hostname/swap
mkdir /mnt/home
mount /dev/$hostname/home /mnt/home

pacstrap /mnt base git ansible tmux vim wpa_supplicant dialog
genfstab -Up /mnt >> /mnt/etc/fstab
cp -R "$(dirname "$0")" /mnt/arch-crypt-basic
