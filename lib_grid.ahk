/*
  This library provides functionality to manage windows like a grid. With
  this library the desktop can be divided in a columns/rows grid, and the
  windows will be forced to fit in the grid. 

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_window.ahk
#include %A_ScriptDir%\lib_desktop.ahk
#include %A_ScriptDir%\lib_monitor.ahk

LibGridAutoExec:
  ; Predefined grid descriptions. 
  ; Format: <n_rows> <n_cols> <zone>+
  ; Each <zone> has this format: (start_row, start_col, end_row, end_col)
  ; Example: 7 8 (1,1,5,5) (1,6,5,8) (6,1,7,2) (6,3,7,6) (6,7,7,8)
  ;
  ;    _________
  ;   |1    |2  | 
  ;   |     |   |
  ;   |     |   |
  ;   |     |   |
  ;   |_____|___|
  ;   |3 |4  |5 |
  ;   |__|___|__|
  ;
  ; A grid with 7 rows, 8 columns and 5 zones defined.
  global _gridDefinitions := [ "1 1 (1,1,1,1)"
                      , "1 2 (1,1,1,1) (1,2,1,2)"
                      , "2 1 (1,1,1,1) (2,1,2,1)"
                      , "2 2 (1,1,1,2) (2,1,2,1) (2,2,2,2)"
                      , "3 3 (1,1,3,2) (1,3,2,3) (3,3,3,3)"
                      , "2 2 (1,1,1,1) (1,2,1,2) (2,1,2,1) (2,2,2,2)"
                      , "7 8 (1,1,5,5) (1,6,5,8) (6,1,7,2) (6,3,7,6) (6,7,7,8)"]

  ; Flag that indicates that all windows, when grid is enabled, must be
  ; resized to fit it's zone.
  global _fitToGrid := true

  ; A grid is defined by number of rows and columns. Internally
  ; each row and column is subdivided by the gridFactor, allowing
  ; the resize of the grid by smaller steps (gridFactor steps per
  ; row and column). This is a constant that defines 8 as a good 
  ; gridFactor.
  global GRID_FACTOR := 8

  ; Object that will hold the grid information for any desktop/monitor. See
  ; below _grids initialization for object description.
  global _grids := []
  ; _grids initialization.
  loop, % N_DESKTOPS {
    i := A_Index
    _grids[i] := []
    loop, % N_MONITORS {
      j := A_Index
      _grids[i][j] := []
      _grids[i][j].START_ROW := 1  ; Start row.
      _grids[i][j].START_COL := 1  ; Start col.
      _grids[i][j].rows := ""  ; Rows of a desktop+monitor grid.
      _grids[i][j].cols := ""  ; Columns of a desktop+monitor grid.
      _grids[i][j].gridFactor := 1  ; Number to multiply rows and cols to 
                                    ; increase resolution when resizing.

      ; The next variables will be dynamically loaded.

      ;_grids[i][j].zones

      ; zones are created in __ParseGridString. It's an array with all the
      ; zones of a desktop+monitor, each element is an object with row1, col1,
      ; row2, col2 properties. Example: _grids[1][1].zones[1].row1

      ;_grids[i][j].bounds

      ; bounds are created in SetGrid. It's an array with all the boundaries
      ; of a zone (in pixels). Each element is an object with x1, y1, x2, y2
      ; properties.
      ; Example: _grids[1][1].bounds[1].x1

      ;_grids[i][j].neighbors

      ; neighbors are created in SetGrid. It's an array with all the neighbors
      ; of a zone. Each element is an object with left, up, right, bottom
      ; properties. Example: _grids[1][1].neighbors[1].right
    }   
  }

  ; Dictionary to save current window location. Key will be a window handler.
  ; Value will be an object that holds the desktop, monitor and zone 
  ; of a window as properties.
  global _wndLocation := {}

  ; Object that will hold stack of windows for each zone in each 
  ; desktop/monitor. A zone window stack will be populated with the 
  ; window handlers of the windows that are in that zone. The one at the
  ; top of the stack (index 0) is the window that will be activated when 
  ; that zone is selected. See below _wndStacks initialization for object 
  ; description.
  global _wndStacks:= []
  ; _wndStacks initialization.
  loop, % N_DESKTOPS {
    i := A_Index
    _wndStacks[i] := []
    loop, % N_MONITORS {
      j := A_Index
      _wndStacks[i][j] := []
      ;
      ; _wndStacks[desktop][monitor][zone] will hold another array with the
      ; windows (hwnd) in that zone.
    }
  }

  ; Register function to be called when active window changes.
  RegisterActiveWindowChangedCallback(Func("__UpdateActiveWindowLocationCallback"))
  RegisterActiveWindowChangedCallback(Func("__ShowNumberWindowsInZoneCallback"))
return

;-----------------------------------------------------------------------------
;                    Enable/Disable grid functions.
;-----------------------------------------------------------------------------

/*
  Defines a grid for the specified desktop and monitor. The grid will
  be defined by the str parameter (see param description for string format).
 
  NOTE: The grid information will be saved in the global variable _grids.
 
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  str - Grid definition string. 
        Format: <n_rows> <n_cols> <zone>+
        Each <zone> has this format: (start_row, start_col, end_row, end_col)
        Example: 7 8 (1,1,5,5) (1,6,5,8) (6,1,7,2) (6,3,7,6) (6,7,7,8)
          (A grid with 7 rows, 8 columns and 5 zones defined.)
  NOTE: If str has an unreadable or wrong grid definition, grid will be 
        disabled (see DisableGrid).

  fitToGrid - If true forces windows to be resized to fit in a grid zone. 
              If false, defines the grid but windows can still be moved and
              resized without being forced to fit to the grid. Value will
              be saved internally in the _fitToGrid global variable. This
              value can be changed anytime using ToggleFitToGrid function.
  hwnds - If fitToGrid is true and this parameter holds an array of window
          handlers, those windows are forced to fit to the defined grid zones.
          First window of the array, will go to zone 1, second window to zone 2
          and so on. If the number of windows is greater than the number of
          zones, the zone number will cycle back to 1 when exhausted.
  gridFactor - A grid is defined by number of rows and columns. Internally
               each row and column is subdivided by the gridFactor, allowing
               the resize of the grid by smaller steps (gridFactor steps per
               row and column).
*/
EnableGrid(desktop:=-1, monitor:=-1, str:="", fitToGrid:=true, hwnds:="", gridFactor:=1) {
  __NormalizeDesktopMonitor(desktop, monitor)

  grid := __ParseGridString(str, gridFactor)
  if ((grid = "") OR (grid.rows = "") OR (grid.cols = "")) {
    DisableGrid(desktop, monitor)
    Msgbox, Wrong grid string: %str% 
    return
  }

  ; Fill computable grid properties.
  grid.bounds := __ComputeBounds(monitor, grid.rows, grid.cols, grid.zones)
  grid.neighbors := __ComputeNeighbors(grid.rows, grid.cols, grid.zones)

  ; Save grid in global _grids for desktop/monitor.
  _grids[desktop][monitor] := grid

  ; Save empty window stacks for each zone in grid.
  _wndStacks[desktop][monitor] := __CreateWndStacks(grid.zones)

  _fitToGrid := fitToGrid
  if (_fitToGrid)
    FitToGrid(desktop, monitor, hwnds)
}

