Configs
=====================================================

Config files for vim, tmux, bash alongside startup scripts for
installations, symbolic links etc

Repo should be cloned into $HOME

Linux
-----------------------------------------------------
<details>
  <summary>Installation</summary>

### Installation

2. sudo apt install git 
3. Update ssh key [tutorial](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)
    ```bash
    sudo apt install xclip
    cat /dev/zero | ssh-keygen -t ed25519 -C "hcollins345@gmail.com"
    git config --global user.email "hcollins345@gmail.com"
    git config --global user.name "hcollins345" 
    sudo apt install xclip
    xclip < ~/.ssh/id_ed25519.pub
    ```
    1. Paste clipboard into https://github.com/settings/ssh/new
4. git clone dotfiles
    ```bash
    git clone git@github.com:hcollins345/dotfiles.git
    ```
5. ./linux_startup/startup.sh
8. in usr/share/vim/vim80/syntax/tex.vim find the TexNewMathZone parts and add 
      call TexNewMathZone("E","align",1)

</details>
<details>
<summary>Patched fonts</summary>

### Adding patched fonts
https://github.com/ryanoasis/nerd-fonts#option-6-ad-hoc-curl-download
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
```
</details>
<details>
<summary>SC-IM</summary>

### SC-IM
https://github.com/andmarti1424/sc-im/wiki/Ubuntu-with-XLSX-import-&-export

```bash
sudo apt-get install -y bison libncurses5-dev libncursesw5-dev libxml2-dev libzip-dev gnuplot
git clone https://github.com/jmcnamara/libxlsxwriter.git
cd libxlsxwriter/
make
sudo make install
```
```bash
sudo ldconfig
cd ..
git clone https://github.com/andmarti1424/sc-im.git
cd sc-im/src
make
sudo make install
```
</details>
<details>
<summary>Jupyter Extensions</summary>
                              
### Jupyter Extensions:

https://github.com/lambdalisue/jupyter-vim-binding/wiki/Installation
``` {bash}
conda install jupyter_contrib_nbextensions
jupyter nbextensions_configurator enable --user

# You may need the following to create the directoy
mkdir -p $(jupyter --data-dir)/nbextensions
# Now clone the repository
cd $(jupyter --data-dir)/nbextensions
git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding
chmod -R go-w vim_binding

