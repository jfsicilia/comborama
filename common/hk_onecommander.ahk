/*

*/
#include %A_ScriptDir%\lib_misc.ahk
#include %A_ScriptDir%\ghk_interface_tabs.ahk
#include %A_ScriptDir%\ghk_interface_history.ahk
#include %A_ScriptDir%\ghk_interface_address.ahk
#include %A_ScriptDir%\ghk_interface_favs.ahk
#include %A_ScriptDir%\ghk_interface_edit.ahk
#include %A_ScriptDir%\ghk_interface_file_manager.ahk
#include %A_ScriptDir%\ghk_interface_alt_cursor.ahk

OneCmdrAutoExec:
  global ONE_COMMANDER_PREV_TAB_COMBO := RShiftRCtrlCombo("{Tab}")
  global ONE_COMMANDER_NEXT_TAB_COMBO := RCtrlCombo("{Tab}")
  global ONE_COMMANDER_GET_PATH_COMBO := "+!^c"
  global ONE_COMMANDER_ALT_PANE_COMBO := LAltCombo("f")
  global ONE_COMMANDER_MOVE_TAB_TO_NEXT_PANE := "!{MButton}"
  global ONE_COMMANDER_BACK_HISTORY := "!{left}"
  global ONE_COMMANDER_FORWARD_HISTORY := "!{right}"
  global ONE_COMMANDER_ADDRESS_BAR := "\"

  ImplementTabsInterface("OneCommander.exe"
    , ONE_COMMANDER_NEXT_TAB_COMBO       ; Next tab
    , ONE_COMMANDER_PREV_TAB_COMBO       ; Prev tab
    , ONE_COMMANDER_NEXT_TAB_COMBO       ; Recently used tab
    , NO_BOUND_ACTION_MSGBOX             ; Go to tab by number.
    , NO_BOUND_ACTION_MSGBOX             ; Move tab right.
    , NO_BOUND_ACTION_MSGBOX             ; Move tab left.
    , NO_BOUND_ACTION_MSGBOX             ; Move tab first.
    , NO_BOUND_ACTION_MSGBOX             ; Move tab last.
    , DEFAULT_IMPLEMENTATION             ; New tab.
    , DEFAULT_IMPLEMENTATION             ; Close tab.
    , DEFAULT_IMPLEMENTATION)            ; Undo close tab.

  ImplementPanesInterface("OneCommander.exe"
    , ONE_COMMANDER_ALT_PANE_COMBO        ; Recent pane
    , NOT_IMPLEMENTED                     ; Go pane by number
    , ONE_COMMANDER_ALT_PANE_COMBO        ; Go left pane
    , ONE_COMMANDER_ALT_PANE_COMBO        ; Go right pane
    , ONE_COMMANDER_ALT_PANE_COMBO        ; Go down pane
    , ONE_COMMANDER_ALT_PANE_COMBO        ; Go up pane
    , ONE_COMMANDER_MOVE_TAB_TO_NEXT_PANE ; Move left pane   
    , ONE_COMMANDER_MOVE_TAB_TO_NEXT_PANE ; Move right pane
    , NOT_IMPLEMENTED                     ; Move down pane   
    , NOT_IMPLEMENTED                     ; Move up pane
    , NOT_IMPLEMENTED                     ; Resize left pane 
    , NOT_IMPLEMENTED                     ; Resize right pane
    , NOT_IMPLEMENTED                     ; Resize down pane 
    , NOT_IMPLEMENTED                     ; Resize up pane   
    , NOT_IMPLEMENTED                     ; Swap left pane   
    , NOT_IMPLEMENTED                     ; Swap right pane
    , NOT_IMPLEMENTED                     ; Swap down pane 
    , NOT_IMPLEMENTED                     ; Swap up pane   
    , NOT_IMPLEMENTED                     ; Max/Restore pane
    , NOT_IMPLEMENTED                     ; Horizontal pane split.
    , NOT_IMPLEMENTED                     ; Vertical pane split.
    , NOT_IMPLEMENTED)                    ; Close pane.

  ImplementHistoryInterface("OneCommander.exe"
    , ONE_COMMANDER_BACK_HISTORY
    , ONE_COMMANDER_FORWARD_HISTORY)

  ImplementAddressInterface("OneCommander.exe"
    , ONE_COMMANDER_ADDRESS_BAR)         ; Focus address bar. 

  ImplementFavsInterface("OneCommander.exe"
    , func("OneCommanderGoToFav"))      ; Go to fav.

  ImplementEditInterface("OneCommander.exe"
    , bind("ShiftSwitch", "^c", "^!+c", "^+c")                        ; Copy
    , DEFAULT_IMPLEMENTATION                                          ; Cut        
    , bind("ShiftSwitch", "^v", Func("OneCommanderMoveFiles"), "#v")  ; Paste
    , func("OneCommanderUndo")                                        ; Undo 
    , func("OneCommanderRedo")                                        ; Redo
    , DEFAULT_IMPLEMENTATION)                                         ; Delete

  ImplementFileManagerInterface("OneCommander.exe"
    , ""                      ; Prefiew file/folder
    , "{enter}"               ; Open file/folder
    , "!{up}"                 ; Go parent folder
    , "{F2}"                  ; Rename file/folder
    , "{F5}"                  ; Refresh file manager
    , "^i"                    ; Show info of file/folder
    , "{F3}"                  ; Find
    , "^d"                    ; Duplicate file/folder
    , "^a"                    ; Select all files/folders
    , "^n"                    ; New file
    , "^+n"                   ; New folder
    , "{F9}"                  ; Context menu
    ; View file/folder.
    , bind("ShiftSwitch", bind("__OpenSelectedItemsWith__", Func("__Chrome__"))) 
    ; Edit file/folder.
    , bind("ShiftSwitch", bind("__OpenSelectedItemsWith__", Func("__Vim__"))
                        , bind("__OpenSelectedItemsWith__", Func("__VSCode__"))
                        , bind("__OpenSelectedItemsWith__", Func("__Typora__")))
    ; Explore folder.
    , bind("ShiftSwitch", bind("__OpenSelectedItemsWith__", Func("__WindowsTerminal__"))
                        , "{F10}"  ; Open in CMD
                        , bind("__OpenSelectedItemsWith__", Func("__FileExplorer__")))
    , "!c"                    ; Copy to other pane
    , "!m")                   ; Move to other pane

  DefaultImplementationOpenWithInterface("OneCommander.exe")

  DefaultImplementationAltCursorInterface("OneCommander.exe")

  ImplementSeekAndSelInterface("OneCommander.exe"
    , ONE_COMMANDER_ADDRESS_BAR           ; Ctrl + Space
    , NO_BOUND_ACTION_MSGBOX              ; Ctrl + Shift + Space
    , bind("ShowFavFoldersListBox", func("OneCommanderGoTo"))       ; Alt + Space
    , NO_BOUND_ACTION_MSGBOX              ; Alt + Shift + Space
    , NO_BOUND_ACTION_MSGBOX              ; Win + Space
    , NO_BOUND_ACTION_MSGBOX)             ; Win + Shift + Space