/*
  Forces windows in the hwnds array parameter to fit to the grid zones.
  First window of the array, will go to zone 1, second window to zone 2
  and so on. If the number of windows is greater than the number of
  zones, the zone number will cycle back to 1 when exhausted.
 
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  hwnds - Array of window handlers, which will be forced to fit to the 
          defined grid zones.

  NOTE: If grid is not enabled, or internal variable _fitToGrid is false, or 
        hwnds is empty/zero-length, the function will do nothing.
*/
FitToGrid(desktop:=-1, monitor:=-1, hwnds:="") {
  if ((!IsGridEnabled()) OR (hwnds = "") OR (!_fitToGrid))
    return

  __NormalizeDesktopMonitor(desktop, monitor)

  numZones := _grids[desktop][monitor].zones.Length()
  zone := 0 
  for i, hwnd in hwnds {
    winTitle := "ahk_id " . hwnd
    WinShow, %winTitle%
    WinActivate, %winTitle%
    MoveActiveWindowToZone(desktop, monitor, zone + 1) 
    zone := Mod((zone + 1), numZones)
    sleep, 300 ; Give time to polling to update internal information.
  }
}

/*
  Disables grid. Use EnableGrid function to enable it.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
*/
DisableGrid(desktop:=-1, monitor:=-1) {
  __NormalizeDesktopMonitor(desktop, monitor)
  ; Disable/Enable grid flag on any desktop/monitor will be rows and cols
  ; properties (when empty, grid is disabled).
  _grids[desktop][monitor].rows := ""
  _grids[desktop][monitor].cols := ""
}

/*
  Parses string grid definition.

    Format: <n_rows> <n_cols> <zone>+
    Each <zone> has this format: (start_row, start_col, end_row, end_col)
    Example: 7 8 (1,1,5,5) (1,6,5,8) (6,1,7,2) (6,3,7,6) (6,7,7,8)
      (A grid with 7 rows, 8 columns and 5 zones defined.)

  str - String with grid definition.
  Returns grid object. This object will have these properties:
    rows - Number of rows.
    cols - Number of cols.
    zones - Array of n zone objects. Each of this objects has the following
            properties: row1, col1, row2, col2.
*/
__ParseGridString(str, gridFactor:=1) {
  grid := []
  grid.START_COL := 1 
  grid.START_ROW := 1
  grid.gridFactor := gridFactor
  grid.zones := []
  Loop, Parse, str, " `t" 
  {
    ; First value is rows
    if (A_Index = 1)
      grid.rows := A_LoopField * gridFactor
    ; Second value is cols
    else if (A_Index = 2) 
      grid.cols := A_LoopField * gridFactor
    ; 3..N are zones definitions (format: (start_row, start_col, end_row, end_col)).
    else {
      i := A_Index-2
      grid.zones[i] := {}
      aux := StrSplit(A_LoopField, "`,", " `t()")
      grid.zones[i].row1 := aux[1] * gridFactor - gridFactor + 1
      grid.zones[i].col1 := aux[2] * gridFactor - gridFactor + 1
      grid.zones[i].row2 := aux[3] * gridFactor
      grid.zones[i].col2 := aux[4] * gridFactor
    }
  }
  ; If no zones defined, create one with all rows and cols in the grid.
  if (grid.zones.Length() = 0)
    grid.zones[1] := {row1:1, col:1, row2:grid.rows, col2:grid.cols}
    
  return grid
}

/*
  Compute bounds of the grid zones.
 
  monitor - Monitor identifier (1..N_MONITORS). Will be used to get screen
            resolution (width x height).
  rows - Rows of the grid.
  cols - Cols of the grid.
  zones - Array with the zones to define in the grid. Each element of the
          array is an object with row1, col1, row2, col2 properties, that
          defines how many cell of the grid belongs to the zone.
 
  Returns an array of boundaries (the length of the array will be the same
  as the length of zones). Each element of the returned array will have an
  object with x1, y1, x2, y2 properties, that define in pixels the boundaries
  of each zone.
*/
__ComputeBounds(monitor, rows, cols, zones) {
  ; Add zones' bounds to the grid.
  GetScreenBounds(monitor, top,  left,  bottom,  right,  width,  height) 
  bounds := []
  for i, zone in zones {
    bounds[i] := {} 
    bounds[i].x1 := Round((zone.col1-1) * width / cols)
    bounds[i].y1 := Round((zone.row1-1) * height / rows)
    bounds[i].x2 := Round((zone.col2) * width / cols) - 1
    bounds[i].y2 := Round((zone.row2) * height / rows) - 1
  }
  return bounds
}

/*
  Compute neighbors of the grid zones.
 
  rows - Rows of the grid.
  cols - Cols of the grid.
  zones - Array with the zones to define in the grid. Each element of the
          array is an object with row1, col1, row2, col2 properties, that
          defines how many cell of the grid belongs to the zone.
 
  Returns an array of neigbors (the length of the array will be the same
  as the length of zones). Each element of the returned array will have an
  object with left, up, right, down properties, that hols the zone number
  of each neighbor.
*/
__ComputeNeighbors(rows, cols, zones) {
  neighbors := []
  for i, zone in zones {
    neighbors[i] := {}
    neighbors[i].left :=  __RowCol2Zone(zone.row1, zone.col1 - 1 = 0? cols : zone.col1 - 1, zones)
    neighbors[i].up :=    __RowCol2Zone(zone.row1 - 1 = 0? rows : zone.row1 - 1, zone.col1, zones)
    neighbors[i].right := __RowCol2Zone(zone.row1, zone.col2 + 1 > cols ? 1: zone.col2 + 1, zones)
    neighbors[i].down :=  __RowCol2Zone(zone.row2 + 1 > rows ? 1: zone.row2 + 1, zone.col1, zones)
  }
  return neighbors
}

/*
  Returns an array with the same length as parameter zones array. Each element
  in the array will be an empty array.
  zones - Zones array.
  Return Array with length equal to parameter zones and each element will hold
  and empty array.
*/
__CreateWndStacks(zones) {
  wndStacks := []
  for i, zone in zones 
    wndStacks[i] := []
  return wndStacks
}

