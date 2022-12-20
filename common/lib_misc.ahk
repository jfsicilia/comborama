#include %A_ScriptDir%\lib_com.ahk

; Several miscellanea functions.
LibMiscAutoExec:
  ; Dictionary with keys and bound modifiers. Key SC056 is used as RWin modifier.
  ; SC055 key is used as RCtrl modifier.
  global ALL_MODIFIERS := {"LAlt":"LAlt", "RAlt":"RAlt", "LCtrl":"LCtrl", "RCtrl":"RCtrl", "LShift":"LShift", "RShift":"RShift", "LWin":"LWin", "RWin":"RWin", "SC056":"RWin", "Tab":"Tab", "SC055":"SC055", "LShift":"LShift", "RShift":"RShift"}

  global CLOSE_WINDOW_COMBO := "!{F4}"
return

/*
  Close current active window.
*/
CloseWindow() {
  SendInputIsolated(CLOSE_WINDOW_COMBO)
}

/*
  Show a text in the middle of the screen for a short time.
  text -- Text to show.
  millisecs -- Time that text lasts on screent.
*/
ShowSplashText(text, millisecs=300) {
  Gui, +AlwaysOnTop +Disabled -SysMenu +Owner  ; +Owner avoids a taskbar button.
  Gui, Add, Text,, %text%
  Gui, Show, NoActivate, ; NoActivate avoids deactivating the currently active window.
  Sleep, %millisecs%
  Gui, destroy
}

ShowProgressText(text, millisecs=300) {
  width := StrLen(text) * 37 
  Progress, zh0 B W%width% fs50, %text%
  Sleep, %millisecs%
  Progress, Off
}

/*
*/
ShiftSwitch(noShift="", LShift="", RShift="") {
  if (RShift == "")
    RShift := LShift
  if (GetKeyState("LShift", "P"))
    (isObject(LShift)) ? LShift.Call() : SendInput(LShift)
  else if (GetKeyState("RShift", "P")) 
    (isObject(RShift)) ? RShift.Call() : SendInput(RShift)
  else 
    (isObject(noShift)) ? noShift.Call() : SendInput(noShift)
}


/*
  Check if a directory exists.
  path - Path to check.
  Returns true if path is a a corrent path to a directory.
*/
DirExist(path) {
  local AttributeString := FileExist(path)
  return InStr(AttributeString, "D") ? AttributeString : ""
}

/* 
  Checks if path is a directory, a file or it doesn't exist.
  Returns "D" if path is a directory, "F" if path is a file, "" if path doesn't
  exist.
*/
IsFileOrDir(path) {
  result := FileExist(path)
  if (!result) ; Path does not exist.
    return ""
  if (InStr(result, "D"))  ; It's a folder?
    return "D"
  return "F" ; It's a file.
}

/*
*/
GetDirFromPath(path) {
  result := IsFileOrDir(path)
  if (!result)
    return ""
  if (result = "F")
    SplitPath, path,, path
  return path
}

