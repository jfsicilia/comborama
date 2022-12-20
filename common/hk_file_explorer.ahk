/*
  This module enables some combos to manage Windows File Explorer application.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_apps.ahk
#include %A_ScriptDir%\lib_folders.ahk
#include %A_ScriptDir%\lib_misc.ahk

FileExplorerAutoExec:
  global FILE_EXPLORER_COMBO_OPEN_FILE_FOLDER = "{enter}"
  global FILE_EXPLORER_COMBO_GO_PARENT = "!{up}"
  global FILE_EXPLORER_COMBO_RENAME_FILE = "{F2}"
  global FILE_EXPLORER_COMBO_REFRESH = "{F5}"
  global FILE_EXPLORER_COMBO_SHOW_INFO = "!{enter}"
  global FILE_EXPLORER_COMBO_FIND = "{F3}"
  global FILE_EXPLORER_COMBO_DUPLICATE = "^c^v"
  global FILE_EXPLORER_COMBO_SELECT_ALL = "^a"
  global FILE_EXPLORER_COMBO_NEW_FOLDER = "^+n"
  global FILE_EXPLORER_COMBO_CONTEXT_MENU = "+{F10}"

  global FILE_EXPLORER_COMBO_ADDRESS_BAR := "!d"

  global FILE_EXPLORER_COMBO_NEW_TAB := "^t"
  global FILE_EXPLORER_COMBO_PREV_TAB := ShiftCtrlCombo("{Tab}")
  global FILE_EXPLORER_COMBO_NEXT_TAB := CtrlCombo("{Tab}")
  global FILE_EXPLORER_COMBO_HISTORY_BACK := "!{left}"
  global FILE_EXPLORER_COMBO_HISTORY_FORWARD := "!{right}"

  global FILE_EXPLORER_COMBO_COPY := "^c"
  global FILE_EXPLORER_COMBO_COPY_PATH := "^+c"
  global FILE_EXPLORER_COMBO_CUT := "^x"
  global FILE_EXPLORER_COMBO_PASTE := "^v"
  global FILE_EXPLORER_COMBO_HISTORY_PASTE := "#v"

  ImplementTabsInterface("Explorer.EXE"
    , FILE_EXPLORER_COMBO_NEXT_TAB         ; Next tab
    , FILE_EXPLORER_COMBO_PREV_TAB         ; Prev tab
    , NO_BOUND_ACTION_MSGBOX               ; Recently used tab
    , DEFAULT_IMPLEMENTATION               ; Go to tab by number.
    , NO_BOUND_ACTION_MSGBOX               ; Move tab right.
    , NO_BOUND_ACTION_MSGBOX               ; Move tab left.
    , NO_BOUND_ACTION_MSGBOX               ; Move tab first.
    , NO_BOUND_ACTION_MSGBOX               ; Move tab last.
    , func("ExplorerNewTab")               ; New tab.
    , DEFAULT_IMPLEMENTATION               ; Close tab.
    , DEFAULT_IMPLEMENTATION)              ; Undo close tab.

  ImplementPanesInterface("Explorer.exe"
    , func("ActivateAppNextWindow")        ; Recent pane
    , NOT_IMPLEMENTED                      ; Go pane by number
    , func("ActivateAppNextWindow")        ; Go left pane
    , func("ActivateAppNextWindow")        ; Go right pane
    , func("ActivateAppNextWindow")        ; Go down pane
    , func("ActivateAppNextWindow")        ; Go up pane
    , NOT_IMPLEMENTED                      ; Move left pane   
    , NOT_IMPLEMENTED                      ; Move right pane
    , NOT_IMPLEMENTED                      ; Move down pane   
    , NOT_IMPLEMENTED                      ; Move up pane
    , NOT_IMPLEMENTED                      ; Resize left pane 
    , NOT_IMPLEMENTED                      ; Resize right pane
    , NOT_IMPLEMENTED                      ; Resize down pane 
    , NOT_IMPLEMENTED                      ; Resize up pane   
    , NOT_IMPLEMENTED                      ; Swap left pane   
    , NOT_IMPLEMENTED                      ; Swap right pane
    , NOT_IMPLEMENTED                      ; Swap down pane 
    , NOT_IMPLEMENTED                      ; Swap up pane   
    , NOT_IMPLEMENTED                      ; Max/Restore pane
    , NOT_IMPLEMENTED                      ; Horizontal pane split.
    , NOT_IMPLEMENTED                      ; Vertical pane split.
    , NOT_IMPLEMENTED)                     ; Close pane.

  ImplementHistoryInterface("Explorer.exe"
    , FILE_EXPLORER_COMBO_HISTORY_BACK     ; History back
    , FILE_EXPLORER_COMBO_HISTORY_FORWARD) ; History forward

  ImplementAddressInterface("Explorer.exe"
    , FILE_EXPLORER_COMBO_ADDRESS_BAR)         ; Focus address bar. 

  ImplementFavsInterface(["Explorer.exe", "PickerHost.exe", "#32770", "CabinetWClass"]
    , func("ExplorerGoToFav"))           ; Go to favourite.

  ImplementEditInterface("Explorer.exe"
    , bind("ShiftSwitch"                         ; Copy
         , FILE_EXPLORER_COMBO_COPY
         , FILE_EXPLORER_COMBO_COPY_PATH)                  
    , DEFAULT_IMPLEMENTATION                     ; Cut        
    , bind("ShiftSwitch"                         ; Paste
        , FILE_EXPLORER_COMBO_PASTE
        , Func("FileExplorerMoveFiles")
        , FILE_EXPLORER_COMBO_HISTORY_PASTE)  
    , DEFAULT_IMPLEMENTATION                     ; Undo        
    , DEFAULT_IMPLEMENTATION                     ; Redo        
    , DEFAULT_IMPLEMENTATION)                    ; Delete

  ImplementFileManagerInterface("Explorer.exe"
    , ""                                    ; Prefiew file/folder
    , FILE_EXPLORER_COMBO_OPEN_FILE_FOLDER  ; Open file/folder
    , FILE_EXPLORER_COMBO_GO_PARENT         ; Go parent folder
    , FILE_EXPLORER_COMBO_RENAME_FILE       ; Rename file/folder
    , FILE_EXPLORER_COMBO_REFRESH           ; Refresh file manager
    , FILE_EXPLORER_COMBO_SHOW_INFO         ; Show info of file/folder
    , FILE_EXPLORER_COMBO_FIND              ; Find
    , FILE_EXPLORER_COMBO_DUPLICATE         ; Duplicate file/folder
    , FILE_EXPLORER_COMBO_SELECT_ALL        ; Select all files/folders
    , func("CreateNewFile")                 ; New file
    , FILE_EXPLORER_COMBO_NEW_FOLDER        ; New folder
    , FILE_EXPLORER_COMBO_CONTEXT_MENU      ; Context menu
    ; View file/folder.
    , bind("ShiftSwitch", bind("__OpenSelectedItemsWith__", Func("__Chrome__"))) 
    ; Edit file/folder.
    , bind("ShiftSwitch", bind("__OpenSelectedItemsWith__", Func("__Vim__"))
                        , bind("__OpenSelectedItemsWith__", Func("__VSCode__"))
                        , bind("__OpenSelectedItemsWith__", Func("__Typora__")))
    ; Explore folder.
    , bind("ShiftSwitch", bind("__OpenSelectedItemsWith__", Func("__WindowsTerminal__"))
                        , bind("__OpenSelectedItemsWith__", Func("__OneCommander__")))
    , func("CopyOtherPane")                 ; Copy to other pane
    , func("MoveOtherPane"))                ; Move to other pane

  DefaultImplementationOpenWithInterface("Explorer.exe")

  DefaultImplementationAltCursorInterface("Explorer.exe")

  ImplementSeekAndSelInterface("Explorer.exe"
    , FILE_EXPLORER_COMBO_ADDRESS_BAR           ; Ctrl + Space
    , NO_BOUND_ACTION_MSGBOX              ; Ctrl + Shift + Space
    , bind("ShowFavFoldersListBox", func("ExplorerGoTo"))       ; Alt + Space
    , NO_BOUND_ACTION_MSGBOX              ; Alt + Shift + Space
    , NO_BOUND_ACTION_MSGBOX              ; Win + Space
    , NO_BOUND_ACTION_MSGBOX)             ; Win + Shift + Space
return

; Keybinding to set focus in file explorer.
#if (WinActive("ahk_class CabinetWClass") 
  || WinActive("ahk_class ExploreWClass")
  || WinActive("ahk_class #32770"))

  ; This will set focus on the list of files.
  F8:: ControlFocus, DirectUIHWND2, A
  
  ; This will set focus on the navigation pane. 
  F7:: ControlFocus, SysTreeView321, A
#if

; Keybinding to set focus in file explorer (Open and Save As dialogs).
#if WinActive("ahk_class #32770")
  ; This will set focus on the filename textbox.
  F6::ControlFocus, Edit1, A
#If

/*
  Go to path.
  path -- Path to go.
*/
ExplorerGoTo(path) {
  SendInputIsolated(FILE_EXPLORER_COMBO_ADDRESS_BAR)
  Sleep, 800
  SendInputIsolated(path . "{Enter}")
}