; ----------------------------------------------------------------------------
;                                 Properties
; ----------------------------------------------------------------------------

/*
  Checks if grid is enabled in desktop/monitor.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  Returns true if grid is enabled. False otherwise.
*/
IsGridEnabled(desktop:=-1, monitor:=-1) {
  __NormalizeDesktopMonitor(desktop, monitor)
  ; rows and cols must be defined in a grid to be anabled.
  return ((_grids[desktop][monitor].rows != "") AND (_grids[desktop][monitor].cols != ""))
}

/*
  Returns grid number of rows.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  Returns number of rows or "" if grid is disabled or not defined.
*/
GetGridRows(desktop:=-1, monitor:=-1) {
  __NormalizeDesktopMonitor(desktop, monitor)
  return _grids[desktop][monitor].rows
}

/*
  Returns grid number of columns.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  Returns number of columns or "" if grid is disabled or not defined.
*/
GetGridCols(desktop:=-1, monitor:=-1) {
  __NormalizeDesktopMonitor(desktop, monitor)
  return _grids[desktop][monitor].cols
}

/*
  Returns grid factor (it multiplies internally the number of rows and cols
  to have more resolution when resizing).
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  Returns grid factor. 
*/
GetGridFactor(desktop:=-1, monitor:=-1) {
  __NormalizeDesktopMonitor(desktop, monitor)
  return _grids[desktop][monitor].gridFactor
}

/*
  Returns an array of zones of the grid.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  Returns array of zones or "" if grid is disabled or not defined. Each
  element of the array will be and object with the following properties:
  row1, col1, row2, col2.
*/
GetGridZones(desktop:=-1, monitor:=-1) {
  __NormalizeDesktopMonitor(desktop, monitor)
  return _grids[desktop][monitor].zones
}

/*
  Get the zone number of the active window.
  Returns the zone of active window (1..N_ZONES). Returns -1 if zone can't
  be determined.
*/
GetActiveWindowZone() {
  WinGetPos, x, y, w, h, A
  ; Sanity check
  if (x = "")
    return -1
  return __XY2Zone(x, y, _grids[GetDesktop()][GetMonitor()].bounds)
}

/*
  Toggles fit window to grid on/off.
  Returns true if fit to grid is on. False otherwise.
*/
ToggleFitToGrid() {
  _fitToGrid := !_fitToGrid
  ; Force window update by minimizing and restoring the active window.
  hwnd := WinExist("A")
  WinMinimize, % "ahk_id " . hwnd 
  WinRestore, % "ahk_id " . hwnd 
  return _fitToGrid
}

/*
  Returns if fit to grid is on.
*/
IsFitToGridOn() {
  return _fitToGrid
}

/*
  Get the definition string of the current grid.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  Returns the definition of the current grid as a string.
    Format: <n_rows> <n_cols> <zone>+
    Each <zone> has this format: (start_row, start_col, end_row, end_col)
    Example: 7 8 (1,1,5,5) (1,6,5,8) (6,1,7,2) (6,3,7,6) (6,7,7,8)
      (A grid with 7 rows, 8 columns and 5 zones defined.)
*/
GetGridDefinitionString(desktop:=-1, monitor:=-1) {
  __NormalizeDesktopMonitor(desktop, monitor)
  grid := _grids[desktop][monitor]
  str := ""
  str .= Floor(grid.rows / grid.gridFactor)
  str .= " " . Floor(grid.cols / grid.gridFactor)
  for i, zone in grid.zones {
    row1 := Floor((zone.row1 + grid.gridFactor - 1) / grid.gridFactor)
    col1 := Floor((zone.col1 + grid.gridFactor - 1) / grid.gridFactor)
    row2 := Floor(zone.row2 / grid.gridFactor)
    col2 := Floor(zone.col2 / grid.gridFactor)
    str .=  " (" . row1 . "," . col1 . "," . row2 . "," . col2 . ")"
  }
  return str
}

; ----------------------------------------------------------------------------
;                            Goto/Activate zone
; ----------------------------------------------------------------------------

/*
  Activates the top of the stack window in the indicated zone.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  zone - Zone of the grid to get the top of the stack window.
  NextWindowFunc - Function to be called to get next window of stack, this
                   allows to implement different strategies (LIFO, FIFO, ...).
  Returns 0 if all went right. -1 if unable to activate window in
  specified zone.
*/
__ActiveWindowAtZone(desktop, monitor, zone, NextWindowFunc) {
  __NormalizeDesktopMonitorZone(desktop, monitor, zone)
  if (!IsGridEnabled(desktop, monitor))
    return -1

  ; Tries to activate next window in the specified zone window stack. It will 
  ; iterate the window stack for that zone, finding the first existing window starting
  ; at the top of the stack. If there is now window available returns -1.
  Loop {
    hwnd := NextWindowFunc.Call(desktop, monitor, zone)
    if (hwnd = "")
      return -1
    if (WinExist("ahk_id " . hwnd))
      break
    ; Discard not existing window.
    _wndStacks[desktop][monitor][zone].Pop()
    _wndLocation.delete(hwnd)
  }

  WinShow, ahk_id %hwnd%
  WinActivate, ahk_id %hwnd%
  return 0
}

/*
  Get the hwnd on top of the stack.
  desktop -- Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
             current active desktop is used.
  monitor -- Monitor identifier (1..N_MONITORS). If ommited or set to -1
             current active monitor is used.
  zone -- Zone of the grid to get the top of the stack window.
  return -- Hwnd on top of the stack.
*/
__WindowStacksTop(desktop, monitor, zone) {
    return Last(_wndStacks[desktop][monitor][zone])
}
    
/*
  Activates a window at a specific zone. Each zone has a stack of windows.
  The one at the top of the stack, will be activated.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  zone -- Zone of the grid to get the top of the stack window.
  return -- Hwnd of the activated window.
*/
ActivateWindowAtZone(desktop:=-1, monitor:=-1, zone:=1) {
  return __ActiveWindowAtZone(desktop, monitor, zone, Func("__WindowStacksTop"))
}

/* 
  Activates a zone, by activating the window at the top of the stack in that
  zone.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  NewZoneFunc - Function that returns a new zone id (1..N_ZONES in screen),
                based in a current zone id. The function must have 3 
                parameters: desktop, monitor, zone).
*/
__ActivateZone(desktop, monitor, NewZoneFunc) {
  __NormalizeDesktopMonitor(desktop, monitor)
  if (!IsGridEnabled(desktop, monitor))
    return 

  WinGetPos, x, y, w, h, A
  ; Sanity check
  if (x = "")
    return
  zone := __XY2Zone(x, y, _grids[desktop][monitor].bounds)
  ; Activates a window in the zone. If no windows are available in the
  ; zone, a new new zone will be used. All NewZoneFunc are close looped
  ; so the will end at the start zone where the current active window belongs, 
  ; therefore there is always an activable window (loop always ends).
  Loop {
    zone := NewZoneFunc.Call(desktop, monitor, zone)
    if (ActivateWindowAtZone(desktop, monitor, zone) != -1)
      break
  }
}

