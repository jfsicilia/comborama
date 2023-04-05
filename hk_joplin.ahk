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

  ; Focus panes' actions dictionary.
  global JOPLIN_COMBO_FOCUS 
  := {"n": LShiftLCtrlCombo("s")       ; Notebooks navigation, pane. 
    , "c": LShiftLCtrlCombo("l")       ; Note list navigation pane (children).
    , "m": LShiftLCtrlCombo("b")       ; Main pane (joplin's note body).
    , "i": LShiftLCtrlCombo("t")       ; Input pane (joplin's note title).
    , "g": JOPLIN_COMBO_GOTO_ANYTHING} ; Address pane (joplin's search all).

  ; Toggle panes' actions dictionary.
  global JOPLIN_COMBO_TOGGLE
  := {"n": "{F10}"                ; Toggle notebooks navigation pane.
    , "c": "{F11}"                ; Toggle note list navigation pane (children).
    ; Toggle bookmarks pane (joplin's favourites).
    , "b": bind("JoplinRunPaletteCmd", "FavsToggleVisibility")
    , "o": bind("JoplinRunPaletteCmd", "ToggleOutline")}

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
  global JOPLIN_CMD_PIN_TAB := "TabsPinNote"
  global JOPLIN_CMD_UNPIN_TAB := "TabsUnPinNote"

  global JOPLIN_NOTEBOOK_PREFIX := "@"
  global JOPLIN_CMD_PREFIX := ":"
  global JOPLIN_TAG_PREFIX := "{raw}#"

  ImplementAddressInterface("Joplin.exe"
    , JOPLIN_COMBO_GOTO_ANYTHING)         ; Focus address bar. 

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

  ImplementFindAndReplaceInterface("Joplin.exe"    ; Search.
    , bind("ShiftSwitch"
            , bind("JoplinRunPaletteCmd","showLocalSearch")
            , bind("JoplinRunPaletteCmd","focusSearch")))

  ImplementFocusAndToggleInterface("Joplin.exe"
    , Func("RunActionFromDict").bind(JOPLIN_COMBO_FOCUS)   ; Focus pane function.
    , Func("RunActionFromDict").bind(JOPLIN_COMBO_TOGGLE)) ; Toggle pane function.
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
  <^f::    JoplinRunPaletteCmd("showLocalSearch")
  <^+f::   JoplinRunPaletteCmd("focusSearch")
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

  ; Pin/Unpin tab.
  >#<^p::  JoplinRunPaletteCmd(JOPLIN_CMD_PIN_TAB)
  >#<^u::  JoplinRunPaletteCmd(JOPLIN_CMD_UNPIN_TAB)

  ; Fast scrolling.
  SC055 & space:: space
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
  Edit joplin's note externally. In my system this will open gVim to edit it.
  When gVim is launched a vim command can be issued (see param vimOpenCommand),
  this allows to open the file in other programs, through gVim preconfigured
  commands. After doing this, focus back joplin to toggle note editing 
  off (in joplin it is bound to <JOPLIN_COMBO_TOGGLE_EDIT>). 

  vimOpenCommand -- Command gor gVim to open note in another external app.
*/
JoplinEditNoteExtNUndoEdit(vimOpenCommand) {
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

/*
  Edit joplin's note externally. In my system this will open gVim to edit it.
  When gVim is launched a vim command can be issued (see param vimOpenCommand),
  this allows to open the file in other programs, through gVim preconfigured
  commands. 

  vimOpenCommand -- Command gor gVim to open note in another external app.
*/
JoplinEditNoteExt(vimOpenCommand) {
  FreeModifiers()
  SendInput, %JOPLIN_COMBO_TOGGLE_EDIT%
  Sleep, 500
  SendInput, %vimOpenCommand%
  Sleep, 1000
  SetModifiers()
}

/*
  Open current note in chrome through gvim.
*/
JoplinOpenInChrome() {
  JoplinEditNoteExtNUndoEdit(VIM_COMBO_EXT_OPEN_IN_CHROME) 
  FocusOrLaunchChrome()
  ChromeFocusBrowsingArea()

}

/*
  Open current note in gvim.
*/
JoplinEditInVim() {
  SendInputIsolated(JOPLIN_COMBO_TOGGLE_EDIT)
}

/*
  Open current note in VSCode through gvim.
*/
JoplinEditInVSCode() {
  JoplinEditNoteExt(VIM_COMBO_EXT_OPEN_IN_VSCODE) 
  FocusOrLaunchVSCode()
}

/*
  Open current note in Typora through gvim.
*/
JoplinEditInTypora() {
  JoplinEditNoteExt(VIM_COMBO_EXT_OPEN_IN_TYPORA) 
  FocusOrLaunchTypora()
}

