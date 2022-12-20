/*
  This module provides combos to work with a grid desktop.

  @jfsicilia 2022.
*/

#include %A_ScriptDir%\lib_grid.ahk

;-----------------------------------------------------------------------------
;                                 Hotkeys
;-----------------------------------------------------------------------------

; Enable grid.
>#g::
>#F10:: ShowEnableGridDialog()

; Disable grid.
>#+g::
>#+F10:: ShowDisableGridDialog()

; Toggle fit to grid.
>#f::
>#F11:: ManageToggleFitToGrid()

#if ((IsGridEnabled()) AND (IsFitToGridOn()))
  ; Activate grid zone.
  >#l::    
  >#right:: ActivateWindowRightZone()
  >#k:: 
  >#up:: ActivateWindowUpZone()
  >#j:: 
  >#down:: ActivateWindowDownZone()
  >#h:: 
  >#left:: ActivateWindowLeftZone()

  ; Move window to zone.
  >#+k:: 
  >#+up:: MoveActiveWindowUpZone()
  >#+j:: 
  >#+down:: MoveActiveWindowDownZone()
  >#+h:: 
  >#+left:: MoveActiveWindowLeftZone()
  >#+l:: 
  >#+right:: MoveActiveWindowRightZone()

  ; Resizing zones methods
  >#>!h:: 
  >#>!left:: ResizeActiveWindowZoneRightBorderLeft()
  >#>!l:: 
  >#>!right:: ResizeActiveWindowZoneRightBorderRight()
  >#>!k:: 
  >#>!up:: ResizeActiveWindowZoneDownBorderUp()
  >#>!j::
  >#>!down:: ResizeActiveWindowZoneDownBorderDown()
  >#>!+h:: 
  >#>!+left:: ResizeActiveWindowZoneLeftBorderLeft()
  >#>!+l:: 
  >#>!+right:: ResizeActiveWindowZoneLeftBorderRight()
  >#>!+k:: 
  >#>!+up:: ResizeActiveWindowZoneUpBorderUp()
  >#>!+j::
  >#>!+down:: ResizeActiveWindowZoneUpBorderDown()

  ; Swapping window to zone methods
  >#>^l:: 
  >#>^right:: SwapActiveWindowRightZone()
  >#>^h:: 
  >#>^left:: SwapActiveWindowLeftZone()
  >#>^k:: 
  >#>^up:: SwapActiveWindowUpZone()
  >#>^j:: 
  >#>^down:: SwapActiveWindowDownZone()
#if

#if (IsGridEnabled())
  ; Activate next window zone.
  <!Tab:: ActivateWindowNextZone()
  ; Activate prev window zone.
  <!+Tab:: ActivateWindowPrevZone()
#if

; Next active window in zone.
<!`:: NextActiveWindowAtZone()
; Prev active window in zone.
<!+`:: PrevActiveWindowAtZone()

; Activate window at zone N
>#1:: ActivateWindowAtZone(,,1)
>#2:: ActivateWindowAtZone(,,2)
>#3:: ActivateWindowAtZone(,,3)
>#4:: ActivateWindowAtZone(,,4)
>#5:: ActivateWindowAtZone(,,5)
>#6:: ActivateWindowAtZone(,,6)
>#7:: ActivateWindowAtZone(,,7)
>#8:: ActivateWindowAtZone(,,8)
>#9:: ActivateWindowAtZone(,,9)

; Move active window to zone N.  
>#+1:: MoveActiveWindowToZone(,,1)
>#+2:: MoveActiveWindowToZone(,,2)
>#+3:: MoveActiveWindowToZone(,,3)
>#+4:: MoveActiveWindowToZone(,,4)
>#+5:: MoveActiveWindowToZone(,,5)
>#+6:: MoveActiveWindowToZone(,,6)
>#+7:: MoveActiveWindowToZone(,,7)
>#+8:: MoveActiveWindowToZone(,,8)
>#+9:: MoveActiveWindowToZone(,,9)

; Enable predefined grid N.
>#F1:: EnablePredefinedGrid(1, 8)
>#F2:: EnablePredefinedGrid(2, 8)
>#F3:: EnablePredefinedGrid(3, 8)
>#F4:: EnablePredefinedGrid(4, 8)
>#F5:: EnablePredefinedGrid(5, 8)
>#F6:: EnablePredefinedGrid(6, 8)
>#F7:: EnablePredefinedGrid(7, 8)
>#F8:: EnablePredefinedGrid(8, 8)
>#F9:: EnablePredefinedGrid(9, 8)

