#include %A_ScriptDir%\lib_misc.ahk
#include %A_ScriptDir%\lib_monitor.ahk
#include %A_ScriptDir%\lib_apps.ahk
#include %A_ScriptDir%\lib_active_window_polling.ahk
#include %A_ScriptDir%\lib_apps.ahk

LibWindowAutoExec:
  ; Number of pixels threshold to consider a window on the 
  ; top/left/bottom/right of the screen.
  _DELTA := 5

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
  Move active window left. It tries to move w pixels to the left, where w
  is the width in pixels of the window. If the window is on the left of the
  screen, it is moved to the right side of the screen.
*/
MoveActiveWindowLeft()
{
  GetActiveMonitorScreenBounds(top, left, bottom, right, width, height)
  global _DELTA
  WinGetPos, x, y, w, h, A
  ; If there's more than window pixels width (w) between left border of screen 
  ; and left border of window, move window w pixels to the left.
  if (x-w >= left) 
    WinMove, A, , x-w, y
  ; If there's less than window pixels width (w) and more than _DELTA pixels
  ; between left border of screen and left border of window, move window 
  ; to the left border of the screen. 
  else if (x > left+_DELTA)
    WinMove, A, , left, y
  ; If window is on the left border of the screen, move window's right border
  ; to the right border of the screen.
  else
    WinMove, A, , right-w, y
}

/*	
  Move active window right. It tries to move w pixels to the right, where w
  is the width in pixels of the window. If the window is on the right of the
  screen, it is moved to the left side of the screen.
*/
MoveActiveWindowRight()
{
  GetActiveMonitorScreenBounds(top, left, bottom, right, width, height)
  global _DELTA
  WinGetPos, x, y, w, h, A
  ; If there's more than window pixels width (w) between right border of screen 
  ; and right border of window, move window w pixels to the right.
  if (x+2*w <= right) 
      WinMove, A, , x+w,y
  ; If there's less than window pixels width (w) and more than _DELTA pixels
  ; between right border of screen and right border of window, move window 
  ; to the right border of the screen. 
  else if (x+w < right-_DELTA)
    WinMove, A, , x+(right-(x+w)), y
  ; If window is on the right border of the screen, move window's left border
  ; to the left border of the screen.
  else 
    WinMove, A, , left, y
}

/*
  Move active window up. It tries to move h pixels up, where h
  is the height in pixels of the window. If the window is on the top of the
  screen, it is moved to the bottom side of the screen.
*/
MoveActiveWindowUp()
{
  GetActiveMonitorScreenBounds(top, left, bottom, right, width, height)
  global _DELTA
  WinGetPos, x, y, w, h, A
  ; If there's more than window pixels height (h) between top border of screen 
  ; and top border of window, move window h pixels up.
  if (y-h >= top) 
    WinMove, A, , x, y-h
  ; If there's less than window pixels height (h) and more than _DELTA pixels
  ; between top border of screen and top border of window, move window 
  ; to the top border of the screen. 
  else if (y > top+_DELTA)
    WinMove, A, , x, top 
  ; If window is on the top border of the screen, move window's bottom border
  ; to the bottom border of the screen.
  else
    WinMove, A, , x, bottom-h 
}

/*
  Move active window down. It tries to move h pixels down, where h
  is the height in pixels of the window. If the window is on the bottom of the
  screen, it is moved to the top side of the screen.
*/
MoveActiveWindowDown()
{
  GetActiveMonitorScreenBounds(top, left, bottom, right, width, height)
  global _DELTA
  WinGetPos, x, y, w, h, A
  ; If there's more than window pixels height (h) between bottom border of screen 
  ; and bottom border of window, move window h pixels down.
  if (y+2*h <= bottom) 
    WinMove, A, , x, y+h
  ; If there's less than window pixels height (h) and more than _DELTA pixels
  ; between bottom border of screen and bottom border of window, move window 
  ; to the bottom border of the screen. 
  else if (y+h < bottom-_DELTA)
    WinMove, A, , x, y+(bottom-(y+h))  
  ; If window is on the bottom border of the screen, move window's top border
  ; to the top border of the screen.
  else
    WinMove, A, , x, top
}

