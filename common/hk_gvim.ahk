/*
  This module enables some combos to manage GVim application.

  @jfsicilia 2022.
*/
GVimAutoExec:
  ; Toggle flag used when maximizing/restoring pane.
  gvimMaximizedPane := false

  ; Go to least recently tab.
  global GVIM_COMBO_GOTO_LAST_USED_TAB := ",,"
  ; Go to tab / load file.
  global GVIM_COMBO_GOTO_TAB_OR_LOAD_FILE := RCtrlCombo("p")
  ; Go to tab by direction.
  global GVIM_COMBO_GOTO_PREV_TAB := ",m"
  global GVIM_COMBO_GOTO_NEXT_TAB := ",."
  ; Go to least recently tab.
  global GVIM_COMBO_GOTO_LAST_USED_PANE := RCtrlCombo("w") . RCtrlCombo("p")
  ; Go to pane by direction.
  global GVIM_COMBO_FOCUS_RIGHT_PANE := RCtrlCombo("w") . "{right}"
  global GVIM_COMBO_FOCUS_LEFT_PANE := RCtrlCombo("w") . "{left}"
  global GVIM_COMBO_FOCUS_UP_PANE := RCtrlCombo("w") . "{up}"
  global GVIM_COMBO_FOCUS_DOWN_PANE := RCtrlCombo("w") . "{down}"
  ; Resize pane.
  global GVIM_COMBO_RESIZE_RIGHT := RCtrlCombo("w") . ">"
  global GVIM_COMBO_RESIZE_LEFT := RCtrlCombo("w") . "<"
  global GVIM_COMBO_RESIZE_DOWN := RCtrlCombo("w") . "+"
  global GVIM_COMBO_RESIZE_UP := RCtrlCombo("w") . "-"
  ; Swap pane.
  global GVIM_COMBO_SWAP_RIGHT := ",{right}"
  global GVIM_COMBO_SWAP_LEFT := ",{left}"
  global GVIM_COMBO_SWAP_DOWN := ",{down}"
  global GVIM_COMBO_SWAP_UP := ",{up}"
  ; Maximize/minimize pane.
  global GVIM_COMBO_MAXIMIZE_PANE := RCtrlCombo("w") . "|" . RCtrlCombo("w") . "_"
  global GVIM_COMBO_RESTORE_PANE := RCtrlCombo("w") . "="
  ; Split horizontal/vertical.
  global GVIM_COMBO_SPLIT_HORIZONTAL := ",_"
  global GVIM_COMBO_SPLIT_VERTICAL := ",|"
  ; Close pane
  global GVIM_COMBO_CLOSE_PANE := RCtrlCombo("w") . "q"
  ; Close buffer
  global GVIM_COMBO_CLOSE_BUFFER := "{Esc}:bd{Enter}"
  ; New buffer
  global GVIM_COMBO_NEW_BUFFER := "{Esc}:enew{Enter}"
  ; Settings
  global GVIM_COMBO_SETTINGS := ",v"
  ; Find
  global GVIM_COMBO_FIND := "/"
  ; Vim jumping back and forward combos.
  global GVIM_COMBO_JUMP_BACK := "^o"
  global GVIM_COMBO_JUMP_FORWARD := "^i"

  ImplementTabsInterface("gvim.exe"
    , GVIM_COMBO_GOTO_NEXT_TAB            ; Next tab
    , GVIM_COMBO_GOTO_PREV_TAB            ; Prev tab
    , GVIM_COMBO_GOTO_LAST_USED_TAB       ; Recently used tab
    , Func("gvimGoToTab")                 ; Go to tab by number.
    , NO_BOUND_ACTION_MSGBOX              ; Move tab right.
    , NO_BOUND_ACTION_MSGBOX              ; Move tab left.
    , NO_BOUND_ACTION_MSGBOX              ; Move tab first.
    , NO_BOUND_ACTION_MSGBOX              ; Move tab last.
    , GVIM_COMBO_NEW_BUFFER               ; New tab.
    , GVIM_COMBO_CLOSE_BUFFER             ; Close tab.
    , NO_BOUND_ACTION_MSGBOX)             ; Undo close tab.

  ImplementPanesInterface("gvim.exe"
    , GVIM_COMBO_GOTO_LAST_USED_PANE      ; Recent pane
    , func("gvimGoToPane")                ; Go pane by number
    , GVIM_COMBO_FOCUS_LEFT_PANE          ; Go left pane
    , GVIM_COMBO_FOCUS_RIGHT_PANE         ; Go right pane
    , GVIM_COMBO_FOCUS_DOWN_PANE          ; Go down pane
    , GVIM_COMBO_FOCUS_UP_PANE            ; Go up pane
    , NO_BOUND_ACTION_MSGBOX              ; Move left pane   
    , NO_BOUND_ACTION_MSGBOX              ; Move right pane
    , NO_BOUND_ACTION_MSGBOX              ; Move down pane   
    , NO_BOUND_ACTION_MSGBOX              ; Move up pane
    , GVIM_COMBO_RESIZE_LEFT              ; Resize left pane 
    , GVIM_COMBO_RESIZE_RIGHT             ; Resize right pane
    , GVIM_COMBO_RESIZE_DOWN              ; Resize down pane 
    , GVIM_COMBO_RESIZE_UP                ; Resize up pane   
    , GVIM_COMBO_SWAP_LEFT                ; Swap left pane   
    , GVIM_COMBO_SWAP_RIGHT               ; Swap right pane
    , GVIM_COMBO_SWAP_DOWN                ; Swap down pane 
    , GVIM_COMBO_SWAP_UP                  ; Swap up pane   
    , func("gvimMaxRestorePane")          ; Max/Restore pane
    , GVIM_COMBO_SPLIT_HORIZONTAL         ; Horizontal pane split.
    , GVIM_COMBO_SPLIT_VERTICAL           ; Vertical pane split.
    , GVIM_COMBO_CLOSE_PANE)              ; Close pane.

  ImplementHistoryInterface("gvim.exe"
    , GVIM_COMBO_JUMP_BACK                ; History back
    , GVIM_COMBO_JUMP_FORWARD)            ; History forward

  ImplementSeekAndSelInterface("gvim.exe"
    , GVIM_COMBO_GOTO_TAB_OR_LOAD_FILE    ; Ctrl + Space
    , NO_BOUND_ACTION_MSGBOX              ; Ctrl + Shift + Space
    , NO_BOUND_ACTION_MSGBOX              ; Alt + Space
    , NO_BOUND_ACTION_MSGBOX              ; Alt + Shift + Space
    , NO_BOUND_ACTION_MSGBOX              ; Win + Space
    , NO_BOUND_ACTION_MSGBOX)             ; Win + Shift + Space

  ImplementSettingsInterface("gvim.exe"
    , GVIM_COMBO_SETTINGS)                ; Open settings.

  ImplementFindAndReplaceInterface("gvim.exe"
    , GVIM_COMBO_FIND)                   ; Search.
return

#if (WinActive("ahk_exe gvim.exe"))
  ; This allows to load file/tab in normal mode and autocomplete in insert mode.
  SC055 & space:: SendInput(GVIM_COMBO_GOTO_TAB_OR_LOAD_FILE)
#if

/*
  Go to buffer (tab) by number.
  n -- Number of the buffer to active.
*/
gvimGoToTab(n) {
  SendInputIsolated("," . n)
}

/*
  Go to pane by number.
  n -- Number of the pane to active.
*/
gvimGoToPane(n) {
  SendInputIsolated(n . RCtrlCombo("w") . "w")
}

/*
  Maximize/restore pane.
*/
gvimMaxRestorePane() {
  global gvimMaximizedPane

  (gvimMaximizedPane := !gvimMaximizedPane) 
    ? SendInputIsolated(GVIM_COMBO_MAXIMIZE_PANE) : SendInputIsolated(GVIM_COMBO_RESTORE_PANE)
}
