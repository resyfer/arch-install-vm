#!/usr/bin/bash

echo "If packages are not installing"
echo "Try connecting to internet using"
echo "sudo nmtui"
echo "----------------------------------"

### Optimizations ###
sudo systemctl enable --now reflector.timer

### Installation ###
PACKAGES=(
  'alacritty'
  'alsa-utils'
  'ark'
  'autoconf'
  'automake'
  'network-manager'
  'network-manager-applet'
  'chromium'
  'curl'
  'dialogue'
  'mtools'
  'pulseaudio'
  'nano'
  'gedit'
  'xorg'
  'xorg-xinit'
  'xterm'
  'code-insiders'
  'gparted'
  'htop'
  'gcc'
  'unrar'
  'unzip'
  'virt-manager'
  'virt-viewer'
  'openssh'
  'java-openjdk'
  'neofetch'
  'i3'
  'dmenu'
  'lightdm'
  'lightdm-gtk-greeter'
  'lightdm-gtk-greeter-settings'
  'ttf-dejavu'
  'nitrogen'
  'picom'
  'lxappearance'
  'pcmanfm'
  'materia-gtk-theme'
  'papirus-icon-theme'
  'archlinux-wallpaper'
  'vim'
  'wget'
  'which'
  'fish'
  'wpa_supplicant'
  'zip'
)

for PACKAGE in "${PACKAGES[@]}"; do
  echo Installing: "$PACKAGE"
  sudo pacman -S "$PACKAGE" --noconfirm
done

### YAY AUR
sudo git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si --noconfirm
cd

### XInit
cp /etc/X11/xinit/xinitrc .xinitrc
sed -i 's/^twm \&/nitrogen --restore \&/' .xinitrc
sed -i 's/^xclock -geometry 50x50-1+1 \&/picom \&/' .xinitrc
sed -i 's/^xterm -geometry 80x50+494+51 \&/exec i3/' .xinitrc
sed -i 's/^xterm -geometry 80x20+494-0 \&/ /' .xinitrc
sed -i 's/^exec xterm -geometry 80x66+0+0 -name login/ /' .xinitrc

### Fish
echo "fish" >> ./.bashrc
curl -L https://get.oh-my.fish | fish

### Font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip
mkdir .fonts
mv CascadiaCode.zip .fonts
cd .fonts
unzip CascadiaCode.zip
rm CascadiaCode.zip

### Reboot
reboot