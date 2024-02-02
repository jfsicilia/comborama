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
  global FILE_EXPLORER_COMBO_UNDO = "^z"
  global FILE_EXPLORER_COMBO_REDO = "^+z"
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

  ; Focus combos dictionary.
  global FILE_EXPLORER_COMBO_FOCUS 
  := {"i": Func("FileExplorerFocusFileNameInputBox")  ; Focus filename textbox.
     ,"n": Func("FileExplorerFocusNavigationPane")    ; Focus address bar. 
     ,"g": FILE_EXPLORER_COMBO_ADDRESS_BAR            ; Focus address bar. 
     ,"p": Func("FileExplorerFocusPreview")           ; Focus address bar. 
     ,"m": Func("FileExplorerFocusFileList") }        ; Focus browsing area.

  ; Focus combos dictionary.
  global FILE_EXPLORER_COMBO_TOGGLE
  := {"p": "!p" }                           ; Toggle preview.

  ImplementTabsInterface("Explorer.EXE"
    , FILE_EXPLORER_COMBO_NEXT_TAB         ; Next tab
    , FILE_EXPLORER_COMBO_PREV_TAB         ; Prev tab
    , NO_BOUND_ACTION_MSGBOX               ; Recently used tab
    , DEFAULT_IMPLEMENTATION               ; Go to tab by number.
    , NO_BOUND_ACTION_MSGBOX               ; Move tab right.
    , NO_BOUND_ACTION_MSGBOX               ; Move tab left.
    , NO_BOUND_ACTION_MSGBOX               ; Move tab first.
    , NO_BOUND_ACTION_MSGBOX               ; Move tab last.
    , func("FileExplorerNewTab")               ; New tab.
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

  ImplementHistoryInterface(["Explorer.exe", "PickerHost.exe", "#32770", "CabinetWClass"]
    , FILE_EXPLORER_COMBO_HISTORY_BACK     ; History back
    , FILE_EXPLORER_COMBO_HISTORY_FORWARD) ; History forward

  ImplementAddressInterface(["Explorer.exe", "PickerHost.exe", "#32770", "CabinetWClass"]
    , FILE_EXPLORER_COMBO_ADDRESS_BAR)         ; Focus address bar. 

  ImplementFavsInterface(["Explorer.exe", "PickerHost.exe", "#32770", "CabinetWClass"]
    , Func("FileExplorerGoToFav"))           ; Go to favourite.
    ;, "!d")           ; Go to favourite.

  ImplementEditInterface(["Explorer.EXE", "PickerHost.exe", "#32770", "CabinetWClass"]
    , bind("ShiftSwitch"                         ; Copy
         , FILE_EXPLORER_COMBO_COPY
         , FILE_EXPLORER_COMBO_COPY_PATH)                  
    , DEFAULT_IMPLEMENTATION                     ; Cut        
    , bind("ShiftSwitch"                         ; Paste
        , FILE_EXPLORER_COMBO_PASTE
        , Func("FileExplorerMoveFiles")
        , FILE_EXPLORER_COMBO_HISTORY_PASTE)  
    , Func("FileExplorerUndo")                   ; Undo        
    , Func("FileExplorerRedo")                   ; Redo        
    , DEFAULT_IMPLEMENTATION)                    ; Delete

  ImplementFileManagerInterface(["Explorer.exe", "PickerHost.exe", "#32770", "CabinetWClass"]
    , ""                                    ; Prefiew file/folder
    , FILE_EXPLORER_COMBO_OPEN_FILE_FOLDER  ; Open file/folder
    , FILE_EXPLORER_COMBO_GO_PARENT         ; Go parent folder
    , FILE_EXPLORER_COMBO_RENAME_FILE       ; Rename file/folder
    , FILE_EXPLORER_COMBO_REFRESH           ; Refresh file manager
    , FILE_EXPLORER_COMBO_SHOW_INFO         ; Show info of file/folder
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
                        , bind("__OpenSelectedItemsWith__", Func("__CMD__")) 
                        , bind("__OpenSelectedItemsWith__", Func("__OneCommander__")))
    , func("FileExplorerCopyOtherPane")                 ; Copy to other pane
    , func("FileExplorerMoveOtherPane"))                ; Move to other pane

  ImplementFindAndReplaceInterface(["Explorer.exe", "PickerHost.exe", "#32770", "CabinetWClass"]
    , FILE_EXPLORER_COMBO_FIND)              ; Find

  DefaultImplementationOpenWithInterface(["Explorer.exe", "PickerHost.exe", "#32770", "CabinetWClass"])

  DefaultImplementationAltCursorInterface(["Explorer.exe", "PickerHost.exe", "#32770", "CabinetWClass"])

  ImplementSeekAndSelInterface(["Explorer.exe", "PickerHost.exe", "#32770", "CabinetWClass"]
    , FILE_EXPLORER_COMBO_ADDRESS_BAR              ; Ctrl + Space
    , NO_BOUND_ACTION_MSGBOX                       ; Ctrl + Shift + Space
    , bind("ShowFavFoldersListBox"
         , FAV_FOLDERS_PATH, func("FileExplorerGoTo")) ; Alt + Space
    , NO_BOUND_ACTION_MSGBOX                       ; Alt + Shift + Space
    , NO_BOUND_ACTION_MSGBOX                       ; Win + Space
    , NO_BOUND_ACTION_MSGBOX)                      ; Win + Shift + Space

  ImplementFocusAndToggleInterface(["Explorer.exe", "PickerHost.exe", "#32770", "CabinetWClass"]
    , Func("RunActionFromDict").bind(FILE_EXPLORER_COMBO_FOCUS)   ; Focus pane function.
    , Func("RunActionFromDict").bind(FILE_EXPLORER_COMBO_TOGGLE)) ; Toggle pane function.
