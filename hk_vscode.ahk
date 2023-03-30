/*
  This script enables some key combos for the VSCode application.

  @jfsicilia 2022.
*/
VSCodeAutoExec:
  global VSCODE_COMBO_RIGHT_PANE := AltCtrlCombo("{right}")
  global VSCODE_COMBO_LEFT_PANE := AltCtrlCombo("{left}")
  global VSCODE_COMBO_UP_PANE := AltCtrlCombo("{up}")
  global VSCODE_COMBO_DOWN_PANE := AltCtrlCombo("{down}")

  global VSCODE_COMBO_MOVE_LEFT_PANE := "^!+{left}"     
  global VSCODE_COMBO_MOVE_RIGHT_PANE := "^!+{right}"   
  global VSCODE_COMBO_MOVE_DOWN_PANE := "^!+{down}"     
  global VSCODE_COMBO_MOVE_UP_PANE := "^!+{up}"         

  global VSCODE_COMBO_SWAP_LEFT_PANE := "^k{left}"                         
  global VSCODE_COMBO_SWAP_RIGHT_PANE := "^k{right}"                     
  global VSCODE_COMBO_SWAP_DOWN_PANE := "^k{down}"                     
  global VSCODE_COMBO_SWAP_UP_PANE := "^k{up}"                      

  global VSCODE_COMBO_GOTO_RECENTLY_USED := ShiftAltCtrlCombo(",")
  global VSCODE_COMBO_GOTO_RECENTLY_USED_IN_GROUP := ShiftAltCtrlCombo(",")
  global VSCODE_COMBO_GOTO_PREV_TAB := ShiftCtrlCombo("{Tab}")
  global VSCODE_COMBO_GOTO_NEXT_TAB := CtrlCombo("{Tab}")
  global VSCODE_COMBO_GOTO_PANE := "^+"                                

  global VSCODE_COMBO_SPLIT_VERTICAL := LShiftLCtrlCombo("\")
  global VSCODE_COMBO_SPLIT_HORIZONTAL := LShiftLCtrlCombo("-")
  global VSCODE_COMBO_MAX_RESTORE_PANE := ShiftAltCtrlCombo("{F11}")

  global VSCODE_COMBO_CLOSE_PANE := LCtrlCombo("w")

  global VSCODE_COMBO_MOVE_TAB_RIGHT := "^+{pgdn}"                                
  global VSCODE_COMBO_MOVE_TAB_LEFT := "^+{pgup}"                                
  
  global VSCODE_COMBO_OPEN_FILE := "^p"                                
  global VSCODE_COMBO_CMD_PALETTE := "^+p"                                
  global VSCODE_COMBO_SYMBOLS := "^t"                                
  global VSCODE_COMBO_VARIABLES := "^+o"                                

  global VSCODE_COMBO_SETTINGS := "^,"                                
  global VSCODE_COMBO_SETTINGS_JSON := "^+p open user json{enter}"
  global VSCODE_COMBO_KEYBINDINGS_JSON := "^+p open keyboard json{enter}"

  ; VSCode vim mode jumping back and forward combos.
  global VSCODE_COMBO_JUMP_BACK := "^k^!o"
  global VSCODE_COMBO_JUMP_FORWARD := "^k^!i"

  ; Find.
  global VSCODE_COMBO_FIND := LCtrlCombo("f")
  global VSCODE_COMBO_VIM_FIND := "/"

  ; Focus panes' actions dictionary.
  global VSCODE_COMBO_FOCUS 
  := {"m": Func("VSCodeRunPaletteCmd").bind("View: Focus Active Editor Group")
     ,"n": Func("VSCodeRunPaletteCmd").bind("Explorer: Focus on Folder View") 
     ,"g": VSCODE_COMBO_OPEN_FILE
     ,"o": Func("VSCodeRunPaletteCmd").bind("Explorer: Focus on Outline View") 
     ,"b": Func("VSCodeRunPaletteCmd").bind("Bookmarks: Focus on Explorer View") 
     ,"t": Func("VSCodeRunPaletteCmd").bind("Terminal: Focus on Terminal") 
     ,"p": Func("VSCodeRunPaletteCmd").bind("View: Focus Problems") 
     ,"v": Func("VSCodeRunPaletteCmd").bind("Source control: Focus on Source Control View") }

  ; Toggle panes' actions dictionary.
  global VSCODE_COMBO_TOGGLE
  := {"s": LCtrlCombo("b")}

  ImplementTabsInterface("Code.exe"
    , VSCODE_COMBO_GOTO_NEXT_TAB                ; Next tab
    , VSCODE_COMBO_GOTO_PREV_TAB                ; Prev tab
    , VSCODE_COMBO_GOTO_RECENTLY_USED_IN_GROUP  ; Recently used tab
    , DEFAULT_IMPLEMENTATION                    ; Go to tab by number.
    , VSCODE_COMBO_MOVE_TAB_RIGHT               ; Move tab right.
    , VSCODE_COMBO_MOVE_TAB_LEFT                ; Move tab left.
    , NO_BOUND_ACTION_MSGBOX                    ; Move tab first.
    , NO_BOUND_ACTION_MSGBOX                    ; Move tab last.
    , VSCODE_COMBO_OPEN_FILE                    ; New tab.
    , DEFAULT_IMPLEMENTATION                    ; Close tab.
    , DEFAULT_IMPLEMENTATION)                   ; Undo close tab.

  ImplementPanesInterface("Code.exe"
    , VSCODE_COMBO_GOTO_RECENTLY_USED     ; Recently used pane
    , func("VSCodeGoPane")                ; Go pane by number
    , VSCODE_COMBO_LEFT_PANE              ; Go left pane
    , VSCODE_COMBO_RIGHT_PANE             ; Go right pane
    , VSCODE_COMBO_DOWN_PANE              ; Go down pane
    , VSCODE_COMBO_UP_PANE                ; Go up pane
    , VSCODE_COMBO_MOVE_LEFT_PANE         ; Move left pane   
    , VSCODE_COMBO_MOVE_RIGHT_PANE        ; Move right pane
    , VSCODE_COMBO_MOVE_DOWN_PANE         ; Move down pane   
    , VSCODE_COMBO_MOVE_UP_PANE           ; Move up pane
    , NO_BOUND_ACTION_MSGBOX              ; Resize left pane 
    , NO_BOUND_ACTION_MSGBOX              ; Resize right pane
    , NO_BOUND_ACTION_MSGBOX              ; Resize down pane 
    , NO_BOUND_ACTION_MSGBOX              ; Resize up pane   
    , VSCODE_COMBO_SWAP_LEFT_PANE         ; Swap left pane   
    , VSCODE_COMBO_SWAP_RIGHT_PANE        ; Swap right pane
    , VSCODE_COMBO_SWAP_DOWN_PANE         ; Swap down pane 
    , VSCODE_COMBO_SWAP_UP_PANE           ; Swap up pane   
    , VSCODE_COMBO_MAX_RESTORE_PANE       ; Max/Restore pane
    , VSCODE_COMBO_SPLIT_HORIZONTAL       ; Horizontal pane split.
    , VSCODE_COMBO_SPLIT_VERTICAL         ; Vertical pane split.
    , VSCODE_COMBO_CLOSE_PANE)            ; Close pane.

  ImplementHistoryInterface("Code.exe"
    , VSCODE_COMBO_JUMP_BACK              ; History back
    , VSCODE_COMBO_JUMP_FORWARD)          ; History forward

  ImplementSeekAndSelInterface("Code.exe"
    , VSCODE_COMBO_OPEN_FILE              ; Ctrl + Space
    , VSCODE_COMBO_CMD_PALETTE            ; Ctrl + Shift + Space
    , VSCODE_COMBO_SYMBOLS                ; Alt + Space
    , NO_BOUND_ACTION_MSGBOX              ; Alt + Shift + Space
    , VSCODE_COMBO_VARIABLES              ; Win + Space
    , NO_BOUND_ACTION_MSGBOX)             ; Win + Shift + Space

  ImplementSettingsInterface("Code.exe"
    , bind("ShiftSwitch"                  ; Open settings.
      , VSCODE_COMBO_SETTINGS
      , VSCODE_COMBO_SETTINGS_JSON
      , VSCODE_COMBO_KEYBINDINGS_JSON))       

  ; NOTE: Edit interface is implemented by default by all apps. We need to
  ; disable it adhoc to let VSCode Vim mode to work properly with Capslock
  ; combos.
  ImplementEditInterface("Code.exe"
    , NOT_IMPLEMENTED                     ; Copy   (Capslock + c -> Ctrl + c)
    , NOT_IMPLEMENTED                     ; Cut    (Capslock + x -> Ctrl + x)
    , NOT_IMPLEMENTED                     ; Paste  (Capslock + v -> Ctrl + v)   
    , NOT_IMPLEMENTED                     ; Undo   (Capslock + z -> Ctrl + z)
    , NOT_IMPLEMENTED                     ; Redo   (Capslock + Shift + z -> Ctrl + Shift + z)
    ; This one will not interfere.
    , DEFAULT_IMPLEMENTATION)             ; Delete (Capslock + Backspace -> Del)

  ; NOTE: Cannot implement FileManagerInterface. It will interfere with vscode 
  ; vim mode. Same functionality is obtained by adding commands to 
  ; keybindings.json

  ImplementFocusAndToggleInterface("Code.exe"
    , Func("RunActionFromDict").bind(VSCODE_COMBO_FOCUS)   ; Focus pane function.
    , Func("RunActionFromDict").bind(VSCODE_COMBO_TOGGLE)) ; Toggle pane function.

  ImplementFindAndReplaceInterface("Code.exe"    ; Search.
    , bind("ShiftSwitch"
            , VSCODE_COMBO_FIND
            , VSCODE_COMBO_VIM_FIND))                   
return

;----------------------------------------------------------------------------
;                    SC055 combos in Visual Studio Code.
;----------------------------------------------------------------------------

#if WinActive("ahk_exe code.exe")
  ; NOTE: See mod_capslock.ahk
  ; We grab here the SC055 + key combination to send it to VSCode as
  ; Ctrl+k Ctrl+Alt+key. This way we can simulate that SC055 and
  ; Ctrl as two keys with different keymappings (like mac ctrl and cmd
  ; keys). SC055 as Vim Mode ctrl and Left Ctrl as VSCode ctrl.
  SC055 & 1::      SendVSCodeProxyCombo("1")
  SC055 & 2::      SendVSCodeProxyCombo("2")
  SC055 & 3::      SendVSCodeProxyCombo("3")
  SC055 & 4::      SendVSCodeProxyCombo("4")
  SC055 & 5::      SendVSCodeProxyCombo("5")
  SC055 & 6::      SendVSCodeProxyCombo("6")
  SC055 & 7::      SendVSCodeProxyCombo("7")
  SC055 & 8::      SendVSCodeProxyCombo("8")
  SC055 & 9::      SendVSCodeProxyCombo("9")
  SC055 & 0::      SendVSCodeProxyCombo("0")
  SC055 & `::      SendVSCodeProxyCombo("`") 
  SC055 & -::      SendVSCodeProxyCombo("-") 
  SC055 & =::      SendVSCodeProxyCombo("=") 
  SC055 & [::      SendVSCodeProxyCombo("[")
  SC055 & ]::      SendVSCodeProxyCombo("]")
  SC055 & \::      SendVSCodeProxyCombo("\") 
  SC055 & `;::     SendVSCodeProxyCombo(";") 
  SC055 & '::      SendVSCodeProxyCombo("'") 
  SC055 & ,::      SendVSCodeProxyCombo(",") 
  SC055 & .::      SendVSCodeProxyCombo(".") 
  SC055 & /::      SendVSCodeProxyCombo("/") 
  SC055 & a::      SendVSCodeProxyCombo("a")
  SC055 & b::      SendVSCodeProxyCombo("b")
  SC055 & c::      SendVSCodeProxyCombo("c")
  SC055 & d::      SendVSCodeProxyCombo("d")
  SC055 & e::      SendVSCodeProxyCombo("e")
  SC055 & f::      SendVSCodeProxyCombo("f")
  SC055 & g::      SendVSCodeProxyCombo("g")
  SC055 & h::      SendVSCodeProxyCombo("h")
  SC055 & i::      SendVSCodeProxyCombo("i")
  SC055 & j::      SendVSCodeProxyCombo("j")
  SC055 & k::      SendVSCodeProxyCombo("k")
  SC055 & l::      SendVSCodeProxyCombo("l")
  SC055 & m::      SendVSCodeProxyCombo("m")
  SC055 & n::      SendVSCodeProxyCombo("n")
  SC055 & o::      SendVSCodeProxyCombo("o")
  SC055 & p::      SendVSCodeProxyCombo("p")
  SC055 & q::      SendVSCodeProxyCombo("q")
  SC055 & r::      SendVSCodeProxyCombo("r")
  SC055 & s::      SendVSCodeProxyCombo("s")
  SC055 & t::      SendVSCodeProxyCombo("t")
  SC055 & u::      SendVSCodeProxyCombo("u")
  SC055 & v::      SendVSCodeProxyCombo("v")
  SC055 & w::      SendVSCodeProxyCombo("w")
  SC055 & x::      SendVSCodeProxyCombo("x")
  SC055 & y::      SendVSCodeProxyCombo("y")
  SC055 & pgdn::   SendVSCodeProxyCombo("{pgdn}")
  SC055 & pgup::   SendVSCodeProxyCombo("{pgup}")
  SC055 & space::  SendVSCodeProxyCombo("{space}")
#if

/*
  It sends this key combo: Ctrl+k Ctrl+Alt+key.
  Right ctrl is used in VSCode as Vim ctrl and Left ctrl as VSCode ctrl.
*/
SendVSCodeProxyCombo(key) {
  shift := GetKeyState("Shift","P")
  if (!shift)
    send, {blind}{Ctrl down}k{Ctrl up}
  else 
    send, {blind}{Shift Up}{Ctrl down}k{Ctrl up}{Shift Down}
  send, {blind}^!%key%
}

VSCodeRunPaletteCmd(cmd) {
  sendInputFree(VSCODE_COMBO_CMD_PALETTE)
  sleep, 50
  sendInputFree(cmd . "{enter}")
}

/*
  Go pane by number
  n -- Numero of pane.
*/
VSCodeGoPane(n) {
  SendInputIsolated(VSCODE_COMBO_GOTO_PANE . n)
}

