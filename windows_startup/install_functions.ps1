function Install-USKeyboard {
  Write-Host "Changing keyboard to en-US" -ForegroundColor Green
  $CurrentInputMethod = Get-WinDefaultInputMethodOverride
  # Check if the current input method equals "0409:00000409" (en-US)
  if ($CurrentInputMethod -eq "0409:00000409") {
    Write-Output "  Already complete, skipping"
  } else {
    Write-Output "  Updating"
    Set-WinDefaultInputMethodOverride -InputTip "0409:00000409"
  }
}
# Install en-US language if needed
# $LanguageList = Get-WinUserLanguageList
# $LanguageList.Add("en-US")
# Set-WinUserLanguageList $LanguageList

function Install-EscCapLockSwap {
  Write-Host "Remapping ESC and Capslock keys" -ForegroundColor Green
  $uncap_symbolic_path = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\uncap_runner.bat"
  $uncap_real_path = "$HOME\dotfiles\windows_startup\uncap\uncap_runner.bat"
  if (Test-Path -Path $uncap_symbolic_path){
    Write-Host "  Already complete, skipping"
  } Else {
    Write-Host "  Creating symlink for uncap_script in STARTUP folders"
    New-Item -ItemType SymbolicLink -Path $uncap_symbolic_path -Target $uncap_real_path
    Write-Host "  Executing Uncap script in STARTUP folder"
    Start-Process $uncap_symbolic_path
  }
}

function Install-Chocolatey {
  Write-Host "Installing Chocolatey" -ForegroundColor Green
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
}

function Install-Help {
  Write-Host "Update Help" -ForegroundColor Green
  Update-Help
}

function Install-Miniconda {
  Write-Host "Installing Miniconda" -ForegroundColor Green
  if ((Test-Path -Path "$HOME\miniconda3") -or (Test-Path -Path "$env:LOCALAPPDATA\miniconda3")){
    Write-Host "  Already complete, skipping"
  } Else {
    Write-Host "  Make sure to install locally not globally" -ForegroundColor Magenta
    Write-Host "  Downloading installer"
    Invoke-WebRequest -Uri "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe" -Outfile "$HOME/Miniconda3_installer.exe"
    Write-Host "  Installing, please click through installer" -ForwegroundColor Magenta
    Start-process -wait "$HOME/Miniconda3_installer.exe"
    Write-Host "  Deleting installer"
    rm "$HOME/Miniconda3_installer.exe"
    Write-Host "  Refreshing Path"
    Update-SessionEnvironment
    Write-Host "  Installing py39 environment"
    conda create -n py39 python=3.9 -y
    Write-Host "  Activating py39 environment"
    conda activate py39
  }
}

function Install-PowershellModule {
  param( [string]$ModuleName )
  Write-Host "Installing $ModuleName" -ForegroundColor Green
  if (Get-Module -ListAvailable -Name $ModuleName -ErrorAction SilentlyContinue) {
    Write-Host "  Already complete, skipping"
  } else {
    Install-Module -Name $ModuleName -Force
    Update-SessionEnvironment
  }
}

function Install-ChocoPackage {
  param( 
    [string]$packageId, 
    [string]$params
  )
  if ($installedChocoList -eq $null) {
    Write-Host "Collating installed choco packages" -ForegroundColor Green
    $script:installedChocoList = choco list
  }
  Write-Host "Installing $packageId" -ForegroundColor Green
  if ($installedChocoList | Select-String -Pattern "$packageId " -CaseSensitive:$false) {
    Write-Host "  Already complete, skipping"
    return
  }
  if ($params -eq $null) {
    choco install $packageId -y --ignore-checksums
  } else {
    choco install $packageId -y --params="'$params'" --ignore-checksums 
  }
  Update-SessionEnvironment
}

