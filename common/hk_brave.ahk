/*
  This module enables some combos to manage Brave application.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_misc.ahk

BraveAutoExec:
  ; Go to prev/next tab.
  global BRAVE_COMBO_GO_PREV_TAB := RShiftRCtrlCombo("{Tab}")
  global BRAVE_COMBO_GO_NEXT_TAB := RCtrlCombo("{Tab}")
  ; Go back/forward in history
  global BRAVE_COMBO_BACK_HISTORY := RAltCombo("{left}")
  global BRAVE_COMBO_FORWARD_HISTORY := RAltCombo("{right}")
  ; Go to recent tab. Registered in "CLUT: Cycle Last Used Tabs" brave extension.
  global BRAVE_COMBO_GO_RECENT_TAB := LAltCombo(",")
  ; Focus bookmark bar.
  global BRAVE_COMBO_FOCUS_BOOKMARK := LCtrlCombo("l") . "{F6 2}{right 2}"
  global BRAVE_COMBO_HISTORY := LCtrlCombo("h")

  ; Go to tab by fuzzy search. BRAVE has now a Ctrl + Shift + a shortcut for this.
  global BRAVE_COMBO_GO_TO_TAB := RShiftRCtrlCombo("a")
  ; Go to bookmark by fuzzy search. Registered in "Holmes" BRAVE extension.
  global BRAVE_COMBO_GO_TO_BOOKMARK := LAltCombo("b")
  ; Show settings.
  global BRAVE_COMBO_SETTINGS := LCtrlCombo("t") . "brave://settings{enter}"

  ImplementTabsInterface("brave.exe"
    , BRAVE_COMBO_GO_NEXT_TAB          ; Next tab
    , BRAVE_COMBO_GO_PREV_TAB          ; Prev tab
    , BRAVE_COMBO_GO_RECENT_TAB        ; Recently used tab
    , DEFAULT_IMPLEMENTATION           ; Go to tab by number.
    , NO_BOUND_ACTION_MSGBOX           ; Move tab right.
    , NO_BOUND_ACTION_MSGBOX           ; Move tab left.
    , NO_BOUND_ACTION_MSGBOX           ; Move tab first.
    , NO_BOUND_ACTION_MSGBOX           ; Move tab last.
    , DEFAULT_IMPLEMENTATION           ; New tab.
    , DEFAULT_IMPLEMENTATION           ; Close tab.
    , DEFAULT_IMPLEMENTATION)          ; Undo close tab.

  ImplementHistoryInterface("brave.exe"
    , BRAVE_COMBO_BACK_HISTORY         ; History back
    , BRAVE_COMBO_FORWARD_HISTORY)     ; History forward

  ImplementSeekAndSelInterface("brave.exe"
    , BRAVE_COMBO_GO_TO_TAB              ; Ctrl + Space
    , NO_BOUND_ACTION_MSGBOX             ; Ctrl + Shift + Space
    , BRAVE_COMBO_GO_TO_BOOKMARK         ; Alt + Space
    , BRAVE_COMBO_FOCUS_BOOKMARK         ; Alt + Shift + Space
    , BRAVE_COMBO_HISTORY                ; Win + Space
    , NO_BOUND_ACTION_MSGBOX)            ; Win + Shift + Space

  ImplementSettingsInterface("brave.exe"
    , BRAVE_COMBO_SETTINGS)               ; Open settings.
return

#IfWinActive ahk_exe brave.exe
  ; Set focus on web page.
  SC055 & F8:: ClickWndCenter()
#if