/*
  This function returns the id of the previous zone. It will cycle back to
  the last zone if the specified zone is the first one.
  desktop -- Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
             current active desktop is used.
  monitor -- Monitor identifier (1..N_MONITORS). If ommited or set to -1
             current active monitor is used.
  zone -- Zone id (1..Number of zones in grid).
  return -- Previous zone id.
*/
__PrevZone(desktop, monitor, zone) {
  return zone > 1 ? zone - 1 : _grids[desktop][monitor].zones.Length()
}

/*
  This function returns the id of the next zone. It will cycle back to
  the first zone if the specified zone is the last one.
  desktop -- Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
             current active desktop is used.
  monitor -- Monitor identifier (1..N_MONITORS). If ommited or set to -1
             current active monitor is used.
  zone -- Zone id (1..Number of zones in grid).
  return -- Previous zone id.
*/
__NextZone(desktop, monitor, zone) {
  return zone >= _grids[desktop][monitor].zones.Length() ? 1 : zone + 1
}

/*
  This function returns the id of the zone to the left of the specified zone. 
  desktop -- Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
             current active desktop is used.
  monitor -- Monitor identifier (1..N_MONITORS). If ommited or set to -1
             current active monitor is used.
  zone -- Zone id (1..Number of zones in grid).
  return -- Zone id of the zone to the left.
*/
__LeftZone(desktop, monitor, zone) {
  return _grids[desktop][monitor].neighbors[zone].left
}

/*
  This function returns the id of the zone above of the specified zone. 
  desktop -- Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
             current active desktop is used.
  monitor -- Monitor identifier (1..N_MONITORS). If ommited or set to -1
             current active monitor is used.
  zone -- Zone id (1..Number of zones in grid).
  return -- Zone id of the zone above.
*/
__UpZone(desktop, monitor, zone) {
  return _grids[desktop][monitor].neighbors[zone].up
}

/*
  This function returns the id of the zone to the right of the specified zone. 
  desktop -- Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
             current active desktop is used.
  monitor -- Monitor identifier (1..N_MONITORS). If ommited or set to -1
             current active monitor is used.
  zone -- Zone id (1..Number of zones in grid).
  return -- Zone id of the zone to the right.
*/
__RightZone(desktop, monitor, zone) {
  return _grids[desktop][monitor].neighbors[zone].right
}

/*
  This function returns the id of the zone below of the specified zone. 
  desktop -- Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
             current active desktop is used.
  monitor -- Monitor identifier (1..N_MONITORS). If ommited or set to -1
             current active monitor is used.
  zone -- Zone id (1..Number of zones in grid).
  return -- Zone id of the zone below.
*/
__DownZone(desktop, monitor, zone) {
  return _grids[desktop][monitor].neighbors[zone].down
}

/*
  Activates the window, top of the stack, of the previous zone.
  NOTE: See __ActivateZone and __PrevZone
  desktop -- Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
             current active desktop is used.
  monitor -- Monitor identifier (1..N_MONITORS). If ommited or set to -1
             current active monitor is used.
*/
ActivateWindowPrevZone(desktop:=-1, monitor:=-1) {
  __ActivateZone(desktop, monitor, Func("__PrevZone"))
}

/*
  Activates the window, top of the stack, of the next zone.
  NOTE: See __ActivateZone and __NextZone
  desktop -- Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
             current active desktop is used.
  monitor -- Monitor identifier (1..N_MONITORS). If ommited or set to -1
             current active monitor is used.
*/
ActivateWindowNextZone(desktop:=-1, monitor:=-1) {
  __ActivateZone(desktop, monitor, Func("__NextZone"))
}

/*
  Activates the window, top of the stack, of the zone to the left.
  NOTE: See __ActivateZone and __LeftZone
  desktop -- Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
             current active desktop is used.
  monitor -- Monitor identifier (1..N_MONITORS). If ommited or set to -1
             current active monitor is used.
*/
ActivateWindowLeftZone(desktop:=-1, monitor:=-1) {
  __ActivateZone(desktop, monitor, Func("__LeftZone"))
}

/*
  Activates the window, top of the stack, of the zone to the right.
  NOTE: See __ActivateZone and __RightZone
  desktop -- Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
             current active desktop is used.
  monitor -- Monitor identifier (1..N_MONITORS). If ommited or set to -1
             current active monitor is used.
*/
ActivateWindowRightZone(desktop:=-1, monitor:=-1) {
  __ActivateZone(desktop, monitor, Func("__RightZone"))
}

/*
  Activates the window, top of the stack, of the zone above.
  NOTE: See __ActivateZone and __UpZone
  desktop -- Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
             current active desktop is used.
  monitor -- Monitor identifier (1..N_MONITORS). If ommited or set to -1
             current active monitor is used.
*/
ActivateWindowUpZone(desktop:=-1, monitor:=-1) {
  __ActivateZone(desktop, monitor, Func("__UpZone"))
}

/*
  Activates the window, top of the stack, of the zone below.
  NOTE: See __ActivateZone and __DownZone
  desktop -- Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
             current active desktop is used.
  monitor -- Monitor identifier (1..N_MONITORS). If ommited or set to -1
             current active monitor is used.
*/
ActivateWindowDownZone(desktop:=-1, monitor:=-1) {
  __ActivateZone(desktop, monitor, Func("__DownZone"))
}

; ----------------------------------------------------------------------------
;                            Cycle windows at zone
; ----------------------------------------------------------------------------
  
/*
  Returns the next window in the stack of the specified zone.
  desktop -- Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
             current active desktop is used.
  monitor -- Monitor identifier (1..N_MONITORS). If ommited or set to -1
             current active monitor is used.
  zone -- Zone id (1..Number of zones in grid).
*/
__WindowStacksNext(desktop, monitor, zone) {
    hwnd := _wndStacks[desktop][monitor][zone].Pop()
    if (hwnd = "")
      return "" 
    _wndStacks[desktop][monitor][zone].InsertAt(1, hwnd)
    return Last(_wndStacks[desktop][monitor][zone])
}