/*
  Resizes current active window. ComputeXY parameter 
  ComputeXY -- Function to call to modify left/right/top/bottom border of the
               active window. This function receives parameters: x1, y1, x2, y2
               (x1/y1 top left corner of window, x2/y2 bottom right corner of
               window), stepX, stepY (resize step), top, left, bottom, right
               (screen pixel coordinates). x1, y1, x2 and y2 are ByRef 
               paramenters, so they are modified inside the function and
               returned new values.
  divisions -- Value used to calculate resize steps. stepX will be 
               width/divisions and stepY will be height/divisions.
*/
__ResizeActiveWindow(ComputeXY, divisions:=16) {
  GetActiveMonitorScreenBounds(top, left, bottom, right, width, height)
  global _DELTA
  WinGetPos, x1, y1, w, h, A

  ; Calculate bottom/right coordinate of window.
  x2 := x1 + w
  y2 := y1 + h
  ; Calculate resize steps.
  stepX := width/divisions
  stepY := height/divisions
  ; Get new x1, y1, x2 and y2 (the new resized window coordinates).
  ComputeXY.Call(x1, y1, x2, y2, stepX, stepY, top, left, bottom, right)

  WinMove, A, , x1, y1, x2-x1, y2-y1 
}

/*
  Function to get the new coordinates equivalent to a left move of the left
  border of a window.
  x1, y1, x2, y2 -- x1/y1 top left corner of window. x2/y2 bottom right corner
                    of window.
  stepX, stepY -- Horizontal and vertical resize step.
  top, left, bottom, right -- Screen pixel coordinates.
  return -- new x1, y1, x2, y2 with the correspondent move.
*/
__LeftBorderLeft(ByRef x1, ByRef y1, ByRef x2, ByRef y2, stepX, stepY, top, left, bottom, right) {
  x1 := (x1 - stepX > left)? x1 - stepX : left
}

/*
  Function to get the new coordinates equivalent to a right move of the left
  border of a window.
  x1, y1, x2, y2 -- x1/y1 top left corner of window. x2/y2 bottom right corner
                    of window.
  stepX, stepY -- Horizontal and vertical resize step.
  top, left, bottom, right -- Screen pixel coordinates.
  return -- new x1, y1, x2, y2 with the correspondent move.
*/
__LeftBorderRight(ByRef x1, ByRef y1, ByRef x2, ByRef y2, stepX, stepY, top, left, bottom, right) {
  x1 := (x1 + stepX < x2 - stepX)? x1 + stepX :  x2 - stepX
}

;/*
;  Function to get the new coordinates equivalent to a right move of the left
;  border of a window.
;  x1, y1, x2, y2 -- x1/y1 top left corner of window. x2/y2 bottom right corner
;                    of window.
;  stepX, stepY -- Horizontal and vertical resize step.
;  top, left, bottom, right -- Screen pixel coordinates.
;  return -- new x1, y1, x2, y2 with the correspondent move.
;*/
;__RightBorderLeft(ByRef x1, ByRef y1, ByRef x2, ByRef y2, stepX, stepY, top, left, bottom, right) {
;  x2 := (x2 - stepX > x1 + stepX)? x2 - stepX :  x1 + stepX
;}
;
/*
  Function to get the new coordinates equivalent to a left move of the right
  border of a window.
  x1, y1, x2, y2 -- x1/y1 top left corner of window. x2/y2 bottom right corner
                    of window.
  stepX, stepY -- Horizontal and vertical resize step.
  top, left, bottom, right -- Screen pixel coordinates.
  return -- new x1, y1, x2, y2 with the correspondent move.
*/
__RightBorderLeft(ByRef x1, ByRef y1, ByRef x2, ByRef y2, stepX, stepY, top, left, bottom, right) {
  x2 := (x2 - stepX > x1 + stepX)? x2 - stepX :  x1 + stepX
}

