/*
  This module enables some combos to manage apps' windows.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_window.ahk
#include %A_ScriptDir%\lib_highlight_active_window.ahk

WindowAutoExec:
  ; Global variable to control if a window has been snapped.
  global __snapped := false
return

;----------------------------------------------------------------------------
;                            Windows management
;----------------------------------------------------------------------------

; Activate next window of same app.
>!`::
<^`:: ActivateAppNextWindow()

; Close app.
#if true
  SC055 & q::
  <^q:: CloseWindow()
#if

; Restore or Maximize window
>#space:: __snapped := false
>#space up:: (!__snapped) ? ToggleMaximizeRestoreActiveWindow()

; Toggle windows always on top.
>#t:: ToggleActiveWindowAlwaysOnTop()

; Toggle window highlighting (it shows a red rectangle around the app).
>#r:: ManageToggleHighlightWindow()

; Go to recent active window.
~RAlt:: 
  activated := NTimesPressed("RAlt", 3,, Func("RecentActiveWindow"))
  ; Google Chrome wants an ESC sent to recover page focus when activating
  ; chrome.
  if activated AND WinActive("ahk_exe chrome.exe")
    Send, {Esc}
return
SC055 & Ralt:: RecentActiveWindow()

#if (!IsGridEnabled())
  ; Activate next window.
  <!Tab:: ActivateNextWindow()
  ; Activate prev window.
  <!+Tab:: ActivatePrevWindow()
#if

#if ((!IsGridEnabled()) OR (!IsFitToGridOn()))
  ; Snap window.
  >#l::    
  >#right:: SnapRight()
  >#k:: 
  >#up:: SnapUp()
  >#j:: 
  >#down:: SnapDown()
  >#h:: 
  >#left:: SnapLeft()
  >#m:: SnapUpLeft()
  >#,:: SnapUpRight()
  >#.:: SnapDownLeft()
  >#/:: SnapDownRight()

  ; Move window.
  >#+k:: 
  >#+up:: MoveActiveWindowUp()
  >#+j:: 
  >#+down:: MoveActiveWindowDown()
  >#+h:: 
  >#+left:: MoveActiveWindowLeft()
  >#+l:: 
  >#+right:: MoveActiveWindowRight()

  ; Resizing windows methods
  >#>!h:: 
  >#>!left:: ResizeActiveWindowRightBorderLeft()
  >#>!l:: 
  >#>!right:: ResizeActiveWindowRightBorderRight()
  >#>!k:: 
  >#>!up:: ResizeActiveWindowDownBorderUp()
  >#>!j::
  >#>!down:: ResizeActiveWindowDownBorderDown()
  >#>!+h:: 
  >#>!+left:: ResizeActiveWindowLeftBorderLeft()
  >#>!+l:: 
  >#>!+right:: ResizeActiveWindowLeftBorderRight()
  >#>!+k:: 
  >#>!+up:: ResizeActiveWindowUpBorderUp()
  >#>!+j::
  >#>!+down:: ResizeActiveWindowUpBorderDown()

  ; Swapping windows methods
  >#>^l:: 
  >#>^right:: SwapActiveWindowRight()
  >#>^h:: 
  >#>^left:: SwapActiveWindowLeft()
  >#>^k:: 
  >#>^up:: SwapActiveWindowUp()
  >#>^j:: 
  >#>^down:: SwapActiveWindowDown()
#if


;----------------------------------------------------------------------------
;                           Helper functions.
;----------------------------------------------------------------------------

/*
  Enable/disable window highlighting. It shows a tray tip with a message 
  showing if highlighting is on or off.
*/
ManageToggleHighlightWindow() {
  highlight := ToggleHighlightWindow()
  if (highlight)
    ShowTrayTip("Window highlighting ON",,2000)
  else
    ShowTrayTip("Window highlighting OFF",,2000)
}

/*
  Snap window to the half-top of the screen.
*/
SnapUp() {
  __snapped := true
  ResizeAndMoveActiveWindow(1, 0.5, 0, 0)
}

/*
  Snap window to the half-bottom of the screen.
*/
SnapDown() {
  __snapped := true
  ResizeAndMoveActiveWindow(1, 0.5, 0, 1)
}

/*
  Snap window to the half-left of the screen.
*/
SnapLeft() {
  __snapped := true
  ResizeAndMoveActiveWindow(0.5, 1, 0, 0)
}

/*
  Snap window to the half-right of the screen.
*/
SnapRight() {
  __snapped := true
  ResizeAndMoveActiveWindow(0.5, 1, 1, 0)
}

/*
  Snap window to the up-left corner of the screen.
*/
SnapUpLeft() {
  __snapped := true
  ResizeAndMoveActiveWindow(0.5, 0.5, 0, 0)
}

/*
  Snap window to the down-left corner of the screen.
*/
SnapDownLeft() {
  __snapped := true
  ResizeAndMoveActiveWindow(0.5, 0.5, 0, 1)
}

/*
  Snap window to the up-right corner of the screen.
*/
SnapUpRight() {
  __snapped := true
  ResizeAndMoveActiveWindow(0.5, 0.5, 1, 0)
}

/*
  Snap window to the down-right corner of the screen.
*/
SnapDownRight() {
  __snapped := true
  ResizeAndMoveActiveWindow(0.5, 0.5, 1, 1)
}

