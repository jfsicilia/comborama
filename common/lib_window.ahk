#include %A_ScriptDir%\lib_misc.ahk
#include %A_ScriptDir%\lib_monitor.ahk
#include %A_ScriptDir%\lib_apps.ahk
#include %A_ScriptDir%\lib_active_window_polling.ahk
#include %A_ScriptDir%\lib_apps.ahk

LibWindowAutoExec:
  ; Number of pixels threshold to consider a window on the 
  ; top/left/bottom/right of the screen.
  DELTA := 5

  ; This type of windows are ignored as user app windows.
  _wndclassBlocklist := { "keypirinha_wndcls_run":true
                        , "NotifyIconOverflowWindow":true
                        , "Progman":true
                        , "WorkerW":true
                        , "Shell_TrayWnd":true
                        , "TaskListThumbnailWnd":true
                        , "Windows.UI.Core.CoreWindow":true }

  ; Previous active window handler (see __UpdatePrevActiveWindowCallback and
  ; RecentActiveWindow).
  global _prevActiveWindow := -1
  RegisterActiveWindowChangedCallback(Func("__UpdatePrevActiveWindowCallback"))

  ; Array with the list of user app windows.
  _windowList := []
  ; Pointer (index) to the current active window in _windowList.
  _windowListPointer := 0
  RegisterActiveWindowChangedCallback(Func("__UpdateWindowListCallback"))
return

;--------------------------------------------------------------
;                 Move active window
;--------------------------------------------------------------

/*	
  Move active window left in the screen grid.
*/
MoveActiveWindowLeft()
{
  GetActiveMonitorScreenBounds(top, left, bottom, right, width, height)
  global DELTA
  WinGetPos, x, y, w, h, A
  if (x-w >= left) 
    WinMove, A, , x-w, y
  else if (x > left+DELTA)
      WinMove, A, , left, y
    else
      WinMove, A, , right-w, y
}

/*
  Move active window right in the screen grid.
*/
MoveActiveWindowRight()
{
  GetActiveMonitorScreenBounds(top, left, bottom, right, width, height)
  global DELTA
  WinGetPos, x, y, w, h, A
  if (x+2*w <= right) 
      WinMove, A, , x+w,y
  else if (x+w < right-DELTA)
    WinMove, A, , x+(right-(x+w)), y
  else 
    WinMove, A, , left, y
}

/*
  Move active window up in the screen grid.
*/
MoveActiveWindowUp()
{
  GetActiveMonitorScreenBounds(top, left, bottom, right, width, height)
  global DELTA
  WinGetPos, x, y, w, h, A
  if (y-h >= top) 
    WinMove, A, , x, y-h
  else if (y > top+DELTA)
    WinMove, A, , x, top 
  else
    WinMove, A, , x, bottom-h 
}

/*
  Move active window down in the screen grid.
*/
MoveActiveWindowDown()
{
  GetActiveMonitorScreenBounds(top, left, bottom, right, width, height)
  global DELTA
  WinGetPos, x, y, w, h, A
  if (y+2*h <= bottom) 
    WinMove, A, , x, y+h
  else if (y+h < bottom-DELTA)
    WinMove, A, , x, y+(bottom-(y+h))  
  else
    WinMove, A, , x, top
}

__ResizeActiveWindow(ComputeXY, divisions:=16) {
  GetActiveMonitorScreenBounds(top, left, bottom, right, width, height)
  global DELTA
  WinGetPos, x1, y1, w, h, A

  x2 := x1 + w
  y2 := y1 + h
  stepX := width/divisions
  stepY := height/divisions
  ComputeXY.Call(x1, y1, x2, y2, stepX, stepY, top, left, bottom, right)

  WinMove, A, , x1, y1, x2-x1, y2-y1 
}

