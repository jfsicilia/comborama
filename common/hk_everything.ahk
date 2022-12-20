#include %A_ScriptDir%\lib_apps.ahk
#include %A_ScriptDir%\lib_misc.ahk
#include %A_ScriptDir%\lib_searches.ahk

EverythingAutoExec:
  global EVERYTHING_COMBO_SHOW_EVERYTHING := LShiftLWinLAltCombo("{F10}")
  global EVERYTHING_COMBO_TOGGLE_EVERYTHING := LShiftLWinLAltCombo("{F11}")
  global EVERYTHING_COMBO_RECENT_FILES_SEARCH := LShiftLAltCombo("r")
  global EVERYTHING_COMBO_FOCUS_FILES_PANE := EVERYTHING_COMBO_SHOW_EVERYTHING . "{Tab}"
  global EVERYTHING_COMBO_FOCUS_PREVIEW := "{F9}"
  global EVERYTHING_COMBO_TOGGLE_PREVIEW := "{Alt Down}V{Alt Up}P"
  global EVERYTHING_COMBO_SHOW_HISTORY := LShiftLCtrlCombo("h")
  ; NOTE: Search txtbox and find txtbox is the same, but two combos are useb
  ; due to special behaviour in some situations.
  global EVERYTHING_COMBO_FOCUS_SEARCH_TXTBOX := LCtrlCombo("l")
  global EVERYTHING_COMBO_FOCUS_FIND_TXTBOX := EVERYTHING_COMBO_SHOW_EVERYTHING

  ImplementHistoryInterface("Everything.exe"
    , Func("EverythingBackInHistory")         ; History back
    , Func("EverythingBackInHistory"))        ; History forward

  ImplementAddressInterface("Everything.exe"
    , EVERYTHING_COMBO_FOCUS_FIND_TXTBOX)         ; Focus address bar. 

  ImplementFileManagerInterface("Everything.exe"
    , ""                      ; Prefiew file/folder
    , "{enter}"               ; Open file/folder
    , NOT_IMPLEMENTED         ; Go parent folder
    , "{F2}"                  ; Rename file/folder
    , "{F5}"                  ; Refresh file manager
    , "!{enter}"              ; Show info of file/folder
    , "{F3}"                  ; Find
    , NOT_IMPLEMENTED         ; Duplicate file/folder
    , "^a"                    ; Select all files/folders
    , NOT_IMPLEMENTED         ; New file
    , NOT_IMPLEMENTED         ; New folder
    , "+{F10}"                ; Context menu
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
    , NOT_IMPLEMENTED          ; Copy to other pane
    , NOT_IMPLEMENTED)         ; Move to other pane

  DefaultImplementationOpenWithInterface("Everything.exe")

  DefaultImplementationAltCursorInterface("Everything.exe")

  ImplementSeekAndSelInterface("Everything.exe"
    , EVERYTHING_COMBO_FOCUS_FIND_TXTBOX  ; Ctrl + Space
    , NO_BOUND_ACTION_MSGBOX              ; Ctrl + Shift + Space
    , func("ShowFavSearchesListBox")      ; Alt + Space
    , NO_BOUND_ACTION_MSGBOX              ; Alt + Shift + Space
    , EVERYTHING_COMBO_SHOW_HISTORY       ; Win + Space
    , NO_BOUND_ACTION_MSGBOX)             ; Win + Shift + Space

  ImplementFavsInterface("Everything.exe"
    , func("EverythingGoToFav"))           ; Go to favourite.

return

; Remap explorer
#if (WinActive("ahk_exe Everything.exe"))
  SC055::
  ESC:: ToggleEverythingApp()

  ; Focus Files
  F8:: EverythingFocusFiles()
  ; Focus preview
  ;NOTE F9 focus preview
  ;F9::  

  <!p:: SendInputIsolated(EVERYTHING_COMBO_TOGGLE_PREVIEW)
#if

/*
  Go back in search history
*/
EverythingBackInHistory() {
  SendInputIsolated(EVERYTHING_COMBO_SHOW_HISTORY)
  sleep, 100
  SendInputIsolated("{tab}{down}")
  sleep, 100
  SendInputIsolated(LAltCombo("o"))
  SendInputIsolated("{enter}")
}

/*
  Focus search textbox.
*/
EverythingFocusSearchBox() {
    SendInputIsolated(EVERYTHING_COMBO_FOCUS_FIND_TXTBOX)
}

/*
  Focus file list.
*/
EverythingFocusFiles() {
  SendInputIsolated(EVERYTHING_COMBO_FOCUS_FILES_PANE)
} 

/*
  Focus preview.
*/
EverythingFocusPreview() {
  SendInputFree(EVERYTHING_COMBO_FOCUS_PREVIEW)
}

/*
  Launch everything showing recent files.
*/
ToggleEverythingApp() {
  KeyWait, RAlt
  SendInputFree(EVERYTHING_COMBO_TOGGLE_EVERYTHING)
  Sleep, 100
  WinGetClass, class, A
  if (class = "EVERYTHING") {
    SendInput(EVERYTHING_COMBO_RECENT_FILES_SEARCH)
    SendInput(EVERYTHING_COMBO_SHOW_EVERYTHING)
  }
}

/*
  Searches in Everything.
  search - Search text
*/
EverythingSearch(search) {
  SendInputIsolated(EVERYTHING_COMBO_FOCUS_SEARCH_TXTBOX . search . "{Enter}")
}

/*
  Go to favourite search by key. The key param will be the key in the 
  FAV_SEARCHES_PATH dictionary to retrive a path. 
  key -- Key to retrieve a path in the FAV_SEARCHERS_PATH dictionary.
*/
EverythingGoToFav(key) {
  EverythingSearch(FAV_SEARCHES_PATH[key])
}

