/*
  This module enables some key combos to dump internal debug inf.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_monitor.ahk
#include %A_ScriptDir%\lib_desktop.ahk
#include %A_ScriptDir%\lib_window.ahk
#include %A_ScriptDir%\lib_grid.ahk

;-----------------------------------------------------------------------------
;                                 Hotkeys
;-----------------------------------------------------------------------------

; Dump grid information.
<!#+F1:: __DumpGrid()

; Dump windows stacks in grid.
<!#+F2:: __DumpGridWndStacks()

; Dump window location in grid.
<!#+F3:: __DumpGridWindowLocation()

; Dump active window by desktop.
<!#+F4:: __DumpDesktopActiveWindow()

; List all opened windows.
<!#+F5:: __DumpAllWindows()
