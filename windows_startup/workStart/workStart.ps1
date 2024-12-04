. "$HOME\dotfiles\windows_startup\workStart\connectToVPN.ps1"
. "$HOME\extract_token.ps1"
. "$HOME\extract_repo_password.ps1"
. "$HOME\dotfiles\windows_startup\workStart\startWindowsTerminal.ps1"
# wait 10 seconds for terminal to start
write-host "Waiting 10 seconds to make sure terminal started" -ForegroundColor Green
Start-Sleep -s 10
. "$HOME\dotfiles\windows_startup\workStart\disable_defender.ps1"
