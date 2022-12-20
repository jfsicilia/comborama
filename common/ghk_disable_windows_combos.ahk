/*
  This module disables some Microsoft Windows keyboard combos.

  @jfsicilia 2022.
*/

;-----------------------------------------------------------------------------
;                                 Hotkeys
;-----------------------------------------------------------------------------

; Avoid Win + Space to change language in language bar.
; NOTE: You can still reach functionality by using LWin + LCtrl + Spacebar,
; or LWin + Shift + Spacebar.
<#Space:: return

; Disable some combos with LWin &/| RWin globally. They are used adhoc in 
; different apps.
>#<#space:: return

; Disable some other key combos.
#l::
#!^Shift::
#^+Alt::
#!+Ctrl::
<#!^+::
>#!^+:: Send {Blind}{vk07}
#!^+y:: MsgBox, no more ymmmy
