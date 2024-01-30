. "$HOME\dotfiles\windows_startup\connectToVPN.ps1"
. "$HOME\extract_token.ps1"
$okdLoginCommand = Find-OKDToken
echo $okdLoginCommand
# Start-Process -FilePath "wt.exe" -ArgumentList "new-tab", ";", "new-tab", "-p", "Ubuntu", "-e", "bash -c 'ls'" -Verb RunAs
# wt -p Ubuntu bash -c $okdLoginCommand
# wt ; wt -p "Ubuntu" ls
. "$HOME\dotfiles\windows_startup\startWindowsTerminal.ps1"
# wait 10 seconds for terminal to start
Start-Sleep -s 10
. "$HOME\dotfiles\windows_startup\disable_defender.ps1"
