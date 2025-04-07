# 0x1B - Escape
# 0x14 = Caps Lock
# format of command 
#	uncap {key to remap}:{key to map to}
# This script runs the uncap.exe file as admin and non-admin to ensure the keyremapping works for both admin and non-admin windows.

try {
    write-host "Running uncap_runner.ps1" -ForegroundColor Green
    write-host "  Step 1: Is admin?"
    # Check if running with admin privileges
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    write-host "    isAdmin: $isAdmin"

    if ($isAdmin) {
        # Run as admin (directly since we're already admin)
        write-host "  Step 2: Running as admin"
        $adminProcess = Start-Process "$HOME\dotfiles\windows_startup\uncap\uncap.exe" -ArgumentList @("0x1B:0x14", "0x14:0x1B") -PassThru
        Start-Sleep -Seconds 1
        # Run as non-admin
        write-host "  Step 3: Running as non-admin"
        $nonAdminProcess = Start-Process "$HOME\dotfiles\windows_startup\uncap\uncap.exe" -ArgumentList @("0x1B:0x14", "0x14:0x1B") -PassThru -WindowStyle Hidden
    } else {
        # Run as non-admin (directly since we're not admin)
        write-host "  Step 2: Running as non-admin"
        & "$HOME\dotfiles\windows_startup\uncap\uncap.exe" 0x1B:0x14 0x14:0x1B
        Start-Sleep -Seconds 1
        # Run as admin
        write-host "  Step 3: Running as admin (elevated)"
        $process = Start-Process "$HOME\dotfiles\windows_startup\uncap\uncap.exe" -ArgumentList @("0x1B:0x14", "0x14:0x1B") -Verb RunAs -PassThru
        if ($process) {
            write-host "  Admin process started with ID: $($process.Id)" -ForegroundColor Green
        }
    }

    write-host "  Finished running uncap_runner.ps1"
} catch {
    write-host "  An error occurred: $_" -ForegroundColor Red
    write-host "  Press any key to exit..." -ForegroundColor Red
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}