/*
  Function to get the new coordinates equivalent to a right move of the right
  border of a window.
  x1, y1, x2, y2 -- x1/y1 top left corner of window. x2/y2 bottom right corner
                    of window.
  stepX, stepY -- Horizontal and vertical resize step.
  top, left, bottom, right -- Screen pixel coordinates.
  return -- new x1, y1, x2, y2 with the correspondent move.
*/
__RightBorderRight(ByRef x1, ByRef y1, ByRef x2, ByRef y2, stepX, stepY, top, left, bottom, right) {
  x2 := (x2 + stepX < right)? x2 + stepX :  right
}

/*
  Function to get the new coordinates equivalent to a up move of the top
  border of a window.
  x1, y1, x2, y2 -- x1/y1 top left corner of window. x2/y2 bottom right corner
                    of window.
  stepX, stepY -- Horizontal and vertical resize step.
  top, left, bottom, right -- Screen pixel coordinates.
  return -- new x1, y1, x2, y2 with the correspondent move.
*/
__UpBorderUp(ByRef x1, ByRef y1, ByRef x2, ByRef y2, stepX, stepY, top, left, bottom, right) {
  y1 := (y1 - stepY > top)? y1 - stepY : top
}

/*
  Function to get the new coordinates equivalent to a down move of the top
  border of a window.
  x1, y1, x2, y2 -- x1/y1 top left corner of window. x2/y2 bottom right corner
                    of window.
  stepX, stepY -- Horizontal and vertical resize step.
  top, left, bottom, right -- Screen pixel coordinates.
  return -- new x1, y1, x2, y2 with the correspondent move.
*/
__UpBorderDown(ByRef x1, ByRef y1, ByRef x2, ByRef y2, stepX, stepY, top, left, bottom, right) {
  y1 := (y1 + stepY < y2 - stepY)? y1 + stepY :  y2 - stepY
}

/*
  Function to get the new coordinates equivalent to a up move of the bottom
  border of a window.
  x1, y1, x2, y2 -- x1/y1 top left corner of window. x2/y2 bottom right corner
                    of window.
  stepX, stepY -- Horizontal and vertical resize step.
  top, left, bottom, right -- Screen pixel coordinates.
  return -- new x1, y1, x2, y2 with the correspondent move.
*/
__DownBorderUp(ByRef x1, ByRef y1, ByRef x2, ByRef y2, stepX, stepY, top, left, bottom, right) {
  y2 := (y2 - stepY > y1 + stepY)? y2 - stepY :  y1 + stepY
}

/*
  Function to get the new coordinates equivalent to a down move of the bottom
  border of a window.
  x1, y1, x2, y2 -- x1/y1 top left corner of window. x2/y2 bottom right corner
                    of window.
  stepX, stepY -- Horizontal and vertical resize step.
  top, left, bottom, right -- Screen pixel coordinates.
  return -- new x1, y1, x2, y2 with the correspondent move.
*/
__DownBorderDown(ByRef x1, ByRef y1, ByRef x2, ByRef y2, stepX, stepY, top, left, bottom, right) {
  y2 := (y2 + stepY < bottom)? y2 + stepY:  bottom
}

/*
  Resize active window, moving left the left border.
  divisions -- Value used to calculate resize steps. The step will be 
               width/divisions.
*/
ResizeActiveWindowLeftBorderLeft(divisions:=16) {
  __ResizeActiveWindow(Func("__LeftBorderLeft"), divisions)
}

/*
  Resize active window, moving right the left border.
  divisions -- Value used to calculate resize steps. The step will be 
               width/divisions.
*/
ResizeActiveWindowLeftBorderRight(divisions:=16) {
  __ResizeActiveWindow(Func("__LeftBorderRight"), divisions)
}

/*
  Resize active window, moving left the right border.
  divisions -- Value used to calculate resize steps. The step will be 
               width/divisions.
*/
ResizeActiveWindowRightBorderLeft(divisions:=16) {
  __ResizeActiveWindow(Func("__RightBorderLeft"), divisions)
}

