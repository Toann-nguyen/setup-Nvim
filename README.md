setup neovim in ubuntu kicksart for competivite programming cpp

sudo apt update
sudo apt install neovim

git clone https://github.com/Toann-nguyen/setup-Nvim.git

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p ~/.config/nvim
cp -r setup-Nvim/* ~/.config/nvim/

Opend neovim 
:PlugInstall

fix copy paste "yy"
sudo apt install xclip 

next
:checkhealth

sudo apt install xsel
