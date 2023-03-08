/*
  This module enables some combos to manage Joplin application.

  @jfsicilia 2022.
*/
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

  global VIM_COMBO_EXT_OPEN_IN_TYPORA := "gO"
  global VIM_COMBO_EXT_OPEN_IN_CHROME := "gX"
  global VIM_COMBO_EXT_OPEN_IN_VSCODE := "gZ"

  global JOPLIN_COMBO_SETTINGS := LCtrlCombo(",")                    

  global JOPLIN_CMD_SWITCH_RIGHT := "SwitchRight"
  global JOPLIN_CMD_SWITCH_LEFT := "SwitchLeft"
  global JOPLIN_CMD_MOVE_TAB_RIGHT := "TabsMoveRight"
  global JOPLIN_CMD_MOVE_TAB_LEFT := "TabsMoveLeft"
  global JOPLIN_CMD_TOGGLE_FAVS_VISIBILITY := "FavsToggleVisibility"
  global JOPLIN_CMD_PIN_TAB := "TabsPinNote"
  global JOPLIN_CMD_UNPIN_TAB := "TabsUnPinNote"

  global JOPLIN_NOTEBOOK_PREFIX := "@"
  global JOPLIN_CMD_PREFIX := ":"
  global JOPLIN_TAG_PREFIX := "{raw}#"

  ImplementTabsInterface("Joplin.exe"
    , bind("JoplinRunPaletteCmd", JOPLIN_CMD_SWITCH_RIGHT)   ; Next tab
    , bind("JoplinRunPaletteCmd", JOPLIN_CMD_SWITCH_LEFT)    ; Prev tab
    , Func("JoplinToggleRecent")                             ; Recently used tab
    , NOT_IMPLEMENTED                                        ; Go to tab by number.
    , bind("JoplinRunPaletteCmd", JOPLIN_CMD_MOVE_TAB_RIGHT) ; Move tab right.
    , bind("JoplinRunPaletteCmd", JOPLIN_CMD_MOVE_TAB_LEFT)  ; Move tab left.
    , NO_BOUND_ACTION_MSGBOX                                 ; Move tab first.
    , NO_BOUND_ACTION_MSGBOX                                 ; Move tab last.
    , NOT_IMPLEMENTED                                        ; New tab.
    , NOT_IMPLEMENTED                                        ; Close tab.
    , NOT_IMPLEMENTED)                                       ; Undo close tab.

  ImplementHistoryInterface("Joplin.exe"
    , JOPLIN_COMBO_GO_BACK        ; History back
    , JOPLIN_COMBO_GO_FORWARD)    ; History forward

  ImplementSeekAndSelInterface("Joplin.exe"
    , JOPLIN_COMBO_GOTO_ANYTHING                          ; Ctrl + Space
    , NO_BOUND_ACTION_MSGBOX                              ; Ctrl + Shift + Space
    , JOPLIN_COMBO_GOTO_ANYTHING . JOPLIN_NOTEBOOK_PREFIX ; Alt + Space
    , JOPLIN_COMBO_GOTO_ANYTHING . JOPLIN_CMD_PREFIX      ; Alt + Shift + Space
    , JOPLIN_COMBO_GOTO_ANYTHING . JOPLIN_TAG_PREFIX      ; Win + Space
    , NO_BOUND_ACTION_MSGBOX)                             ; Win + Shift + Space

  ImplementSettingsInterface("Joplin.exe"
    , JOPLIN_COMBO_SETTINGS)                    ; Open settings.

  ImplementFileManagerInterface("Joplin.exe"
    , NOT_IMPLEMENTED                      ; Prefiew file/folder
    , NOT_IMPLEMENTED                      ; Open file/folder
    , NO_BOUND_ACTION_MSGBOX               ; Go parent folder
    , NOT_IMPLEMENTED                      ; Rename file/folder
    , NOT_IMPLEMENTED                      ; Refresh file manager
    , NOT_IMPLEMENTED                      ; Show info of file/folder
    , NOT_IMPLEMENTED                      ; Find
    , NOT_IMPLEMENTED                      ; Duplicate file/folder
    , NOT_IMPLEMENTED                      ; Select all files/folders
    , JOPLIN_COMBO_NEW_NOTE                ; New note
    ; New notebook/subnotebook
    , bind("ShiftSwitch", JOPLIN_COMBO_NEW_NOTE
                        , JOPLIN_COMBO_NEW_NOTEBOOK
                        , JOPLIN_COMBO_NEW_SUBNOTEBOOK)                 
    , NOT_IMPLEMENTED                      ; Context menu
    , func("JoplinOpenInChrome")           ; View file/folder.
    ; Edit note.
    , bind("ShiftSwitch", Func("JoplinEditInVim")   
                        , Func("JoplinEditInVSCode")
                        , Func("JoplinEditInTypora"))
    , NOT_IMPLEMENTED                      ; Explore folder.
    , NOT_IMPLEMENTED                      ; Copy to other pane
    , NOT_IMPLEMENTED)                     ; Move to other pane
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
  >#<!>^f:: JoplinRunPaletteCmd(JOPLIN_CMD_TOGGLE_FAVS_VISIBILITY) 
  ; Toggles all panes.
  >#<!>^a::
    JoplinRunPaletteCmd(JOPLIN_CMD_TOGGLE_FAVS_VISIBILITY)
    SendInputIsolated(JOPLIN_COMBO_TOGGLE_SIDEBAR)
    SendInputIsolated(JOPLIN_COMBO_TOGGLE_NOTELIST)
  return

  ; Focus panes.
  >#<!:: return
  >#<!b:: SendInputFree(JOPLIN_COMBO_FOCUS_BODY)
  >#<!n:: SendInputFree(JOPLIN_COMBO_FOCUS_NOTELIST)
  >#<!t:: SendInputFree(JOPLIN_COMBO_FOCUS_TITLE)
  >#<!s:: SendInputFree(JOPLIN_COMBO_FOCUS_SIDEBAR)

  ; Pin/Unpin tab.
  >#<^p::  JoplinRunPaletteCmd(JOPLIN_CMD_PIN_TAB)
  >#<^u::  JoplinRunPaletteCmd(JOPLIN_CMD_UNPIN_TAB)

  ;<^0::   Actual size
  ;<^-::   Reduce size
  ;<^plus::Increase size

  F8::     ClickWndCenter()