/*
  Resize active window, moving right the right border.
  divisions -- Value used to calculate resize steps. The step will be 
               width/divisions.
*/
ResizeActiveWindowRightBorderRight(divisions:=16) {
  __ResizeActiveWindow(Func("__RightBorderRight"), divisions)
}

/*
  Resize active window, moving up the top border.
  divisions -- Value used to calculate resize steps. The step will be 
               height/divisions.
*/
ResizeActiveWindowUpBorderUp(divisions:=16) {
  __ResizeActiveWindow(Func("__UpBorderUp"), divisions)
}

/*
  Resize active window, moving down the top border.
  divisions -- Value used to calculate resize steps. The step will be 
               height/divisions.
*/
ResizeActiveWindowUpBorderDown(divisions:=16) {
  __ResizeActiveWindow(Func("__UpBorderDown"), divisions)
}

/*
  Resize active window, moving up the bottom border.
  divisions -- Value used to calculate resize steps. The step will be 
               height/divisions.
*/
ResizeActiveWindowDownBorderUp(divisions:=16) {
  __ResizeActiveWindow(Func("__DownBorderUp"), divisions)
}

/*
  Resize active window, moving down the bottom border.
  divisions -- Value used to calculate resize steps. The step will be 
               height/divisions.
*/
ResizeActiveWindowDownBorderDown(divisions:=16) {
  __ResizeActiveWindow(Func("__DownBorderDown"), divisions)
}