/*
  Returns the previous window in the stack of the specified zone.
  desktop -- Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
             current active desktop is used.
  monitor -- Monitor identifier (1..N_MONITORS). If ommited or set to -1
             current active monitor is used.
  zone -- Zone id (1..Number of zones in grid).
*/
__WindowStacksPrev(desktop, monitor, zone) {
    ; Put bottom window at the top of the stack.
    hwnd := _wndStacks[desktop][monitor][zone].RemoveAt(1)
    if (hwnd = "") ; No window available in the stack?
      return "" 
    _wndStacks[desktop][monitor][zone].Push(hwnd)
    return Last(_wndStacks[desktop][monitor][zone])
}

/*
  Activates the next window in the stack at the specified zone.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  zone -- Zone id (1..Number of zones in grid).
  return -- 0 if all went right. -1 if unable to activate window in
            specified zone.
*/
NextActiveWindowAtZone(desktop:=-1, monitor:=-1, zone:=-1) {
  return __ActiveWindowAtZone(desktop, monitor, zone, Func("__WindowStacksNext"))
}

/*
  Activates the previous window in the stack at the specified zone.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  zone -- Zone id (1..Number of zones in grid).
  return -- 0 if all went right. -1 if unable to activate window in
            specified zone.
*/
PrevActiveWindowAtZone(desktop:=-1, monitor:=-1, zone:=-1) {
  return __ActiveWindowAtZone(desktop, monitor, zone, Func("__WindowStacksPrev"))
}

; ----------------------------------------------------------------------------
;                            Move window to zone
; ----------------------------------------------------------------------------

/*
  Move indicated window (in winTitle) to specified zone.
  winTitle - AHK window title of the window to move (eg. "ahk_id 0x00F3E", 
             "A", "ahk_exe chrome.exe").
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  zone - Zone to move the window to.
*/
MoveWindowToZone(winTitle, desktop:=-1, monitor:=-1, zone:=1) {
  __NormalizeDesktopMonitor(desktop, monitor)
  if (!IsGridEnabled(desktop, monitor))
    return 

  ; NOTE: push to _wndStacks is done in window polling 
  ; (check __UpdateActiveWindowLocationCallback)

  ; Prepare window to move it.
  WinGet, maximized, MinMax, %winTitle%
  if (maximized)
    WinRestore, %winTitle%
  bound := _grids[desktop][monitor].bounds[zone] 
  WinMove, %winTitle%, , bound.x1, bound.y1, bound.x2-bound.x1+1, bound.y2-bound.y1+1
}

/*
  Move current active window to specified zone.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  zone - Zone to move the window to.
*/
MoveActiveWindowToZone(desktop:=-1, monitor:=-1, zone:=1) {
  MoveWindowToZone("A", desktop, monitor, zone)
}

/*
  Move current active window to a new zone. The zone id will be obtained 
  by calling the function passed as paramenter.
  NewZoneFunc - Function that returns a new zone id (1..N_ZONES in screen),
                based in a current zone id. The function must have 3 
                parameters: desktop, monitor, zone).
*/
__MoveActiveWindow(NewZoneFunc) {
  desktop := GetDesktop()
  monitor := GetMonitor()
  if (!IsGridEnabled(desktop, monitor))
    return 

  WinGetPos, x, y, w, h, A
  zone := __XY2Zone(x, y, _grids[desktop][monitor].bounds)
  MoveActiveWindowToZone(desktop, monitor, NewZoneFunc.Call(desktop, monitor, zone)) 
}

/*
  Move current active window to the zone to the left.
  NOTE: See _MoveActiveWindow and __LeftZone
*/
MoveActiveWindowLeftZone() {
  __MoveActiveWindow(Func("__LeftZone"))
}

/*
  Move current active window to the above zone.
  NOTE: See _MoveActiveWindow and __UpZone
*/
MoveActiveWindowUpZone() {
  __MoveActiveWindow(Func("__UpZone"))
}

/*
  Move current active window to the zone to the left.
  NOTE: See _MoveActiveWindow and __RightZone
*/
MoveActiveWindowRightZone() {
  __MoveActiveWindow(Func("__RightZone"))
}

/*
  Move current active window to the below zone.
  NOTE: See _MoveActiveWindow and __DownZone
*/
MoveActiveWindowDownZone() {
  __MoveActiveWindow(Func("__DownZone"))
}

; ----------------------------------------------------------------------------
;                            Rezise zone
; ----------------------------------------------------------------------------

/*
  Checks if the target zone is allowed to expand.
  grid -- Grid definition object.
*/
__ExpandAllowResizeCheck(grid, targetZone, start, end, thd) { 
  return targetZone[start] != grid[thd]
}
/*
  Checks if the target zone is allowed to shrink.
  grid -- Grid definition object.
*/
__ShrinkAllowResizeCheck(grid, targetZone, start, end, thd) { 
  return targetZone[start] != targetZone[end]
}

/*

*/
__ExpandIsCandidateCheck(targetZone, zone, start, end, dir, pStart, pEnd) {
  return ((zone[end] = targetZone[start] + dir) 
    AND ((Between(zone[pStart], targetZone[pStart], targetZone[pEnd])) 
      OR (Between(zone[pEnd], targetZone[pStart], targetZone[pEnd]))))
}
/*

*/
__ShrinkIsCandidateCheck(targetZone, zone, start, end, dir, pStart, pEnd) {
  return ((zone[end] = targetZone[start] - dir) 
    AND ((Between(zone[pStart], targetZone[pStart], targetZone[pEnd])) 
     AND (Between(zone[pEnd], targetZone[pStart], targetZone[pEnd]))))
}

/*

*/
__ExpandAllCandidatesCanResizeCheck(candidatesZone, start, end) {
  ; Check if all affected candidates can shrink. If there is one that can not
  ; shrink, resize is not allowed, therefore exit.
  for i, candidateZone in candidatesZone
    if (candidateZone[start] = candidateZone[end])
      return false
  return true
}
/*

*/
__ShrinkAllCandidatesCanResizeCheck(candidatesZone, start, end) {
  return true
}

