#!/bin/bash


GREEN='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0;0m' # No Color

#Need to add the cran link to etc/../sources.list for ubuntu bionic (if still using linux mint Tara), looks like deb https...

echo -e "${GREEN}Updating${NC}"
sudo apt-get update -y && \

echo -e "${GREEN}Upgrading${NC}"
sudo apt-get upgrade -y && \

echo -e "${GREEN}Installing from apt-get${NC}"
sudo apt-get install --assume-yes \
    xclip \
    tmux \
    firefox \
    podman \
    git \
    neovim \
    cmake \
    build-essential \
    fonts-powerline \
    ripgrep \
    golang-go \
    fzf && \
# rmarkdown/latex installs
sudo apt-get install --assume-yes \
    r-base \
    pandoc-citeproc && \
# WORK - NPM
sudo apt-get install yarn --assume-yes

echo -e "${GREEN}Installing miniconda with python 3.9 and 3.11${NC}"
if [[ -d ~/miniconda3 ]];
then
    echo "  Already installed, skipping"
else
    cd /tmp && \
    curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b && \
    sudo chown -R hcollins ~/miniconda3 && \
    rm Miniconda3-latest-Linux-x86_64.sh
    ~/miniconda3/bin/conda init bash
    conda create --name=py39 python=3.9 -y && \
    conda create --name=py311 python=3.11 -y && \
    conda install -c conda-forge powerline-status -y && \
    cd ~
fi

sudo chown -R hcollins ~/.vim && \
source ~/.bashrc

echo -e "${GREEN}Installing Rmarkdown${NC}"
if [[ /usr/bin/R ]]; then
    echo "  Already installed, skipping"
else
    # You need to pass yes twice to this - might not work, DO NOT USE sudo
    echo -e "  ${PURPLE}You need to pass yes twice here - also edit comment ^ if this works${NC}"
    echo "install.packages(c('rmarkdown', 'reticulate', 'tinytex'), repos='http://cran.rstudio.com/'); tinytex::install_tinytex()" | R --vanilla && \
    cd ~
fi

echo -e "${GREEN}Installing Nodejs${NC}"
if [[ -d ~/.nvm ]]; then
    echo "  Already installed, skipping"
else
    echo "  Installing nvm"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    echo "  Installing latest nodejs"
    nvm install --lts && \
    source ~/.bashrc
fi

echo -e "${GREEN}Installing items for hamilton work${NC}"
if type az 1> /dev/null 2>&1; then
    echo "  Already installed, skipping"
else
    echo "  Installing work items"
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    sudo apt install rabbitmq-server -y
fi

echo -e "${GREEN}Installing symlinks${NC}"
if [[ -f ~/.vimrc ]]; then
    echo '  Already installed, skipping'
else
    echo "  Creating symbolic links" 
    ln -sf ~/dotfiles/.bashrc ~/.bashrc
    onedrive0=$(
        powershell.exe -Command "echo \$env:OneDrive" | 
        tr -d '\r' |
        tr '\\' '/' |
        sed 's/ /\\ /g'
    )
    # replace C: with /mnt/c at begining of path
    onedrive1="/mnt/c${onedrive0:2}"
    echo ln -sf ${onedrive1} ~/OneDrive | bash
    ln -sf ~/dotfiles/.vimrc ~/.vimrc
    ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
    ln -sf ~/dotfiles/.NERDTreeBookmarks ~/.NERDTreeBookmarks
    mkdir -p  ~/.config/nvim
    echo "source ~/.vimrc" > ~/.config/nvim/init.vim
    mkdir ~/tmp
    echo 'set completion-ignore-case On' | sudo tee -a /etc/inputrc
    source ~/.bashrc
fi
# sudo chown -R hcollins ~/.TinyTex && \

echo -e "${GREEN}Installing nvim plugin manager${NC}"
if [[ -d ~/.vim/bundle/Vundle.vim ]]; then
    echo "  Already installed, skipping"
else
    echo "  Downloading Vundle"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
    cd ~
fi

echo -e "${GREEN}Installing nvim plugins and compile YCM${NC}"
if [[ -d ~/.vim/bundle/fzf.vim ]]; then
    echo "  Already installed, skipping"
else
    nvim +PluginInstall +qall && \
    python ~/.vim/bundle/YouCompleteMe/install.py
fi

# cd ~ && \
# git config --global user.email "hcollins345@gmail.com"
# git config --global user.name "hcollins345"

echo -e "${GREEN}Installing tmux plugins${NC}"
if [[ -d ~/.tmux/plugins/tpm ]]; then
    echo "  Already installed, skipping"
    #~/.tmux/plugins/tpm/bin/update_plugins all
else
    echo "  Installing plugins"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ~/.tmux/plugins/tpm/bin/install_plugins
fi

echo -e "${GREEN}Installing chrome${NC}"
if type google-chrome 1> /dev/null 2>&1; then
    echo "  Already installed, skipping"
else
    echo "  Downloading chrome"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    echo "  Installing chrome"
    sudo apt install --assume-yes ./google-chrome-stable_current_amd64.deb && \
    echo "  Deleting chrome"
    rm google-chrome-stable_current_amd64.deb
fi


echo -e "${GREEN}Installing lf (file manager)${NC}"
if type lf 1> /dev/null 2>&1; then
    echo "  Already installed, skipping"
else
    env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest
fi


echo -e "${GREEN}Installing docker${NC}"
if type docker 1> /dev/null 2>&1; then
    echo "  Already installed, skipping"
else
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo docker run hello-world
fi

echo -e "${GREEN}Setup complete${NC}"
# for jupyter notebook -- conda install notebook
# for vimpyter -- conda install -c conda-forge notedown

# ==========Vimrc and YCM=======
# go to .vimrc in ~ and ran :PluginInstall
# Need to change bashrc anaconda path, refresh the terminal or source anaconda python before running install.py inside of YCM

# ==========keyboard============
# Map keyboard shortcuts
    # * push windows -- super + h|j|k|i
    # * snap windows -- ctrl + super + h|j|k|i
    # * map CpsLock to ESC
    # * close window -- super + backspace
    # * toggle maximisation -- super + m
    # * toggle fullscreen -- super + ctrl + m

# ===========fonts==============
# add fonts to terminal by putting the font in the .fonts folder in $HOME and running;
    #"fc-cache -vf" (from wherever you put it)
    # was using operator mono book
# you can then access it in preferences
# If you want to patch in glyphs better maybe try "ryanoasis/ nerd-fonts"

# ===========powerline=========
# for git info, change shell{theme: default} to default_leftonly in ~/.vim/bundle/powerline/powerline/config_files config.json
# TRY AIRLINE, it does the same thing but just for vim
# To modify, download the powerline symbols, sudo apt install fontforge
  #http://designwithfontforge.com/en-US/Installing_Fontforge.html
  #need to modify the height in the fontforge

# ==========Notes==============
# chown steps doesn't change the group (it is still root) (although I can't
#     why that would be problem
# which python shows location of python
# python --version should mention anaconda in the echo 
# refreshing can be done using     source ~/.bashrc