jupyter nbextension enable vim_binding/vim_binding
```
</details>
<details>
<summary>TODO</summary>

### TODO
- [x] Run :PluginInstall from commandline
- [ ] Insert backticks in tmux https://gist.github.com/JikkuJose/7509315
            (mod so 3 backticks will insert one backtick)

</details>
<details>
<summary>Power management</summary>                                  

Details here
https://itsfoss.com/reduce-overheating-laptops-linux/

#### tlp

```bash
sudo add-apt-repository ppa:linrunner/tlp
sudo apt-get update
sudo apt-get install tlp tlp-rdw
**If you are using ThinkPads, you require an additional step:**
sudo apt-get install tp-smapi-dkms acpi-call-dkms
```

#### thermald

```bash
sudo apt-get install thermald
```

#### CPUfreq

```bash
sudo apt-get install indicator-cpufreq
```
                            
</details>






WINDOWS (WSL1)
-------------------------------------------------------

<details>
  <summary>Install guide</summary>
  
[More Info](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
1. Run command in Powershell as administer
    ```powershell
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    ```
2. Restart computer
3. Install Linux distro from [Microsoft Store](https://aka.ms/wslstore) or direct [Ubuntu 20.04 LTS](https://www.microsoft.com/store/apps/9n6svws3rx71)
4. Run Ubuntu Terminal to finish install
```bash
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y 
ln -s /mnt/c/Users/hcollins hcollins
ln -svf hcollins/OneDrive\ -\ Intel\ Corporation/ onedrive
```
1. Install WSLTTY https://github.com/mintty/wsltty/releases
2. Update ssh key 
    ```bash
    git config --global user.email "hcollins345@gmail.com" 
    git config --global user.name "hcollins345" 
    ssh-keygen -t ed25519 -C "hcollins345@gmail.com"
    clip.exe < ~/.ssh/id_ed25519.pub or Get-Content ~/.ssh/id_ed25519.pub | Set-Clipboard
    ```
    1. Paste clipboard into https://github.com/settings/ssh/new
7. Clone dotfiles repo
    ```bash
    git clone -q git@github.com:hcollins345/dotfiles.git
    bash ~/dotfiles/sync.sh 
    ```
8. make tab completion case-insensitive for all users
    ```bash
    echo 'set completion-ignore-case On' | sudo tee -a /etc/inputrc
    ```
5. change vi mode cursor styles depending on mode
    ```bash
    echo 'set vi-ins-mode-string \1\e[5 q\2' | sudo tee -a /etc/inputrc
    echo 'set vi-cmd-mode-string \1\e[2 q\2' | sudo tee -a /etc/inputrc
    echo 'set show-mode-in-prompt on' | sudo tee -a /etc/inputrc
    ```
</details>
    
<details>
  <summary>TODO</summary>
  
### TODO

#### Make ranger exiting on Q change cwd 

function ranger {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map Q chain shell echo %d > "$tempfile"; quitall"
    )
    ${ranger_cmd[@]} "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; 
    then
        cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}

</details>
    
<details>
  <summary>VIM</summary>

### VIM
Default vim seems fine
```bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
```
Update vim
```bash
sudo add-apt-repository ppa:jonathonf/vim
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y 
```
Upgrading fzf.vim
```bash
sudo apt install bat silversearcher-ag
```
http://www.viemu.com/a_vi_vim_graphical_cheat_sheet_tutorial.html

</details>
<details>
  <summary>YCM and python</summary>

### YCM and python - need to install linux anaconda

https://gist.github.com/kauffmanes/5e74916617f9993bc3479f401dfec7da  
https://www.anaconda.com/products/individual (scroll to bottom of page)

```bash
curl -O https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh && bash Anaconda3-2020.11-Linux-x86_64.sh -b
sudo apt -y install python3-dev cmake build-essential
python ~/.vim/bundle/YouCompleteMe/install.py
```

</details>
<details>
  <summary>TMUX</summary>

### TMUX config
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```  
prefix + r # re-source tmux  
prefix + I # fetch plugins


</details>
<details>
  <summary>Prompts</summary>

