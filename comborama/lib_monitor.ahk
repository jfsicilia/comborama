/*
  This libary provides functionality to manage monitors.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_window.ahk

LibMonitorAutoExec:
  ; Number of monitors.
  global N_MONITORS := 4
return

/*
  Returns active monitor (1..N).
  return -- Monitor id.
*/
GetMonitor() {
  WinGet, hwnd, ID, A
  return GetMonitorIndexFromWindow(hwnd)
}

/*
  Move active window to next monitor.
*/
MoveActiveWindowToNextMonitor() {
  WinGet, hwnd, ID, A
  mon := GetMonitorIndexFromWindow(hwnd)
	SysGet, monitorCount, MonitorCount
  mon := mod(mon, monitorCount)
  GetScreenBounds(mon+1, top, left, bottom, right, width, height)
  WinGetPos, X, Y, width, height, A
  WinMove, A,, left, top, width, height
}

/*
  Get window's monitor index.
  windowHandle -- Handle of the window to check.
  return -- Monitor id of the window.
*/
GetMonitorIndexFromWindow(windowHandle)
{
	; Starts with 1.
	monitorIndex := 1

	VarSetCapacity(monitorInfo, 40)
	NumPut(40, monitorInfo)
	
	if (monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2)) 
		&& DllCall("GetMonitorInfo", "uint", monitorHandle, "uint", &monitorInfo) 
	{
		monitorLeft   := NumGet(monitorInfo,  4, "Int")
		monitorTop    := NumGet(monitorInfo,  8, "Int")
		monitorRight  := NumGet(monitorInfo, 12, "Int")
		monitorBottom := NumGet(monitorInfo, 16, "Int")
		workLeft      := NumGet(monitorInfo, 20, "Int")
		workTop       := NumGet(monitorInfo, 24, "Int")
		workRight     := NumGet(monitorInfo, 28, "Int")
		workBottom    := NumGet(monitorInfo, 32, "Int")
		isPrimary     := NumGet(monitorInfo, 36, "Int") & 1

		SysGet, monitorCount, MonitorCount

		Loop, %monitorCount%
		{
			SysGet, tempMon, Monitor, %A_Index%

			; Compare location to determine the monitor index.
			if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
				and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom))
			{
				monitorIndex := A_Index
				break
			}
		}
	}
	return monitorIndex
}
