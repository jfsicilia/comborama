/*
  This module enables some key combos to work with more than one monitor.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_window.ahk

;----------------------------------------------------------------------------
;                            Monitor management
;----------------------------------------------------------------------------

; Goto next monitor
>#<#k:: 
>#<#up:: Msgbox, TODO GoToNextMonitor()
; Goto prev monitor
>#<#j:: 
>#<#down:: Msgbox, TODO GoToPrevMonitor()

; Move window to next monitor.
>#<#+k:: 
>#<#+up:: MoveActiveWindowToNextMonitor()
; Move window to next monitor.
>#<#+j:: 
>#<#+down:: MoveActiveWindowToNextMonitor()