/*
  Resizes current active window zone. This method will move one of the zone
  borders (left, right, up, down) in a direction (left, right, up, down).
  Depending on the grid configuration, moving a border of a zone may affect
  to other zones that share the same border. This is checked in the function
  and dealt accordingly. Only if all affected zones are able to move the
  border, then the resize is done.
  start -- Name of the property in the grid that is going to be changed. 
           Could be "row1" (when moving upper zone border), "row2" (when moving
           lower zone border), "col1" (when moving left zone border), "col2" 
           (when moving right zone border.
  end -- Must be the complement of the property selected in start. For
         "row1" -> "row2", "row2" -> "row1", "col1" -> "col2", "col2" -> "col1".
  pStart -- If start and end are rows ("row1"/"row2"), pStart/pEnd must be cols
            ("col1"/"col2"), and viceversa. pStart must be always "row1" or "col1". 
  pEnd -- Must be the complement of the property selected in pStart. For
         "row1" -> "row2", "col1" -> "col2".
  thd -- Threshold. Posible values are: 
         "": No threshold to check
         "START_ROW": First row. Used to limit movement of border upwards.
         "START_COL": First column. Used to limit movement of border to the left.
         "rows": Last row. Used to limit movement of border downards.
         "cols": Last column. Used to limit movement of border to the right. 
  dir -- +1 to move border right or down, -1 to move border left or up.
  AllowResizeCheck -- Function to check if resized is allowed.
  IsCandidateCheck -- Function to check if a zone is a candidate to be resized.
  AllCandidatesCanResizeCheck -- Function to check if all affected zones are
                                 allowed to resize.
*/
ResizeActiveWindowZoneBorder(start, end, pStart, pEnd, thd, dir
    , AllowResizeCheck, IsCandidateCheck, AllCandidatesCanResizeCheck) {

  desktop := GetDesktop()
  monitor := GetMonitor()
  if (!IsGridEnabled(desktop, monitor))
    return 

  grid := _grids[desktop][monitor]
  targetZoneIndex := GetActiveWindowZone()
  targetZone := grid.zones[targetZoneIndex]  
  ; If not able to resize, because the border to move it's already a border
  ; of the screen, exit.
  if (!AllowResizeCheck.Call(grid, targetZone, start, end, thd)) 
    return

  ; Find zones affected by zone resizing, and save them as candidates.
  candidatesZone := []
  candidatesZoneIndex := []
  for i, zone in grid.zones 
    if (IsCandidateCheck.Call(targetZone, zone, start, end, dir, pStart, pEnd))  {
      candidatesZone.Push(zone)
      candidatesZoneIndex.Push(i)
    }

  ; If there is one candidate that can not resize, abort resizing.
  if (!AllCandidatesCanResizeCheck.Call(candidatesZone, start, end))
      return

  targetZone[start] := targetZone[start] + dir
  for i, candidateZone in candidatesZone
    candidateZone[end] := candidateZone[end] + dir 

  ; Recalculate bounds and neighbors.
  grid.bounds := __ComputeBounds(monitor, grid.rows, grid.cols, grid.zones)
  grid.neighbors := __ComputeNeighbors(grid.rows, grid.cols, grid.zones)

  ; Call fit to grid to resize affected windows.
  hwnds := []
  MoveWindowToZone("ahk_id " . Last(_wndStacks[desktop][monitor][targetZoneIndex]),,,targetZoneIndex)
  for _, i in candidatesZoneIndex
    MoveWindowToZone("ahk_id " . Last(_wndStacks[desktop][monitor][i]),,,i)
}

/*
  Resizes current active window zone. The left border of the zone will be moved
  to the left.
*/
ResizeActiveWindowZoneLeftBorderLeft() {
  ResizeActiveWindowZoneBorder("col1", "col2", "row1", "row2", "START_COL", -1
    , Func("__ExpandAllowResizeCheck")
    , Func("__ExpandIsCandidateCheck") 
    , Func("__ExpandAllCandidatesCanResizeCheck"))
}

/*
  Resizes current active window zone. The left border of the zone will be moved
  to the right.
*/
ResizeActiveWindowZoneLeftBorderRight() {
  ResizeActiveWindowZoneBorder("col1", "col2", "row1", "row2", "", +1
    , Func("__ShrinkAllowResizeCheck")
    , Func("__ShrinkIsCandidateCheck") 
    , Func("__ShrinkAllCandidatesCanResizeCheck"))
}

/*
  Resizes current active window zone. The right border of the zone will be moved
  to the left.
*/
ResizeActiveWindowZoneRightBorderLeft() {
  ResizeActiveWindowZoneBorder("col2", "col1", "row1", "row2", "", -1
    , Func("__ShrinkAllowResizeCheck")
    , Func("__ShrinkIsCandidateCheck") 
    , Func("__ShrinkAllCandidatesCanResizeCheck"))
}

/*
  Resizes current active window zone. The right border of the zone will be moved
  to the right.
*/
ResizeActiveWindowZoneRightBorderRight() {
  ResizeActiveWindowZoneBorder("col2", "col1", "row1", "row2", "cols", +1
    , Func("__ExpandAllowResizeCheck")
    , Func("__ExpandIsCandidateCheck") 
    , Func("__ExpandAllCandidatesCanResizeCheck"))
}

/*
  Resizes current active window zone. The upper border of the zone will be moved
  upwards.
*/
ResizeActiveWindowZoneUpBorderUp() {
  ResizeActiveWindowZoneBorder("row1", "row2", "col1", "col2", "START_ROW", -1
    , Func("__ExpandAllowResizeCheck")
    , Func("__ExpandIsCandidateCheck") 
    , Func("__ExpandAllCandidatesCanResizeCheck"))
}

/*
  Resizes current active window zone. The upper border of the zone will be moved
  downards.
*/
ResizeActiveWindowZoneUpBorderDown() {
  ResizeActiveWindowZoneBorder("row1", "row2", "col1", "col2", "", +1
    , Func("__ShrinkAllowResizeCheck")
    , Func("__ShrinkIsCandidateCheck") 
    , Func("__ShrinkAllCandidatesCanResizeCheck"))
}

/*
  Resizes current active window zone. The bottom border of the zone will be moved
  upwards.
*/
ResizeActiveWindowZoneDownBorderUp() {
  ResizeActiveWindowZoneBorder("row2", "row1", "col1", "col2", "", -1
    , Func("__ShrinkAllowResizeCheck")
    , Func("__ShrinkIsCandidateCheck") 
    , Func("__ShrinkAllCandidatesCanResizeCheck"))
}

