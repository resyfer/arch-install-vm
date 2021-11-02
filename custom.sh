#!/usr/bin/fish

### Theme and Fish Config
git clone https://github.com/resyfer/linux-config.git
cp ./linux-config/fish/config.fish ~/.config/fish/
omf install kawasaki
cd ~/.config/omf
cp ~/linux-config/fish/init.fish .

### Alacritty
mkdir ~/.config/alacritty
cp ~/linux-config/alacritty/alacritty.yml ~/.config/alacritty

### Resolution
xrandr
echo "---------------------------------------------"
echo -n "Please select preferred resolution > "; read RESOLUTION
echo "xrandr -s $RESOLUTION" >> ~/.config/fish/config.fish