;----------------------------------------------------------------------------
;                           Helper functions.
;----------------------------------------------------------------------------

/*
  Toggles fit to grid. 
*/
ManageToggleFitToGrid() {
  if (!IsGridEnabled()) {
    ShowTrayTip("Grid is not enabled...",18,2000)
    return
  }

  fitToGrid := ToggleFitToGrid()
  if (fitToGrid)
    ShowTrayTip("Fit window to grid is ON",,2000)
  else
    ShowTrayTip("Fit window to grid is OFF",,2000)
}

/*
  Enables a predefined grid (see _gridDefinitions in lib_grid.ahk). 
  index -- Index of the _gridDefinitions array.
  gridFactor - A grid is defined by number of rows and columns. Internally
               each row and column is subdivided by the gridFactor, allowing
               the resize of the grid by smaller steps (gridFactor steps per
               row and column).
*/
EnablePredefinedGrid(index, gridFactor:=1) {
  global _gridDefinitions
  EnableGrid(,, _gridDefinitions[index], , GetWindowList(), gridFactor)
  __ShowGridEnabledToolTip(GetDesktop(), GetMonitor(), Round(GetGridRows()/GetGridFactor()), Round(GetGridCols()/GetGridFactor()))
}

/*
  Shows a dialog where a screen grid can be introduced or a predefined one
  can be selected. 
*/
ShowEnableGridDialog() {
  global _gridDefinitions
  prompt := "Please enter grid configuration...`n`n"
  prompt .= "Format: <n_rows> <n_cols> <zone>+`n"
  prompt .= "Each <zone> has this format: (start_row, start_col, end_row, end_col)`n`n"
  prompt .= "Example: 7 8 (1,1,5,5) (1,6,5,8) (6,1,7,2) (6,3,7,6) (6,7,7,8)`n`n" 
  prompt .= "Predefined grids (write #<number> to select one):`n`n"
  height := 270
  for i, str in _gridDefinitions {
    prompt .= "#" . i . "  -->  " . str . "`n"
    height += 20
  }
  
  example := (IsGridEnabled())? GetGridDefinitionString() : "7 8 (1,1,5,5) (1,6,5,8) (6,1,7,2) (6,3,7,6) (6,7,7,8)"
  InputBox, gridDefinition,,%prompt%,,600,%height%,,,,,%example%
  if ErrorLevel
    return
  if (InStr(gridDefinition, "#") = 1)
    gridDefinition := _gridDefinitions[SubStr(gridDefinition, 2, 1)]

  ; TODO Set 8 to a global constant.
  EnableGrid(, , gridDefinition, , GetWindowList(), 8)
  __ShowGridEnabledToolTip(GetDesktop(), GetMonitor(), Round(GetGridRows()/GetGridFactor()), Round(GetGridCols()/GetGridFactor()))
}

/*
  Shows a dialog to confirm that the grid will be disabled.
*/
ShowDisableGridDialog() {
  Msgbox, 4,, "Do you want to disable grid in current screen?"
  IfMsgBox Yes 
  {
    DisableGrid()
    __ShowGridDisabledToolTip(GetDesktop(), GetMonitor())
  }
}

/*
  Show a message dialog with grid info. 
  desktop -- Desktop id.
  monitor -- Monitor id.
  rows -- Number of rows in the grid.
  cols -- Number of columns in the grid.
*/
__ShowGridEnabledToolTip(desktop, monitor, rows, cols) {
  rowText := (rows = 1) ? " row" : " rows"
  colText := (cols = 1) ? " column" : " columns"
  ShowTrayTip("Grid with " . rows . rowText . " and " . cols . colText . " enabled in desktop " . desktop . " and monitor " . monitor . ".")
}

/*
  Show a message dialog with disabled grid info.
  desktop -- Desktop id.
  monitor -- Monitor id.
*/
__ShowGridDisabledToolTip(desktop, monitor) {
  ShowTrayTip("Grid disabled in desktop " . desktop . " and monitor " . monitor . ".")
}


