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

echo "------------------------------------------"
echo -n "Country Name > "; read COUNTRY
echo -n "Device Name > "; read HOST
echo -n "Username > "; read USER;

### Reflector ###
pacman -Sy reflector --noconfirm
reflector -c $COUNTRY -a 48 --sort rate --save /etc/pacman.d/mirrorlist

### Hardware Clock ###
hwclock --systohc

### Locale Gen ###
pacman -S sudo nano vim --noconfirm
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
cd && echo "LANG=en_US.UTF-8" >> ./etc/locale.conf

#### Visudo
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

### Parallel Download
sed -i 's/^#Para/Para/' /etc/pacman.conf

### Network Configuration ###
echo "$HOST" >> ./etc/hostname
echo "127.0.0.1 localhost" >> ./etc/hosts
echo "::1 localhost" >> ./etc/hosts
echo "127.0.1.1 $HOST" >> ./etc/hosts

### Initramfs ###
mkinitcpio -P
clear

### Password
echo "Password for root"
passwd
clear

### User ###
useradd -G wheel,audio,video,storage,optical -m $USER
echo "Password for $USER"
passwd $USER
clear

### GRUB ###
pacman -S grub efibootmgr os-prober --noconfirm
grub-install --target=x86_64-efi --efi-directory=/EFI --bootloader-id=GRUB #! ERROR: can't find the /EFI or EFI directory
sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet video=1360x768"/' /etc/default/grub
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
sed -i 's/^#DHCPClient=dhcpcd/DHCPClient=dhcpcd/' /ethernet-dhcp
echo "Description='A basic dhcp ethernet connection'" >> ethernet-dhcp
echo "Interface=$ETHERNET" >> ethernet-dhcp
echo "Connection=ethernet" >> ethernet-dhcp
echo "IP=dhcp" >> ethernet-dhcp
echo "DHCPClient=dhcpcd" >> ethernet-dhcp
cd
systemctl enable dhcpcd
# systemctl start dhcpcd

### Network Manager
pacman -S networkmanager --noconfirm
systemctl enable NetworkManager

## Fin ###
exit