/*
  Resizes current active window zone. The bottom border of the zone will be moved
  downards.
*/
ResizeActiveWindowZoneDownBorderDown() {
  ;ResizeActiveWindowZoneBorder("row2", "row1", "col1", "col2", "cols", +1
  ResizeActiveWindowZoneBorder("row2", "row1", "col1", "col2", "rows", +1
    , Func("__ExpandAllowResizeCheck")
    , Func("__ExpandIsCandidateCheck") 
    , Func("__ExpandAllCandidatesCanResizeCheck"))
}

; ----------------------------------------------------------------------------
;                            Swap window to zone
; ----------------------------------------------------------------------------

/*
  Swap indicated window (see winTitle) with the top window in the indicated zone.
  winTitle - AHK window title of the window to move (eg. "ahk_id 0x00F3E", 
             "A", "ahk_exe chrome.exe").
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  zone - Zone to move the window to.
*/
SwapWindowToZone(winTitle, desktop:=-1, monitor:=-1, zone:=1) {
  __NormalizeDesktopMonitor(desktop, monitor)
  if (!IsGridEnabled(desktop, monitor))
    return 

  ; NOTE: push to _wndStacks is done in window polling 
  ; (check __UpdateActiveWindowLocationCallback)

  ; Prepare window to move it.
  WinGet, maximized, MinMax, %winTitle%
  if (maximized)
    WinRestore, %winTitle%

  origZone := GetActiveWindowZone()
  destZone := zone
  origHwnd := WinExist(winTitle)
  
  ; If there is, at least, a window in the destination zone, pick up the 
  ; one at the top of the stack an swap it.
  last := _wndStacks[desktop][monitor][destZone].MaxIndex()
  ; NOTE: push to _wndStacks is done in window polling 
  ; (check __UpdateActiveWindowLocationCallback)

  if (last > 0) {
    origBound := _grids[desktop][monitor].bounds[origZone] 
    destHwnd := _wndStacks[desktop][monitor][destZone][last]
    ; Move the window in the destination zone to the zone of the original window.
    WinActivate, % "ahk_id " destHwnd
    WinMove, % "ahk_id " destHwnd, , origBound.x1, origBound.y1, origBound.x2-origBound.x1+1, origBound.y2-origBound.y1+1
    Sleep, 300  ; Give time to polling to update internal information.
  }
  ; Move original window to destination zone.
  destBound := _grids[desktop][monitor].bounds[destZone] 
  WinActivate, % "ahk_id " origHwnd
  WinMove, % "ahk_id " origHwnd, , destBound.x1, destBound.y1, destBound.x2-destBound.x1+1, destBound.y2-destBound.y1+1
}

/*
  Swap current active window with the top window in the indicated zone.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  zone - Zone to move the window to.
*/
SwapActiveWindowToZone(desktop:=-1, monitor:=-1, zone:=1) {
  SwapWindowToZone("A", desktop, monitor, zone)
}

/*
  Swap the current active window with the top window of the zone provided
  by the function NewZoneFunc.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  NewZoneFunc - Function that returns a new zone id (1..N_ZONES in screen),
                based in a current zone id. The function must have 3 
                parameters: desktop, monitor, zone.
*/
__SwapActiveWindowZone(desktop, monitor, NewZoneFunc) {
  __NormalizeDesktopMonitor(desktop, monitor)
  if (!IsGridEnabled(desktop, monitor))
    return 

  WinGetPos, x, y, w, h, A
  zone := __XY2Zone(x, y, _grids[desktop][monitor].bounds)
  SwapActiveWindowToZone(desktop, monitor, NewZoneFunc.Call(desktop, monitor, zone)) 
}


/*
  Swap the current active window with the top window of the zone to the left
  of active window's zone.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  NOTE: See _SwapActiveWindow and __LeftZone
*/
SwapActiveWindowLeftZone(desktop:=-1, monitor:=-1) {
  __SwapActiveWindowZone(desktop, monitor, Func("__LeftZone"))
}

/*
  Swap the current active window with the top window of the above zone 
  of active window's zone.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  NOTE: See _SwapActiveWindow and __UpZone
*/
SwapActiveWindowUpZone(desktop:=-1, monitor:=-1) {
  __SwapActiveWindowZone(desktop, monitor, Func("__UpZone"))
}

/*
  Swap the current active window with the top window of the zone to the right
  of active window's zone.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  NOTE: See _SwapActiveWindow and __RightZone
*/
SwapActiveWindowRightZone(desktop:=-1, monitor:=-1) {
  __SwapActiveWindowZone(desktop, monitor, Func("__RightZone"))
}

/*
  Swap the current active window with the top window of the below zone 
  of active window's zone.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  NOTE: See _SwapActiveWindow and __DownZone
*/
SwapActiveWindowDownZone(desktop:=-1, monitor:=-1) {
  __SwapActiveWindowZone(desktop, monitor, Func("__DownZone"))
}


; ----------------------------------------------------------------------------
;                       Internal helper functions.
; ----------------------------------------------------------------------------

/*
  Gets desktop and monitor in the right bounds (1..N_DESKTOPS and 1..N_MONITORS).
  Both params are passed byref, so the function makes sure that the values
  are kept inside the right bounds and if not it modifies them accordingly.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
*/
__NormalizeDesktopMonitor(ByRef desktop, ByRef monitor) {
  desktop := __NormalizeDesktop(desktop)
  monitor := __NormalizeMonitor(desktop)
}

/*
  Gets desktop in the right bounds (1..N_DESKTOPS)
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set out of the
            bounds, active desktop id is return.
  return - Desktop id between 1 and N_DESKTOPS.  
*/
__NormalizeDesktop(desktop) {
  if ((desktop >= 1) AND (desktop <= N_DESKTOPS))
    return desktop
  return GetDesktop()
}

/*
  Gets monitor in the right bounds (1..N_MONITORS)
  desktop - Desktop identifier (1..N_MONITORS). If ommited or set out of the
            bounds, active desktop id is return.
  return - Desktop id between 1 and N_MONITORS.  
*/
__NormalizeMonitor(monitor) {
  if ((monitor >= 1) AND (monitor <= N_MONITORS))
    return monitor
  return GetMonitor()
}

/*
  Gets desktop, monitor and zone in the right bounds (1..N_DESKTOPS, 
  1..N_MONITORS and 1..N_ZONES). Params are passed byref, so the function 
  makes sure that the values are kept inside the right bounds, if not it 
  modifies them accordingly.
  desktop - Desktop identifier (1..N_DESKTOPS). If ommited or set to -1
            current active desktop is used.
  monitor - Monitor identifier (1..N_MONITORS). If ommited or set to -1
            current active monitor is used.
  zone - Zone identifier (1..N_ZONES). If ommited or set to -1 current
         active window zone is used.
*/
__NormalizeDesktopMonitorZone(ByRef desktop, ByRef monitor, ByRef zone) {
  __NormalizeDesktopMonitor(desktop, monitor)
  if (zone = -1)
    zone := GetActiveWindowZone()
}

/* 
  Return the zone id where row/col belongs (1..zones.length()). Returns
  default if row/col don't belong to any zone.
  row -- Row of the grid.
  col -- Column of the grid.
  zones -- Zones defined in the grid. See _grids[desktop][monitor].zones for
           format.
  return -- Zone identifier. Default if something goes wrong with row and col.
*/
__RowCol2Zone(row, col, zones, default:=1) {
  for i, zone in zones {
    if ((row >= zone.row1) AND (row <= zone.row2) AND (col >= zone.col1) AND (col <= zone.col2))
      return i
  }
  return default
}

/* 
  Return zone id where x/y belongs (1..zones.length()). Returns
  default if x/y don't belong to any zone boundary.
  x -- X position.
  y -- Y position.
  bounds -- Bounds in pixels of the zones. See _grids[desktop][monitor].bounds
            for format.
  return -- Zone identifier. Default if something goes wrong with X and Y.
*/
__XY2Zone(x, y, bounds, default:=1) {
  for i, bound in bounds {
    if ((x >= bound.x1) AND (x <= bound.x2) AND (y >= bound.y1) AND (y <= bound.y2))
      return i
  }
  return default
}

; ----------------------------------------------------------------------------
;                             Callback funtions
;
;  Module lib_active_window_polling, allows to register functions that will
;  be called whenever a window changes it's size or position. 
; ----------------------------------------------------------------------------

/*
  This callback function will keep updated properties zone, desktop and monitor 
  of the _wndLocation global variable (see description in the beginning of the 
  script).

  active -- Object with the active window current info: hwnd, maximized 
            (boolean), x, y, w, h, desktop and monitor.
  prev -- Object with the active window previous info: hwnd, maximized 
            (boolean), x, y, w, h, desktop and monitor.
*/
__UpdateActiveWindowLocationCallback(active, prev) {
  global _grids, _wndLocation, _fitToGrid

  x := active.x, y := active.y 
  hwnd := active.hwnd, maximized := active.maximized
  desktop := active.desktop, monitor := active.monitor

  ; If grid is not enabled, ensure window location is reseted.
  if (!IsGridEnabled(desktop, monitor)) {
    _wndLocation.delete(hwnd)
    return
  }

  ; If this window is not a normal window app, return.
  if (!IsWindowUserApp(hwnd))
    return
  
  ; Get window's zone.
  zone := __XY2Zone(x, y, _grids[desktop][monitor].bounds)

  ; TODO: Optimize remove and push when old_zone and zone are the same and
  ; the window is at the top of the stack.

  ; If it is not the first time (after grid is enabled), save old location
  ; and remove window from old zone window stack.
  old_zone := _wndLocation[hwnd].zone
  if (old_zone > 0)
  {
    old_desktop := _wndLocation[hwnd].desktop
    old_monitor := _wndLocation[hwnd].monitor
    ; Remove window from old zone window stack.
    for i, old_hwnd in _wndStacks[old_desktop][old_monitor][old_zone] {
      if (old_hwnd = hwnd) {
        _wndStacks[old_desktop][old_monitor][old_zone].RemoveAt(i)
        break
      }
    }
  }

  ; Save new window location and push it at the top of the new zone 
  ; window stack.
  _wndLocation[hwnd] := []
  _wndLocation[hwnd].desktop := desktop
  _wndLocation[hwnd].monitor := monitor
  _wndLocation[hwnd].zone := zone
  _wndStacks[desktop][monitor][zone].push(hwnd)

  ; Fit window to the zone.
  if ((!maximized) AND (_fitToGrid))
    MoveActiveWindowToZone(desktop, monitor, zone)
}

/*
  This callback function will show the number of windows stacked in a zone.
  The number will be showed in the lower right corner.

  active -- Object with the active window current info: hwnd, maximized 
            (boolean), x, y, w, h, desktop and monitor.
  prev -- Object with the active window previous info: hwnd, maximized 
            (boolean), x, y, w, h, desktop and monitor.
*/
__ShowNumberWindowsInZoneCallback(active, prev) {
  global _grids
  if (!IsGridEnabled(active.desktop, active.monitor))
    return
  
  x := active.x, y := active.y, w := active.w, h := active.h
  desktop := active.desktop, monitor := active.monitor

  zone := __XY2Zone(x, y, _grids[desktop][monitor].bounds)
  numWindows := _wndStacks[desktop][monitor][zone].Length()
  try {
    Gui, TextGUI:New
    Gui, Color, Black
    Gui, -caption +toolwindow +AlwaysOnTop
    Gui, font, s20 bold, Arial
    Gui, add, text, cYellow TransColor, % numWindows
    Gui, Show, % "x" x+w-80 " y" y+h-60 " NoActivate", TRANS-WIN
    WinSet, TransColor, Black, TRANS-WIN
  }
}

; ----------------------------------------------------------------------------
;                            Debugging functions.
; ----------------------------------------------------------------------------

/*
  Dumbs grid information.
*/
__DumpGrid() {
  global _grids
  msg := ""
  for i, monitors in _grids {
    for j, grid in monitors {
      msg .= "desktop[" . i . "] monitor[" . j . "].rows =  " . grid.rows . "`n"
      msg .= "desktop[" . i . "] monitor[" . j . "].cols =  " . grid.cols . "`n"
      msg .= "desktop[" . i . "] monitor[" . j . "].gridStr =  " . GetGridDefinitionString(i, j) . "`n"
      msg .= "desktop[" . i . "] monitor[" . j . "].gridFactor =  " . grid.gridFactor . "`n"
      for k, zone in grid.zones 
        msg .= "desktop[" . i . "] monitor[" . j . "] zone[" . k . "] = ("  . zone.row1 . "," . zone.col1 . "," . zone.row2 . "," . zone.col2 . ")`n"
      for k, bound in grid.bounds 
        msg .= "desktop[" . i . "] monitor[" . j . "] bound[" . k . "] = ("  . bound.x1 . "," . bound.y1 . "," . bound.x2 . "," . bound.y2 . ")`n"
      for k, neighbor in grid.neighbors
        msg .= "desktop[" . i . "] monitor[" . j . "] neighbor[" . k . "] = ("  . neighbor.left . "," . neighbor.up . "," . neighbor.right . "," . neighbor.down . ")`n"
      msg .= "`n"
      msg .= "`n"
    }
    msg .= "`n"
  }
  Msgbox, Grid settings `n`n%msg%
}

/*
  Dumps the information of the window stacks. There is a window stack for
  each zone.
*/
__DumpGridWndStacks() {
  msg := ""
  for i, monitors in _wndStacks {
    for j, stacks in monitors {
      for k, stack in stacks {
        for h, hwnd in stack 
          msg .= "desktop[" . i . "] monitor[" . j . "] wndStack[" . k . "] [" . h . "]= "  . int2hex(hwnd)  . "`n"
      }
      msg .= "`n"
      msg .= "`n"
    }
    msg .= "`n"
  }
  Msgbox, Grid windows' stacks `n`n%msg%
}

/*
  Dumps the window location dictionary.
*/
__DumpGridWindowLocation() {
  msg := "Window locations`n`n"
  for hwnd, location in _wndLocation {
    msg .= "[" . hwnd . "] .desktop=" . location.desktop . " .monitor=" . location.monitor . " .zone=" . location.zone . "`n"
  }
  Msgbox, %msg%
}

