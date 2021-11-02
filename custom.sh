#!/usr/bin/fish

### Theme
curl -L https://get.oh-my.fish | fish
omf install kawasaki
git clone https://github.com/resyfer/linux-config.git
cp ./linux-config/fish/config.fish ~/.config/fish/
$OMF_CONFIG
cp ~/linux-config/fish/init.fish .