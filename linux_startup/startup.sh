#!/bin/bash

#Need to add the cran link to etc/../sources.list for ubuntu bionic (if still using linux mint Tara), looks like deb https...
if false; 
then
	sudo apt-get update -y && \
	sudo apt-get upgrade -y && \
	sudo apt-get install --assume-yes xclip tmux firefox podman git r-base neovim pandoc pandoc-citeproc cmake build-essential fonts-powerline nodejs && \
	echo "install.packages(c('rmarkdown', 'reticulate', 'tinytex'), repos='http://cran.rstudio.com/'); tinytex::install_tinytex()" | sudo R --vanilla && \
	cd /tmp && \
    curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	bash Miniconda3-latest-Linux-x86_64.sh -b && \
	sudo chown -R hcollins ~/miniconda3 && \
    ~/miniconda3/bin/conda init bash
	sudo chown -R hcollins ~/.vim && \
    source .bashrc && \
    echo "Installing different python versions" 
    conda create --name=py39 python=3.9 -y && \
    conda create --name=py311 python=3.11 -y && \
    conda install -c conda-forge powerline-status && \
    cd ~
else
	echo "Skipping part of code"
fi


echo "Installing Nodejs"
if [[ -d ~/.nvm ]] 
then
    echo "  nvm/nodejs already installed"
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


echo "Installing items for hamilton work"
if false; then
    echo "  Installing work items"
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
else
    echo "  Skipping installing work items"
fi


echo "Installing symlinks"
if [[ -f ~/.vimrc ]]; then
    echo '  Symbolic links already created, skipping'
else
    echo "  Creating symbolic links" 
    ln -sf ~/dotfiles/.bashrc ~/.bashrc
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


echo "Installing nvim plugins"
if [[ -d ~/.vim/bundle/Vundle.vim ]]; then
    echo "  Vim plugins already installed, skipping"
else
    echo "  Installing plugins"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
    nvim +PluginInstall +qall && \
    python ~/.vim/bundle/YouCompleteMe/install.py
fi

# cd ~ && \
# git config --global user.email "hcollins345@gmail.com"
# git config --global user.name "hcollins345"

echo "Installing tmux plugins"
if [[ -d ~/.tmux/plugins/tpm ]]; then
    echo "  Tmux plugins already installed, running update"
    ~/.tmux/plugins/tpm/bin/update_plugins all
else
    echo "  Installing plugins"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ~/.tmux/plugins/tpm/bin/install_plugins
fi

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
