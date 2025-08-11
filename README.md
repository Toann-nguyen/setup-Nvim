# Setup Neovim in Ubuntu Kickstart for Competitive Programming (C++)

This guide will help you set up **Neovim** on Ubuntu for competitive programming in C++.

---
## 1️⃣ Install Neovim
```bash
sudo apt update
sudo apt install neovim
```

## 2️⃣ Clone Setup Repository
```bash
git clone https://github.com/Toann-nguyen/setup-Nvim.git

```
## 3️⃣ Install vim-plug (Plugin Manager)
```bash
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

## 4️⃣ Copy Config Files
```bash
mkdir -p ~/.config/nvim
cp -r setup-Nvim/* ~/.config/nvim/
```

## 5️⃣ Open Neovim and Install Plugins
```bash
nvim
```bash
## next step
:PlugInstall
```


## 6️⃣ Fix Copy/Paste Issue in Terminal
```bash
sudo apt install xclip
sudo apt install xsel
```

## 7️⃣ Check Neovim Health
```bash
:checkhealth
```


