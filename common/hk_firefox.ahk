/*
  This module enables some combos to manage Firefox application.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_misc.ahk

FirefoxAutoExec:
  global FIREFOX_COMBO_GO_TO_TAB := RCtrlCombo("{space}")
  global FIREFOX_COMBO_NEXT_TAB := RCtrlCombo("{PgDn}")
  global FIREFOX_COMBO_PREV_TAB := RCtrlCombo("{PgUp}")
  global FIREFOX_COMBO_RECENT_TAB := RCtrlCombo("{tab}")

  global FIREFOX_COMBO_ADDRESS_BAR := AltCombo("d")

  global FIREFOX_COMBO_HISTORY_FORWARD := RAltCombo("{right}")
  global FIREFOX_COMBO_HISTORY_BACK := RAltCombo("{left}")

  ; Show settings.
  global FIREFOX_COMBO_SETTINGS := LCtrlCombo("t") . "about:preferences{enter}"
  ; Find.
  global FIREFOX_COMBO_FIND := LCtrlCombo("f")
    
  ImplementAddressInterface("firefox.exe"
    , FIREFOX_COMBO_ADDRESS_BAR)                ; Focus address bar. 

  ImplementTabsInterface("firefox.exe"
    , FIREFOX_COMBO_NEXT_TAB           ; Next tab
    , FIREFOX_COMBO_PREV_TAB           ; Prev tab
    , FIREFOX_COMBO_RECENT_TAB         ; Recently used tab
    , DEFAULT_IMPLEMENTATION           ; Go to tab by number.
    , NO_BOUND_ACTION_MSGBOX           ; Move tab right.
    , NO_BOUND_ACTION_MSGBOX           ; Move tab left.
    , NO_BOUND_ACTION_MSGBOX           ; Move tab first.
    , NO_BOUND_ACTION_MSGBOX           ; Move tab last.
    , DEFAULT_IMPLEMENTATION           ; New tab.
    , DEFAULT_IMPLEMENTATION           ; Close tab.
    , DEFAULT_IMPLEMENTATION)          ; Undo close tab.

  ImplementHistoryInterface("firefox.exe"
    , FIREFOX_COMBO_HISTORY_BACK       ; History back
    , FIREFOX_COMBO_HISTORY_FORWARD)   ; History forward

  ImplementSeekAndSelInterface("firefox.exe"
    , FIREFOX_COMBO_GO_TO_TAB             ; Ctrl + Space
    , NO_BOUND_ACTION_MSGBOX              ; Ctrl + Shift + Space
    , NO_BOUND_ACTION_MSGBOX              ; Alt + Space
    , NO_BOUND_ACTION_MSGBOX              ; Alt + Shift + Space
    , NO_BOUND_ACTION_MSGBOX              ; Win + Space
    , NO_BOUND_ACTION_MSGBOX)             ; Win + Shift + Space

  ImplementSettingsInterface("firefox.exe"
    , FIREFOX_COMBO_SETTINGS)               ; Open settings.

  ImplementFindAndReplaceInterface("firefox.exe"
    , FIREFOX_COMBO_FIND)                   ; Search.

; Add some new shortcuts to Firefox.
#IfWinActive ahk_exe firefox.exe
#if

