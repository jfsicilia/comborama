/*
  This module enables some misc key combos.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\mod_tab.ahk

MiscAutoExec:
  ; If the user is in the middle of an alt+tab combo, this var is true. False,
  ; otherwise.
  global altTabLaunched := false
return

;----------------------------------------------------------------------------
;                            Apps switching
;----------------------------------------------------------------------------
; I have reassigned modifiers keys with keysharp. Alt+Tab windows functinality
; is now done with LCtrl + Tab.
LCtrl & Tab:: AltTabLaunch() 

#If (altTabLaunched)
  ~*LCtrl Up:: AltTabRelease()
#If

;----------------------------------------------------------------------------
;                            Tabs switching
;----------------------------------------------------------------------------

; Allows Win-Tab for tab switching after Ctrl-Tab replaces Alt-Tab for
; apps switching.
>#<^l::
>#<^right::
<#Tab:: SendInputIsolated(RCtrlCombo("{Tab}"))
>#<^h::
>#<^left::
<#+Tab:: SendInputIsolated(RShiftRCtrlCombo("{Tab}"))

;----------------------------------------------------------------------------
;                             Print Screen
;----------------------------------------------------------------------------

; Capture entire screen with PrintScreen
PrintScreen::send #{PrintScreen}

; Capture portion of the screen with Shitf + PrintScreen
<!PrintScreen::
+PrintScreen::send #+s

;----------------------------------------------------------------------------
;                          Task View / Mission Control
;----------------------------------------------------------------------------

; Show TaskView (Mac's mission control equivalent).
<#`::>#Tab

;----------------------------------------------------------------------------
;                             Autohotkey management
;----------------------------------------------------------------------------

; Check if ESC is double pressed to launch free modifiers. Function is defined
; in lib_misc.ahk.
~*ESC up:: FreeModifiersIf3TimesPressedEsc()

; Reload autohotkey main script.
#if true
  Tab & r:: ReloadMain()
#if

;----------------------------------------------------------------------------
;                                Window Session
;----------------------------------------------------------------------------

; Win+L is disabled to allow LWin & RWin shortcut combinations (see 
; ghk_disable_windows_combos.ahk). In order not to loose the functionality 
; to lock the session, this is provided here.
<#l:: LockWorkstation() 

;----------------------------------------------------------------------------
;                            Syncronization
;----------------------------------------------------------------------------

; Sync WSL folders with free file sync.
#if true
  Tab & s:: SyncWSL()
#if

;----------------------------------------------------------------------------
;                              Widgets
;----------------------------------------------------------------------------

; Toggle SidebarDiagnostics.
#if true
  Tab & m:: SendInputIsolated("!^{F12}")
#if

;----------------------------------------------------------------------------
;                              Language
;----------------------------------------------------------------------------

; Toggle on/off writing with accents.
#if true
  Tab & a:: ToggleAltCharsWithNotification()
#if

;----------------------------------------------------------------------------
;                              System
;----------------------------------------------------------------------------

; Shutdown or suspend/sleep.
#if true
  Tab & q:: ShutdownSleepHibernate()
#if

; Launch Task manager application dialog
#if true
  Tab & ESC:: RunTaskManager() 
#if

;----------------------------------------------------------------------------
;                           Helper functions.
;----------------------------------------------------------------------------

/*
  Launch windows alt+tab functionality.
  It sets internally global variable altTabLaunched to true.
*/
AltTabLaunch() {
  altTabLaunched := true
  if (GetKeyState("LShift","P"))
    Send {Alt Down}{LShift Down}{Tab}
  else if (GetKeyState("RShift", "P"))
    Send {Alt Down}{RShift Down}{Tab}
  else
    Send {Alt Down}{Tab}
}

/*
  Shuts windows alt+tab functionality.
  It sets internally global variable altTabLaunched to false.
*/
AltTabRelease() {
    Send {Shift Up}{Alt Up}
    altTabLaunched := false 
}

/*
 Reload autohotkey main script.
*/
ReloadMain() {
  ShowTrayTip("Reloading autohotkey main script...",,1000)
  Reload
}

/*
 Sync WSL folders with free file sync.
*/
SyncWSL() {
  global DEFAULT_FOLDER
  ffs_file := DEFAULT_FOLDER . "\settings\freefilesync\wsl_projects.ffs_batch"
  run "c:\Program Files\FreeFileSync\FreeFileSync.exe" %ffs_file%
}

/*
  Opens task manager.
*/
RunTaskManager() {
  run taskmgr.exe
}

/*
  Check if ESC has been pressed 3 times in a short time. If that happens,
  FreeModifiers is called.
*/
FreeModifiersIf3TimesPressedEsc() {
  if (NTimesPressed("ESC", 3,, Func("FreeModifiers"))) 
    ShowTrayTip("Modifiers released.",,2000)
}

/*
  Shutdown, hibernate or sleep computer. If alt key is pressed then shutdown 
  is issued, if shift is pressed then hibernate is issued. If none of those
  two are pressed, then sleep is issued.
*/
ShutdownSleepHibernate() {
  ; If Alt key is pressed, shutdown is carried.
  if GetKeyState("Alt", "P") {
    Shutdown, 1
  }
  ; If Alt key was not pressed, sleep (shift up) or hibernate (shift down) is
  ; carried.
  else {
    ; Set off DisableLockWorkstation to require login after sleep.
    RegRead, vIsDisabled, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation
    if vIsDisabled
      try RunWait, % "*RunAs " A_ComSpec " /c REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableLockWorkstation /t REG_DWORD /d 0 /f",, Hide ;enable Win+L

    if GetKeyState("Shift", "P")
      DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0) ; Hibernate
    else
      DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0) ; Sleep

    RegRead, vIsDisabled, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation
    if !vIsDisabled
      try RunWait, % "*RunAs " A_ComSpec " /c REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableLockWorkstation /t REG_DWORD /d 1 /f",, Hide ;disable Win+L
  }
}


