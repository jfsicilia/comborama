/*
  This interface enables some key combos to open selected items with apps.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\interface.ahk

OpenWithInterfaceAutoExec:
  ; Name of interface.
  global __OPEN_WITH_ID__ := "OPEN_WITH_INTERFACE"

  ; Interface's actions.
  global ACTION_OPEN_WITH 
    := {id: "__openWith(f)__", default: Func("__OpenWithDefaultAction__")}

  ; Dictionary with bound keys to functions to open items with apps.
  global __OPEN_WITH_FUNCS__ :=  {"v":Func("__Vim__")
                                , "m":Func("__Chrome__")
                                , "M":Func("__CMD__")
                                , "y":Func("__Typora__")
                                , "e":Func("__FileExplorer__")
                                , "n":Func("__OneCommander__")
                                , "c":Func("__VSCode__")
                                , "t":Func("__WindowsTerminal__")}
return

;----------------------------------------------------------------------  
;------------------------ ACTIONS' HOTKEYS ----------------------------  
;----------------------------------------------------------------------  

; RAlt + RCtrl + <key>
;
; Used keys:    _ _ _ _ _ _ _ _ _ _ _'_'_ _
;                  q w e r t y u i o p _ _ _ 
;                   a s d f g h j k l _ _ 
;                    z x c v b n m _ _ _
;                          

; Open with.
#if (IsActionImplemented(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id) && (!altTabLaunched))
  >!>^a:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "a")
  >!>^b:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "b")
  >!>^c:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "c")
  >!>^d:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "d")
  >!>^e:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "e")
  >!>^f:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "f")
  >!>^g:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "g")
  >!>^h:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "h")
  >!>^i:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "i")
  >!>^j:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "j")
  >!>^k:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "k")
  >!>^l:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "l")
  >!>^m:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "m")
  >!>^+m:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "M")
  >!>^n:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "n")
  >!>^o:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "o")
  >!>^p:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "p")
  >!>^q:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "q")
  >!>^r:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "r")
  >!>^s:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "s")
  >!>^t:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "t")
  >!>^u:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "u")
  >!>^v:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "v")
  >!>^w:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "w")
  >!>^x:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "x")
  >!>^y:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "y")
  >!>^z:: RunInterfaceActionIsolated(__OPEN_WITH_ID__, ACTION_OPEN_WITH.id, "z")
#if

;-----------------------------------------------------------------------------
;                         Open with helper functions
;-----------------------------------------------------------------------------

/* 
  Help function to get selected items in file explorer or similar (must be able
  to copy paths of files to clipboard) and call a handler funtion to process 
  each one.
  handlerFunc -- Handler to a function that receives two params, an index 
                 and a string with a path.
*/
__OpenSelectedItemsWith__(handlerFunc) {
  ; Save clipboard and copy paths (for example in file explorer or everything)
  ; of selected files/folders into clipboard.
  clipSaved := ClipboardAll
  clipboard := ""
  Send, ^c
  ClipWait, 1
  if ErrorLevel {
    clipboard := clipSaved
    return
  }

  ; Parse clipboard, line by line, to get and process the copied paths.
  Loop, Parse, clipboard, `n, `r 
  {
    SplitPath A_LoopField, , dir
    handlerFunc.Call(A_Index, A_LoopField)
  }
  clipboard := clipSaved
}

/*
  Opens selected items with bound app to specified key.
*/
__OpenWithDefaultAction__(key) {
  if (__OPEN_WITH_FUNCS__[key] == "")
    msgbox("No app bound to key '" . key . "'.")
  else
    __OpenSelectedItemsWith__(__OPEN_WITH_FUNCS__[key])
}

