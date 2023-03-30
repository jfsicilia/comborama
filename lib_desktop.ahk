/*
  This libary provides functionality to use windows virtual desktops: goto
  desktop, create desktop, delete desktop, move window to desktop, get 
  current desktop, show desktop id, etc.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_grid.ahk

;-----------------------------------------------------------------------------
; If you want to use this file as a module from other, this subroutine must
; be invoked by a GoSub instruction (e.g. GoSub LibDesktopAutoExec).
;-----------------------------------------------------------------------------
LibDesktopAutoExec:

  ; Path to dll.
  DLLPath := A_ScriptDir . "\move_to_desktop\VirtualDesktopAccessor_20088.dll"

  ; DLL functions handlers.
  global hVirtualDesktopAccessor := DllCall("LoadLibrary", Str, DLLPath, "Ptr") 
  global GoToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GoToDesktopNumber", "Ptr")
  global IsPinnedWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsPinnedWindow", "Ptr")
  global GetCurrentDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetCurrentDesktopNumber", "Ptr")
  global GetWindowDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetWindowDesktopNumber", "Ptr")
  global MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "MoveWindowToDesktopNumber", "Ptr")
  global RestartVirtualDesktopAccessorProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "RestartVirtualDesktopAccessor", "Ptr")
  global ViewSetFocusProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "ViewSetFocus", "Ptr")
  global ViewSwitchToProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "ViewSwitchTo", "Ptr")

  ; Restart the virtual desktop accessor when Explorer.exe crashes, or 
  ; restarts (e.g. when coming from fullscreen game)
  explorerRestartMsg := DllCall("user32\RegisterWindowMessage", "Str", "TaskbarCreated")
  OnMessage(explorerRestartMsg, "OnExplorerRestart")

  ; Number of desktops. This global variable is updated in __GetCurrentDesktop().
  global N_DESKTOPS := 4 
  ; Saves current active window per desktop. Key: Desktop (1..N_DESKTOPS), 
  ; Value: Active window handler
  global _desktopActiveWindow := {} 

  ; Delete desktop combo.
  global DELETE_DESKTOP_COMBO := "#^{F4}"
  ; Create desktop combo.
  global CREATE_DESKTOP_COMBO := "#^d"

  ; Last recent desktop.
  global LAST_RECENT_DESKTOP := 1
return

/*
  Restarts VirtualDesktopAccessor. Params are dismissed.
*/
OnExplorerRestart(wParam, lParam, msg, hwnd) {
    result := ""
    try DllCall(RestartVirtualDesktopAccessorProc, UInt, result)
}

;-----------------------------------------------------------------------------
;                       DESKTOPS FUNCTIONALITY
;-----------------------------------------------------------------------------

/*
  Returns current desktop. If param hwnd is passed, then it will return the 
  desktop where that window can be found.
  hwnd -- Optional. Window handler to find in which desktop is.
  return -- Current desktop or desktop of the window passed (hwnd). 
            1..N_DESKTOPS.
*/
GetDesktop(hwnd:=0) {
  if (hwnd == 0)
    ; NOTE __GetCurrentDesktop is more realiable than the dll call.
    ;result := DllCall(GetCurrentDesktopNumberProc, UInt) + 1
    result := __GetCurrentDesktop()
  else
    result := DllCall(GetWindowDesktopNumberProc, UInt, hwnd) + 1

  ; TODO There is some sort of bug, where the DllCall returns no value 
  ; sometimes, therefore we are forced to cheack and return a valid value.
  if ((result >= 1) AND (result <= N_DESKTOPS))
    return result
  return 1
}

/*
  Move active window to indicated desktop.
  nDesktop -- Destiny desktop (1..N_DESKTOPS).
*/
MoveActiveWindowToDesktop(nDesktop) {
  WinGet, activeHwnd, ID, A
  _desktopActiveWindow[nDesktop] := 0 ; Do not activate
  DllCall(MoveWindowToDesktopNumberProc, UInt, activeHwnd, UInt, nDesktop-1)
	GoToDesktop(nDesktop, activeHwnd)
  return
}