/*
  Gets the best candidate window, in relation to the current active window,
  to apply a function. 
  IsBetterCandidateFunc -- This function returns true or false, if a new window
                           is better candidate or not. This function receives
                           coordinates x/y of the candidate, coordinates x/y
                           of the active window and the current minimum
                           difference in X and Y from former candidates until
                           this moment.
  TargetFunc -- Function to call with the best candidate. This function 
                receives an object with the active window information
                (hwnd, x, y, width, height) and an object with the candidate
                window information (hwnd, x, y, width, height).
*/
__TargetCandidate(IsBetterCandidateFunc, TargetFunc) {
  active := []
  active.hwnd := WinExist("A")
  WinGetPos, x, y, w, h, A
  active.x := x, active.y := y, active.w := w, active.h := h

  ; Get an array of all the opened windows, and check which of them
  ; is the best candidate (closer in X and Y).
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

/*
  Function that will activate the newFocusWnd.
  oldFocusWnd -- Object with former active window. Properties of this object
                 are: hwnd, x, y, w, h.
  newFocusWnd -- Object with new active window. Properties of this object
                 are: hwnd, x, y, w, h.
*/
__ActivateWindow(oldFocusWnd, newFocusWnd) {
  WinActivate, % "ahk_id " newFocusWnd.hwnd
}

/*
  Function that will swap wndA with wndB.
  wndA -- Object with A window information. Properties of this object
                 are: hwnd, x, y, w, h.
  wndB -- Object with B window information. Properties of this object
                 are: hwnd, x, y, w, h.
*/
__SwapWindows(wndA, wndB) {
  WinActivate, % "ahk_id " wndB.hwnd
  WinMove, % "ahk_id " wndB.hwnd, , wndA.x, wndA.y, wndA.w, wndA.h
  Sleep, 300  ; Give time to polling to update internal information.
  WinActivate, % "ahk_id " wndA.hwnd
  WinMove, % "ahk_id " wndA.hwnd, , wndB.x, wndB.y, wndB.w, wndB.h
}

/*
  This function checks if the window defined by coordinates x1, y1, x2, y2
  is a better candidate to the left of the active window.
  x1 -- candidate left coordinate
  y1 -- candidate top coordinate 
  x2 -- reference left coordinate
  y2 -- reference top coordinate
  minDiffX -- X difference goal to beat.
  minDiffY -- Y difference goal to beat.
  return True if current x1/y1 difference with x1/y1 beats minDiffX and 
         minDiffY. False otherwise.
*/
__IsBetterCandidateLeft(x1, y1, x2, y2, minDiffX, minDiffY) {
  if (!Between(y2 - y1, 0, minDiffY))
    return false
  ; If there is a draw, priorize closer window in x.
  if ((y2 - y1 = minDiffY) AND (!Between(Abs(x1 - x2), 0, minDiffX)))
    return false
  return true
}

/*
  This function checks if the window defined by coordinates x1, y1, x2, y2
  is a better candidate to the right of the active window.
  x1 -- candidate left coordinate
  y1 -- candidate top coordinate 
  x2 -- reference left coordinate
  y2 -- reference top coordinate
  minDiffX -- X difference goal to beat.
  minDiffY -- Y difference goal to beat.
  return True if current x1/y1 difference with x1/y1 beats minDiffX and 
         minDiffY. False otherwise.
*/
__IsBetterCandidateRight(x1, y1, x2, y2, minDiffX, minDiffY) {
  if (!Between(y1 - y2, 0, minDiffY))
    return false
  ; If there is a draw, priorize closer window in x.
  if ((y1 - y2 = minDiffY) AND (!Between(Abs(x1 - x2), 0, minDiffX)))
    return false
  return true
}

/*
  This function checks if the window defined by coordinates x1, y1, x2, y2
  is a better candidate above the active window.
  x1 -- candidate left coordinate
  y1 -- candidate top coordinate 
  x2 -- reference left coordinate
  y2 -- reference top coordinate
  minDiffX -- X difference goal to beat.
  minDiffY -- Y difference goal to beat.
  return True if current x1/y1 difference with x1/y1 beats minDiffX and 
         minDiffY. False otherwise.
*/
__IsBetterCandidateUp(x1, y1, x2, y2, minDiffX, minDiffY) {
  if (!Between(x2 - x1, 0, minDiffX)) 
    return false
  ; If there is a draw, priorize closer window in y.
  if ((x2 - x1 = minDiffX) AND (!Between(Abs(y1 - y2), 0, minDiffY)))
    return false
  return true
}

/*
  This function checks if the window defined by coordinates x1, y1, x2, y2
  is a better candidate below the active window.
  x1 -- candidate left coordinate
  y1 -- candidate top coordinate 
  x2 -- reference left coordinate
  y2 -- reference top coordinate
  minDiffX -- X difference goal to beat.
  minDiffY -- Y difference goal to beat.
  return True if current x1/y1 difference with x1/y1 beats minDiffX and 
         minDiffY. False otherwise.
*/
__IsBetterCandidateDown(x1, y1, x2, y2, minDiffX, minDiffY) {
  if (!Between(x1 - x2, 0, minDiffX))
    return false
  ; If there is a draw, priorize closer window in y.
  if ((x1 - x2 = minDiffX) AND (!Between(Abs(y1 - y2), 0, minDiffY)))
    return false
  return true
}

/*
  Activate the closer window to the left of the current active window.
*/
ActivateWindowLeft() {
  __TargetCandidate(Func("__IsBetterCandidateLeft"), Func("__ActivateWindow"))
}

/*
  Activate the closer window to the right of the current active window.
*/
ActivateWindowRight() {
  __TargetCandidate(Func("__IsBetterCandidateRight"), Func("__ActivateWindow"))
}
/*
  Activate the closer window above the current active window.
*/
ActivateWindowUp() {
  __TargetCandidate(Func("__IsBetterCandidateUp"), Func("__ActivateWindow"))
}
/*
  Activate the closer window below the current active window.
*/
ActivateWindowDown() {
  __TargetCandidate(Func("__IsBetterCandidateDown"), Func("__ActivateWindow"))
}

/*
  Swap current active window with the closer window to the left of the current 
  active window.
*/
SwapActiveWindowLeft() {
  __TargetCandidate(Func("__IsBetterCandidateLeft"), Func("__SwapWindows"))
}

/*
  Swap current active window with the closer window to the right of the current 
  active window.
*/
SwapActiveWindowRight() {
  __TargetCandidate(Func("__IsBetterCandidateRight"), Func("__SwapWindows"))
}

/*
  Swap current active window with the closer window above the current 
  active window.
*/
SwapActiveWindowUp() {
  __TargetCandidate(Func("__IsBetterCandidateUp"), Func("__SwapWindows"))
}

/*
  Swap current active window with the closer window below the current 
  active window.
*/
SwapActiveWindowDown() {
  __TargetCandidate(Func("__IsBetterCandidateDown"), Func("__SwapWindows"))
}

;--------------------------------------------------------------
;                   Resize/move active window
;--------------------------------------------------------------

/*
  Resize and/or move active window. The function will consider that the screen
  is divided in rows and cols, where the number of rows and cols will be
  determined by the wRatio and hRatio. The number of rows will be 1/hRatio
  and the number of columns will be 1/wRatio. The current active window will
  be moved and resized, with the top/left corner of the window at the start
  of the specified row and col, and the bottom/right corner at the end of 
  the specified row and col.
  wRatio - New window_width/screen_width (e.g. 1 - whole screen, 0.5 - half screen size)
  hRatio - New window_height/screen_height (e.g. 1 - whole screen, 0.5 - half screen size)
  row - Row in the screen grid (0..(1/hRatio)-1).
  col - Col in the screen grid (0..(1/wRatio)-1).
*/
ResizeAndMoveActiveWindow(wRatio, hRatio, row, col)
{
  GetActiveMonitorScreenBounds(top, left, bottom, right, width, height)
  WinMove,A,, left + width * wRatio * row, top + height * hRatio * col, width * wRatio, height * hRatio
}

/*
  Resize and/or move active window. Set the window size to wndCols/scrCols width
  and wndRows/scrRows height. Set window's position to (row,col), in the 
  virtual screen grid defined by scrRows and scrCols.
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
  Activates next window. Internally all opened windows are held in the
  _windowList array, and there is a pointer to the current active window.
  This function will retrieve the next window in the array (in a circular
  motion where after the last element will come the first one) and updates
  the pointer.
*/
ActivateNextWindow() {
  global _windowListPointer, _windowList

  _windowListPointer := (_windowListPointer == _windowList.MaxIndex())
    ? 1: _windowListPointer+1
  winTitle := "ahk_id " . _windowList[_windowListPointer]
  WinActivate, %winTitle%
}

/*
  Activates previous window. Internally all opened windows are held in the
  _windowList array, and there is a pointer to the current active window.
  This function will retrieve the previous window in the array (in a circular
  motion where after the first element will come the last one) and updates
  the pointer.
*/
ActivatePrevWindow() {
  global _windowListPointer, _windowList

  _windowListPointer := (_windowListPointer <= 1) 
    ? _windowList.Length() : _windowListPointer-1 
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
  see IsWindowUserApp.
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
  Checks if window is visible.
  hwnd -- Handler of the window (id).
  return -- True if window is visible, false otherwise.
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
  Checks if window is a normal user app.
  See also IsClassBlocklisted.
  hwnd -- Handler of the window (id).
  return -- True if window is a normal user app window, false otherwise.
*/
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
  Check if window class is blacklisted.
  See global variable _wndclassBlocklist.
  wndclass -- Class of a window to check.
  return -- true if the class has been blocklisted. Some windows classes are
  not required to set them in the screen grid, therefore have been blocklisted.
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
 See __UpdatePrevActiveWindowCallback.
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
  Check if specified window has been set to be always on top.
  windowTitle -- Window title to find (eg. "ahk_exe chrome.exe").
  return -- True if window is always on top. False otherwise.
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
  This callback function, updates global variable _prevActiveWindow if the
  current active window has changed, and the previous one is a normal 
  user app.
*/
__UpdatePrevActiveWindowCallback(active, prev) {
  global _prevActiveWindow

  ; Only update previous active window if hwnd has changed and 
  ; previous active window is a user app window.
  if ((active.hwnd != prev.hwnd) AND (IsWindowUserApp(prev.hwnd)))
    _prevActiveWindow := prev.hwnd

  ; ----------------------------- Debugging.--------------------------------
  ;if (!IsWindowUserApp(active.hwnd))
  ;  return
  ;winTitle := "ahk_id " . active.hwnd
  ;WinGetClass, class, %winTitle%
  ;WinGetTitle, title, %winTitle%
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