/*
  Go to favourite folder by key. The key param will be the key in the 
  FAV_FOLDERS_PATH dictionary to retrive a path. 
  key -- Key to retrieve a path in the FAV_FOLDERS_PATH dictionary.
*/
ExplorerGoToFav(key) {
  ExplorerGoTo(FAV_FOLDERS_PATH[key])
}

/*
  Create a new tab and also set it to the DEFAULT_FOLDER.
*/
ExplorerNewTab() {
  SendInputIsolated(FILE_EXPLORER_COMBO_NEW_TAB)
  Sleep, 800
  ExplorerGoTo(DEFAULT_FOLDER)
}

CopyOtherPane() {
  SendInputIsolated(FILE_EXPLORER_COMBO_COPY)
  sleep, 500
  if ActivateAppNextWindow() {
    sleep, 500
    SendInputIsolated(FILE_EXPLORER_COMBO_PASTE)
    sleep, 500
    RecentActiveWindow()
  }
}

MoveOtherPane() {
  SendInputIsolated(FILE_EXPLORER_COMBO_CUT)
  sleep, 500
  if ActivateAppNextWindow() {
    sleep, 500
    SendInputIsolated(FILE_EXPLORER_COMBO_PASTE)
    sleep, 500
    RecentActiveWindow()
  }
}

