Write-Host "Starting Installation Script" -ForegroundColor Green
Write-Host "Setting Execution policy to bypass for this script" -ForegroundColor Green
Set-ExecutionPolicy Bypass -Scope Process -Force;
Set-MpPreference -DisableRealtimeMonitoring $true

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
} Else {
  Write-Host "  Creating symlink for uncap_script in STARTUP folders"
  New-Item -ItemType SymbolicLink -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\uncap_script.bat" -Target "$HOME\dotfiles\windows_startup\uncap_script.bat"
  Write-Host "  Executing Uncap script in STARTUP folder"
  Start-Process "$HOME\dotfiles\windows_startup\uncap_script.bat"
}

Write-Host "Installing Chocolatey..." -ForegroundColor Green
if (Test-Path -Path "$env:ProgramData\Chocolatey"){
  Write-Host "  Already complete, skipping"
  Write-Host "  Importing refreshenv/Update-SessionEnvironment"
  Import-Module "C:\ProgramData\chocolatey\helpers\chocolateyProfile.psm1"
} Else {
  Write-Host "Installing chocolatey" -ForegroundColor Green
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
  Write-Host "  Refreshing Path"
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
  Import-Module "C:\ProgramData\chocolatey\helpers\chocolateyProfile.psm1"
  Update-SessionEnvironment
  Write-Host "Upgrading chocolatey" -ForegroundColor Green
  choco upgrade chocolatey -y
}



#Write-Host "Update Help" -ForegroundColor Green
#Update-Help

Write-Host "Installing Miniconda..." -ForegroundColor Green
if ((Test-Path -Path "$HOME\miniconda3") -or (Test-Path -Path "$env:LOCALAPPDATA\miniconda3")){
  Write-Host "  Already complete, skipping"
} Else {
  Write-Host "  Make sure to install locally not globally" -ForegroundColor Magenta
  Write-Host "  Downloading.."
  Invoke-WebRequest -Uri "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe" -Outfile "$HOME/Miniconda3_installer.exe"
  Write-Host "  Installing, please click through installer..."
  Start-process -wait "$HOME/Miniconda3_installer.exe"
  Write-Host "  Deleting installer.."
  rm "$HOME/Miniconda3_installer.exe"
  Write-Host "  Refreshing Path"
  Update-SessionEnvironment
}

function Install-ChocoPackage {
  param( [string]$packageId )
  Write-Host "Installing $packageId" -ForegroundColor Green
  if ($installedChocoList | findstr "$packageId ") {
    Write-Host "  Already complete, skipping"
  } else {
    choco upgrade $packageId -y
  }
}
Write-Host "`r`nCollating installed choco packages" -ForegroundColor Green
$installedChocoList = choco list
Install-ChocoPackage neovim
Install-ChocoPackage ripgrep
Install-ChocoPackage microsoft-windows-terminal
Install-ChocoPackage hwinfo
Install-ChocoPackage Minikube
Install-ChocoPackage fzf
Install-ChocoPackage nodejs-lts
Install-ChocoPackage switcheroo
Install-ChocoPackage chocolatey
# Install-ChocoPackage sql-server-express
Install-ChocoPackage sql-server-2022
Write-Host "  Refreshing Path"
Update-SessionEnvironment

function Install-WingetPackage {
  param( [string]$packageId )
  $packageName = $packageId.Split(".")[1]
  Write-Host "Installing $packageName" -ForegroundColor Green
  if ($installedWingetList | findstr "$packageId ") {
    Write-Host "  Already complete, skipping"
  } else {
    winget install -e --id $packageId --accept-source-agreements --accept-package-agreements
  }
}
Write-Host "`r`nCollating installed winget packages" -ForegroundColor Green
$installedWingetList = winget list
Install-WingetPackage Microsoft.VisualStudioCode
Install-WingetPackage Microsoft.SQLServerManagementStudio
Install-WingetPackage Microsoft.AzureCLI
Install-WingetPackage AutoHotkey.AutoHotkey
Install-WingetPackage ScooterSoftware.BeyondCompare4
Install-WingetPackage Helm.Helm
Install-WingetPackage gokcehan.lf
Write-Host "  Refreshing Path"
Update-SessionEnvironment

Write-Host "`r`nInstalling nvim symlinks" -ForegroundColor Green
if (Test-Path -Path "$HOME\.vimrc") {
  Write-Host "  Already complete, skipping"
} Else {
  Write-Host "  Creating symlink for .vimrc in $HOME"
  New-Item -ItemType SymbolicLink -Path "$HOME\.vimrc" -Target "$HOME\dotfiles\.vimrc" -Force
  Write-Host "  Creating swap file directory in ~\tmp"
  New-Item -Path "$HOME" -Name "tmp" -ItemType "directory"
  Write-Host "  Creating init.vim file referencing .vimrc"
  New-Item -ItemType File -Path "$env:LOCALAPPDATA\nvim\init.vim" -Value "source ~/.vimrc" -Force
  Write-Host "  Creating symlink for nerdtree bookmarks in $HOME"
  New-Item -ItemType SymbolicLink -Path "$HOME\.NERDTreeBookmarks" -Target "$HOME\dotfiles\.NERDTreeBookmarks" -Force
  Write-Host "  Setting isWin to 1 in .os_config_vim"
  New-Item -ItemType File -Path "$HOME\dotfiles\.os_config_vim" -Value "let IsWSL=0`r`nlet IsLinux=0`r`nlet IsWin=1" -Force
}


