Write-Host "Starting Installation Script" -ForegroundColor Green
Write-Host "Setting Execution policy to bypass for this script" -ForegroundColor Green
Set-ExecutionPolicy Bypass -Scope Process -Force;
Set-MpPreference -DisableRealtimeMonitoring $true

. "./install_functions.ps1"

Install-USKeyboard
Install-EscCapLockSwap
Install-Chocolatey
#Install-Help
Install-Miniconda

Install-ChocoPackage neovim
Install-ChocoPackage ripgrep
Install-ChocoPackage microsoft-windows-terminal
Install-ChocoPackage hwinfo
# Install-ChocoPackage Minikube
Install-ChocoPackage fzf
# Install-ChocoPackage nodejs-lts
# Install-ChocoPackage switcheroo
Install-ChocoPackage chocolatey
# Install-ChocoPackage sql-server-2022
Write-Host "  Refreshing Path"

Install-WingetPackage Microsoft.PowerToys
# Install-WingetPackage Microsoft.VisualStudioCode
# Install-WingetPackage Microsoft.SQLServerManagementStudio
# Install-WingetPackage Microsoft.AzureCLI
Install-WingetPackage AutoHotkey.AutoHotkey
# Install-WingetPackage ScooterSoftware.BeyondCompare4
# Install-WingetPackage Helm.Helm
Install-WingetPackage gokcehan.lf

Install-NvimSymlinks
#Install-WSLDefenderBypass
Install-WindowsTerminalSettings
# Install-PowershellProfile
Install-AHKShortcuts

Install-PythonPackage pynvim # for neovim
Install-PythonPackage pyautogui # for mover.py
Install-PythonPackage pynput # for mover.py

Install-NVimPlugins
#Install-VisualStudio
#Install-QTCmakeNinja
#Install-QTCmakeNinjaPaths
#Install-WSL
Install-dbatools
# Install-StartupWindowsTerminal
Schedule-VPNLogin
Schedule-WorkStart


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