__LeftBorderLeft(ByRef x1, ByRef y1, ByRef x2, ByRef y2, stepX, stepY, top, left, bottom, right) {
  x1 := (x1 - stepX > left)? x1 - stepX : left
}
__LeftBorderRight(ByRef x1, ByRef y1, ByRef x2, ByRef y2, stepX, stepY, top, left, bottom, right) {
  x1 := (x1 + stepX < x2 - stepX)? x1 + stepX :  x2 - stepX
}
__RightBorderLeft(ByRef x1, ByRef y1, ByRef x2, ByRef y2, stepX, stepY, top, left, bottom, right) {
  x2 := (x2 - stepX > x1 + stepX)? x2 - stepX :  x1 + stepX
}
__RightBorderRight(ByRef x1, ByRef y1, ByRef x2, ByRef y2, stepX, stepY, top, left, bottom, right) {
  x2 := (x2 + stepX < right)? x2 + stepX :  right
}
__UpBorderUp(ByRef x1, ByRef y1, ByRef x2, ByRef y2, stepX, stepY, top, left, bottom, right) {
  y1 := (y1 - stepY > top)? y1 - stepY : top
}
__UpBorderDown(ByRef x1, ByRef y1, ByRef x2, ByRef y2, stepX, stepY, top, left, bottom, right) {
  y1 := (y1 + stepY < y2 - stepY)? y1 + stepY :  y2 - stepY
}
__DownBorderUp(ByRef x1, ByRef y1, ByRef x2, ByRef y2, stepX, stepY, top, left, bottom, right) {
  y2 := (y2 - stepY > y1 + stepY)? y2 - stepY :  y1 + stepY
}
__DownBorderDown(ByRef x1, ByRef y1, ByRef x2, ByRef y2, stepX, stepY, top, left, bottom, right) {
  y2 := (y2 + stepY < bottom)? y2 + stepY:  bottom
}

ResizeActiveWindowLeftBorderLeft(divisions:=16) {
  __ResizeActiveWindow(Func("__LeftBorderLeft"), divisions)
}
ResizeActiveWindowLeftBorderRight(divisions:=16) {
  __ResizeActiveWindow(Func("__LeftBorderRight"), divisions)
}

ResizeActiveWindowRightBorderLeft(divisions:=16) {
  __ResizeActiveWindow(Func("__RightBorderLeft"), divisions)
}

ResizeActiveWindowRightBorderRight(divisions:=16) {
  __ResizeActiveWindow(Func("__RightBorderRight"), divisions)
}

ResizeActiveWindowUpBorderUp(divisions:=16) {
  __ResizeActiveWindow(Func("__UpBorderUp"), divisions)
}

ResizeActiveWindowUpBorderDown(divisions:=16) {
  __ResizeActiveWindow(Func("__UpBorderDown"), divisions)
}

ResizeActiveWindowDownBorderUp(divisions:=16) {
  __ResizeActiveWindow(Func("__DownBorderUp"), divisions)
}
ResizeActiveWindowDownBorderDown(divisions:=16) {
  __ResizeActiveWindow(Func("__DownBorderDown"), divisions)
}

__TargetCandidate(IsBetterCandidateFunc, TargetFunc) {
  active := []
  active.hwnd := WinExist("A")
  WinGetPos, x, y, w, h, A
  active.x := x, active.y := y, active.w := w, active.h := h

  hwnds := GetWindowList()
  candidate := []
  candidate.hwnd := ""
  minDiffX := 999999
  minDiffY := 999999
  for i, hwnd in hwnds {
    if (hwnd = active.hwnd)
      continue
    WinGetPos, x, y, w, h, % "ahk_id " hwnd

    if (IsBetterCandidateFunc.Call(x, y, active.x, active.y, minDiffX, minDiffY)) {
      candidate.hwnd := hwnd
      candidate.x := x, candidate.y := y, candidate.w := w, candidate.h := h
      minDiffX := Abs(candidate.x - active.x)
      minDiffY := Abs(candidate.y - active.y)
    }
  }
  if (candidate.hwnd = "")
    return

  TargetFunc.Call(active, candidate)
}

__ActivateWindow(oldFocusWnd, newFocusWnd) {
  WinActivate, % "ahk_id " newFocusWnd.hwnd
}

__SwapWindows(wndA, wndB) {
  WinActivate, % "ahk_id " wndB.hwnd
  WinMove, % "ahk_id " wndB.hwnd, , wndA.x, wndA.y, wndA.w, wndA.h
  Sleep, 300  ; Give time to polling to update internal information.
  WinActivate, % "ahk_id " wndA.hwnd
  WinMove, % "ahk_id " wndA.hwnd, , wndB.x, wndB.y, wndB.w, wndB.h
}

