/*
  This library provides functions to launch or activate applications. 

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_log.ahk
#include %A_ScriptDir%\lib_misc.ahk
#include %A_ScriptDir%\lib_combo.ahk
#include %A_ScriptDir%\lib_desktop.ahk

LibAppsAutoExec:
  ; Combo to launch OneCommander.
  global ONE_COMMANDER_FOCUS_COMBO := "#!o"
return

;-----------------------------------------------------------------------------
;                               LAUNCH APPs 
;-----------------------------------------------------------------------------

/*
  Focus or launchs an application. First it tries to find if the app is running
  in the same destktop or others. If so, it activates the app window. If it 
  is not running, it will try to launch it, if appRun parameter is specified.
 
  appExe -- (optional) App exe name to find with ahk_exe (optional).
  appTitle -- (optional) App title to find (optional). 
  appRun -- Filename or full path to launch app with run command (optional).
            If appRun is omitted, if won't try the launch step if app is 
            not running.
  hidden -- Check for hidden/other desktops apps?
  appRunParam -- If additional parameters are required for appRun, set this
                 parameter.
  forceLaunch -- If true, avoids finding if app is running, just tries to 
                 launch app (see appRun and appRunParams).
  appCombo -- (optional) If appCombo is present, it will be issued to focus 
              app if forceLaunch is false (example "#!o" is a global combo to 
              focus oneCommander).
  Returns 0 if app wasn't running and didn't/couldn't launch it.
          1 if app is running and it has been activated.
          2 if app wasn't running and it has been launched. 
*/
FocusOrLaunchApp(appExe := "", appTitle := "", appRun := "", hidden := true, appRunParam := "", forceLaunch := false, appCombo := "") {

  winTitle := (appExe != "") ? "ahk_exe " . appExe : appTitle
  hwnd := WinExist(winTitle) 

  if (!forceLaunch) {
    ; If there is an app combo to focus it, use it.
    if (appCombo) {
      SendInputIsolated(appCombo)
      return 1
    }

    ; Tries to find if app is running.
    if ((hidden) && (hwnd = 0)) {
      DetectHiddenWindows, On
      hwnd := WinExist(winTitle)
      DetectHiddenWindows, Off
    }

    ; If app is running, activate it.
    if %hwnd% {
      ; GW_HWNDFIRST:=0, GW_HWNDLAST:=1, GW_HWNDNEXT:=2, GW_HWNDPREV:=3, GW_OWNER:=4, GW_CHILD:=5, GW_ENABLEDPOPUP:=6, 
      ; Get owner windows handler (GW_OWNTER:=4).
      ownerHwnd := DllCall("GetWindow", "ptr", hwnd, "uint", 4, "ptr")

      ; If there is an owner window, set app handler to that.
      if %ownerHwnd%
        hwnd := ownerHwnd

      ; Check if the app is in the same desktop. If not, change desktop.
      desktop := GetDesktop(hwnd)
      if (desktop < 1) ; Sanity check for some special apps that return -1.
        desktop := 1
      currentDesktop := GetDesktop()
      if (desktop != currentDesktop)
        GoToDesktop(desktop,,false)

      WinShow, ahk_id %hwnd%
      WinActivate, ahk_id %hwnd%
      return 1
    }
  }

  ; App is not running, launch it if an appRun has been specified.
  if (appRun != "") {
    ; ShellRun allows to launch apps in not elevation mode in spite of 
    ; launching this script in elevation mode.
    ShellRun(appRun, appRunParam)

    WinWait, %winTitle%,,2
    if ErrorLevel 
    {
      return 0
    }
    return 2
  }
  return 0
}

/*
  Param dir If dir is specified (not ""), if FileExplorer must be launch or
            it was already running and just focus the app, it will set the
            current path to the dir param. If dir is not specified, it will
            leave the current path on the already running FileExplorer or,
            if the FileExplorer is launched it will use de DEFAULT_FOLDER.
  Returns 1 if file explorer is running and it has been activated.
          2 if file explorer wasn't running and it has been launched. 
*/
FocusOrLaunchFileExplorer(dir := "") {
  ; Define the group: Windows Explorer windows
  GroupAdd, Explorer, ahk_class ExploreWClass ; Unused on Vista and later
  GroupAdd, Explorer, ahk_class CabinetWClass

  ; Is File Explorer already opened?
  if WinExist("ahk_group Explorer") {
    WinActivate
    ControlFocus, DirectUIHWND2, A
    WinWait, ahk_group Explorer,,3
    if ErrorLevel
      return 0
    if (dir != "")
      ExplorerGoTo(dir)
    return 1
  }

  ; Run File Explorer.
  run, explorer.exe
  WinWait, ahk_group Explorer,,3
  if ErrorLevel
    return 0
  dir := (dir = "") ? DEFAULT_FOLDER : dir
  ExplorerGoTo(dir)
  return 2
}