return

#if (WinActive("ahk_exe OneCommander.exe"))
#if

/*
  Go to path.
  path -- Path to go.
*/
OneCommanderGoTo(path) {
  FreeModifiers()
  SendInput("\")
  Sleep, 50
  SendInput(path . "{Enter}")
  SetModifiers()
}

/*
  Go to favourite folder by key. The key param will be the key in the 
  FAV_FOLDERS_PATH dictionary to retrive a path. 
  key -- Key to retrieve a path in the FAV_FOLDERS_PATH dictionary.
*/
OneCommanderGoToFav(key) {
  OneCommanderGoTo(FAV_FOLDERS_PATH[key])
}

/*
  Undo last operation in OneCommander. OneCommander is not allowed to do that
  in Windows OS, therefore we switch to Windows File Explorer, undo there, and
  then come back to OneCommander.
*/
OneCommanderUndo() {
  FocusOrLaunchFileExplorer()    
  SendInputIsolated("^z")
  FocusOrLaunchOneCommander()

}

/*
  Redo last operation in OneCommander. OneCommander is not allowed to do that
  in Windows OS, therefore we switch to Windows File Explorer, redo there, and
  then come back to OneCommander.
*/
OneCommanderRedo() {
  FocusOrLaunchFileExplorer()    
  SendInputIsolated("^y")
  FocusOrLaunchOneCommander()
}

/*
  Get current path in OneCommander browser.
  return -- Current path.
*/
OneCommanderGetPath() {
  selection := clipboard
  SendInput(ONE_COMMANDER_GET_PATH_COMBO)
  path := clipboard
  clipboard := selection
  return path
}

/*
  Move copied files to current selected folder in one commander.
*/
OneCommanderMoveFiles() {
  selection := clipboard
  SendInput(ONE_COMMANDER_GET_PATH_COMBO)
  path := clipboard
  if (!path) {
    MsgBox, % "Error, unable to move files."
    return
  }
  ; Move copied files to new path.
  Loop, parse, selection, `n, `r
  {
    ShowSplashText("Moving... " . A_LoopField, 500)
    if (DirExist(A_LoopField))
    {
      SplitPath, A_LoopField, folder
      FileMoveDir, %A_LoopField%, %path%\%folder%
    }
    else
      FileMove, %A_LoopField%, %path%
  }
}