__IsBetterCandidateLeft(x1, y1, x2, y2, minDiffX, minDiffY) {
  if (!Between(y2 - y1, 0, minDiffY))
    return false
  ; If there is a draw, priorize closer window in x.
  if ((y2 - y1 = minDiffY) AND (!Between(Abs(x1 - x2), 0, minDiffX)))
    return false
  return true
}
__IsBetterCandidateRight(x1, y1, x2, y2, minDiffX, minDiffY) {
  if (!Between(y1 - y2, 0, minDiffY))
    return false
  ; If there is a draw, priorize closer window in x.
  if ((y1 - y2 = minDiffY) AND (!Between(Abs(x1 - x2), 0, minDiffX)))
    return false
  return true
}
__IsBetterCandidateUp(x1, y1, x2, y2, minDiffX, minDiffY) {
  if (!Between(x2 - x1, 0, minDiffX)) 
    return false
  ; If there is a draw, priorize closer window in y.
  if ((x2 - x1 = minDiffX) AND (!Between(Abs(y1 - y2), 0, minDiffY)))
    return false
  return true
}
__IsBetterCandidateDown(x1, y1, x2, y2, minDiffX, minDiffY) {
  if (!Between(x1 - x2, 0, minDiffX))
    return false
  ; If there is a draw, priorize closer window in y.
  if ((x1 - x2 = minDiffX) AND (!Between(Abs(y1 - y2), 0, minDiffY)))
    return false
  return true
}

ActivateWindowLeft() {
  __TargetCandidate(Func("__IsBetterCandidateLeft"), Func("__ActivateWindow"))
}
ActivateWindowRight() {
  __TargetCandidate(Func("__IsBetterCandidateRight"), Func("__ActivateWindow"))
}
ActivateWindowUp() {
  __TargetCandidate(Func("__IsBetterCandidateUp"), Func("__ActivateWindow"))
}
ActivateWindowDown() {
  __TargetCandidate(Func("__IsBetterCandidateDown"), Func("__ActivateWindow"))
}
SwapActiveWindowLeft() {
  __TargetCandidate(Func("__IsBetterCandidateLeft"), Func("__SwapWindows"))
}
SwapActiveWindowRight() {
  __TargetCandidate(Func("__IsBetterCandidateRight"), Func("__SwapWindows"))
}
SwapActiveWindowUp() {
  __TargetCandidate(Func("__IsBetterCandidateUp"), Func("__SwapWindows"))
}
SwapActiveWindowDown() {
  __TargetCandidate(Func("__IsBetterCandidateDown"), Func("__SwapWindows"))
}

;--------------------------------------------------------------
;                   Resize/move active window
;--------------------------------------------------------------

/*
  Resize and/or move active window. Set the window size with X_ratio, and 
  set window's postion with row and col in the screens grid.
  wRatio - New window_width/screen_width (e.g. 1 - whole screen, 0.5 - half screen size)
  hRatio - New window_height/screen_height (e.g. 1 - whole screen, 0.5 - half screen size)
  row - Row in the screen grid (0..max_rows-1).
  col - Col in the screen grid (0..max_cols-1).
*/
ResizeAndMoveActiveWindow(wRatio, hRatio, row, col)
{
  GetActiveMonitorScreenBounds(top, left, bottom, right, width, height)
  WinMove,A,, left + width * wRatio * row, top + height * hRatio * col, width * wRatio, height * hRatio
}

/*
  Resize and/or move active window. Set the window size wndCols/scrCols width
  and wndRows/scrRows height. Set window's position to (row,col) in the
  screen grid.
  wndRows - Number of screen rows the window occupies (1..scr_row).
  scrRows - Number of rows the screen is divived to.
  row - Row in the screen grid where to set the window (0..scrRows-1).
  wndCols - Number of screen cols the window occupies (1..scrCols).
  scrCols - Number of cols the screen is divived to.
  col - Col in the screen grid where to set the window (0..scrCols-1).
*/
ResizeAndMoveActiveWindow2(wndRows, scrRows, row, wndCols, scrCols, col) {
  GetActiveMonitorScreenBounds(top, left, bottom, right, width, height)
  WinMove,A,, left + width * 1/scrCols * col, top + height * 1/scrRows * row, width * wndCols/scrCols , height * wndRows/scrRows
}

