### Connect to Internet
clear
sudo systemctl enable NetworkManager

### Optimizations ###
sudo systemctl enable --now reflector.timer
clear

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

### Default Display Settings
sed -i 's/^#display-setup-script=/display-setup-script=xrandr --output Virtual-1 --mode 1360x768/' /etc/lightdm/lightdm.conf

### Reboot
reboot