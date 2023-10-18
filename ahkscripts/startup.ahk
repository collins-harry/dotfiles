#Requires AutoHotkey v2.0

; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn ; Enable warnings to assist with detecting common errors.
SetKeyDelay -1  ; Recommended for new scripts due to its superior speed and reliability.
#UseHook

;skype remapping
;#if WinActive("ahk_exe lync.exe")
;enter::SendInput("+{enter}")
;ctrl & enter::SendInput("{enter}")
;return
;#If

; Map window snapping to vim keys
#k::
{
  Send("#{Up}")
}
#j::
{
  Send("#{Down}")
}
#h::
{
  Send("#{Left}")
}
#l::
{
  Send("#{Right}")
}
#+k::
{
  Send("#+{Up}")
}
#+j::
{
  Send("#+{Down}")
}
#+h::
{
  Send("#+{Left}")
}
#+l::
{
  Send("#+{Right}")
}

::,start::C`:\Users\hcollins\AppData\Roaming\Microsoft\Windows\Start` Menu\Programs\Startup\
::,gdot::git@github.com:collins-harry/dotfiles.git



; Close active window
#Backspace::
{
  WinClose("A")
}

; Add work sensitive ahk commands
#Include C:\Users\%A_UserName%\work.ahk
