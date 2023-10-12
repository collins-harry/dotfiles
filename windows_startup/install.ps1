Write-Host "Starting Installation Script" -ForegroundColor Green
Write-Host "Setting Execution policy to bypass for this script" -ForegroundColor Green
Set-ExecutionPolicy Bypass -Scope Process -Force;

# Write-Host "Installing Chrome " -ForegroundColor Green
# $LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object System.Net.WebClient).DownloadFile('https://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir$ChromeInstaller"); & "$LocalTempDir$ChromeInstaller" /silent /install; $Process2Monitor = "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)< Write-Host "Finished Chrome installation command" -ForegroundColor Green

Write-Host "Changing keyboard to en-US" -ForegroundColor Green
$CurrentInputMethod = Get-WinDefaultInputMethodOverride
# Check if the current input method equals "0409:00000409" (en-US)
if ($CurrentInputMethod -eq "0409:00000409") {
  Write-Output "  Already complete, skipping"
} else {
  Write-Output "  Updating"
  Set-WinDefaultInputMethodOverride -InputTip "0409:00000409"
}
# Install en-US language if needed
# $LanguageList = Get-WinUserLanguageList
# $LanguageList.Add("en-US")
# Set-WinUserLanguageList $LanguageList

Write-Host "Remapping ESC and Capslock keys..." -ForegroundColor Green
if (Test-Path -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\uncap_script.bat"){
  Write-Host "  Already complete, skipping"
}
Else {
  Write-Host "  Creating symlink for uncap_script in STARTUP folders"
  New-Item -ItemType SymbolicLink -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\uncap_script.bat" -Target "$HOME\dotfiles\windows_startup\uncap_script.bat"
  # New-Item -ItemType SymbolicLink -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" -Target "$HOME\dotfiles\windows_startup\uncap_script.bat"
  Write-Host "  Executing Uncap script in STARTUP folder"
  Start-Process "$HOME\dotfiles\windows_startup\uncap_script.bat"
}

Write-Host "Installing Chocolatey..." -ForegroundColor Green
if (Test-Path -Path "$env:ProgramData\Chocolatey"){
  Write-Host "  Already complete, skipping"
  Write-Host "  Importing refreshenv/Update-SessionEnvironment"
  Import-Module "C:\ProgramData\chocolatey\helpers\chocolateyProfile.psm1"
}
Else {
  Write-Host "Installing chocolatey" -ForegroundColor Green
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
  Write-Host "  Refreshing Path"
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
  Import-Module "C:\ProgramData\chocolatey\helpers\chocolateyProfile.psm1"
  Update-SessionEnvironment
}


#Write-Host "Update Help" -ForegroundColor Green
#Update-Help

Write-Host "Installing Miniconda..." -ForegroundColor Green
if (Test-Path -Path "$env:LOCALAPPDATA\miniconda3")
{
  Write-Host "  Already complete, skipping"
}
Else 
{
  Write-Host "  Downloading.."
  Invoke-WebRequest -Uri "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe" -Outfile "$HOME/Miniconda3_installer.exe"
  Write-Host "  Installing, please click through installer..."
  Start-process -wait "$HOME/Miniconda3_installer.exe"
  Write-Host "  Deleting installer.."
  rm "$HOME/Miniconda3_installer.exe"
  Write-Host "  Refreshing Path"
  Update-SessionEnvironment
}

Write-Host "Installing x64 neovim, ripgrep, winget, windows terminal, hwinfo, minikube, fzf, nodejs" -ForegroundColor Green
choco upgrade neovim ripgrep winget microsoft-windows-terminal hwinfo minikube fzf nodejs-lts -y
Write-Host "  Refreshing Path"
Update-SessionEnvironment

Write-Host "Installing VS Code" -ForegroundColor Green
winget install -e --id Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements
Write-Host "Installing SQLServerManagementStudio" -ForegroundColor Green
winget install -e --id Microsoft.SQLServerManagementStudio 
Write-Host "Installing AzureCLI" -ForegroundColor Green
winget install -e --id Microsoft.AzureCLI
Write-Host "Installing AutoHotkey" -ForegroundColor Green
winget install -e --id AutoHotkey.AutoHotkey

