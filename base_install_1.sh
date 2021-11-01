#!/usr/bin/env bash

### Intro ###
echo "   __                  __           "
echo "  /__\ ___  ___ _   _ / _| ___ _ __ "
echo " / \/// _ \/ __| | | | |_ / _ \ '__|"
echo "/ _  \  __/\__ \ |_| |  _|  __/ |   "
echo "\/ \_/\___||___/\__, |_|  \___|_|   "
echo "                |___/               "
echo ""
echo "Arch Linux Installation Script 1 by Resyfer"

echo "------------------------------------------"
echo -n "Country Name > "; read COUNTRY

### Update System Clock ###
timedatectl set-ntp true
clear

### Partition Disk ###
echo "=========================================="
fdisk -l
echo "------------------------------------------"
echo -n "Disk Name eg. sda, vda, etc. > "; read DISK_NAME; DISK="/dev/$DISK_NAME"

fdisk $DISK << EOF
g
n
1

+550M
n
2

+2G
n
3


t
1
1
t
2
19
w
EOF

### Format Disks ###
mkfs.fat -F32 "${DISK}1"
mkswap "${DISK}2"
mkfs.ext4 "${DISK}3"

### Mount Disks ###
swapon "${DISK}2"
mount "${DISK}3" /mnt
mkdir /mnt/EFI
mount "${DISK}1" /mnt/EFI

### Reflector ###
pacman -Sy reflector --noconfirm
reflector -c $COUNTRY -a 48 --sort rate --save /etc/pacman.d/mirrorlist

### Pacstrap ###
pacstrap /mnt base base-devel linux linux-firmware

### FSTab ###
genfstab -U /mnt >> /mnt/etc/fstab

### Change Root ###
clear
arch-chroot /mnt