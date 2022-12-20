#include %A_ScriptDir%\lib_misc.ahk
FirefoxAutoExec:
  ImplementTabsInterface("firefox.exe"
    , RCtrlCombo("{PgDn}")             ; Next tab
    , RCtrlCombo("{PgUp}")             ; Prev tab
    , RCtrlCombo("{Tab}")              ; Recently used tab
    , DEFAULT_IMPLEMENTATION           ; Go to tab by number.
    , NO_BOUND_ACTION_MSGBOX           ; Move tab right.
    , NO_BOUND_ACTION_MSGBOX           ; Move tab left.
    , NO_BOUND_ACTION_MSGBOX           ; Move tab first.
    , NO_BOUND_ACTION_MSGBOX           ; Move tab last.
    , DEFAULT_IMPLEMENTATION           ; New tab.
    , DEFAULT_IMPLEMENTATION           ; Close tab.
    , DEFAULT_IMPLEMENTATION)          ; Undo close tab.

  ImplementHistoryInterface("firefox.exe"
    , ">!{left}"                       ; History back
    , ">!{right}")                     ; History forward
return

; Add some new shortcuts to Firefox.
#IfWinActive ahk_exe firefox.exe
  ; Ctrl+Alt+Right - Move next window (see switch_windows.ahk).
  !^right::SendInput,  ^``
  ; Ctrl+Alt+Left - Move prev window (not implemented, do next window instead).
  !^left::SendInput,  ^``
  ; Open goto tab.
  <^space:: SendInputIsolated(RCtrlCombo("{Space}"))
#if

