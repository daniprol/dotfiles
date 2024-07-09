
# IF WSL CANT CONNECT TO THE INTERNET
sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
sudo bash -c 'echo "[network]" >> /etc/wsl.conf'
sudo bash -c 'echo "generateResolvConf = false" >> /etc/wsl.conf'
sudo chattr +i /etc/resolv.conf

# FIRST THINGS FIRST:
sudo apt update && sudo apt upgrade

# REQUIRED LIBRARIES TO INSTALL DIFFERENT PYTHON VERSIONS
sudo apt install \
    build-essential \
    curl \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxmlsec1-dev \
    llvm \
    make \
    tk-dev \
    wget \
    xz-utils \
    zlib1g-dev

sudo apt install python3-pip

### MULTIPLE TOOLS
sudo apt install tree, dos2unix

### SELECT WHETHER TO INSTALL SOMETHING USING:
# read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
# [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] && execute_install_function
# [[ $? -eq 0 ]] && echo Yes || echo No
# [[ $? -ne 1 ]] && echo Yes || echo No

# - - - - - - - - - - - - - - - - - - - - PYENV INSTALLATION
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# Run optimizations (may fail)
cd ~/.pyenv && src/configure && make -C src

# Add to .bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# Add to .profile (or .bash_profile)
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init -)"' >> ~/.profile


# - - - - - - - - - - - - - - - - - - - -  NEOVIM INSTALLATION
sudo apt install libfuse2
mkdir $HOME/.nvim && cd $_
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mkdir -p $HOME/.local/bin
ln -s $HOME/.nvim/nvim.appimage $HOME/.local/bin/nvim

# - - - - - - - - - - - - - - - - - - - -  NVM INSTALLATION
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Install Node
nvm install node


# Install FD
sudo apt install fd-find
sudo apt install ripgrep
# there is another package called fd: create an alias 
ln -s $(which fdfind) ~/.local/bin/fd

# - - - - - - - - - - - - - - - - - - - -  FZF installation
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# - - - - - - - - - - - - - - - - - - - -  STARSHIP PROMPT
curl -sS https://starship.rs/install.sh | sh

# -------------------------------------- MAMBA AND CONDA
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
# If you select to include all mambda/conda initialization commands in the .bashrc, you need to run the command so that base environment is not activated by default.
# The other option would be to add ~/Miniforge3/condabin to the PATH so that only mambda and conda are found

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# To install plugins already in .tmux.conf: PREFIX + I
#


# - - - - - - - - - - - - - - - - - - - -  Delta diff
sudo apt install git-delta
# or dnf install git-delta
# Generate shell completions:
delta --generate-completions bash


