/*
  This module enables some combos to manage Chrome application.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_misc.ahk

ChromeAutoExec:
  ; Move tab to new window. Registered in "Tab to Window/Popup" chrome extension.
  global CHROME_COMBO_TAB_TO_NEW_WINDOW := LShiftLAltCombo(".")
  ; Move tab back to window. Registered in "Tab to Window/Popup" chrome extension.  
  global CHROME_COMBO_TAB_TO_PREV_WINDOW := LShiftLAltCombo(",")
  ; Go to recent tab. Registered in "CLUT: Cycle Last Used Tabs" chrome extension.
  global CHROME_COMBO_GO_RECENT_TAB := LAltCombo(",")
  ; Go to tab by fuzzy search. Chrome has now a Ctrl + Shift + a shortcut for this.
  ;global CHROME_COMBO_GO_TO_TAB := RCtrlCombo("{space}")
  global CHROME_COMBO_GO_TO_TAB := RShiftRCtrlCombo("a")
  ; Go to bookmark by fuzzy search. Registered in "Holmes" chrome extension.
  global CHROME_COMBO_GO_TO_BOOKMARK := LAltCombo("b")
  ; Focus bookmark bar.
  global CHROME_COMBO_FOCUS_BOOKMARK := LCtrlCombo("l") . "{F6 2}{right 2}"
  ; Go to prev/next tab in chrome  
  global CHROME_COMBO_GO_PREV_TAB := RShiftRCtrlCombo("{tab}")
  global CHROME_COMBO_GO_NEXT_TAB := RCtrlCombo("{tab}")
  ; Move tab right/left/start/end
  global CHROME_COMBO_MOVE_TAB_RIGHT := LShiftLCtrlCombo("9")
  global CHROME_COMBO_MOVE_TAB_LEFT := LShiftLCtrlCombo("8")
  global CHROME_COMBO_MOVE_TAB_START := LShiftLCtrlCombo("6")
  global CHROME_COMBO_MOVE_TAB_END := LShiftLCtrlCombo("7")
  ; Go back/forward in history
  global CHROME_COMBO_BACK_HISTORY := RAltCombo("{left}")
  global CHROME_COMBO_FORWARD_HISTORY := RAltCombo("{right}")
  global CHROME_COMBO_HISTORY := LCtrlCombo("h")
  ; Close tab.
  global CHROME_COMBO_CLOSE_PANE := LCtrlCombo("w")
  ; Show settings.
  global CHROME_COMBO_SETTINGS := LCtrlCombo("t") . "chrome://settings{enter}"

  ImplementTabsInterface("chrome.exe"
    , CHROME_COMBO_GO_NEXT_TAB           ; Next tab
    , CHROME_COMBO_GO_PREV_TAB           ; Prev tab
    , CHROME_COMBO_GO_RECENT_TAB         ; Recently used tab
    , DEFAULT_IMPLEMENTATION             ; Go to tab by number.
    , CHROME_COMBO_MOVE_TAB_RIGHT        ; Move tab right.
    , CHROME_COMBO_MOVE_TAB_LEFT         ; Move tab left.
    , CHROME_COMBO_MOVE_TAB_START        ; Move tab first.
    , CHROME_COMBO_MOVE_TAB_END          ; Move tab last.
    , DEFAULT_IMPLEMENTATION             ; New tab.
    , DEFAULT_IMPLEMENTATION             ; Close tab.
    , DEFAULT_IMPLEMENTATION)            ; Undo close tab.

  ImplementHistoryInterface("chrome.exe"
    , CHROME_COMBO_BACK_HISTORY          ; History back
    , CHROME_COMBO_FORWARD_HISTORY)      ; History forward

  ImplementPanesInterface("chrome.exe"
    , func("ActivateAppNextWindow")       ; Recent pane
    , NO_BOUND_ACTION_MSGBOX              ; Go pane by number
    , func("ActivateAppNextWindow")       ; Go left pane
    , func("ActivateAppNextWindow")       ; Go right pane
    , NO_BOUND_ACTION_MSGBOX              ; Go down pane
    , NO_BOUND_ACTION_MSGBOX              ; Go up pane
    , CHROME_COMBO_TAB_TO_PREV_WINDOW     ; Move left pane   
    , CHROME_COMBO_TAB_TO_NEW_WINDOW      ; Move right pane
    , NOT_IMPLEMENTED                     ; Move down pane   
    , NOT_IMPLEMENTED                     ; Move up pane
    , NO_BOUND_ACTION_MSGBOX              ; Resize left pane 
    , NO_BOUND_ACTION_MSGBOX              ; Resize right pane
    , NO_BOUND_ACTION_MSGBOX              ; Resize down pane 
    , NO_BOUND_ACTION_MSGBOX              ; Resize up pane   
    , NO_BOUND_ACTION_MSGBOX              ; Swap left pane   
    , NO_BOUND_ACTION_MSGBOX              ; Swap right pane
    , NO_BOUND_ACTION_MSGBOX              ; Swap down pane 
    , NO_BOUND_ACTION_MSGBOX              ; Swap up pane   
    , NO_BOUND_ACTION_MSGBOX              ; Max/Restore pane
    , CHROME_COMBO_TAB_TO_NEW_WINDOW      ; Horizontal pane split.
    , CHROME_COMBO_TAB_TO_NEW_WINDOW      ; Vertical pane split.
    , CHROME_COMBO_CLOSE_PANE)            ; Close pane.

  ImplementSeekAndSelInterface("chrome.exe"
    , CHROME_COMBO_GO_TO_TAB              ; Ctrl + Space
    , NO_BOUND_ACTION_MSGBOX              ; Ctrl + Shift + Space
    , CHROME_COMBO_GO_TO_BOOKMARK         ; Alt + Space
    , CHROME_COMBO_FOCUS_BOOKMARK         ; Alt + Shift + Space
    , CHROME_COMBO_HISTORY                ; Win + Space
    , NO_BOUND_ACTION_MSGBOX)             ; Win + Shift + Space

  ImplementSettingsInterface("chrome.exe"
    , CHROME_COMBO_SETTINGS)               ; Open settings.
return

; Add some new shortcuts to Chrome.
#IfWinActive ahk_exe chrome.exe
  ; Set focus on web page.
  F8:: ClickWndCenter()
#if