;--------------------------------------------------------------
;                   Activate next window.
;--------------------------------------------------------------

/*

*/
ActivateNextWindow() {
  global _windowListPointer, _windowList

  _windowListPointer := (_windowListPointer = _windowList.MaxIndex())? 1: _windowListPointer+1
  winTitle := "ahk_id " . _windowList[_windowListPointer]
  WinActivate, %winTitle%
}

/*

*/
ActivatePrevWindow() {
  global _windowListPointer, _windowList

  _windowListPointer := (_windowListPointer <= 1) ? _windowList.Length() : _windowListPointer-1 
  winTitle := "ahk_id " . _windowList[_windowListPointer]
  WinActivate, %winTitle%
}

; ----------------------------------------------------------------------------
;                        Helper functions.
; ----------------------------------------------------------------------------

/*
  Get screen bounds of the active window's monitor.
  Returns - top, left, bottom, right, width and height.
*/
GetActiveMonitorScreenBounds(ByRef top, ByRef left, ByRef bottom, ByRef right, ByRef width, ByRef height) 
{
  WinGet, maximized, MinMax, A
  if (maximized)
    WinRestore, A
  WinGet, hwnd, ID, A
  GetScreenBounds(GetMonitorIndexFromWindow(hwnd), top, left, bottom, right, width, height)
}

/*
  Get screen bounds of specified monitor.
  monitor - Monitor to checkk (1..N_MONITORS).
  Returns top, left, bottom, right, width and height.
*/
GetScreenBounds(monitor, ByRef top, ByRef left, ByRef bottom, ByRef right, ByRef width, ByRef height) 
{
  SysGet, Scr, MonitorWorkArea, %monitor%
  top := ScrTop
  left := ScrLeft
  bottom := ScrBottom
  right := ScrRight
  width := right - left
  height := bottom - top
}

/*
  Returns an array with the hwnds of the current visible windows.
*/
GetWindowList() {
  WinGet windows, List
  wndList := []
  Loop %windows%
  {
    hwnd := windows%A_Index%
    if (!IsWindowUserApp(hwnd))
      continue

    wndList.Push(hwnd)
  }
  return wndList
}

/*
  Returns 1 if window is visible. 0 otherwise.
*/
IsWindowVisible(hwnd) {
  winTitle := "ahk_id " . hwnd

  ; If it hasn't title it is not a "visible" window.
  WinGetTitle title, %winTitle%
  if (title = "")  
    return false
  
  ; If window is minimized it is not a "visible" window.
  WinGetClass class, %winTitle%
  if (class = "ApplicationFrameWindow") 
  {
    WinGetText, text, %winTitle%
    if (text = "") 
    {
      WinGet, style, style, %winTitle%
      if !(style = "0xB4CF0000")	 ; the window isn't minimized
        return false
    }
  }

  ; If the window doesn't have a title bar it is not a "visible" window.
	WinGet, style, Style, %winTitle% 
  if !(style & 0xC00000) 
    return false ; If title not contains ...  ; add exceptions

  ; Check if WS_VISIBLE is set or not.
	Transform, result, BitAnd, %style%, 0x10000000 ; 0x10000000 is WS_VISIBLE. 
  return (result != 0) ? true : false
}

/*
  Returns 1 if window is a normal user app window. 0 otherwise.
*/
IsWindowUserApp(hwnd) {
  WS_EX_CONTROLPARENT := 0x10000
  WS_EX_APPWINDOW := 0x40000
  WS_EX_TOOLWINDOW := 0x80
  WS_DISABLED := 0x8000000
  WS_POPUP := 0x80000000
  EXPLORER_DIALOG := "#32770"

  winTitle := "ahk_id " . hwnd
  WinGetTitle title, %winTitle%
  WinGet, style, Style, %winTitle%
  if ((style & WS_DISABLED) OR !(title)) ; skip unimportant windows 
    return false

  WinGet, exStyle, ExStyle, %winTitle%
  WinGetClass, winClass, %winTitle%
  parent := int2hex2(DllCall("GetParent", "uint", hwnd))
  WinGet, parentStyle, Style, ahk_id %parent%

  if ((exStyle & WS_EX_TOOLWINDOW)
    OR ((exStyle & WS_EX_CONTROLPARENT) AND !(style & WS_POPUP) AND !(winClass = EXPLORER_DIALOG) AND !(exStyle & WS_EX_APPWINDOW)) ; pspad child window excluded
    OR ((style & WS_POPUP) AND (parent) AND ((parentStyle & WS_DISABLED) =0))) ; notepad find window excluded ; note - some windows result in blank value so must test for zero instead of using NOT operator!
    return false

  if (IsClassBlocklisted(winClass))
    return false

  return true
}

