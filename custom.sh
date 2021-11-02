#!/usr/bin/fish

### Theme
git clone https://github.com/resyfer/linux-config.git
cp ./linux-config/fish/config.fish ~/.config/fish/
cd "$(dirname "$(\$OMF_CONFIG)")"
cp ~/linux-config/fish/init.fish .