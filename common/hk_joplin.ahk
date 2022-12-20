#include %A_ScriptDir%\lib_apps.ahk
#include %A_ScriptDir%\lib_misc.ahk

; Keycombos for joplin.
JoplinAutoExec:
  global JOPLIN_COMBO_GO_BACK := LAltLCtrlCombo("[")
  global JOPLIN_COMBO_GO_FORWARD := LAltLCtrlCombo("]")
  global JOPLIN_COMBO_GOTO_ANYTHING := LAltLCtrlCombo("p")
  global JOPLIN_COMBO_CMD_PALETTE := LAltLCtrlCombo("P")

  global JOPLIN_COMBO_TOGGLE_NOTELIST := "{F11}"
  global JOPLIN_COMBO_TOGGLE_SIDEBAR := "{F10}"

  global JOPLIN_COMBO_FOCUS_NOTELIST := LShiftLCtrlCombo("l")
  global JOPLIN_COMBO_FOCUS_SIDEBAR := LShiftLCtrlCombo("s")
  global JOPLIN_COMBO_FOCUS_TITLE := LShiftLCtrlCombo("t")
  global JOPLIN_COMBO_FOCUS_BODY := LShiftLCtrlCombo("b")

  global JOPLIN_COMBO_SELECT_ALL := "{Esc}ggVG"
  global JOPLIN_COMBO_TOGGLE_EDIT := LAltLCtrlCombo("e")
  global JOPLIN_COMBO_QUIT := LAltLCtrlCombo("q")
  global JOPLIN_COMBO_BOLD := LAltLCtrlCombo("b")
  global JOPLIN_COMBO_ITALIC := LAltLCtrlCombo("i")
  global JOPLIN_COMBO_LINK := LAltLCtrlCombo("k")

  global JOPLIN_COMBO_NEW_NOTE := LAltLCtrlCombo("n")
  global JOPLIN_COMBO_NEW_NOTEBOOK := LShiftLAltLCtrlCombo("n")
  global JOPLIN_COMBO_NEW_SUBNOTEBOOK := LShiftLAltLCtrlCombo("s")
  global JOPLIN_COMBO_NEW_TODO := LAltLCtrlCombo("d")
  global JOPLIN_COMBO_SEARCH_IN_NOTE := "/"
  global VIM_COMBO_EXT_OPEN_FILE := "gX"

  ImplementTabsInterface("Joplin.exe"
    , bind("JoplinRunPaletteCmd", "SwitchRight")      ; Next tab
    , bind("JoplinRunPaletteCmd", "SwitchLeft")       ; Prev tab
    , Func("JoplinToggleRecent")                      ; Recently used tab
    , NOT_IMPLEMENTED                                 ; Go to tab by number.
    , bind("JoplinRunPaletteCmd", "TabsMoveRight")    ; Move tab right.
    , bind("JoplinRunPaletteCmd", "TabsMoveLeft")     ; Move tab left.
    , NO_BOUND_ACTION_MSGBOX                          ; Move tab first.
    , NO_BOUND_ACTION_MSGBOX                          ; Move tab last.
    , NOT_IMPLEMENTED                                 ; New tab.
    , NOT_IMPLEMENTED                                 ; Close tab.
    , NOT_IMPLEMENTED)                                ; Undo close tab.

  ImplementHistoryInterface("Joplin.exe"
    , JOPLIN_COMBO_GO_BACK        ; History back
    , JOPLIN_COMBO_GO_FORWARD)    ; History forward

  ImplementSeekAndSelInterface("Joplin.exe"
    , JOPLIN_COMBO_GOTO_ANYTHING          ; Ctrl + Space
    , NO_BOUND_ACTION_MSGBOX              ; Ctrl + Shift + Space
    , JOPLIN_COMBO_GOTO_ANYTHING . "@"    ; Alt + Space
    , JOPLIN_COMBO_GOTO_ANYTHING . ":"    ; Alt + Shift + Space
    , JOPLIN_COMBO_GOTO_ANYTHING . "{raw}#" ; Win + Space
    , NO_BOUND_ACTION_MSGBOX)             ; Win + Shift + Space

  ImplementSettingsInterface("Joplin.exe"
    , LCtrlCombo(","))                    ; Open settings.
return

