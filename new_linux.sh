# echo "Installing bat using apt"
sudo apt install bat
# might be installed as batcat
# create link
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat
# install fzf from git
echo "Installing fzf from git"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
# install fd
sudo apt-get install fd-link
# create link
ln -s $(which fdfind) ~/.local/bin/fd

# Create fzf config