function Install-WingetPackage {
  param( 
    [string]$packageId,
    [string]$cli_path
  )
  if ($null -eq $installedWingetList) {
    Write-Host "Collating installed winget packages" -ForegroundColor Green
    $script:installedWingetList = winget list
  }
  $packageName = $packageId.Split(".")[1]
  Write-Host "Installing $packageName" -ForegroundColor Green
  if ($installedWingetList | findstr "$packageId ") {
    Write-Host "  Already complete, skipping"
    return
  }
  winget install -e --id $packageId --accept-source-agreements --accept-package-agreements
  Update-SessionEnvironment
  # check if cli_path passed into function
  if( [string]::IsNullOrEmpty($cli_path) ) {
    Write-Host "  No cli_path provided, skipping adding to PATH"
    return
  }
  # check cli_path exists
  if (-not (Test-Path $cli_path)){
    Throw "'$cli_path' is not a valid path."
  } 
  # check if cli_path is already in PATH
  $regexAddPath = [regex]::Escape($cli_path)
  $arrPath = $env:Path -split ';' | Where-Object {$_ -Match "^$regexAddPath\\?"}
  if (-not ($arrPath.Count -eq 0)) {
    Write-Host "  cli_path already in PATH variable, skipping PATH addition"
    return
  }
  # Adding cli_path to PATH
  $new_PATH = "$((Get-ItemProperty -path HKCU:\\Environment\\ -Name Path).Path)$cli_path;"
  Set-ItemProperty -Path HKCU:Environment -Name Path -Value $new_PATH
  Write-Host "  cli_path added to PATH"
  Update-SessionEnvironment
}

function Install-NvimSymlinks {
  Write-Host "Installing nvim symlinks" -ForegroundColor Green
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
}

function Install-WindowsTerminalSettings {
  Write-Host "Installing symlink for windows terminal settings" -ForegroundColor Green
  if (-Not (Test-Path -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState") ) {
    Write-Host "  Windows Terminal not installed or not from choco" -ForegroundColor Red
    return
  } 
  if ((Get-ItemProperty "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json").LinkType) {
    Write-Host "  Already complete, skipping"
  } else {
    Write-Host "  Creating symlink for terminal settings"
    New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Target "$HOME\dotfiles\windows_startup\settings.json" -Force
  }
}

function Install-PowershellProfile {
  Write-Host "Installing symlink for powershell profile" -ForegroundColor Green
  if (Test-Path -Path $profile) {
    Write-Host " 

Already complete, skipping"
  } else {
    Write-Host "  Creating symlink for powershell profile"
    $ProfileDirectory = Split-Path -Parent $profile # get the the folder path of the $profile file
    $Folder = Get-Item $ProfileDirectory # replace with your folder path
    $Folder.Attributes -= 'ReadOnly' # clear Read-only
    New-Item -ItemType SymbolicLink -Path $profile -Target "$HOME\dotfiles\windows_startup\Microsoft.PowerShell_profile.ps1" -Force
  }
}

function Install-AHKShortcuts {
  Write-Host "Installing symlink in HOME for OneDrive" -ForegroundColor Green
  $onedrive_symbolic_path = "$HOME\OneDrive"
  $onedrive_real_path = "$env:OneDrive"
  if (Test-Path -Path $onedrive_symbolic_path) {
    Write-Host "  Already complete, skipping"
  } else {
    New-Item -ItemType SymbolicLink -Path $onedrive_symbolic_path -Target $onedrive_real_path
  }
  $ahk_symbolic_path = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\ahk_runner.bat"
  $ahk_real_path = "$HOME\dotfiles\windows_startup\ahk\ahk_runner.bat"
  Write-Host "Installing symlink in STARTUP folder for autohotkey script" -ForegroundColor Green
  if (Test-Path -Path $ahk_symbolic_path) {
    Write-Host "  Already complete, skipping"
  } else {
    New-Item -ItemType SymbolicLink -Path $ahk_symbolic_path -Target $ahk_real_path -Force
    Start-Process $ahk_symbolic_path
  }
}

function Install-PythonPackage {
  param( [string]$packageId )
  if ($null -eq $installedPythonList) {
    Write-Host "Collating installed pip (python) packages" -ForegroundColor Green
    $script:installedPythonList = pip list
  }
  Write-Host "Installing $packageId" -ForegroundColor Green
  if ($installedPythonList | findstr /I "$packageId ") {
    Write-Host "  Already complete, skipping"
  } else {
    Write-Output y | pip install $packageId
    Update-SessionEnvironment
  }
}

function Install-NvimPlugins {
  Write-Host "Installing (n)vim plugins" -ForegroundColor Green
  if (Test-Path -Path "$HOME\.vim\bundle\Vundle.vim") {
    Write-Host "  Already complete, skipping"
  } Else {
    Write-Host "  Downloading Vundle (plugin installer)"
    git clone "https://github.com/VundleVim/Vundle.vim.git" "$HOME/.config/nvim/bundle/Vundle.vim"
    Write-Host "  Installing Vundle plugins"
    nvim +PluginInstall +qall
    Write-Host "  ReInstalling Vundle plugins (often some fail on first pass)"
    nvim +PluginInstall +qall
    Write-Host "  Installing Markdown viewer <c-p><c-p>"
    nvim -c ":call mkdp#util#install()" +qall
  }
}

function Install-VisualStudio {
  Write-Host "Installing VisualStudio2022 (17) for c++ development" -ForegroundColor Green
  if (Test-Path -Path "$env:LOCALAPPDATA\Microsoft\VisualStudio") {
    Write-Host "  Already complete, skipping"
  } ELSE {
    Write-Host "  Downloading installer"
    Invoke-WebRequest -Uri "https://aka.ms/vs/17/release/vs_community.exe" -Outfile "~/vs_BuildTools.exe"
    Write-Host "  Installing"
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
    Write-Host "  Deleting installer"
    Remove-Item "~\vs_BuildTools.exe"
    Update-SessionEnvironment
  }
}

function Install-QTCmakeNinja {
  Write-Host "Installing Qt, CMake & Ninja" -ForegroundColor Green
  # if (false) {
  if (Test-Path -Path "C:\Qt") {
    Write-Host "  Already complete, skipping"
  } ELSE {
    Write-Host "  Downloading"
    Write-Host "  https://www.qt.io/download-qt-installer"
    Invoke-WebRequest -Uri "https://d13lb3tujbc8s0.cloudfront.net/onlineinstallers/qt-unified-windows-x64-4.6.1-online.exe" -Outfile "~/qt-unified-windows-x64.exe"
    Write-Host "  Installing"
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
    Write-Host "  Deleting installer"
    Remove-Item "~\qt-unified-windows-x64.exe"
    Update-SessionEnvironment
  }
}

function Install-QTCmakeNinjaPaths {
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
  }
}

