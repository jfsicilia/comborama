/*
  This module enables some combos to manage Microsoft Edge application.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_misc.ahk

EdgeAutoExec:
  ; Go next/prev tab.
  global EDGE_COMBO_GO_PREV_TAB := LShiftLCtrlCombo("{Tab}")
  global EDGE_COMBO_GO_NEXT_TAB := LCtrlCombo("{Tab}")
  ; Show history.
  global EDGE_COMBO_HISTORY := LCtrlCombo("h")
  ; Show settings.
  global EDGE_COMBO_SETTINGS := LCtrlCombo("t") . "edge://settings{Enter}"

  ImplementTabsInterface("msedge.exe"
    , EDGE_COMBO_GO_NEXT_TAB           ; Next tab
    , EDGE_COMBO_GO_PREV_TAB           ; Prev tab
    , NO_BOUND_ACTION_MSGBOX           ; Recently used tab
    , DEFAULT_IMPLEMENTATION           ; Go to tab by number.
    , NO_BOUND_ACTION_MSGBOX           ; Move tab right.
    , NO_BOUND_ACTION_MSGBOX           ; Move tab left.
    , NO_BOUND_ACTION_MSGBOX           ; Move tab first.
    , NO_BOUND_ACTION_MSGBOX           ; Move tab last.
    , DEFAULT_IMPLEMENTATION           ; New tab.
    , DEFAULT_IMPLEMENTATION           ; Close tab.
    , DEFAULT_IMPLEMENTATION)          ; Undo close tab.

  ImplementHistoryInterface("msedge.exe"
    , Func("edgeBackHistory")          ; History back
    , Func("edgeForwardHistory"))      ; History forward

  ImplementSeekAndSelInterface("msedge.exe"
    , NO_BOUND_ACTION_MSGBOX              ; Ctrl + Space
    , NO_BOUND_ACTION_MSGBOX              ; Ctrl + Shift + Space
    , NO_BOUND_ACTION_MSGBOX              ; Alt + Space
    , NO_BOUND_ACTION_MSGBOX              ; Alt + Shift + Space
    , EDGE_COMBO_HISTORY                  ; Win + Space
    , NO_BOUND_ACTION_MSGBOX)             ; Win + Shift + Space

  ImplementSettingsInterface("msedge.exe"
    , EDGE_COMBO_SETTINGS)               ; Open settings.
return

/*
  Back in history.
*/
edgeBackHistory() {
  SendInput, ^l
  Sleep, 50
  SendInput, {Esc}
  Sleep, 50
  SendInput, !{left}
}

/*
  Forward in history.
*/
edgeForwardHistory() {
  SendInput, ^l
  Sleep, 50
  SendInput, {Esc}
  Sleep, 50
  SendInput, !{right}
}

#ifWinActive ahk_exe msedge.exe
#if

