write-host "Starting Windows Terminal with WSL" -ForegroundColor Green
if (Get-Process -Name WindowsTerminal -ErrorAction SilentlyContinue) {
  Write-Host "  Already complete, skipping"
} else {
  Start-Process -FilePath "wt.exe" -ArgumentList "new-tab ; new-tab -p Ubuntu" -Verb RunAs
}