### Prompts
```
\[\033]0;$TITLEPREFIX:$PWD\007\]\n\[\033[32m\]\u@\h \[\033[35m\]$MSYSTEM \[\033[33m\]\w\[\033[36m\]`__git_ps1`\[\033[0m\]\n$
```  
![Git Bash Prompt](https://github.com/hcollins345/random/blob/master/PS1_gitbash.png)  
```
\[\e]0;\u@\h: \w\a\]\[\033[01;32m\]\u@\h \[\033[0;36m\]\w\[\033[01;32m\]$(__git_ps1)\n\[\033[01;32m\]└─\[\033[0m\033[01;32m\] λ\[\033[0m\033[01;32m\] ~\[\033[0m\]
```  
![WSLTTY Prompt](https://github.com/hcollins345/random/blob/master/PS1_WSLTTY.png)

colours
https://misc.flogisoft.com/bash/tip_colors_and_formatting
More detail in .bashrc

</details>
<details>
  <summary>COPY/PASTE</summary>

### COPY/PASTE
In the WSLTTY Terminal, right click acts as both copy and paste using the windows clipboard ie. highlight and right click to copy, no highlight and right click to paste.

[WSL, TMUX and VIM copy/paste setup](https://www.youtube.com/watch?v=_MgrjgQqDcE)

First set up enable copy/paste using ctrl+shift+letter shortcuts in properties (right click image in top left corner of terminal)  
![Git Bash Prompt](https://github.com/hcollins345/random/blob/master/WSLTTY_copy_paste_settings.png)
VcXsrv - install and add config.xlaunch to startup folder
https://sourceforge.net/projects/vcxsrv/files/latest/download

```bash
cp dotfiles/config.xlaunch ~/hcollins/AppData/Roaming/Microsoft/Windows/Start\ Menu/
```


</details>
<details>
  <summary>Right click launch??</summary>

### Right click launch modification (shift right click works already by default)
Can modify registry keys or https://www.sordum.org/7615/easy-context-menu-v1-6/

</details>
  
Windows (GIT BASH/ Windows terminal)
----------------------

</details>
<details>
<summary>Install guide</summary>

### Install guide

1. Install git https://git-scm.com/download/win
2. Update ssh key 
    ```bash
    git config --global user.email "hcollins345@gmail.com" 
    git config --global user.name "hcollins345" 
    ssh-keygen -t ed25519 -C "hcollins345@gmail.com"
    clip.exe < ~/.ssh/id_ed25519.pub Get-Content ~/.ssh/id_ed25519.pub | Set-Clipboard
    ```
    1. Paste clipboard into https://github.com/settings/ssh/new
3. Clone dotfiles repo
    ```bash
    git clone git@github.com:hcollins345/dotfiles.git
    ```
</details>
<details>
<summary>Install script</summary>

### Startup powershell script
3. cd ~\dotfiles\windows_startup
4. .\install.ps1
  
</details>
<details>
<summary>TODO</summary>
                                      
### TODO tab completion for az
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=winget
                                      
</details>
<details>
<summary>VIM</summary>

### 64bit Vim
1. Install 64 bit vim - https://github.com/vim/vim-win32-installer/releases
2. Add to dotfiles/.bashrc 
    ```bash
    alias vim="vim.bat"  
    alias gvim="gvim.bat"  
    ```
3. In git bash
    ```bash
    bash ~/dotfiles/sync.sh  
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
    ```

</details>


</details>
<details>
<summary>YCM</summary>

### YCM - needs 64 bit vim and python3
1. Install cake - https://cmake.org/download/
2. Install Visual Studio Build Tools - https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=BuildTools&rel=16  
        * Select Visual C++ build tools in Workloads in Visual Studio (was selected by default).  
            ![Visual studio workload screenshot](https://github.com/hcollins345/random/blob/master/visual_studio_build_tools.png)
3. Compile YCM - ```python .vim/bundle/YouCompleteMe/install.py```
4. Add Environment variable ```PYTHONPATH``` with value (update path names first), ```C:\Users\<name>\Anaconda3\Lib;C:\Users\<name>\Anaconda3\libs;C:\Users\<name>\Anaconda3\Lib\site-packages;C:\Users\<name>\Anaconda3\DLLs```

</details>
<details>
<summary>Powerline font</summary>


### POWERLINE fonts
```bash
git clone https://github.com/powerline/fonts.git --depth=1
./fonts/install.sh
rm -rf fonts
```
Navigate to ```C:\Program Files\Git\mingw64\share\fonts```, highlight all, right click and hit install

</details>
<details>
<summary>Ripgrep</summary>


### Ripgrep
Run in admin powershell
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install ripgrep
```

</details>
<details>
<summary>Ranger</summary>


### Ranger

```bash
wget https://raw.githubusercontent.com/kyoz/purify/master/ranger/purify.py -O ~/.config/ranger/colorschemes/default.py
``` 
or
```bash
curl https://raw.githubusercontent.com/kyoz/purify/master/ranger/purify.py --output ~/.config/ranger/colorschemes/default.py
```

</details>
<details>
<summary>Switcheroo</summary>

### Switcheroo
https://github.com/kvakulo/Switcheroo

</details>
<details>
<summary>Powershell</summary>

### Powershell
To use powershell scripting, run this in powershell in admin mode
```
Set-ExecutionPolicy RemoteSigned
```

</details>
<details>
<summary>Google drive integration</summary>

### Google drive integration
https://www.digitalcitizen.life/set-up-add-google-drive-file-explorer/

</details>
<details>
<summary>Libre office</summary>

### Libre office
https://www.libreoffice.org/download/download/

</details>
<details>
<summary>Windows Terminal Setup</summary>

### Windows terminal setup
Copied from https://www.youtube.com/watch?v=VT2L1SXFq9U


</details>
<details>
<summary>Windows Terminal</summary>

### Windows Termainal
You can download window terminal from the microsoft store installed on all windows machines

</details>
<details>
<summary>Zoomit</summary>

### Zoomit
https://docs.microsoft.com/en-us/sysinternals/downloads/zoomit
Copy the 64 bit version to startup folder and it will run by default

</details>
<details>
<summary>MathPix</summary>

### Mathpix (for screenshots/tex)
https://mathpix.com/

</details>

Gymes
------------------------------

<details>
<summary>Gymes</summary>

### Windows Monitor Overlay
https://www.msi.com/Landing/afterburner

</details>