/*
  Move active window to prev desktop. Previous desktop of desktop 1 is the
  final desktop (N_DESKTOP).
*/
MoveActiveWindowToPrevDesktop() {
  current := GetDesktop()
  prev := current = 1 ? N_DESKTOPS : current - 1
  MoveActiveWindowToDesktop(prev)
}

/*
  Move active window to next desktop. Next desktop of final desktop is the
  first desktop.
*/
MoveActiveWindowToNextDesktop() {
  current := GetDesktop()
  next := current = N_DESKTOPS ? 1 : current + 1
  MoveActiveWindowToDesktop(next)
}

/*
  Goes to the indicated desktop.
  num -- 1..N_DESKTOPS
  hwnd -- Window handler to activate when desktop change has been done. If
          0 (default) and used_saved_active window is true, last active 
          window in the new desktop will be tried to activate. 
  useSavedActiveWindow -- If true, use saved last active window in new 
                          desktop, if no hwnd is specified. If false,
                          and hwnd is not specified, only change desktop.
  showDesktopId -- If true, it will show a splash text with the id of the new
                   desktop.
  return -- desktop num (1..N_DESKTOPS) if successfully gone to that desktop. 
  -1 if error.
*/
GoToDesktop(num, hwnd:=0, useSavedActiveWindow:=true, showDesktopId:=true) {
  ; Sanity check.
  if (num < 1)
    num := 1
  if (num > N_DESKTOPS)
    num := N_DESKTOPS

	WinGet, activeHwnd, ID, A
  current := GetDesktop()

	; Store the active window of old desktop, if it is not pinned
	isPinned := DllCall(IsPinnedWindowProc, UInt, activeHwnd)
  if (isPinned == 0) 
    _desktopActiveWindow[current] := activeHwnd

	; Try to avoid flashing task bar buttons, deactivate the current window if it is not pinned
  if (isPinned != 1)
    WinActivate, ahk_class Shell_TrayWnd

	; Change desktop
	DllCall(GoToDesktopNumberProc, Int, num-1)

  ; Activate indicated window or the one saved for the new desktop.
  if (hwnd = 0)
    hwnd := useSavedActiveWindow ? _desktopActiveWindow[num] : 0

  if (hwnd != 0) {
    sleep, 100
    WinShow, ahk_id %hwnd%
    WinActivate, ahk_id %hwnd%
  }

  ; Show splashtext with new desktop identificar.
  if (showDesktopId) {
    ShowDesktopId()
  }

  LAST_RECENT_DESKTOP := current
}

/*
  Show desktop identifier with a splash text.
*/
ShowDesktopId(millisecs=300) {
  desktop := __GetCurrentDesktop()
  Progress, zh0 B W100 fs50, %desktop%
  Sleep, %millisecs%
  Progress, Off
  return desktop
}

/*
  Go to previous desktop.
  hwnd -- Window handler to activate when desktop change has been done. If
          0 (default) last active window in the new desktop will be tried 
          to activate. 
*/
GoToPrevDesktop(hwnd:=0) {
  current := GetDesktop()
  prev := current = 1 ? N_DESKTOPS : current - 1
  GoToDesktop(prev, hwnd)
}

/*
  Go to next desktop.
  hwnd -- Window handler to activate when desktop change has been done. If
          0 (default) last active window in the new desktop will be tried 
          to activate. 
*/
GoToNextDesktop(hwnd:=0) {
  current := GetDesktop()
  next := current = N_DESKTOPS ? 1 : current + 1
  GoToDesktop(next, hwnd)
}						

/*
  Creates a new virtual desktop and switches to it
*/
CreateDesktop() {
  SendInputFree(CREATE_DESKTOP_COMBO)
  __MapDesktopsFromRegistry(desktop, N_DESKTOPS)
  GoToDesktop(N_DESKTOPS)
}

