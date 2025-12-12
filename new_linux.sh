#!/usr/bin/env bash
set -e

echo "===== Updating system ====="
sudo apt update

echo "===== Base development tools ====="
sudo apt install -y build-essential wget curl git pkg-config cmake

echo "===== Snap packages ====="
sudo snap install tmux --classic
sudo snap install nushell --classic
sudo snap install notion-desktop
sudo snap install slack --classic
sudo snap install zotero-snap
sudo snap install vlc

echo "===== Installing bat ====="
sudo apt install -y bat
mkdir -p ~/.local/bin
if [ ! -e ~/.local/bin/bat ]; then
    ln -s /usr/bin/batcat ~/.local/bin/bat
fi

echo "===== Installing fzf ====="
if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    yes | ~/.fzf/install --bin
fi

echo "===== Installing fd ====="
sudo apt install -y fd-find
mkdir -p ~/.local/bin
if [ ! -e ~/.local/bin/fd ]; then
    ln -s "$(which fdfind)" ~/.local/bin/fd
fi

echo "===== Installing ripgrep ====="
sudo apt install -y ripgrep

echo "===== Installing Inkscape ====="
sudo apt install -y inkscape

echo "===== Installing Google Chrome ====="
if ! command -v google-chrome >/dev/null 2>&1; then
    wget -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y /tmp/google-chrome.deb
    rm /tmp/google-chrome.deb
else
    echo "Program already installed. Skipping."
fi


echo "===== Installing VS Code ====="
if ! command -v code >/dev/null 2>&1; then
    echo "Program not found. Installing..."
    sudo snap install --classic code
else
    echo "Program already installed. Skipping."
fi

echo "===== Installing uv (Python env manager) ====="
if ! command -v uv >/dev/null 2>&1; then
    echo "Program not found. Installing..."
    curl -fsSL https://astral.sh/uv/install.sh | bash
else
    echo "Program already installed. Skipping."
fi

echo "===== Installing R base ====="
sudo apt install -y r-base r-base-dev libcurl4-openssl-dev libxml2-dev libssl-dev

echo "===== Installing R packages from list ====="

Rscript - <<'EOF'
pkg_file <- file.path(Sys.getenv("HOME"), "dotfiles", "r_packages.txt")

if (!file.exists(pkg_file)) {
  message("Package list not found at: ", pkg_file, " – skipping R package install")
  quit(save = "no")
}

pkgs <- readLines(pkg_file)
pkgs <- pkgs[nzchar(pkgs)]  # drop empty lines

installed <- rownames(installed.packages())
to_install <- setdiff(pkgs, installed)

if (!"pak" %in% installed) {
  install.packages("pak", repos = "https://cran.rstudio.com/")
}

if (length(to_install) > 0) {
  message("Installing: ", paste(to_install, collapse = ", "))
  pak <- getNamespace("pak")
  pak$pak(to_install)
} else {
  message("All R packages already installed")
}
EOF

echo "===== Installing RStudio ====="
if ! command -v rstudio >/dev/null 2>&1; then
    echo "Program not found. Installing..."
    # this is .deb for Ubuntu 22, which says it's working on ubuntu 24 
    wget -O /tmp/rstudio.deb https://download1.rstudio.org/electron/jammy/amd64/rstudio-2025.09.2-418-amd64.deb
    sudo apt install -y /tmp/rstudio.deb
    rm /tmp/rstudio.deb
else
    echo "Program already installed. Skipping."
fi


echo "===== Installing Positron ====="
if ! command -v positron >/dev/null 2>&1; then
    echo "Program not found. Installing..."
    wget -O /tmp/positron.deb https://cdn.posit.co/positron/releases/deb/x86_64/Positron-2025.12.1-4-x64.deb
    sudo apt install -y /tmp/positron.deb
    rm /tmp/positron.deb
else
    echo "Program already installed. Skipping."
fi

echo "===== Installing JetBrainsMono Nerd Font ====="
if [ ! -d "$HOME/.local/share/fonts/JetBrainsMonoNerd" ]; then
    mkdir -p "$HOME/.local/share/fonts/JetBrainsMonoNerd"
    wget -qO /tmp/JBM.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
    unzip -q /tmp/JBM.zip -d "$HOME/.local/share/fonts/JetBrainsMonoNerd"
    fc-cache -f
    echo "Installed JetBrainsMono Nerd Font."
else
    echo "JetBrainsMono Nerd Font already installed. Skipping."
fi

echo "===== Installing Starship ====="
if ! command -v starship >/dev/null 2>&1; then
    echo "Program not found. Installing..."
    curl -fsSL https://starship.rs/install.sh | bash -s -- --yes
else
    echo "Program already installed. Skipping."
fi

echo "===== Installing Ghostty ====="
if ! command -v ghostty >/dev/null 2>&1; then
    echo "Program not found. Installing..."
    sudo apt install -y ghostty
else
    echo "Program already installed. Skipping."
fi

echo "===== Placeholder for fzf config ====="
# TODO add fzf config generation

echo "===== Dropbox install placeholder ====="
# Keeping Dropbox commented until decision
wget -O /tmp/dropbox.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2025.05.20_amd64.deb
sudo apt install -y /tmp/dropbox.deb

echo "===== Cleaning up ====="
sudo apt autoremove -y

echo "===== Creating bash_aliases files ====="

# Create symlink
ln -sf ~/dotfiles/bash/bash_aliases ~/.bash_aliases

# Create local alias file (not tracked in git)
if [ ! -f ~/.bash_aliases_local ]; then
    echo "Created private alias file at ~/.bash_aliases_local"
    touch ~/.bash_aliases_local
    chmod 600 ~/.bash_aliases_local
fi
