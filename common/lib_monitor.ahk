#include %A_ScriptDir%\lib_window.ahk

LibMonitorAutoExec:
  ; Number of monitors.
  global N_MONITORS := 4
return

/*
  Returns active monitor (1..N).
*/
GetMonitor() {
  WinGet, hwnd, ID, A
  return GetMonitorIndexFromWindow(hwnd)
}

/*
  Return the monitor's index (0..N) of the current active window.
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
  Returns active monitor (1..N).
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