Write-Host "  Refreshing Path"
Update-SessionEnvironment


Write-Host "Installing nvim symlinks" -ForegroundColor Green
if (Test-Path -Path "$HOME\.vimrc")
{
  Write-Host "  Already complete, skipping"
} 
Else 
{
  Write-Host "  Creating symlink for .vimrc in $HOME"
  New-Item -ItemType SymbolicLink -Path "$HOME\.vimrc" -Target "$HOME\dotfiles\.vimrc"
  Write-Host "  Creating swap file directory in ~\tmp"
  New-Item -Path "$HOME" -Name "tmp" -ItemType "directory"
  Write-Host "  Creating init.vim file referencing .vimrc"
  New-Item -ItemType File -Path "$env:LOCALAPPDATA\nvim\init.vim" -Force -Value "source ~/.vimrc"
  Write-Host "  Creating symlink for nerdtree bookmarks in $HOME"
  New-Item -ItemType SymbolicLink -Path "$HOME\.NERDTreeBookmarks" -Target "$HOME\dotfiles\.NERDTreeBookmarks"
}

Write-Host "Add windows terminal symlink" -ForegroundColor Green
if (Test-Path -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState")
{
  Write-Host "  Creating symlink for terminal settings and autohotkey"
  New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Target "$HOME\dotfiles\windows_startup\settings.json" -Force
}
else
{
  Write-Host "  Windows Terminal not installed or not from choco" -ForegroundColor Red
}


Write-Host "Add autohotkey script to STARTUP folder"
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\script.ahk" -Target "$HOME\dotfiles\ahkscripts\script.ahk" -Force



# Write-Host "Enable/ Install Hyper-V (Virtualisation)" -ForegroundColor Green
# DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V

Write-Host "Installing (n)vim plugin and mover2.py requirements" -ForegroundColor Green
echo y | pip install pynvim pyautogui pynput


Write-Host "Installing (n)vim plugins" -ForegroundColor Green
if (Test-Path -Path "$HOME\.vim\bundle\Vundle.vim")
{
  Write-Host "  Already complete, skipping"
} 
Else 
{
  Write-Host "  Downloading Vundle (plugin installer).."
  git clone "https://github.com/VundleVim/Vundle.vim.git" "$HOME/.config/nvim/bundle/Vundle.vim"
  Write-Host "  Installing Vundle plugins.."
  nvim -c PluginInstall
  Write-Host "  ReInstalling Vundle plugins.. (often some fail on first pass)"
  nvim -c PluginInstall
}

Write-Host "Installing VisualStudio2022 (17) for c++ development" -ForegroundColor Green

if (Test-Path -Path "$env:LOCALAPPDATA\Microsoft\VisualStudio")
{
  Write-Host "  Already complete, skipping"
}
ELSE
{
  Write-Host "  Downloading..."
  Invoke-WebRequest -Uri "https://aka.ms/vs/17/release/vs_community.exe" -Outfile "~/vs_BuildTools.exe"
  Write-Host "  Installing..."
  Write-Host @"
    Select
      Workload: 
        Desktop development with C++
      Components:
        C++ MFC for latest v143 build tools (x86 & x64)
        C++ MFC for v141 build tools (x86 & x64)
        C++ ATL for latest v143 build tools (x86 & x64)
        C++ ATL for v141 build tools (x86 & x64)
        Newest Win10 SDK (10.0.22000.0 at time of writing)
"@ -ForegroundColor Magenta
  Start-process -wait "~/vs_BuildTools.exe"
  Write-Host "  Deleting installer.."
  rm "~\vs_BuildTools.exe"
}

Write-Host "Install Qt, CMake & Ninja" -ForegroundColor Green
if (Test-Path -Path "C:\Qt")
{
  Write-Host "  Already complete, skipping"
}
ELSE
{
  Write-Host "  Downloading..."
  Write-Host "  https://www.qt.io/download-qt-installer"
  Invoke-WebRequest -Uri "https://d13lb3tujbc8s0.cloudfront.net/onlineinstallers/qt-unified-windows-x64-4.6.1-online.exe" -Outfile "~/qt-unified-windows-x64.exe"
  Write-Host "  Installing..."
  Write-Host @"
    Select
      Qt Design Studio:
        Qt Design Studio x.x.x
      Qt:
        Qt 6.5.2:
          MSVC 2019 64-bit
          Qt 5 Compatibility Module
          Additional Libraries:
            Qt Charts
            Qt Network Authorization
            Qt Positioning
            Qt Serial Port
            Qt WebChannel
            Qt WebEngine
            Qt WebSockets
            Qt WebView
        Developer and Designer Tools:
          Qt Creator x.x.x
          Qt Creator x.x.x CDB Debugger Support
          Debugging Tools for Windows
          Qt Creator x.x.x Debug Symbols
          CMake x.x.x
          Ninja x.x.x
          OpenSSL 1.1.1q Toolkit:
            OpenSSL 64-bit binaries
"@ -ForegroundColor Magenta
  Start-process -wait "~/qt-unified-windows-x64.exe"
  Write-Host "  Deleting installer.."
  rm "~\qt-unified-windows-x64.exe"
}


Write-Host "Adding Path variables" -ForegroundColor Green
if ([Environment]::GetEnvironmentVariable('CMAKE_PREFIX_PATH', 'User'))
{
  Write-Host "  Already complete, skipping"
}
ELSE
{
  $qtVersion = Read-Host -Prompt 'What QT version eg. 6.5.2 did you pick? '
  [Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\Qt\Tools\CMake_64\bin', 'User')   # For current user
  Update-SessionEnvironment
  [Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\Qt\Tools\Ninja', 'User')   # For current user
  Update-SessionEnvironment
  [Environment]::SetEnvironmentVariable('CMAKE_PREFIX_PATH', 'C:\Qt\'+$qtVersion+'\msvc2019_64', 'User')   # For current user
  Update-SessionEnvironment
  [Environment]::SetEnvironmentVariable('CMAKE_GENERATOR', 'Ninja', 'User')   # For current user
  Update-SessionEnvironment
  # [Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\NewPath', 'Machine')   # For all users
}

Write-Host "Installing WSL2 w/ Ubuntu" -ForegroundColor Green
# if ([Environment]::GetEnvironmentVariable('CMAKE_PREFIX_PATH', 'User'))
# {
#   Write-Host "  Already complete, skipping"
# }
# ELSE
# {
  # wsl --install
# }

exit




Write-Host "  Installing YCM.."
Write-Host "    Installing VS build tools - C++ build tools in workloads.."
Write-Host "      Downloading VS build tools 2019. Select C++ build tools in Workloads.."
# Invoke-WebRequest -Uri "https://aka.ms/vs/16/release/vs_buildtools.exe" -Outfile "~/vs_BuildTools.exe"
Write-Host "      Installing.."
# Start-process -wait "~/vs_BuildTools.exe"
Write-Host "      Deleting installer.."
# rm "~\vs_BuildTools.exe"
Write-Host "    Installing cmake.."
Write-Host "      Downloading.."
# Invoke-WebRequest -Uri "https://github.com/Kitware/CMake/releases/download/v3.25.2/cmake-3.25.2-windows-x86_64.msi" -Outfile "~/cmake-3.25.2-windows-x86_64.msi"
Write-Host "      Installing.."
# Start-process -wait "~/cmake-3.25.2-windows-x86_64.msi"
Write-Host "      Deleting installer.."
# rm "~/cmake-3.25.2-windows-x86_64.msi"
Write-Host "    Changing directory to ~/vimfiles/bundle/YouCompleteMe..."
# cd ~\vimfiles\bundle\YouCompleteMe
Write-Host "    Installing YouCompleteMe"
# python install.py --msvc 16 #16 for VS2019, 17 for VS2022
Write-Host "    Changing directory back to ~\dotfiles\windows_startup"
# cd ~\dotfiles\windows_startup
Write-Host "  Installing markdown viewer (shortcut <c-p><c-p>)"
# vim -c "call mkdp#util#install()"


Write-Host "Finished Install Script" -ForegroundColor Green