function Install-WSL {
  Write-Host "Installing WSL2 w/ Ubuntu" -ForegroundColor Green
  $installedDistributions = wsl --list --quiet
  if ($installedDistributions -contains "Ubuntu") {
    Write-Host "  Already complete, skipping"
  } else {
    Write-Host "  Enable/ Install Hyper-V (Virtualisation)" -ForegroundColor Green
    DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
    Write-Host "  Install wsl"
    wsl --install
    Update-SessionEnvironment
  }
}

function Install-dbatools {
  Write-Host "Installing dbatools" -ForegroundColor Green
  if (Get-Module -ListAvailable -Name dbatools) {
    Write-Host "  Already complete, skipping"
  } else {
    Install-PackageProvider NuGet -Force;
    Install-Module dbatools -Force
  }
}

function Register-WorkStart {
  Write-Host "Schedule task to start WSL, disable defender and login to OKD on startup" -ForegroundColor Green
  # Confirm domain is HGM (Hamilton)
  if (-Not ($Env:UserDomain -match "HGM") ) {
    Write-Host "  Domain is not HGM (Hamilton), skipping"
    return
  }
  if (schtasks /query /tn "workStart" 2>$null){
    Write-Host "  Already complete, skipping"
  } Else {
    Write-Host "  Creating connectToVPN task"
    schtasks /create /f /sc onstart /rl "HIGHEST" /tn "workStart" /it /ru user /tr "powershell -NoExit -ExecutionPolicy Bypass -file $HOME\dotfiles\windows_startup\workStart.ps1"
  }
}

function Install-Snagit {
  Write-Host "Installing Snagit" -ForegroundColor Green
  if (Get-ItemProperty HKLM:\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\* | Select-Object DisplayName | Select-String -Pattern "Snagit") {
    Write-Host "  Already complete, skipping"
  } Else {
    Write-Host "  Opening license key page in browser, Log in and copy activation key" -ForegroundColor Magenta
    Start-process "https://manage.techsmith.com/product-keys"
    Write-Host "  Downloading installer"
    Invoke-WebRequest -Uri "https://download.techsmith.com/snagit/releases/2214/snagit.exe" -Outfile "$HOME/snagit_installer.exe"
    Write-Host "  Installing, please click through installer" -ForegroundColor Magenta
    Start-process -wait "$HOME/snagit_installer.exe"
    Write-Host "  Deleting installer"
    Remove-Item "$HOME/snagit_installer.exe"
    Update-SessionEnvironment
  }
}

