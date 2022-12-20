#include %A_ScriptDir%\lib_window.ahk
#include %A_ScriptDir%\lib_highlight_active_window.ahk

WindowAutoExec:
  global snapped := false
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
>#space:: snapped := false
>#space up:: (!snapped) ? ToggleMaximizeRestoreActiveWindow()

; Toggle windows always on top.
>#t::
>#+space:: ToggleActiveWindowAlwaysOnTop()

; Toggle window highlighting.
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
*/
ManageToggleHighlightWindow() {
  highlight := ToggleHighlightWindow()
  if (highlight)
    ShowTrayTip("Window highlighting ON",,2000)
  else
    ShowTrayTip("Window highlighting OFF",,2000)
}

/*

*/
SnapUp() {
  snapped := true
  ResizeAndMoveActiveWindow(1, 0.5, 0, 0)
}

/*

*/
SnapDown() {
  snapped := true
  ResizeAndMoveActiveWindow(1, 0.5, 0, 1)
}

/*

*/
SnapLeft() {
  snapped := true
  ResizeAndMoveActiveWindow(0.5, 1, 0, 0)
}

/*

*/
SnapRight() {
  snapped := true
  ResizeAndMoveActiveWindow(0.5, 1, 1, 0)
}

/*

*/
SnapUpLeft() {
  snapped := true
  ResizeAndMoveActiveWindow(0.5, 0.5, 0, 0)
}

/*

*/
SnapDownLeft() {
  snapped := true
  ResizeAndMoveActiveWindow(0.5, 0.5, 0, 1)
}

/*

*/
SnapUpRight() {
  snapped := true
  ResizeAndMoveActiveWindow(0.5, 0.5, 1, 0)
}

/*

*/
SnapDownRight() {
  snapped := true
  ResizeAndMoveActiveWindow(0.5, 0.5, 1, 1)
}