;-----------------------------------------------------------------------------
;      Help functions to launch/focus common applications.
;-----------------------------------------------------------------------------

/*
  Focus or launch Atana.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchAtani(hidden := true) {
  return FocusOrLaunchApp("Atani.exe",, HOME_FOLDER . "\AppData\Local\Programs\Atani\Atani.exe", hidden)
}

/*
  Focus or launch Brave.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchBrave(hidden := true) {
  return FocusOrLaunchApp("brave.exe",, "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe", hidden)
}

/*
  Focus or launch Everything.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchEverything(hidden := true) {
  ToggleEverythingApp()
  return 1
  ;return FocusOrLaunchApp("everything.exe",, "C:\Program Files\Everything\Everything.exe", hidden,,, "{RAlt Down}{LCtrl}{RAlt up}")
}

/*
  Focus or launch VirtualBox.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchVirtualBox(hidden := true) {
  return FocusOrLaunchApp("VirtualBoxVM.exe",, "C:\Program Files\Oracle\VirtualBox\VirtualBox.exe", hidden)
}

/*
  Focus or launch Blender.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchBlender(hidden := true) {
; TODO
  return FocusOrLaunchApp(, "Blender", "C:\Program Files\Blender Foundation\Blender 2.93\blender.exe", hidden)
}

/*
  Focus or launch Edge.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchEdge(hidden := true) {
  return FocusOrLaunchApp("msedge.exe",, "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", hidden)
}

/*
  Focus or launch VSCode.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchVSCode(hidden := true) {
  return FocusOrLaunchApp("code.exe",, "code", hidden)
}

/*
  Focus or launch Discord.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchDiscord(hidden := true) {
  return FocusOrLaunchApp(,"Discord", HOME_FOLDER . "\AppData\Local\Discord\Update.exe", hidden, "--processStart Discord.exe")
}

/*
  Focus or launch GoldenDict.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchGoldenDict(hidden := true) {
  return FocusOrLaunchApp(, "GoldenDict", "C:\Program Files (x86)\GoldenDict\GoldenDict.exe", hidden)
}

/*
  Focus or launch Fusion360.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchFusion360(hidden := true) {
  return FocusOrLaunchApp("fusion360.exe",, HOME_FOLDER . "\AppData\Local\Autodesk\webdeploy\production\6a0c9611291d45bb9226980209917c3d\FusionLauncher.exe", hidden)
}

/*
  Focus or launch Joplin.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchJoplin(hidden := true) {
  return FocusOrLaunchApp(, "Joplin", HOME_FOLDER . "\AppData\Local\Programs\Joplin\Joplin.exe", hidden)
}

/*
  Focus or launch KeePassXC.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchKeePassXC(hidden := true) {
  return FocusOrLaunchApp("KeePassXC.exe",, "C:\Program Files\KeePassXC\KeePassXC.exe", hidden)
}

/*
  Focus or launch OneCommander.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchOneCommander(hidden := true) {
  SendInputFree(ONE_COMMANDER_FOCUS_COMBO)
;  return FocusOrLaunchApp("OneCommander.exe", , HOME_FOLDER . "\bin\windows\OneCommander\OneCommander.exe", hidden,,,ONE_COMMANDER_FOCUS_COMBO)
;  return FocusOrLaunchApp(, "ahk_class HwndWrapper[OneCommander.exe;;85e0a275-8de1-4c9e-9606-f3f0f273150b]", HOME_FOLDER . "\bin\windows\OneCommander\OneCommander.exe", hidden)
}

/*
  Focus or launch Opera.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchOpera(hidden := true) {
  return FocusOrLaunchApp("opera.exe",, HOME_FOLDER . "\AppData\Local\Programs\Opera\launcher.exe", hidden)
}


/*
  Focus or launch FreeFileSync.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchFreeFileSync(hidden := true) {
  return FocusOrLaunchApp("FreeFileSync.exe",, "C:\Program Files\FreeFileSync\FreeFileSync.exe", hidden)
}

/*
  Focus or launch Firefox.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchFirefox(hidden := true) {
  return FocusOrLaunchApp("firefox.exe",, "firefox.exe", hidden)
}

/*
  Focus or launch Chrome.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchChrome(hidden := true, params := "") {
  return FocusOrLaunchApp("chrome.exe",, "chrome.exe", hidden, params)
}

/*
  Focus or launch Word.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchWord(hidden := true) {
;If you use ahk_class instead of title, use this --- >!o:: FocusOrLaunchApp( , "OpusApp", "C:\Program Files (x86)\Microsoft Office\root\Office16\WINWORD.EXE")
  return FocusOrLaunchApp( , "ahk_class OpusApp", "C:\Program Files (x86)\Microsoft Office\root\Office16\WINWORD.EXE")
  ;return FocusOrLaunchApp("WINWORD.EXE",, "C:\Program Files (x86)\Microsoft Office\root\Office16\WINWORD.EXE", false)
}

/*
  Focus or launch AffinityPhoto.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchAffinityPhoto(hidden := true) {
  return FocusOrLaunchApp(, "Affinity Photo", "C:\Program Files\Affinity\Photo\Photo.exe", hidden)
}

/*
  Focus or launch AffinityDesigner.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchAffinityDesigner(hidden := true) {
  return FocusOrLaunchApp(, "Affinity Designer", "C:\Program Files\Affinity\Designer\Designer.exe", hidden)
}

/*
  Focus or launch Spotify.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchSpotify(hidden := true) {
  return FocusOrLaunchApp("Spotify.exe",, HOME_FOLDER . "\AppData\Roaming\Spotify\Spotify.exe", hidden)
}

/*
  Focus or launch WindowsTerminal.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
  params -- Command line params to set if Windows terminal is launched.
*/
FocusOrLaunchWindowsTerminal(hidden := true, params := "") {
  return FocusOrLaunchApp("WindowsTerminal.exe",, "wt.exe", hidden, params)
}

