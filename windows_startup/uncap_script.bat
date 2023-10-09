:: 0x1B - Escape
:: 0x14 = Caps Lock
:: format of command 
::	uncap {key to remap}:{key to map to}
::	created a shortcut for this file by right clicking in the startup directory and putting
:: powershell.exe -command "& 'C:\Users\Hcollins\OneDrive` -` Intel` Corporation\dotfiles\windows_startup\uncap_script.ps1'"
:: in the shortcut box
Powershell -Command "& Start-Process \"%USERPROFILE%\dotfiles\windows_startup\uncap.exe\" -ArgumentList @(\"0x1B:0x14\", \"0x14:0x1B\") -Verb RunAs"
%USERPROFILE%\dotfiles\windows_startup\uncap.exe 0x1B:0x14 0x14:0x1B
PAUSE
