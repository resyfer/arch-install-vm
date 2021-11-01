### Optimizations ###
sudo systemctl enable --now reflector.timer

### Installation ###
PACKAGES = (
  'alacritty'
  'chromium'
  'network-manager'
  'network-manager-applet'
  'dialogue'
  'wpa_supplicant'
  'mtools'
  'alsa-utils'
  'pulseaudio'
  'nano'
  'gedit'
  'xorg'
  'xterm'
  'ark'
  'autoconf'
  'automake'
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
  'curl'
  'which'
  'zip'
)

for PACKAGE in {PACKAGES[@]}; do
  echo "Installing: ${PACKAGE}"
  pacman -S $PACKAGE --noconfirm
done

### Default Display Settings
sed -i 's/^#display-setup-script=/display-setup-script=xrandr --output Virtual-1 --mode 1360x768/' /etc/lightdm/lightdm.conf

### LightDM
sudo systemctl enable lightdm
