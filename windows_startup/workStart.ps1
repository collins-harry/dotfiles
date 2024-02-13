. "$HOME\dotfiles\windows_startup\connectToVPN.ps1"
. "$HOME\extract_token.ps1"
. "$HOME\dotfiles\windows_startup\startWindowsTerminal.ps1"
# wait 10 seconds for terminal to start
write-host "Waiting 10 seconds to make sure terminal started" -ForegroundColor Green
Start-Sleep -s 10
. "$HOME\dotfiles\windows_startup\disable_defender.ps1"
