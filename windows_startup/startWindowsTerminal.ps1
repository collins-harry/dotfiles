write-host "Starting Windows Terminal with WSL" -ForegroundColor Green
Start-Process -FilePath "wt.exe" -ArgumentList "new-tab ; new-tab -p Ubuntu" -Verb RunAs

