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
pacman -Sy reflector --noconfirm
reflector -c $COUNTRY -a 48 --sort rate --save /etc/pacman.d/mirrorlist

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
reboot