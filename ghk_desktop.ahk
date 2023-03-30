/*
  This module enables some key combos to go to desktops, move windows to 
  desktops, create desktops, delete desktops and compose a desktop.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_apps.ahk
#include %A_ScriptDir%\lib_grid.ahk
#include %A_ScriptDir%\lib_window.ahk
#include %A_ScriptDir%\lib_desktop.ahk

;-----------------------------------------------------------------------------
;                                 Hotkeys
;                            Desktop management
;-----------------------------------------------------------------------------

; Go to prev desktop.
>#<#h:: 
>#<#Left:: GoToPrevDesktop()

; Go to next desktop.
>#<#l:: 
>#<#Right:: GoToNextDesktop()

; Go to last recent desktop.
SC055 & LWin:: ToggleRecentDesktop()

; Move window to prev desktop.
>#<#+h:: 
>#<#+Left:: MoveActiveWindowToPrevDesktop()

; Move window to next desktop.
>#<#+l:: 
>#<#+Right:: MoveActiveWindowToNextDesktop()

; Create desktop.
>#<#n:: CreateDesktop()

; Delete desktop.
>#<#Backspace:: DeleteDesktop()

; Go to desktop by number.
>#<#1:: GoToDesktop(1)
>#<#2:: GoToDesktop(2)
>#<#3:: GoToDesktop(3)
>#<#4:: GoToDesktop(4)
>#<#5:: GoToDesktop(5)
>#<#6:: GoToDesktop(6)
>#<#7:: GoToDesktop(7)
>#<#8:: GoToDesktop(8)
>#<#9:: GoToDesktop(9)

; Move window to desktop by number.
>#<#+1:: MoveActiveWindowToDesktop(1)
>#<#+2:: MoveActiveWindowToDesktop(2)
>#<#+3:: MoveActiveWindowToDesktop(3)
>#<#+4:: MoveActiveWindowToDesktop(4)
>#<#+5:: MoveActiveWindowToDesktop(5)
>#<#+6:: MoveActiveWindowToDesktop(6)
>#<#+7:: MoveActiveWindowToDesktop(7)
>#<#+8:: MoveActiveWindowToDesktop(8)
>#<#+9:: MoveActiveWindowToDesktop(9)

;----------------------------------------------------------------------------
;                               Hotkeys
;                            Desktop Compose
;----------------------------------------------------------------------------

; Key combinations to launch several apps and compose them neatly in the 
; screen within a grid.

; Developer desktop with Visual Studio Code, Vim, WindowsTerminal, Chorme and FileExplorer.
>#+F1::
  grid := "7 8 (1,1,5,5) (1,6,5,8) (6,1,7,2) (6,3,7,6) (6,7,7,8)"
  EnableGrid(,, grid) 
  FocusOrLaunchFileExplorer()
  MoveActiveWindowToZone(, , 5)
  FocusOrLaunchVSCode(false)
  MoveActiveWindowToZone(, , 1)
  FocusOrLaunchWindowsTerminal(false)
  MoveActiveWindowToZone(, , 4)
  FocusOrLaunchVim(false)
  MoveActiveWindowToZone(, , 3)
  FocusOrLaunchFirefox(false)
  MoveActiveWindowToZone(, , 2)
  FocusOrLaunchChrome(false)
  MoveActiveWindowToZone(, , 2)
return

; CAM desktop with FileExplorer, Cura, Chrome and Fusion 360.
>#+F2::
  grid := "3 3 (1,1,3,2) (1,3,2,3) (3,3,3,3)"
  EnableGrid(,, grid) 
  FocusOrLaunchFileExplorer()
  MoveActiveWindowToZone(, , 3)
  sleep 200
  FocusOrLaunchCura(false)
  MoveActiveWindowToZone(, , 1)
  sleep 200
  FocusOrLaunchChrome(false)
  MoveActiveWindowToZone(, , 2)
  sleep 200
  FocusOrLaunchFusion360(false)
  MoveActiveWindowToZone(, , 1)
  sleep 200
return

; Vector Designer desktop with FileExplorer, Chrome and Affinity Designer.
>#+F3::
  grid := "3 3 (1,1,3,2) (1,3,2,3) (3,3,3,3)"
  EnableGrid(,, grid) 
  FocusOrLaunchFileExplorer()
  MoveActiveWindowToZone(, , 3)
  FocusOrLaunchChrome(false)
  MoveActiveWindowToZone(, , 2)
  FocusOrLaunchAffinityDesigner(false)
  MoveActiveWindowToZone(, , 1)
return

; Photo Designer desktop with FileExplorer, Chrome and Affinity Photo.
>#+F4::
  grid := "3 3 (1,1,3,2) (1,3,2,3) (3,3,3,3)"
  EnableGrid(,, grid) 
  FocusOrLaunchFileExplorer()
  MoveActiveWindowToZone(, , 3)
  FocusOrLaunchChrome(false)
  MoveActiveWindowToZone(, , 2)
  FocusOrLaunchAffinityPhoto(false)
  MoveActiveWindowToZone(, , 1)
return