/*
  Returns true if the class has been blocklisted. Some windows classes are
  not required to set them in the screen grid, therefore have been blocklisted
*/
IsClassBlocklisted(wndclass) {
  global _wndclassBlocklist
  return _wndclassBlocklist[wndclass]
}

/*
  Maximizes/restores the active window.
*/
ToggleMaximizeRestoreActiveWindow() {
  WinGet, maximized, MinMax, A
  if (maximized)
    WinRestore, A
  else
    WinMaximize, A
}

/*
 Activates previous active window if available. Each time a new window is
 activated, the previous one is stored. This function restores this previous
 activated window.
*/
RecentActiveWindow() {
  global _prevActiveWindow
  FocusOrLaunchApp(, "ahk_id " . _prevActiveWindow)
}

/*
  Toggles if the active window is always on top or not.
*/
ToggleActiveWindowAlwaysOnTop() {
  WinGetTitle, activeWindow, A
	if IsWindowAlwaysOnTop(activeWindow) {
		notificationMessage := "The window """ . activeWindow . """ is now always on top."
		notificationIcon := 16 + 1 ; No notification sound (16) + Info icon (1)
	}
	else {
		notificationMessage := "The window """ . activeWindow . """ is no longer always on top."
		notificationIcon := 16 + 2 ; No notification sound (16) + Warning icon (2)
	}
	Winset, Alwaysontop, , A
  ShowTrayTip(notificationMessage, notificationIcon)
}

/*
  windowTitle - Window title to find (eg. "ahk_exe chrome.exe").
  Returns true if window is alwyas on top. False otherwise.
*/
IsWindowAlwaysOnTop(windowTitle) {
  WinGet, windowStyle, ExStyle, %windowTitle%
  isWindowAlwaysOnTop := (windowStyle & 0x8) ? false : true ; 0x8 is WS_EX_TOPMOST.
  return isWindowAlwaysOnTop
}

; ----------------------------------------------------------------------------
;                             Callback funtions
; ----------------------------------------------------------------------------

/*

*/
__UpdateWindowListCallback(active, prev) {
  global _windowList, _windowListPointer
  windowList := GetWindowList()
  if ((_windowList.MaxIndex() != windowList.MaxIndex()) OR (active.desktop != prev.desktop))
    _windowList := windowList

  for i, hwnd in _windowList
    if (hwnd == active.hwnd) {
      _windowListPointer := i
      break
    }
}

/*

*/
__UpdatePrevActiveWindowCallback(active, prev) {
  global _prevActiveWindow

  ; Only update previous active window if hwnd has changed and 
  ; previous active window is a user app window.
  if ((active.hwnd != prev.hwnd) AND (IsWindowUserApp(prev.hwnd)))
    _prevActiveWindow := prev.hwnd

  ; ----------------------------- Debugging.--------------------------------
  if (!IsWindowUserApp(active.hwnd))
    return
  winTitle := "ahk_id " . active.hwnd
  WinGetClass, class, %winTitle%
  WinGetTitle, title, %winTitle%
  ;LOG.log("Switched from [" . int2hex2(_prevActiveWindow) . "] -> [" . int2hex2(active.hwnd) . " ( " . class . " ) (" . title . ")]")
  ; ------------------------------------------------------------------------
}

; ----------------------------------------------------------------------------
;                            Debugging functions.
; ----------------------------------------------------------------------------

/*
  Shows all "visible" windows.
*/
__DumpAllWindows() {
  global _windowList, _windowListPointer
  list := _windowList
  s := "Pointer = " . _windowListPointer . "`n"
  for i, hwnd in list {
    if (i = _windowListPointer)
      s .= "-> "
    winTitle := "ahk_id " . hwnd
    WinGetTitle, title, %winTitle%
    s .= "[" . A_Index . "]= " . hwnd . " (" . title . ")`n"
  }
  MsgBox, % s
}