/*
  Returns the hexadecimal notation of an int.
*/
int2hex(int)
{
    HEX_INT := 8
    while (HEX_INT--)
    {
        n := (int >> (HEX_INT * 4)) & 0xf
        h .= n > 9 ? chr(0x37 + n) : n
        if (HEX_INT == 0 && HEX_INT//2 == 0)
            h .= " "
    }
    return "0x" h
}

/*
  Returns the hexadecimal notation of an int.
*/
int2hex2(int)
{
  SetFormat, integer, hex
  int += 0
  SetFormat, integer, d
  return int
}

/*
  Checks if a value is in a range: (start, end) or (start, end] or [start, end)
  or [start, end].
  value - Value to check.
  start - Range start.
  end - Range end.
  startIncluded - If true start is included in range, if not it is exlcluded.
  endIncluded - If true end is included in range, if not it is exlcluded.

  Returns true if value is between start and end. If startIncluded is true
  value must be equal or greater, if false only greater, than start. If 
  endIncluded is true, value must be equal or less, if false only less, than
  end.
*/
Between(value, start, end, startIncluded:=true, endIncluded:=true)
{
  return (((startIncluded) ? value >= start : value > start)
      AND ((endIncluded) ? value <= end : value < end))
}

/*
  Return the last element of and array (it doesn't remove it).
*/
Last(a) {
  return a[a.MaxIndex()]
}

/*
  Sometimes, when a window has no effective gain focus, there
  is no keyboard shortcut to regain focus. This function, simulates
  a click in the middle of the window, to set focus.
*/
ClickWndCenter() {
  WinGetPos, x, y, w, h, A
  x := x + w/2
  y := y + h/2
  DllCall("SetCursorPos", "int", x, "int", y) 
  Click
  ; Move mouse to not interfering area.
  DllCall("SetCursorPos", "int", x+w, "int", y+h) 
}

/*
  Binds function with arguments, returning a callable object.
*/
bind(fn, args*) {
    return new BoundFunc(fn, args*)
}

/*
  Class that defines a callable object that holds a function reference and
  its predefined function arguments.
  This object could be call for example:
    value := new BoundFunc("Max", "1", "5", "3").Call()  ; value equals 5.
*/
class BoundFunc {
    __New(fn, args*) {
        this.fn := Func(fn)
        this.args := args
    }
    __Call(callee) {
      return this.fn.Call(this.args*)
    }
}

/*
  Checks if a key has been pressed n times.
  If true, data will be send with sendInput.
  key - Key to check (eg. "LCtrl", "Alt", "RWin", "LShift", ...).
  nTimes - Times to detect key pressed before calling functions.
  delay - Delay between SendInput calls.
  data - Functions to call (without parameters) or data to send using sendInput 
         (eg. "#{Tab}", "#!^h", "{Blind}{Ctrl Down}l{Ctrl Up}"). If more than 
         one data param is passed, the will be sent in sequence, making pauses 
         in between if delay param has been specified greater than 0.
  Returns true if a double pressed of the key has been detected.
*/
NTimesPressed(key, nTimes, delay:=0, data*) {
  static nTimesPressed := 1
  ;LOG.log("Prior key4: " . A_PriorHotKey . " current key: " . key . " A_TimeSincePriorHotkey: " . A_TimeSincePriorHotkey . " nTimesPressed: " . nTimesPressed . " InStr: " . InStr(A_PriorHotkey, key))
  activated := false 
  if ((InStr(A_PriorHotKey, key)) AND (A_TimeSincePriorHotkey < 400)) 
    nTimesPressed := nTimesPressed + 1
  else
    nTimesPressed := 1

  if (nTimesPressed >= nTimes) {
    activated := true
    nTimesPressed := 1          ; Reset
    for index, d in data {
      (IsObject(d))? d.Call() : SendInputIsolated(d)
      if (delay > 0)
        sleep, %delay%
    }
  }
  KeyWait %key%, T3
  return activated
}

MsgBox(test:="") {
  msgbox, %test%
}

KeyWait(key:="") {
  KeyWait, %key%
}

Sleep(time:=0) {
  Sleep, %time%
}

/*
  Function that mimics SendInput command.
  string - String to send.
*/
SendInput(string:="") {
  SendInput, %string%
}

/*
  Send input keys, releasing before any held modifier. If after this method
  is called you want to use the same modifiers combo, you have to physically
  release them and pressed them again.
  data -  Data to send.
  e.g. If for example, SendInputFree("{Tab}") is called while RCtrl and LShift
  is pressed down, it will be translated to:
    SendInput, {RCtrl up}{LShift up}{Tab}
*/
SendInputFree(data*) {
  ; Get all active modifiers.
  prefix := GetFreeModifiers()

  ; Send data without active modifiers.
  for i, d in data {
    ;LOG.log("SendInputFree: " . prefix . d)
    SendInput, %prefix%%d%
  }
}

/*
  Send input keys, releasing before any held modifier and pressing them again
  after if physical key is still pressed.
  data -  Data to send.
  e.g. If for example, SendInputIsolated("{Tab}") is called while RCtrl and LShift
  is pressed down, it will be translated to:
    SendInput, {RCtrl up}{LShift up}{Tab}{LShift down}{RCtrl down}
*/
SendInputIsolated(data*) {
  ; Get all active modifiers.
  prefix := GetFreeModifiers()
  suffix := GetSetModifiers()

  ; Send data without active modifiers.
  for i, d in data {
    ;LOG.log("SendInputIsolated " . prefix . d . suffix)
    SendInput, %prefix%%d%%suffix%
  }
}

/*
  Call function/s, releasing before any held modifier and pressing them again
  after if physical key is still pressed.
  functions - Functions to call.
*/
CallIsolated(functions*) {
  ; Free all active modifiers.
  FreeModifiers()

  ; Call functions without active modifiers.
  for i, f in functions
    f.Call()

  ;sleep, 50
  ; Enable modifiers that are still pressed.
  SetModifiers()
}


/* 
  Dump to log modifiers state.
*/
LogModifiersState() {
  LOG.log("------- Modifiers state --------")
  for i, modifier in ALL_MODIFIERS {
    LOG.log(modifier . " " . GetKeyState(modifier, "P"))
    LOG.log(modifier . " " . GetKeyState(modifier, "T"))
    LOG.log(modifier . " " . GetKeyState(modifier))
  }
}

;/*
;  Set modifiers.
;  modifiers - Name of the modifiers to set (e.g. "Alt", "RCtrl", "LWin", "Shift").
;              If no modifiers are passed, all physically pressed modifiers keys
;              are set.
;*/
;GetSetModifiers(modifiers*) {
;  data := ""
;  if (modifiers.MaxIndex() == "") {
;    for key, modifier in ALL_MODIFIERS
;      if GetKeyState(key, "P") 
;        data := "{" . modifier . " down}" . data
;  }
;  else {
;    for i, modifier in modifiers 
;      data := "{" . modifier . " down}" . data
;  }
;  LOG.log("SetModifiers: " . data)
;  return data
;}
;

;GetFreeModifiers(modifiers*) {
;  data := ""
;  if (modifiers.MaxIndex() == "") {
;    for key, modifier in ALL_MODIFIERS
;      if GetKeyState(key) 
;        data := data . "{" . modifier . " up}"
;  }
;  else {
;    for i, modifier in modifiers
;      data := data . "{" . modifier . " up}"
;  }
;  LOG.log("GetFreeModifiers: " . data)
;  return data
;}

GetFreeModifiers(modifiers*) {
  data := ""
  if (modifiers.MaxIndex() == "")
    modifiers := ALL_MODIFIERS
  for key, modifier in modifiers
    if GetKeyState(key) 
      data := data . "{" . modifier . " up}"
  ;LOG.log("GetFreeModifiers: " . data)
  return data
}

/*
  Releases modifiers.
  modifiers - Name of the modifiers to free (e.g. "Alt", "RCtrl", "LWin", "Shift").
              If no modifiers are passed, all active modifiers will be released.
*/
FreeModifiers(modifiers*) {
  data := GetFreeModifiers(modifiers*)
  SendInput, %data%
}

/*
  Set modifiers.
  modifiers - Name of the modifiers to set (e.g. "Alt", "RCtrl", "LWin", "Shift").
              If no modifiers are passed, all physically pressed modifiers keys
              are set.
*/
GetSetModifiers(modifiers*) {
  data := ""
  if (modifiers.MaxIndex() == "")
    modifiers := ALL_MODIFIERS
  for key, modifier in modifiers
    if GetKeyState(key, "P") 
      data := "{" . modifier . " down}" . data
  ;LOG.log("GetSetModifiers: " . data)
  return data
}

/*
  Set modifiers.
  modifiers - Name of the modifiers to set (e.g. "Alt", "RCtrl", "LWin", "Shift").
              If no modifiers are passed, all physically pressed modifiers keys
              are set.
*/
SetModifiers(modifiers*) {
  data := GetSetModifiers(modifiers*)
  SendInput, %data%
}

/*
*/
FreeModifiersIf3TimesPressedEsc() {
  if (NTimesPressed("ESC", 3,, Func("FreeModifiers"))) 
    ShowTrayTip("Modifiers released.",,2000)
}

/*
  ShellRun by Lexikos
    requires: AutoHotkey_L
    license: http://creativecommons.org/publicdomain/zero/1.0/

  Credit for explaining this method goes to BrandonLive:
  http://brandonlive.com/2008/04/27/getting-the-shell-to-run-an-application-for-you-part-2-how/
 
  Shell.ShellExecute(File [, Arguments, Directory, Operation, Show])
  http://msdn.microsoft.com/en-us/library/windows/desktop/gg537745
*/
ShellRun(prms*) {
    shellWindows := ComObjCreate("{9BA05972-F6A8-11CF-A442-00A0C90A8F39}")
    
    desktop := shellWindows.Item(ComObj(19, 8)) ; VT_UI4, SCW_DESKTOP                
   
    ; Retrieve top-level browser object.
    if ptlb := ComObjQuery(desktop
        , "{4C96BE40-915C-11CF-99D3-00AA004AE837}"  ; SID_STopLevelBrowser
        , "{000214E2-0000-0000-C000-000000000046}") ; IID_IShellBrowser
    {
        ; IShellBrowser.QueryActiveShellView -> IShellView
        if DllCall(NumGet(NumGet(ptlb+0)+15*A_PtrSize), "ptr", ptlb, "ptr*", psv:=0) = 0
        {
            ; Define IID_IDispatch.
            VarSetCapacity(IID_IDispatch, 16)
            NumPut(0x46000000000000C0, NumPut(0x20400, IID_IDispatch, "int64"), "int64")
           
            ; IShellView.GetItemObject -> IDispatch (object which implements IShellFolderViewDual)
            DllCall(NumGet(NumGet(psv+0)+15*A_PtrSize), "ptr", psv
                , "uint", 0, "ptr", &IID_IDispatch, "ptr*", pdisp:=0)
           
            ; Get Shell object.
            shell := ComObj(9,pdisp,1).Application
           
            ; IShellDispatch2.ShellExecute
            shell.ShellExecute(prms*)
           
            ObjRelease(psv)
        }
        ObjRelease(ptlb)
    }
}


/* Flags: Search MSDN for ShowHTMLDialogEx.
#define HTMLDLG_NOUI                     0x0010 // invisible
#define HTMLDLG_MODAL                    0x0020 // normal behaviour
#define HTMLDLG_MODELESS                 0x0040 // returns immediately
#define HTMLDLG_PRINT_TEMPLATE           0x0080
#define HTMLDLG_VERIFY                   0x0100 // force into viewable portion of desktop
#define HTMLDLG_ALLOW_UNKNOWN_THREAD     0x0200 // IE7+
*/

/*  Options: one or more of the following semicolon-delimited values:
dialogHeight:sHeight
    Sets the height of the dialog window.
    Valid unit-of-measure prefixes: cm, mm, in, pt, pc, em, ex, px
dialogLeft:sXPos
    Sets the left position of the dialog window relative to the upper-left
    corner of the desktop.
dialogTop:sYPos
    Sets the top position of the dialog window relative to the upper-left
    corner of the desktop.
dialogWidth:sWidth
    Sets the width of the dialog window.
    Valid unit-of-measure prefixes: cm, mm, in, pt, pc, em, ex, px
center:{ yes | no | 1 | 0 | on | off }
    Specifies whether to center the dialog window within the desktop. Default: yes
dialogHide:{ yes | no | 1 | 0 | on | off }
    Specifies whether the dialog window is hidden when printing or using print
    preview. Default: no
edge:{ sunken | raised }
    Specifies the edge style of the dialog window. Default: raised
resizable:{ yes | no | 1 | 0 | on | off }
    Specifies whether the dialog window has fixed dimensions. Default: no
scroll:{ yes | no | 1 | 0 | on | off }
    Specifies whether the dialog window displays scrollbars. Default: yes
status:{ yes | no | 1 | 0 | on | off }
    Specifies whether the dialog window displays a status bar. Default: no
unadorned:{ yes | no | 1 | 0 | on | off }
    Specifies whether the dialog window displays the window border.
*/
ShowHTMLDialog(URL, argIn="", Options="", hwndParent=0, Flags=0)
{
    ; "Typically, the COM library is initialized on a thread only once. Subsequent
    ;  calls to CoInitialize or CoInitializeEx on the same thread will succeed,..."
    COM_CoInitialize()
    
    hinstMSHTML := DllCall("LoadLibrary","str","MSHTML.DLL")
    hinstUrlMon := DllCall("LoadLibrary","str","urlmon.dll") ; necessary to keep the URL moniker in memory.
    
    if !hinstMSHTML or !hinstUrlMon
        goto ShowHTMLDialog_Exit
    
    pUrl := COM_SysAllocString(URL)
    pUrlMoniker := ""
    Error := ""
    
    hr := DllCall("urlmon\CreateURLMonikerEx","uint",0,"uint",pUrl,"uint*",pUrlMoniker,"uint",1)
    if (ErrorLevel) {
        Error = DllCall(CreateURLMoniker)--%ErrorLevel%
        goto ShowHTMLDialog_Exit
    }
    if (hr or !pUrlMoniker) {
        Error = CreateURLMoniker--%hr%
        goto ShowHTMLDialog_Exit
    }

    pOptions := Options!="" ? COM_SysAllocString(Options) : 0
    
    pArgIn := COM_SysAllocString(argIn)
    VarSetCapacity(varArgIn, 16, 0), NumPut(8,varArgIn,0), NumPut(pArgIn,varArgIn,8)
    VarSetCapacity(varResult, 16, 0)

    if Flags
        hr := DllCall("mshtml\ShowHTMLDialogEx","uint",hwndParent,"uint",pUrlMoniker,"uint",Flags,"uint",&varArgIn,"uint",pOptions,"uint",&varResult)
    else
        hr := DllCall("mshtml\ShowHTMLDialog","uint",hwndParent,"uint",pUrlMoniker,"uint",&varArgIn,"uint",pOptions,"uint",&varResult)
    if (ErrorLevel) {
        Error = DllCall(ShowHTMLDialog)--%ErrorLevel%
        goto ShowHTMLDialog_Exit
    }
    if (hr) {
        Error = ShowHTMLDialog--%hr%
        goto ShowHTMLDialog_Exit
    }
    ; based on a line from COM_Invoke(). returnValue = varResult as string;
    InStr(" 0 4 5 6 7 14 "," " . NumGet(varResult,0,"Ushort") . " ") ? DllCall("oleaut32\VariantChangeTypeEx","Uint",&varResult,"Uint",&varResult,"Uint",0,"Ushort",0,"Ushort",8) : "", NumGet(varResult,0,"Ushort")=8 ? (returnValue:=COM_Ansi4Unicode(NumGet(varResult,8))) . COM_SysFreeString(NumGet(varResult,8)) : returnValue:=NumGet(varResult,8)
    
ShowHTMLDialog_Exit:
    if pArgIn
        COM_SysFreeString(pArgIn)
    if pOptions
        COM_SysFreeString(pOptions)
    if pUrlMoniker
        COM_Release(pUrlMoniker)
    if pUrl
        COM_SysFreeString(pUrl)
    
    ; "Each process maintains a reference count for each loaded library module.
    ;  This reference count is incremented each time LoadLibrary is called and
    ;  is decremented each time FreeLibrary is called."
    ; -- So FreeLibrary() will not unload these DLLs if they were loaded before
    ;    the function was called. :)
    if hinstMSHTML
        DllCall("FreeLibrary","uint",hinstMSHTML)
    if hinstUrlMon
        DllCall("FreeLibrary","uint",hinstUrlMon)
    
    ; "To close the COM library gracefully, each successful call to CoInitialize
    ;  or CoInitializeEx, including those that return S_FALSE, must be balanced
    ;  by a corresponding call to CoUninitialize."
    COM_CoUninitialize()
    
    ErrorLevel := Error
    return returnValue
}

