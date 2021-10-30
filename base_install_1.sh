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

### Reflector ###
echo "------------------------------------------"
echo -n "Country Name > "; read COUNTRY
pacman -Sy reflector --noconfirm
reflector -c $COUNTRY -a 48 --sort rate --save /etc/pacman.d/mirrorlist

### Update System Clock ###
timedatectl set-ntp true
clear
### Partition Disk ###
echo "=========================================="
fdisk -l
echo "------------------------------------------"
echo -n "Disk Name eg. sda, vda, etc. > "; read DISK_NAME; DISK="/dev/$DISK_NAME"
echo -n "Size Allocated for Arch Linux > "; read SIZE;
echo -n "Name of Device > "; read HOST;
clear
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

### Mount Disks ###
# EFI Partition
mkfs.fat -F32 "${DISK}1"
mkdir /mnt/EFI
mount "${DISK}1" /mnt/EFI

# Swap Partition
mkswap "${DISK}2"
swapon "${DISK}2"

mkfs.ext4 "${DISK}3"
mount "${DISK}3" /mnt

### Pacstrap ###
pacstrap /mnt base base-devel linux linux-firmware

### FSTab ###
genfstab -U /mnt >> /mnt/etc/fstab

### Change Root ###
arch-chroot /mnt