/*
  Help function that currently handles opening a path in windows terminal.
  index -- Index of the file. It allows special treatment for 1st item.
  path -- Path to open.

  NOTE: Now FocusOrLaunch function is used to launch/focus Windows Terminal,
  this allows also to open a new tab with the selected path. Before that,
  this command was used to open Windows Terminal.

    run, wt.exe -d "%path%"
*/
__WindowsTerminal__(index, path) {
  path := GetDirFromPath(path) ; Make sure we are dealing with a dir not a file.
  path := Path2WslPath(path)   ; Convert path to wsl's path format.

  ; Windows Terminal is tried to be launch only in first file (index = 1). If
  ; it's tried to be launched it will check if it's already running, in that
  ; case a new tab will be created and set to path.
  if (index > 1) || (FocusOrLaunchWindowsTerminal(true, "-d """ . path . """") = 1)
  {
    ; If Windows terminal already launched, lets create a new tab and set
    ; it to the selected path.
    sleep, 300
    ; Open new tab (Ctrl+numpad5 is customized to do that in Windows Terminal) 
    SendInput, % CtrlCombo("{numpad5}")
    sleep, 300
    ; Set path (wslpath is used to convert path from windows to wsl).
    SendInput, cd "%path%"{Enter}
    ; There's no need to use wslpath anymore. No the path conversion is done
    ; adhoc at the beginning of this function.
    ;SendInput, cd $(wslpath "%path%"){Enter}
  }
  else ; WindowsTerminal was not running, wait until it loads.
    sleep, 500
}

/*
  Help function that currently handles opening a path in cmd.exe.
  index -- Index of the file. It allows special treatment for 1st item.
  path -- Path to open.
*/
__CMD__(index, path) {
  path := GetDirFromPath(path) ; Make sure we are dealing with a dir not a file.

  result := FocusOrLaunchCmd()
  sleep, 200
  ; If not the first path or cmd was already opened, open a new tab.
  if (index > 1) || (result = 1) {
    ; Open new tab (Shift+Ctrl+2 is the shortcut to create a cmd window tab).
    SendInput, % ShiftCtrlCombo("2")
    sleep, 200
  }
  SendInput, cd "%path%"{Enter}
}

/*
  Help function that currently handles opening a path in file explorer. 
  If many paths are selected, they will be opened in tabs.
  index -- Index of the file. It allows special treatment for 1st item.
  path -- Path to open.
*/
__FileExplorer__(index, path) {
  path := GetDirFromPath(path) ; Make sure we are dealing with a dir not a file.
  ; Before the first path is processed, focus or launch File Explorer.
  if (index = 1) {
    ; Focus or launchs File Explorer.
    result := FocusOrLaunchFileExplorer()
    ; If File Explorer has been launched, wait until is ready.
    if (result = 2) {
      ; Define the group: Windows Explorer windows
      GroupAdd, Explorer, ahk_class ExploreWClass ; Unused on Vista and later
      GroupAdd, Explorer, ahk_class CabinetWClass

      WinWait, % "ahk_group Explorer"
      WinActivate, % "ahk_group Explorer"
    }
  }
  ; Open path in new tab.
  Sleep, 800
  SendInputIsolated("^t")
  Sleep, 800
  SendInputIsolated("!d")
  Sleep, 800
  SendInputIsolated(path . "{Enter}")
  Sleep, 400
}

/*
  Help function that currently handles opening a path in OneCommander. 
  If many paths are selected, they will be opened in tabs.
  index -- Index of the file. It allows special treatment for 1st item.
  path -- Path to open.
*/
__OneCommander__(index, path) {
  path := GetDirFromPath(path) ; Make sure we are dealing with a dir not a file.
  ; Before the first path is processed, focus or launch OneCommander.
  if (index = 1) {
    ; Focus or launchs onecommander
    result := FocusOrLaunchOneCommander()
    ; If onecommander has been launched, wait until is ready.
    if (result = 2) {
      WinWait, % "ahk_exe OneCommander.exe"
      WinActivate, % "ahk_exe OneCommander.exe"
    }
  }
  Sleep, 500
  ; Open path in new tab.
  SendInputIsolated("^t")
  Sleep, 500
  SendInputIsolated("\")
  Sleep, 500
  SendInputIsolated(path . "{Enter}")
}


/*
  Help function that currently handles opening a path in VSCode.
  index -- Index of the path to process. If 1 launch or focus VSCode 
           before trying to open path.
  path -- Path can be a file path or a folder path. A file path it's opened
          in a new editor tab. A folder path is set in VSCode as a root
          project path.
*/
;__VSCode__(index, path) {
;  ; Before the first path is processed, focus or launch VSCode.
;  if (index = 1) {
;    result := FocusOrLaunchVSCode()
;    ; If vscode has been launched, wait until is ready.
;    if (result = 2) {
;      WinWait, % "ahk_exe code.exe"
;      WinActivate, % "ahk_exe code.exe"
;      sleep, 1500
;    }
;  }
;  
;  file_or_dir := IsFileOrDir(path)
;  if (file_or_dir = "D") { ; It's a folder?
;    SendInput, ^k^o
;    sleep, 300
;    SendInput, %path%{Enter}{Enter}
;    return
;  }
;  if (file_or_dir = "F") { ; It's a file?
;    SendInput, ^o
;    sleep, 300
;    SendInput, %path%{Enter}
;  }
;}

/*
  Help function that currently handles opening a path in VSCode.
  index -- Index of the path to process. If 1 launch or focus VSCode 
           before trying to open path.
  path -- Path can be a file path or a folder path. A file path it's opened
          in a new editor tab. A folder path is set in VSCode as a root
          project path.
*/
__VSCode__(index, path) {
  file_or_dir := IsFileOrDir(path)
  ; Open WindowsTerminal if dealing with a wsl path or Cmd otherwise.
  if (InStr(path, "\\wsl$\") > 0) {
    __WindowsTerminal__(index, path)
    path := Path2WslPath(path)
  }
  else
    __CMD__(index, path)

  ; Open folder if path is a folder or file if it is a file.
  if (file_or_dir = "D")            ; It's a folder? 
    SendInput, code .{Enter}
  else                              ; It's a file.
    SendInput, code "%path%"{Enter} 
}


/*
  Help function that currently handles opening a file path in vim.
  index -- Index of the file to process. If 1 launch or focus vim
           before trying to open file.
  file -- File path.
*/
__Vim__(index, file) {
  ; Before the first path is processed, focus or launch vim.
  if (index = 1) {
    ; Focus or launchs vim (if launched, option: -c "cd <path>", 
    ; is used to set the path).
    result := FocusOrLaunchVim(true, "-c ""cd " . GetDirFromPath(file) . """")
    ; If vim has been launched, wait until is ready.
    if (result = 2) {
      WinWait, % "ahk_exe gvim.exe"
      WinActivate, % "ahk_exe gvim.exe"
    }
  }
  ; Open file in vim, using 'e' command.
  SendInput, {Esc}:e %file%{Enter}
}

/*
  Help function that currently handles opening a file path in chrome.
  index - Index of the file to process. If 1 launch or focus chrome
          before trying to open file.
  file - File path.
*/
__Chrome__(index, file) {
  ; Before the first path is processed, focus or launch app.
  if (index = 1) {
    result := FocusOrLaunchChrome()
    ; If app has been launched, wait until is ready.
    if (result = 2) {
      WinWait, % "ahk_exe chrome.exe"
      WinActivate, % "ahk_exe chrome.exe"
    }
  }
  ; Open file in chrome in new tab.
  SendInput, {LCtrl down}t{LCtrl up}%file%{Enter}
}

/*
  Help function that currently handles opening a file path in typora.
  index - Index of the file to process. It's ignored because each file
          launches an instance of typora.
  file - File path.
*/
__Typora__(index, file) {
  FocusOrLaunchTypora(true, file, true)
}

/*
  Help function that handles running a file with the joplin_bookcase_link.bat.
  index - Index of the file to process. It's ignored because each file
          launches an instance of typora.
  file - File path.
*/
__JoplinLinkScript__(index, file) {
  ; Before the first path is processed, focus or launch vim.
  run, c:\tools\joplin_bookcase_link\joplin_bookcase_link.bat "%file%"
}

;----------------------------------------------------------------------  
;------------------------ HELPER FUNCTIONS ----------------------------  
;----------------------------------------------------------------------  

/*
  Call this function to implement the interface. 
  appsId -- (String or Array of strings) Name of app/apps that will implement
            this interface. The name of the app could be:
              1) The process name (as the one get by "WinGet, ..., ProcessName, A")
              2) The class name (as the one get by "WinGetClass, ..., A")
              3) ANY_APP_ID constant that will behave as a wildcard for any app.
  actions -- After appsId param, there will be 1 or more params that must be 
             supplied to implement the interface. Each param represents a 
             bound hotkey that when issued and action will be run. Each of 
             these params expects an action to be run. The value of these 
             params could be one of these:
              1) String -- Action will be: SendInput <string>
              2) Function -- Action will be: Function.Call() (Some actions 
                             have parameters so the function to pass must 
                             receive parameters).
              3) DEFAULT_IMPLEMENTATION -- Action will be a string/function 
                                           predefined.
              4) NOT_IMPLEMENTED -- No action will be run.
*/
ImplementOpenWithInterface(appsId
  , openWith) {                 ; Open with

  app := {}
  app[ACTION_OPEN_WITH.id]       
    := (openWith != DEFAULT_IMPLEMENTATION) ? openWith : ACTION_OPEN_WITH.default

  ImplementInterface(__OPEN_WITH_ID__, appsId, app)
}

/*
  Default implementation for the interface. See Implement<...>Interface function.
*/
DefaultImplementationOpenWithInterface(appsId) {
  ImplementOpenWithInterface(appsId, DEFAULT_IMPLEMENTATION)
}

