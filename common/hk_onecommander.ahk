/*
  This module enables some combos to manage OneCommander application.

  @jfsicilia 2022.
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

  global ONE_COMMANDER_COMBO_OPEN_FILE_FOLDER = "{enter}"
  global ONE_COMMANDER_COMBO_GO_PARENT = "!{up}"
  global ONE_COMMANDER_COMBO_RENAME_FILE = "{F2}"
  global ONE_COMMANDER_COMBO_REFRESH = "{F5}"
  global ONE_COMMANDER_COMBO_SHOW_INFO = "^i"
  global ONE_COMMANDER_COMBO_FIND = "{F3}"
  global ONE_COMMANDER_COMBO_DUPLICATE = "^d"
  global ONE_COMMANDER_COMBO_SELECT_ALL = "^a"
  global ONE_COMMANDER_COMBO_NEW_FILE = "^n"
  global ONE_COMMANDER_COMBO_NEW_FOLDER = "^+n"
  global ONE_COMMANDER_COMBO_CONTEXT_MENU = "{F9}"
  global ONE_COMMANDER_COMBO_COPY_OTHER_PANE = "!c"
  global ONE_COMMANDER_COMBO_MOVE_OTHER_PANE = "!m"

  global ONE_COMMANDER_COMBO_UNDO = "^z"
  global ONE_COMMANDER_COMBO_REDO = "^y"

  global ONE_COMMANDER_COMBO_COPY := "^c"
  global ONE_COMMANDER_COMBO_COPY_PATH := "^+c"
  global ONE_COMMANDER_COMBO_COPY_FOLDER_PATH := "^!+c"
  global ONE_COMMANDER_COMBO_PASTE := "^v"
  global ONE_COMMANDER_COMBO_HISTORY_PASTE := "#v"

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
    , bind("ShiftSwitch"                           ; Copy
         , ONE_COMMANDER_COMBO_COPY
         , ONE_COMMANDER_COMBO_COPY_FOLDER_PATH
         , ONE_COMMANDER_COMBO_COPY_PATH)           
    , DEFAULT_IMPLEMENTATION                       ; Cut        
    , bind("ShiftSwitch"                           ; Paste
         , ONE_COMMANDER_COMBO_PASTE
         , Func("OneCommanderMoveFiles")
         , ONE_COMMANDER_COMBO_HISTORY_PASTE)  
    , func("OneCommanderUndo")                     ; Undo 
    , func("OneCommanderRedo")                     ; Redo
    , DEFAULT_IMPLEMENTATION)                      ; Delete

  ImplementFileManagerInterface("OneCommander.exe"
    , ""                      ; Prefiew file/folder
    , ONE_COMMANDER_COMBO_OPEN_FILE_FOLDER     ; Open file/folder
    , ONE_COMMANDER_COMBO_GO_PARENT            ; Go parent folder
    , ONE_COMMANDER_COMBO_RENAME_FILE          ; Rename file/folder
    , ONE_COMMANDER_COMBO_REFRESH              ; Refresh file manager
    , ONE_COMMANDER_COMBO_SHOW_INFO            ; Show info of file/folder
    , ONE_COMMANDER_COMBO_FIND                 ; Find
    , ONE_COMMANDER_COMBO_DUPLICATE            ; Duplicate file/folder
    , ONE_COMMANDER_COMBO_SELECT_ALL           ; Select all files/folders
    , ONE_COMMANDER_COMBO_NEW_FILE             ; New file
    , ONE_COMMANDER_COMBO_NEW_FOLDER           ; New folder
    , ONE_COMMANDER_COMBO_CONTEXT_MENU         ; Context menu
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
    , ONE_COMMANDER_COMBO_COPY_OTHER_PANE      ; Copy to other pane
    , ONE_COMMANDER_COMBO_MOVE_OTHER_PANE)     ; Move to other pane

  DefaultImplementationOpenWithInterface("OneCommander.exe")

  DefaultImplementationAltCursorInterface("OneCommander.exe")

  ImplementSeekAndSelInterface("OneCommander.exe"
    , ONE_COMMANDER_ADDRESS_BAR                        ; Ctrl + Space
    , NO_BOUND_ACTION_MSGBOX                           ; Ctrl + Shift + Space
    , bind("ShowFavFoldersListBox"
         , FAV_FOLDERS_PATH, func("OneCommanderGoTo")) ; Alt + Space
    , NO_BOUND_ACTION_MSGBOX                           ; Alt + Shift + Space
    , NO_BOUND_ACTION_MSGBOX                           ; Win + Space
    , NO_BOUND_ACTION_MSGBOX)                          ; Win + Shift + Space
return

#if (WinActive("ahk_exe OneCommander.exe"))
#if

/*
  Go to path.
  path -- Path to go.
*/
OneCommanderGoTo(path) {
  FreeModifiers()
  SendInput(ONE_COMMANDER_ADDRESS_BAR)
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
  MsgBox, 4,, Would you like to undo?
  IfMsgBox No
    return
  FocusOrLaunchFileExplorer()    
  SendInputIsolated(ONE_COMMANDER_COMBO_UNDO)
  FocusOrLaunchOneCommander()
}

/*
  Redo last operation in OneCommander. OneCommander is not allowed to do that
  in Windows OS, therefore we switch to Windows File Explorer, redo there, and
  then come back to OneCommander.
*/
OneCommanderRedo() {
  MsgBox, 4,, Would you like to redo?
  IfMsgBox No
    return
  FocusOrLaunchFileExplorer()    
  SendInputIsolated(ONE_COMMANDER_COMBO_REDO)
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