/*
  Deletes the current virtual desktop
*/
DeleteDesktop() {
  SendInputFree(DELETE_DESKTOP_COMBO)
  Sleep, 500
  LAST_RECENT_DESKTOP := ShowDesktopId()
}

/*
  Activates last recent desktop. 
*/
ToggleRecentDesktop() {
  GoToDesktop(LAST_RECENT_DESKTOP)
}

/*
  This function examines the registry to build an accurate list of the current 
  virtual desktops and which one we're currently on. Current desktop UUID 
  appears to be in 
  HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\1\VirtualDesktops
  List of desktops appears to be in 
  HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops
  desktop -- Current desktop is return in this byref param.
  numDesktops -- Number of desktops is return in this byref param.
*/
__MapDesktopsFromRegistry(ByRef desktop, ByRef numDesktops)
{
    ; Get the current desktop UUID. Length should be 32 always, but there's no guarantee this couldn't change in a later Windows release so we check.
    idLength := 32
    sessionId := __GetSessionId()
    if (sessionId) {
        
        ; Older windows 10 version
        ;RegRead, CurrentDesktopId, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\1\VirtualDesktops, CurrentVirtualDesktop
        
        ; Windows 10
        ;RegRead, CurrentDesktopId, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\%sessionId%\VirtualDesktops, CurrentVirtualDesktop
        
        ; Windows 11
        RegRead, CurrentDesktopId, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, CurrentVirtualDesktop
        if (CurrentDesktopId) {
            idLength := StrLen(CurrentDesktopId)
        }
    }

    ; Get a list of the UUIDs for all virtual desktops on the system

    ; Windows 10
    ; RegRead, DesktopList, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs

    ; Windows 11
    RegRead, DesktopList, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs
    if (DesktopList) {
        DesktopListLength := StrLen(DesktopList)
        ; Figure out how many virtual desktops there are
        numDesktops := floor(DesktopListLength / idLength)
    }
    else {
        numDesktops := 1
    }

    ; Parse the REG_DATA string that stores the array of UUID's for virtual desktops in the registry.
    i := 0
    while (CurrentDesktopId and i < numDesktops) {
        StartPos := (i * idLength) + 1
        DesktopIter := SubStr(DesktopList, StartPos, idLength)
        OutputDebug, The iterator is pointing at %DesktopIter% and count is %i%.

        ; Break out if we find a match in the list. If we didn't find anything, keep the
        ; old guess and pray we're still correct :-D.
        if (DesktopIter = CurrentDesktopId) {
            desktop := i + 1
            OutputDebug, Current desktop number is %desktop% with an ID of %DesktopIter%.
            break
        }
        i++
    }
}

/*
  Finds out ID of current session.
  return Sessing id.
*/
__GetSessionId()
{
    processId := DllCall("GetCurrentProcessId", "UInt")
    if ErrorLevel {
        OutputDebug, Error getting current process id: %ErrorLevel%
        return
    }
    OutputDebug, Current Process Id: %processId%

    sessionId := ""
    DllCall("ProcessIdToSessionId", "UInt", processId, "UInt*", sessionId)
    if ErrorLevel {
        OutputDebug, Error getting session id: %ErrorLevel%
        return
    }
    OutputDebug, Current Session Id: %sessionId%
    return sessionId
}

/*
  Returns the current desktop (1..N_DESKTOPS)
  return -- Current desktop.
*/
__GetCurrentDesktop()
{
  __MapDesktopsFromRegistry(desktop, N_DESKTOPS)
  return desktop
}

/*
  Dumps the information of the active windows by desktop.
*/
__DumpDesktopActiveWindow() {
  msg := "Active Windows by Desktop`n`n"
  for i, hwnd in _desktopActiveWindow {
    msg .= "[" . i . "]= " . hwnd . "`n"
  }
  Msgbox, %msg%
}