return

;------------------ Helper functions --------------------

/*
  Go to path.
  path -- Path to go.
*/
FileExplorerGoTo(path) {
  SendInputIsolated(FILE_EXPLORER_COMBO_ADDRESS_BAR)
  Sleep, 800
  SendInputIsolated(path . "{Enter}")
  Sleep, 1500
  FileExplorerFocusFileList()
}

/*
  Go to favourite folder by key. The key param will be the key in the 
  FAV_FOLDERS_PATH dictionary to retrive a path. 
  key -- Key to retrieve a path in the FAV_FOLDERS_PATH dictionary.
*/
FileExplorerGoToFav(key) {
  FileExplorerGoTo(FAV_FOLDERS_PATH.item(key))
}

/*
  This will set focus on file list.
*/
FileExplorerFocusFileList() {
  ControlFocus, DirectUIHWND2, A
}

/*
  This will set focus on the navigation pane.
*/
FileExplorerFocusNavigationPane() {
  ControlFocus, SysTreeView321, A
}

/*
  This will set focus on the filename textbox.
*/
FileExplorerFocusFileNameInputBox() {
  ControlFocus, Edit1, A
  ; Sometimes there is an Edit2 control. If exists then focus, if not it
  ; will remained focused in Edit1.
  ControlFocus, Edit2, A
}

/*
  This will set focus on the preview pane.
*/
FileExplorerFocusPreview() {
  ControlFocus, PdfWebviewPreview1, A
}


/*
  Create a new tab and also set it to the DEFAULT_FOLDER.
*/
FileExplorerNewTab() {
  SendInputIsolated(FILE_EXPLORER_COMBO_NEW_TAB)
  Sleep, 800
  FileExplorerGoTo(DEFAULT_FOLDER)
}

FileExplorerCopyOtherPane() {
  SendInputIsolated(FILE_EXPLORER_COMBO_COPY)
  sleep, 500
  if ActivateAppNextWindow() {
    sleep, 500
    SendInputIsolated(FILE_EXPLORER_COMBO_PASTE)
    sleep, 500
    RecentActiveWindow()
  }
}

FileExplorerMoveOtherPane() {
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

  path := FileExplorerGetPath()
  if (!path) {
    MsgBox, % "Error, unable to create file " . userInput
    return
  }
  path := path . "\" . userInput
  FileAppend, ,%path%	
}

/*
  Undo last operation in OneCommander. OneCommander is not allowed to do that
  in Windows OS, therefore we switch to Windows File Explorer, undo there, and
  then come back to OneCommander.
*/
FileExplorerUndo() {
  MsgBox, 4,, Would you like to undo?
  IfMsgBox No
    return
  SendInputIsolated(FILE_EXPLORER_COMBO_UNDO)
}

/*
  Redo last operation in OneCommander. OneCommander is not allowed to do that
  in Windows OS, therefore we switch to Windows File Explorer, redo there, and
  then come back to OneCommander.
*/
FileExplorerRedo() {
  MsgBox, 4,, Would you like to redo?
  IfMsgBox No
    return
  SendInputIsolated(FILE_EXPLORER_COMBO_REDO)
}

/*
  Move copied files to current selected folder in file explorer.
*/
FileExplorerMoveFiles() {
  path := FileExplorerGetPath()
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
FileExplorerGetPath(title:="A") {
  WinGetClass class, %title%
  path := ""
  if ((class = "CabinetWClass") OR (class = "ExploreWClass")) {
    w := GetActiveFileExplorer()
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
GetActiveFileExplorer() {
  static objShell := ComObjCreate("Shell.Application")
  WinHWND := WinActive("A")    ; Active window
  for Item in objShell.Windows
      if (Item.HWND = WinHWND)
          return Item        ; Return active window object
  return -1    ; No explorer windows match active window
}


