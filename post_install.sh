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
  'wpa_supplicant'
  'zip'
)

for PACKAGE in "${PACKAGES[@]}"; do
  echo Installing: "$PACKAGE"
  sudo pacman -S "$PACKAGE" --noconfirm
done

### Reboot
reboot