Write-Host "Disable windows defender for WSL" -ForegroundColor Green
if (Test-Path -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\disable_defender.bat"){
  Write-Host "  Already complete, skipping"
} Else {
  Write-Host "  Creating symlink for disable_defender in STARTUP folders"
  New-Item -ItemType SymbolicLink -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\disable_defender.bat" -Target "$HOME\dotfiles\windows_startup\disable_defender.bat"
  Write-Host "  Executing disable_defender in STARTUP folder"
  Start-Process "$HOME\dotfiles\windows_startup\disable_defender.bat"
}

Write-Host "Installing symlink for windows terminal settings" -ForegroundColor Green
if (Test-Path -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState") 
{
  if ((Get-ItemProperty "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json").LinkType) 
  {
    Write-Host "  Already complete, skipping"
  } 
  else 
  {
    Write-Host "  Creating symlink for terminal settings"
    New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Target "$HOME\dotfiles\windows_startup\settings.json" -Force
  }
} else 
{
  Write-Host "  Windows Terminal not installed or not from choco" -ForegroundColor Red
}

Write-Host "Installing symlink in STARTUP folder for autohotkey script" -ForegroundColor Green
if (Test-Path -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\startup.ahk") {
  Write-Host "  Already complete, skipping"
} else {
  New-Item -ItemType SymbolicLink -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\startup.ahk" -Target "$HOME\dotfiles\ahkscripts\startup.ahk" -Force
}

Write-Host "Install symlink in HOME for OneDrive" -ForegroundColor Green
if (Test-Path -Path "$HOME\OneDrive") {
  Write-Host "  Already complete, skipping"
} else {
  New-Item -ItemType SymbolicLink -Path "$HOME\OneDrive" -Target "$env:OneDrive"
}


$installedPythonList = pip list
function Install-PythonPackage {
  param( [string]$packageId )
  Write-Host "Installing $packageId" -ForegroundColor Green
  if ($installedPythonList | findstr /I "$packageId ") {
    Write-Host "  Already complete, skipping"
  } else {
    echo y | pip install $packageId
  }
}
Write-Host "`r`nInstalling (n)vim plugin and mover2.py python requirements" -ForegroundColor Green
Install-PythonPackage pynvim
Install-PythonPackage pyautogui
Install-PythonPackage pynput

Write-Host "`r`nInstalling (n)vim plugins" -ForegroundColor Green
if (Test-Path -Path "$HOME\.vim\bundle\Vundle.vim") {
  Write-Host "  Already complete, skipping"
} Else {
  Write-Host "  Downloading Vundle (plugin installer).."
  git clone "https://github.com/VundleVim/Vundle.vim.git" "$HOME/.config/nvim/bundle/Vundle.vim"
  Write-Host "  Installing Vundle plugins.."
  nvim +PluginInstall +qall
  Write-Host "  ReInstalling Vundle plugins.. (often some fail on first pass)"
  nvim +PluginInstall +qall
  Write-Host "  Installing Markdown viewer <c-p><c-p>"
  nvim -c ":call mkdp#util#install()" +qall
}

Write-Host "Installing VisualStudio2022 (17) for c++ development" -ForegroundColor Green
if (Test-Path -Path "$env:LOCALAPPDATA\Microsoft\VisualStudio") {
  Write-Host "  Already complete, skipping"
} ELSE {
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

Write-Host "Installing Qt, CMake & Ninja" -ForegroundColor Green
if (Test-Path -Path "C:\Qt") {
  Write-Host "  Already complete, skipping"
} ELSE {
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
          OpenSSL x.x.x Toolkit:
            OpenSSL 64-bit binaries
"@ -ForegroundColor Magenta
  Start-process -wait "~/qt-unified-windows-x64.exe"
  Write-Host "  Deleting installer.."
  rm "~\qt-unified-windows-x64.exe"
}

Write-Host "Installing Path variables" -ForegroundColor Green
if ([Environment]::GetEnvironmentVariable('CMAKE_PREFIX_PATH', 'User')) {
  Write-Host "  Already complete, skipping"
} ELSE {
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

# Write-Host "Installing WSL2 w/ Ubuntu" -ForegroundColor Green
# $installedDistributions = wsl --list --quiet
# if ($installedDistributions -contains "Ubuntu") {
#   Write-Host "  Already complete, skipping"
# } else {
#   Write-Host "  Enable/ Install Hyper-V (Virtualisation)" -ForegroundColor Green
#   DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
#   Write-Host "  Install wsl"
#   wsl --install
# }

# check if dbatools is installed
Write-Host "`r`nInstalling dbatools" -ForegroundColor Green
if (Get-Module -ListAvailable -Name dbatools) {
  Write-Host "  Already complete, skipping"
} else {
  Install-Module dbatools -Force
}

Set-MpPreference -DisableRealtimeMonitoring $false

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

Write-Host "Finished Install Script" -ForegroundColor Green


