#HotkeyInterval 9000 
#MaxHotkeysPerInterval 1000
#SingleInstance Force

; Convert <> spanish key into RWin modifier.
*SC056:: 
  state := GetKeyState("Shift","P")
  if (!state)
    Send {Blind}{RWin Down}
  else
    Send {Blind}{Shift Down}{RWin Down}
return

*SC056 Up::
  state := GetKeyState("Shift","P")
  ; Check if SC056 has been used as a key modifier (true) or just has been 
  ; pressed (false).
  if (A_PriorHotkey != "*SC056") {
    if (!state)
      Send {Blind}{RWin Up}
    else
      Send {Blind}{Shift Up}{RWin Up}
  } else {
    ; SC056 has been pressed alone, released RWin doing nothing (vkE8 key).
    Send {Blind}{vkE8}{RWin Up} 
  }
  
return