/*
  Focus or launch CMD.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
  params -- Command line params to set if Windows terminal is launched.
*/
FocusOrLaunchCmd(hidden := true, params := "") {
  ;return FocusOrLaunchApp(,"C:\Windows\system32\cmd.exe", "cmd.exe", hidden, params)
  return FocusOrLaunchApp("WindowsTerminal.exe",, "cmd.exe", hidden, params)
}

/*
  Focus or launch Telegram.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
  params -- Command line params to set if Windows terminal is launched.
*/
FocusOrLaunchTelegram(hidden := true, params := "") {
  return FocusOrLaunchApp(, "Telegram", HOME_FOLDER . "\AppData\Roaming\Telegram Desktop\Telegram.exe", hidden, params)
}

/*
  Focus or launch Cura.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchCura(hidden := true) {
; TODO
  return FocusOrLaunchApp("cura.exe",, "C:\Program Files\Ultimaker Cura 4.11.0\Cura.exe", hidden)
}

/*
  Focus or launch Vim.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchVim(hidden := true, params := "") {
  return FocusOrLaunchApp("gvim.exe",, "gvim", hidden, params)
}

/*
  Focus or launch Whatsapp.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchWhatsApp(hidden := true) {
  return FocusOrLaunchApp(, "WhatsApp", HOME_FOLDER . "\AppData\Local\WhatsApp\WhatsApp.exe", hidden)
}

/*
  Focus or launch Excel.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchExcel(hidden := true) {
;If you use ahk_class instead of title, use this --- >!x:: 
  return FocusOrLaunchApp( , "ahk_class XLMAIN", "C:\Program Files (x86)\Microsoft Office\root\Office16\EXCEL.EXE")
  ;return FocusOrLaunchApp("EXCEL.EXE" , , "C:\Program Files (x86)\Microsoft Office\root\Office16\EXCEL.EXE", hidden)
}

/*
  Focus or launch Typora.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchTypora(hidden := true, params := "", forceLaunch := false) {
  return FocusOrLaunchApp("Typora.exe",, HOME_FOLDER . "\AppData\Local\Programs\Typora\Typora.exe", hidden, params, forceLaunch)
}

/*
  Focus or launch Zeal.
  hidden -- If true forces to look for the app even if it's hidden or in 
            another desktop.
*/
FocusOrLaunchZeal(hidden := true) {
  return FocusOrLaunchApp("zeal.exe",, "C:\Program Files\Zeal\zeal.exe", hidden)
}