/*
  Finds if there are other windows of the same application and if true,
  activates it the least recently use.
  return -- True if another app window has been activated, false otherwise.
*/
ActivateAppNextWindow() {
  WinGet, ActiveProcess, ProcessName, A
  WinGet, OpenWindowsAmount, Count, ahk_exe %ActiveProcess%
  if OpenWindowsAmount = 1  ; If only one Window exist, do nothing
    return false

  WinGetClass, ClassName, A
  WinGet, windowsList, List, ahk_class %ClassName%
  ; This loop looks for windows of the same class, and the same ActiveProcess.
  Loop, %windowsList%
  {
    index := windowsList - A_Index + 1
    WinGet, name, ProcessName, % "ahk_id " windowsList%index%
    if (name = ActiveProcess)
    {
      WinActivate, % "ahk_id " windowsList%index%	; Activate next Window	
      return true
    }
  }
  return false
}

/*
*/
LockWorkstation() {
  ;lock workstation (note: requires 2 'run as admin' registry writes)
  ;tested with Windows 7

    ;enable 'lock workstation' (and enable Win+L hotkey):
    RegRead, vIsDisabled, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation
    if vIsDisabled
      try RunWait, % "*RunAs " A_ComSpec " /c REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableLockWorkstation /t REG_DWORD /d 0 /f",, Hide ;enable Win+L
      ;RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation, 0 ;enable Win+L

    ;lock workstation:
    DllCall("user32\LockWorkStation")

    ;disable 'lock workstation' (and disable Win+L hotkey):
    RegRead, vIsDisabled, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation
    if !vIsDisabled
      try RunWait, % "*RunAs " A_ComSpec " /c REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableLockWorkstation /t REG_DWORD /d 1 /f",, Hide ;disable Win+L
      ;RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation, 1 ;disable Win+L
}

/*
  Shows a tray notification window.
  notificationMessage - Message to show.
  notificationIcon - Icon to show (view TrayTip command for help).
  time - Time to show the notification (in ms).
*/
ShowTrayTip(notificationMessage, notificationIcon:=17, time:=3000) {
	TrayTip, Autohotkey-main, %notificationMessage%, , %notificationIcon% 
  if (time = -1)
    return
	Sleep %time%
  HideTrayTip()
}

/* 
  Hides a tray notification window.
*/
HideTrayTip() {
  TrayTip  ; Attempt to hide it the normal way.
  if SubStr(A_OSVersion,1,3) = "10." {
    Menu Tray, NoIcon
    Sleep 200  ; It may be necessary to adjust this sleep.
    Menu Tray, Icon
  }
}

