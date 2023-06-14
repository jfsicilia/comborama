/*
  This script enables some key combos to interact with Windows Terminal.

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

WindowsTerminalAutoExec:
  global WT_COMBO_RECENT_PANE := AltCtrlCombo("{left}")
  global WT_COMBO_RIGHT_PANE := CtrlCombo("{numpad6}")
  global WT_COMBO_LEFT_PANE := CtrlCombo("{numpad4}")
  global WT_COMBO_UP_PANE := CtrlCombo("{numpad8}")
  global WT_COMBO_DOWN_PANE := CtrlCombo("{numpad2}")

  global WT_COMBO_PREV_TAB := RShiftRCtrlCombo("{Tab}")
  global WT_COMBO_NEXT_TAB := RCtrlCombo("{Tab}")
  global WT_COMBO_RECENT_TAB := LAltLCtrlCombo("0")

  global WT_COMBO_CLOSE_PANE_OR_TAB := CtrlCombo("{numpad0}")
  global WT_COMBO_CLOSE_NEW_TAB := CtrlCombo("{numpad5}")

  global WT_COMBO_SPLIT_VERTICAL := CtrlCombo("{numpad9}")
  global WT_COMBO_SPLIT_HORIZONTAL := CtrlCombo("{numpad3}")

  global WT_COMBO_SCROLL_1_LINE_DOWN := ShiftCtrlCombo("{F7}")
  global WT_COMBO_SCROLL_1_LINE_UP := ShiftCtrlCombo("{F8}")
  global WT_COMBO_SCROLL_1_PAGE_DOWN := ShiftCtrlCombo("{F9}")
  global WT_COMBO_SCROLL_1_PAGE_UP := ShiftCtrlCombo("{F10}")
  global WT_COMBO_SCROLL_TO_BOTTOM := ShiftCtrlCombo("{F11}")
  global WT_COMBO_SCROLL_TO_TOP := ShiftCtrlCombo("{F12}")

  global WT_COMBO_COPY := CtrlCombo("{numpad7}")
  global WT_COMBO_PASTE := CtrlCombo("{numpad1}")

  global WT_COMBO_SETTINGS := "^,"
  global WT_COMBO_SETTINGS_JSON := "^+,"
  global WT_COMBO_DEFAULTS_JSON := "^!,"

  global WT_COMBO_VIM_CTRL_P := LCtrlCombo("p")

  global WT_WSL_LINUX_DISTRO := "Linux"


  ImplementTabsInterface("WindowsTerminal.exe"
    , WT_COMBO_NEXT_TAB                  ; Next tab
    , WT_COMBO_PREV_TAB                  ; Prev tab
    , WT_COMBO_RECENT_TAB                ; Recently used tab
    , Func("WTGoToTab")                  ; Go to tab by number.
    , NO_BOUND_ACTION_MSGBOX             ; Move tab right.
    , NO_BOUND_ACTION_MSGBOX             ; Move tab left.
    , NO_BOUND_ACTION_MSGBOX             ; Move tab first.
    , NO_BOUND_ACTION_MSGBOX             ; Move tab last.
    , WT_COMBO_CLOSE_NEW_TAB             ; New tab.
    , WT_COMBO_CLOSE_PANE_OR_TAB         ; Close tab.
    , NO_BOUND_ACTION_MSGBOX)            ; Undo close tab.

  ImplementPanesInterface("WindowsTerminal.exe"
    , WT_COMBO_RECENT_PANE          ; Recent pane
    , NO_BOUND_ACTION_MSGBOX        ; Go pane by number
    , WT_COMBO_LEFT_PANE            ; Go left pane
    , WT_COMBO_RIGHT_PANE           ; Go right pane
    , WT_COMBO_DOWN_PANE            ; Go down pane
    , WT_COMBO_UP_PANE              ; Go up pane
    , NO_BOUND_ACTION_MSGBOX        ; Move left pane   
    , NO_BOUND_ACTION_MSGBOX        ; Move right pane
    , NO_BOUND_ACTION_MSGBOX        ; Move down pane   
    , NO_BOUND_ACTION_MSGBOX        ; Move up pane
    , NO_BOUND_ACTION_MSGBOX        ; Resize left pane 
    , NO_BOUND_ACTION_MSGBOX        ; Resize right pane
    , NO_BOUND_ACTION_MSGBOX        ; Resize down pane 
    , NO_BOUND_ACTION_MSGBOX        ; Resize up pane   
    , NO_BOUND_ACTION_MSGBOX        ; Swap left pane   
    , NO_BOUND_ACTION_MSGBOX        ; Swap right pane
    , NO_BOUND_ACTION_MSGBOX        ; Swap down pane 
    , NO_BOUND_ACTION_MSGBOX        ; Swap up pane   
    , NO_BOUND_ACTION_MSGBOX        ; Max/Restore pane
    , WT_COMBO_SPLIT_HORIZONTAL     ; Horizontal pane split.
    , WT_COMBO_SPLIT_VERTICAL       ; Vertical pane split.
    , WT_COMBO_CLOSE_PANE_OR_TAB)   ; Close pane.

  ; NOTE: Cursor interface is implemented by default by all apps. We need to
  ; disable some combos to let WindowsTerminal implement TerminalInterface
  ; without combo clashing. 
  ImplementCursorInterface("WindowsTerminal.exe"
    , DEFAULT_IMPLEMENTATION      ; left                            
    , DEFAULT_IMPLEMENTATION      ; shiftLeft                       
    , DEFAULT_IMPLEMENTATION      ; right                           
    , DEFAULT_IMPLEMENTATION      ; shiftRight                      
    , NOT_IMPLEMENTED             ; startLine  (ctrl + left)
    , DEFAULT_IMPLEMENTATION      ; shiftStartLine                  
    , NOT_IMPLEMENTED             ; endLine    (ctrl + right)                     
    , DEFAULT_IMPLEMENTATION      ; shiftEndLine                    
    , DEFAULT_IMPLEMENTATION      ; down                            
    , DEFAULT_IMPLEMENTATION      ; shiftDown                       
    , DEFAULT_IMPLEMENTATION      ; up                              
    , DEFAULT_IMPLEMENTATION      ; shiftUp                         
    , NOT_IMPLEMENTED             ; startText      (ctrl + up)
    , NOT_IMPLEMENTED             ; shiftStartText (ctrl + shift + up)                 
    , NOT_IMPLEMENTED             ; endText        (ctrl + down)                 
    , NOT_IMPLEMENTED             ; shiftEndText   (ctrl + shift + down)                 
    , DEFAULT_IMPLEMENTATION      ; pageUp                          
    , DEFAULT_IMPLEMENTATION      ; shiftPageUp                     
    , DEFAULT_IMPLEMENTATION      ; pageDown                        
    , DEFAULT_IMPLEMENTATION      ; shiftPageDown
    , DEFAULT_IMPLEMENTATION      ; prevWord
    , DEFAULT_IMPLEMENTATION      ; shiftPrevWord
    , DEFAULT_IMPLEMENTATION      ; nextWord
    , DEFAULT_IMPLEMENTATION)     ; shiftNextWord

  ImplementTerminalInterface("WindowsTerminal.exe"
    , WT_COMBO_SCROLL_1_LINE_UP            ; Scroll 1 line up
    , WT_COMBO_SCROLL_1_LINE_DOWN          ; Scroll 1 line down
    , WT_COMBO_SCROLL_1_PAGE_UP            ; Scroll 1 page up 
    , WT_COMBO_SCROLL_1_PAGE_DOWN          ; Scroll 1 page down 
    , WT_COMBO_SCROLL_TO_TOP               ; Scroll to top
    , WT_COMBO_SCROLL_TO_BOTTOM            ; Scroll to bottom
    , WT_COMBO_COPY                        ; Terminal copy
    , WT_COMBO_PASTE)                      ; Terminal paste

  ImplementSettingsInterface("WindowsTerminal.exe"
    , bind("ShiftSwitch"                   ; Open settings.
         , WT_COMBO_SETTINGS
         , WT_COMBO_SETTINGS_JSON
         , WT_COMBO_DEFAULTS_JSON))       

  ImplementFavsInterface("WindowsTerminal.exe"
    , func("WTGoToFav"))      ; Go to fav.

  ImplementSeekAndSelInterface("WindowsTerminal.exe"
    , WT_COMBO_VIM_CTRL_P                             ; Ctrl + Space
    , NO_BOUND_ACTION_MSGBOX                          ; Ctrl + Shift + Space
    , bind("ShowFavFoldersListBox"
        , FAV_FOLDERS_PATH, func("WTGoTo"))           ; Alt + Space
    , NO_BOUND_ACTION_MSGBOX                          ; Alt + Shift + Space
    , NO_BOUND_ACTION_MSGBOX                          ; Win + Space
    , NO_BOUND_ACTION_MSGBOX)                         ; Win + Shift + Space
return

; Windows terminal keybindings.
#if WinActive("ahk_exe WindowsTerminal.exe")
#if

/*
  Go to tab by number.
  n -- Number of the tab.
*/
WTGoToTab(n) {
  SendInputIsolated(LAltLCtrlCombo(n))
}

/*
  Go to path.
  path -- Path to go.
*/
WTGoTo(path) {
  FreeModifiers()
  path := GetDirFromPath(path) ; Make sure we are dealing with a dir not a file.
  WinGetActiveTitle, title
  if (InStr(title, WT_WSL_LINUX_DISTRO))
    path := Path2WslPath(path)   ; Convert path to wsl's path format.
  SendInput, cd "%path%"{Enter}
  SetModifiers()
}

/*
  Go to favourite folder by key. The key param will be the key in the 
  FAV_FOLDERS_PATH dictionary to retrive a path. 
  key -- Key to retrieve a path in the FAV_FOLDERS_PATH dictionary.
*/
WTGoToFav(key) {
  WTGoTo(FAV_FOLDERS_PATH.item(key))
}


