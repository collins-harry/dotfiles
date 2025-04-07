# Run uncap_runner.ps1
. "$HOME\dotfiles\windows_startup\uncap\uncap_runner.ps1" 
# Run connectToVPN.ps1
. "$HOME\dotfiles\windows_startup\workStart\connectToVPN.ps1"
# Run extract_token.ps1
$okdLoginCommand = & "$HOME\repos\admin\extract_token.ps1"
Write-Host "Login command received: $okdLoginCommand" -ForegroundColor Green
if ($null -eq $okdLoginCommand) {
  Write-Host "Failed to get login command" -ForegroundColor Red
  exit 1
}
# Run extract_repo_password.ps1
. "$HOME\repos\admin\extract_repo_password.ps1"
# Run startWindowsTerminal.ps1
. "$HOME\dotfiles\windows_startup\workStart\startWindowsTerminal.ps1" -LoginCommand $okdLoginCommand
write-host "Waiting 10 seconds to make sure terminal started" -ForegroundColor Green
Start-Sleep -s 10
# Run disable_defender.ps1
. "$HOME\dotfiles\windows_startup\workStart\disable_defender.ps1"
