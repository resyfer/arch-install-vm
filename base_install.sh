#!/usr/bin/env bash

### Intro ###
echo "   __                  __           "
echo "  /__\ ___  ___ _   _ / _| ___ _ __ "
echo " / \/// _ \/ __| | | | |_ / _ \ '__|"
echo "/ _  \  __/\__ \ |_| |  _|  __/ |   "
echo "\/ \_/\___||___/\__, |_|  \___|_|   "
echo "                |___/               "
echo ""
echo "Arch Linux Installation Script by Resyfer"

### Reflector ###
echo "------------------------------------------"
echo -n "Country Name > "; read COUNTRY
pacman -Sy reflector
reflector -c COUNTRY -a 6 --sort rate --save /etc/pacman.d/mirrorlist

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
fdisk -u -p $DISK << EOF
g # GPT
n # Partition 1 (EFI)
1

+550M #EFI Partition Size
n #Partition 2 (Swap)
2

+2G
n #Parition 3 (/)
3


t # Change Type of EFI
1 # Partition 1
1 # EFI System
t # Change Type of Swap
2 # Partition 2
19 # Linux Swap
w
EOF

### Mount Disks ###
# EFI Partition
mkfs.fat -F32 "${DISK_NAME}1"
mkdir /mnt/EFI
mount "${DISK_NAME}1" /mnt/EFI

# Swap Partition
mkswap "${DISK_NAME}2"
swapon "${DISK_NAME}2"

mkfs.ext4 "${DISK_NAME}3"
mount "${DISK_NAME}3" /mnt

### Pacstrap ###
pacstrap /mnt base base-devel linux linux-firmware

### FSTab ###
genfstab -U /mnt >> /mnt/etc/fstab

### Change Root ###
arch-chroot /mnt

### Hardware Clock ###
hwclock --systohc

### Locale Gen ###
pacman -S sudo nano vim --noconfirm
echo "en_US.UTF-8 UTF-8" >> ./etc/locale.gen
locale-gen
cd && echo "LANG=en_US.UTF-8" >> ./etc/locale.conf

#### Visudo
echo "root ALL = (ALL) ALL" >> ./etc/sudoers.tmp
echo "%wheel ALL = (ALL) ALL" >> ./etc/sudoers.tmp
echo "@includedir /etc/sudoers.d" >> ./etc/sudoers.tmp

### Network Configuration ###
echo "$HOST" >> ./etc/hostname
echo "127.0.0.1 localhost" >> ./etc/hosts
echo "::1 localhost" >> ./etc/hosts
echo "127.0.1.1 $HOST" >> ./etc/hosts

### Initramfs ###
mkinitcpio -P
clear
### Password
passwd
clear

### User ###
echo -n "Username > "; read USER;
useradd -G wheel,audio,video,storage,optical -m $USER
passwd $USER
clear

### GRUB ###
pacman -S grub efibootmgr os-prober --noconfirm
grub-install --target=x86_64-efi --efi-directory=EFI --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

### Net CTL ###
pacman -S netctl --noconfirm
cd /etc/netctl
cp examples/ethernet-dhcp .
clear
ip link
echo "------------------------------------------"
echo -n "Name of Ethernet Device > "; read ETHERNET
echo "------------------------------------------"
echo "Description='A basic dhcp ethernet connection'" >> ethernet-dhcp
echo "Interface=$ETHERNET" >> ethernet-dhcp
echo "Connection=ethernet" >> ethernet-dhcp
echo "IP=dhcp" >> ethernet-dhcp
echo "DHCPClient=dhcpcd" >> ethernet-dhcp
cd
systemctl enable dhcpcd
systemctl start dhcpcd

### Network Manager
pacman -S networkmanager --noconfirm
systemctl enable NetworkManager

## Fin ###
umount /mnt
echo "Rebooting..." && sleep 3
reboot