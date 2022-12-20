/*
  This script enables some key combos to interact with Windows Terminal.

  @jfsicilia 2022.
*/
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

  global WT_COMBO_SCROLL_1_LINE_DOWN := CtrlCombo("{end}")
  global WT_COMBO_SCROLL_1_LINE_UP := CtrlCombo("{home}")
  global WT_COMBO_SCROLL_1_PAGE_DOWN := CtrlCombo("{pgdn}")
  global WT_COMBO_SCROLL_1_PAGE_UP := CtrlCombo("{pgup}")

  global WT_COMBO_COPY := CtrlCombo("{numpad7}")
  global WT_COMBO_PASTE := CtrlCombo("{numpad1}")

  ImplementTabsInterface("WindowsTerminal.exe"
    , WT_COMBO_NEXT_TAB                  ; Next tab
    , WT_COMBO_PREV_TAB                  ; Prev tab
    , WT_COMBO_RECENT_TAB                ; Recently used tab
    , Func("wtGoToTab")                  ; Go to tab by number.
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

  ImplementTerminalInterface("WindowsTerminal.exe"
    , WT_COMBO_SCROLL_1_LINE_UP            ; Scroll 1 line up
    , WT_COMBO_SCROLL_1_LINE_DOWN          ; Scroll 1 line down
    , WT_COMBO_SCROLL_1_PAGE_UP            ; Scroll 1 page up 
    , WT_COMBO_SCROLL_1_PAGE_DOWN          ; Scroll 1 page down 
    , WT_COMBO_COPY                        ; Terminal copy
    , WT_COMBO_PASTE)                      ; Terminal paste

  ImplementSettingsInterface("WindowsTerminal.exe"
    , bind("ShiftSwitch", "^,", "^+,", "^!,"))       ; Open settings.
return

/*
  Go to tab by number.
  n -- Number of the tab.
*/
wtGoToTab(n) {
  SendInputIsolated(LAltLCtrlCombo(n))
}

; Windows terminal keybindings.
#if WinActive("ahk_exe WindowsTerminal.exe")
#if
