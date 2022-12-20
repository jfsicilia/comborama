/*
  This module allow hotkeys for fast navigation on text.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_misc.ahk

; Avoid next combos in WindowsTerminal.
#If not (WinActive("ahk_exe WindowsTerminal.exe")) 
  
  ; Move to home/end
  <^Left:: Send {Home}
  <^Right:: Send {End}
  
  ; Select to home/end
  <^+Left:: Send {LCtrl up}+{Home}
  <^+Right:: Send {LCtrl up}+{End}
  
  ; Select to previous/next word
  <!+Left:: Send {RCtrl down}+{Left}{RCtrl up}
  <!+Right:: Send {RCtrl down}+{Right}{RCtrl up}

  ; Move to page up/down
  <!Up:: Send {PgUp}
  <!Down:: Send {PgDn}
#if

; Avoid using next combos in WindowsTerminal or OneCommander
#if not (WinActive("ahk_exe WindowsTerminal.exe") 
  || WinActive("ahk_exe OneCommander.exe"))

  ; Move to previous/next word
  <!Left:: Send {RCtrl down}{Left}{RCtrl up}
  <!Right:: Send {RCtrl down}{Right}{RCtrl up}
#if

; Avoid using next combos in explorer, open/save dialogs, WindowsTerminal,
; Everything and VSCode.
#if not (WinActive("ahk_class #32770") 
  || WinActive("ahk_class CabinetWClass") 
  || WinActive("ahk_class ExploreWClass") 
  || WinActive("ahk_exe WindowsTerminal.exe") 
  || WinActive("ahk_exe Code.exe") 
  || WinActive("ahk_exe gvim.exe") 
  || WinActive("ahk_exe OneCommander.exe") 
  || WinActive("ahk_class EVERYTHING"))

  ; Move to page up/down.
  Capslock & space:: ShiftSwitch("{pgdn}", "{pgup}")

  ; Move to begin/end of text.
  <^Up::>^Home
  <^Down::>^End
#if