; Add some new shortcuts to Chrome.
#if WinActive("ahk_exe joplin.exe")
  ; Joplin has a vim like editor. Capslock (SC055) combos behave like Ctrl
  ; combos for Vim (using de Right Control). In this way Left Ctrl is free
  ; create combos that work with joplin without interfering with vim editing.
  <^p::    SendInputIsolated(JOPLIN_COMBO_GOTO_ANYTHING)
  <^+p::   SendInputIsolated(JOPLIN_COMBO_CMD_PALETTE)
  <^e::    SendInputIsolated(JOPLIN_COMBO_TOGGLE_EDIT)
  <^a::    SendInputIsolated(JOPLIN_COMBO_SELECT_ALL)
  <^f::    SendInputIsolated(JOPLIN_COMBO_SEARCH_IN_NOTE)
  <^q::    SendInputIsolated(JOPLIN_COMBO_QUIT)
  <^b::    SendInputIsolated(JOPLIN_COMBO_BOLD)
  <^i::    SendInputIsolated(JOPLIN_COMBO_ITALIC)
  <^k::    SendInputIsolated(JOPLIN_COMBO_LINK)
  <^n::    SendInputIsolated(JOPLIN_COMBO_NEW_NOTE)
  <^+n::   SendInputIsolated(JOPLIN_COMBO_NEW_NOTEBOOK)
  <^+s::   SendInputIsolated(JOPLIN_COMBO_NEW_SUBNOTEBOOK)
  <^d::    SendInputIsolated(JOPLIN_COMBO_NEW_TODO)
  <^[::    SendInputIsolated(JOPLIN_COMBO_GO_BACK)
  <^]::    SendInputIsolated(JOPLIN_COMBO_GO_FORWARD)
  <^o::    JoplinOpenInChrome()

  ; Toggle panes.
  <!>^s::
  >#<!>^s:: SendInputIsolated(JOPLIN_COMBO_TOGGLE_SIDEBAR)
  <!>^n::
  >#<!>^n:: SendInputIsolated(JOPLIN_COMBO_TOGGLE_NOTELIST)
  <!>^f::
  >#<!>^f:: JoplinRunPaletteCmd("favsToggleVisibility")
  ; Toggles all panes.
  >#<!>^a::
    JoplinRunPaletteCmd("favsToggleVisibility")
    SendInputIsolated(JOPLIN_COMBO_TOGGLE_SIDEBAR)
    SendInputIsolated(JOPLIN_COMBO_TOGGLE_NOTELIST)
  return

  ; Focus panes.
  >#<!b:: SendInputIsolated(JOPLIN_COMBO_FOCUS_BODY)
  >#<!n:: SendInputIsolated(JOPLIN_COMBO_FOCUS_NOTELIST)
  >#<!t:: SendInputIsolated(JOPLIN_COMBO_FOCUS_TITLE)
  >#<!s:: SendInputIsolated(JOPLIN_COMBO_FOCUS_SIDEBAR)

  ; Pin/Unpin tab.
  >#<^p::  JoplinRunPaletteCmd("tabsPinNote")
  >#<^u::  JoplinRunPaletteCmd("tabsUnpinNote")

  ;<^0::   Actual size
  ;<^-::   Reduce size
  ;<^plus::Increase size

  F8::     ClickWndCenter()
#If

;------------------ Helper functions --------------------


/*
  Runs a command in joplin. First it launches the command palette,
  writes the command and finally, hits enter.
  params:
    cmd -- Command to execute.
*/
JoplinRunPaletteCmd(cmd) {
  FreeModifiers()
  SendInput(JOPLIN_COMBO_CMD_PALETTE)
  Sleep, 200
  SendInput(cmd)
  Sleep, 300
  SendInput, {Enter} 
  SetModifiers()
}

/*
  Goes to recent note. To do this, a global flag is used to choose 
  between going back or going forward in history (not really recent note,
  but behaves almost similar).
*/
JoplinToggleRecent() {
  FreeModifiers()
  static flag := true
  if (flag)
    Send, %JOPLIN_COMBO_GO_BACK%
  else
    Send, %JOPLIN_COMBO_GO_FORWARD%
  flag := !flag
  SetModifiers()
}

/*
  Open note in chrome. To do this, open note in external editor (in my case
  gVim. In gVim, issue command to open current file in external app (in my 
  case chrome) and close gVim (in my vim configuration, it is bound to
  <VIM_COMBO_EXT_OPEN_FILE>). Then focus back joplin to toggle note editing 
  off (in joplin it is bound to <JOPLIN_COMBO_tOGGLE_EDIT>). 
  Finally, focus chrome and activate web page. 
*/
JoplinOpenInChrome() {
  FreeModifiers()
  SendInput, %JOPLIN_COMBO_TOGGLE_EDIT%
  Sleep, 500
  SendInput, %VIM_COMBO_EXT_OPEN_FILE%
  Sleep, 1000
  FocusOrLaunchJoplin()
  Sleep, 300
  SendInput, %JOPLIN_COMBO_TOGGLE_EDIT%
  Sleep, 300
  FocusOrLaunchChrome()
  ClickWndCenter()
  SetModifiers()
}