/*
  Creates a new file in the current selected folder in file explorer.
  An input box will be displayed to request user a file name. 
*/
CreateNewFile() {
  ; Display input box for file name.
  _fileExplorerModifiying := true
  InputBox, userInput, New File (example: foo.txt), , ,400, 100
  _fileExplorerModifiying := false
  if ErrorLevel  ; If user pressed cancel, return.
      return

  path := GetExplorerPath()
  if (!path) {
    MsgBox, % "Error, unable to create file " . userInput
    return
  }
  path := path . "\" . userInput
  FileAppend, ,%path%	
}

/*
  Move copied files to current selected folder in file explorer.
*/
FileExplorerMoveFiles() {
  path := GetExplorerPath()
  if (!path) {
    MsgBox, % "Error, unable to move files."
    return
  }
  ; Move copied files to new path.
  Loop, parse, clipboard, `n, `r
  {
    if (DirExist(A_LoopField))
    {
      SplitPath, A_LoopField, folder
      FileMoveDir, %A_LoopField%, %path%\%folder%
    }
    else
      FileMove, %A_LoopField%, %path%
  }
  Send {F5}   ; Refresh file explorer.
}

/*
  Returns the current path of a file explorer window. It copes with file
  explorer open/save dialogs (class #32770).
*/
GetExplorerPath(title:="A") {
  WinGetClass class, %title%
  path := ""
  if ((class = "CabinetWClass") OR (class = "ExploreWClass")) {
    w := GetActiveExplorer()
    if (w = -1)  
      return path
    path := w.Document.Folder.Self.Path
  }
  else if (class = "#32770") {
    WinGetTitle, dlgType, %title%
    ; Depending if the dialog is an open or save one, the control that holds
    ; the path is different.
    if (dlgType = "Open",m)
      ControlGetText, path,  ToolbarWindow323, %title%
    else
      ControlGetText, path, ToolbarWindow324, %title%
    ; The path is prefixed with "Address :", here we get rid of it.
    path := StrSplit(path, ":", " `t", 2)[2]
  }
  return path
}

/*  
  Returns Active explorer window object. 
*/
GetActiveExplorer() {
  static objShell := ComObjCreate("Shell.Application")
  WinHWND := WinActive("A")    ; Active window
  for Item in objShell.Windows
      if (Item.HWND = WinHWND)
          return Item        ; Return active window object
  return -1    ; No explorer windows match active window
}


