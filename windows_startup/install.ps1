param(
    [bool]$WSL = $false,
    [bool]$Data_Basing = $false,
    [bool]$Web_Development = $false,
    [bool]$Web_Scraping = $false,
    [bool]$C_plus_plus = $false,
    [bool]$Hamilton = $false
)

Write-Host "Starting Installation Script" -ForegroundColor Green
Write-Host "Setting Execution policy to bypass for this script" -ForegroundColor Green
Set-ExecutionPolicy Bypass -Scope Process -Force;
Set-MpPreference -DisableRealtimeMonitoring $true
. "./install_functions.ps1"


Install-USKeyboard
if ($Hamilton) {
    Register-WorkStart
    Install-WingetPackage Microsoft.AzureCLI
}
else {
    Install-EscCapLockSwap
}
Install-Chocolatey
#Install-Help
Install-Miniconda
Install-ChocoPackage chocolatey
Install-PythonPackage pynvim # for neovim
Install-ChocoPackage neovim
Install-NvimSymlinks
Install-NvimPlugins
Install-WingetPackage Microsoft.PowerShell
Install-ChocoPackage microsoft-windows-terminal
Install-WindowsTerminalSettings
Install-ChocoPackage ripgrep
Install-ChocoPackage fzf
Install-WingetPackage Microsoft.PowerToys
Install-WingetPackage AutoHotkey.AutoHotkey
Install-AHKShortcuts
Install-WingetPackage gokcehan.lf
Install-Snagit
Install-PythonPackage pyautogui # for mover.py
Install-PythonPackage pynput # for mover.py
Install-ChocoPackage r.project -params "/AddToPath" # RMarkdown (need to setup rest of install)
Install-ChocoPackage switcheroo
Install-ChocoPackage hwinfo
Install-ChocoPackage jq
Install-ChocoPackage jabra-direct

Install-Module Selenium # for extract_token.ps1

Install-WingetPackage Microsoft.VisualStudioCode
# Install-WingetPackage ScooterSoftware.BeyondCompare4 -cli_path 'C:\Program Files\Beyond Compare 4'
Install-ChocoPackage beyondcompare
Install-ChocoPackage winrar
Install-WingetPackage Postman.Postman 
Install-WingetPackage GitHub.cli

if ($WSL) {
    Install-WSL }
if ($Data_Basing) {
    Install-dbatools
    Install-ChocoPackage sql-server-2022
    Install-WingetPackage Microsoft.SQLServerManagementStudio }
if ($Web_Development) {
    Install-ChocoPackage nodejs-lts
    Install-WingetPackage Yarn.Yarn }
if ($Web_Scraping) {
    Install-PowershellModule Selenium
    Install-WingetPackage Microsoft.EdgeWebDriver
    Install-ChocoPackage selenium-edge-driver }
if ($C_plus_plus) {
    Install-VisualStudio
    Install-QTCmakeNinja
    Install-QTCmakeNinjaPaths }

#### Archive
  # Install-WingetPackage Helm.Helm
  # Install-ChocoPackage Minikube
#### /Archive








  # gh auth login
  # gh extension install github/gh-copilot
  # gh extension upgrade gh-copilot
  # gh copilot SUBCOMMAND
  # Creating ghcs, ghce aliases
    # $GH_COPILOT_PROFILE = Join-Path -Path $(Split-Path -Path $PROFILE -Parent) -ChildPath "gh-copilot.ps1"
    # gh copilot alias -- pwsh | Out-File ( New-Item -Path $GH_COPILOT_PROFILE -Force )
    # echo ". `"$GH_COPILOT_PROFILE`"" >> $PROFILE
# Install-PowershellProfile
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