#If

;------------------ Helper functions --------------------


/*
  Runs a command in joplin. First it launches the command palette,
  writes the command and finally, hits enter.
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
  gVim. In gVim, issue command to open current file in external app 
  (vimOpenCommand) and close gVim. Then focus back joplin to toggle note editing 
  off (in joplin it is bound to <JOPLIN_COMBO_TOGGLE_EDIT>). 
  Finally, focus chrome and activate web page. 
*/
JoplinOpenIn(vimOpenCommand) {
  FreeModifiers()
  SendInput, %JOPLIN_COMBO_TOGGLE_EDIT%
  Sleep, 500
  SendInput, %vimOpenCommand%
  Sleep, 1000
  FocusOrLaunchJoplin()
  Sleep, 300
  SendInput, %JOPLIN_COMBO_TOGGLE_EDIT%
  Sleep, 300
  SetModifiers()
}

JoplinOpenInChrome() {
  JoplinOpenIn(VIM_COMBO_EXT_OPEN_IN_CHROME) 
  FocusOrLaunchChrome()
  ClickWndCenter()
}

JoplinEditIn(vimOpenCommand) {
  FreeModifiers()
  SendInput, %JOPLIN_COMBO_TOGGLE_EDIT%
  Sleep, 500
  SendInput, %vimOpenCommand%
  Sleep, 1000
  SetModifiers()
}

JoplinEditInVim() {
  SendInputIsolated(JOPLIN_COMBO_TOGGLE_EDIT)
}

JoplinEditInVSCode() {
  JoplinEditIn(VIM_COMBO_EXT_OPEN_IN_VSCODE) 
  FocusOrLaunchVSCode()
}

JoplinEditInTypora() {
  JoplinEditIn(VIM_COMBO_EXT_OPEN_IN_TYPORA) 
  FocusOrLaunchTypora()
}

