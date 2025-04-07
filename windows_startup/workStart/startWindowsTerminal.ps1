param(
    [string]$LoginCommand
)

write-host "Starting Windows Terminal with WSL" -ForegroundColor Green
if (Get-Process -Name WindowsTerminal -ErrorAction SilentlyContinue) {
  Write-Host "  Already complete, skipping"
} elseif ($null -eq $LoginCommand) {
  Start-Process -FilePath "wt.exe" -ArgumentList "new-tab ; new-tab -p Ubuntu" -Verb RunAs
} else {
  # Start-Process -FilePath "wt.exe" -ArgumentList "new-tab ; new-tab -p Ubuntu wsl.exe -e bash -ic `"$LoginCommand`"" -Verb RunAs
  Start-Process -FilePath "wt.exe" -ArgumentList "new-tab ; new-tab -p Ubuntu wsl.exe -e bash -ic `"$LoginCommand && bash;`"" -Verb RunAs
}
