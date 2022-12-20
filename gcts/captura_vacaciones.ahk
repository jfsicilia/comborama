#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include %A_ScriptDir%\lib_apps.ahk

; It makes a screenshot of Chrome, paste it in whatsapp. Then captures text
; info in chrome at coordinates (198,158). Paste it in whatsapp. Then captures
; text info in chrome at coordinates (244, 268). Paste it in whatsapp. Finally
; it returns to chrome.
;<#<^<!v::
F12::
  CoordMode, Mouse, Window
  sleep, 300
  FocusOrLaunchChrome()
  sleep, 300
  ;send, #{PrintScreen}
  ; Capture only active window.
  send, !^{PrintScreen}
  sleep, 300
  FocusOrLaunchWhatsapp()
  sleep, 300
  send, ^v
  sleep, 300
  FocusOrLaunchChrome()
  sleep, 300
  MouseClick, left, 160, 230
  send, ^c
  sleep, 300
  FocusOrLaunchWhatsapp()
  sleep, 300
  cta := clipboard
  sendInput(trim(cta) . " tienes disponibles: ") 
  sleep, 300
  FocusOrLaunchChrome()
  sleep, 300
  MouseClick, left, 312, 340
  send, ^c
  sleep, 300
  FocusOrLaunchWhatsapp()
  sleep, 300
  ciclos := clipboard
  sendInput(ciclos)
  sleep, 300
  send, {Enter}
  sleep, 300
  FocusOrLaunchChrome()
return

;+<#<^<!s::
;  MouseClick, left, 894, 235
;  sleep, 1000
;  MouseClick, left, 270, 235
;  sleep, 1000
;  MouseClick, left, 1125, 235
;  sleep, 1000
;return
;
