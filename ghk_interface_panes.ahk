/*
  This interface enables some key combos to manage panes.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\interface.ahk

PanesInterfaceAutoExec:
  ; Name of interface.
  global __PANES_ID__ := "PANES_INTERFACE"

  ; Interface actions.
  global ACTION_RECENT_PANE :=       {id: "__recentPane()__", default: NOT_IMPLEMENTED}
  global ACTION_GO_PANE :=           {id: "__goPane(n)__", default: NOT_IMPLEMENTED}
  global ACTION_GO_PANE_LEFT :=      {id: "__goPaneLeft()__", default: NOT_IMPLEMENTED}
  global ACTION_GO_PANE_RIGHT :=     {id: "__goPaneRight()__", default: NOT_IMPLEMENTED}
  global ACTION_GO_PANE_DOWN :=      {id: "__goPaneDown()__", default: NOT_IMPLEMENTED}
  global ACTION_GO_PANE_UP :=        {id: "__goPaneUp()__", default: NOT_IMPLEMENTED}
  global ACTION_MOVE_PANE_LEFT :=    {id: "__movePaneLeft()__", default: NOT_IMPLEMENTED}
  global ACTION_MOVE_PANE_RIGHT :=   {id: "__movePaneRight()__", default: NOT_IMPLEMENTED}
  global ACTION_MOVE_PANE_DOWN :=    {id: "__movePaneDown()__", default: NOT_IMPLEMENTED}
  global ACTION_MOVE_PANE_UP :=      {id: "__movePaneUp()__", default: NOT_IMPLEMENTED}
  global ACTION_RESIZE_PANE_LEFT :=  {id: "__resizePaneLeft()__", default: NOT_IMPLEMENTED}
  global ACTION_RESIZE_PANE_RIGHT := {id: "__resizePaneRight()__", default: NOT_IMPLEMENTED}
  global ACTION_RESIZE_PANE_DOWN :=  {id: "__resizePaneDown()__", default: NOT_IMPLEMENTED}
  global ACTION_RESIZE_PANE_UP :=    {id: "__resizePaneUp()__", default: NOT_IMPLEMENTED}
  global ACTION_SWAP_PANE_LEFT :=    {id: "__swapPaneLeft()__", default: NOT_IMPLEMENTED}
  global ACTION_SWAP_PANE_RIGHT :=   {id: "__swapPaneRight()__", default: NOT_IMPLEMENTED}
  global ACTION_SWAP_PANE_DOWN :=    {id: "__swapPaneDown()__", default: NOT_IMPLEMENTED}
  global ACTION_SWAP_PANE_UP :=      {id: "__swapPaneUp()__", default: NOT_IMPLEMENTED}
  global ACTION_MAX_RESTORE_PANE :=  {id: "__maxRestorePane()__", default: NOT_IMPLEMENTED}
  global ACTION_HSPLIT_PANE :=       {id: "__hSplitPane()__", default: NOT_IMPLEMENTED}
  global ACTION_VSPLIT_PANE :=       {id: "__vSplitPane()__", default: NOT_IMPLEMENTED}
  global ACTION_CLOSE_PANE :=        {id: "__closePane()__", default: NOT_IMPLEMENTED}
return

;----------------------------------------------------------------------  
;------------------------ ACTIONS' HOTKEYS ----------------------------  
;----------------------------------------------------------------------  

; Capslock + <key> / 3x LAlt
;
; Used keys:    _ _ _ _ _ _ _ _ _ _ _ _ _ _
;               _  _ _ _ _ _ _ _ _ _ _ _ _ _ 
;                   _ _ _ _ _ _ _ _ _ _ _  
;                    _ _ _ _ _ _ _ _ _ _    
;              LAlt                             

; Go to recent used pane.
#if (IsActionImplemented(__PANES_ID__, ACTION_RECENT_PANE.id) && (!altTabLaunched))
  SC055 & LAlt:: RunInterfaceActionFree(__PANES_ID__, ACTION_RECENT_PANE.id)
  LAlt up:: NTimesPressed("LAlt up", 3,, bind("RunInterfaceActionFree", __PANES_ID__, ACTION_RECENT_PANE.id))
  ; NOTE Ended up removing ~ before LAlt because LAlt pressed 3 times didn't
  ; execute correctly the action.
  ;~LAlt up:: NTimesPressed("LAlt up", 3,, bind("RunInterfaceActionFree", __PANES_ID__, ACTION_RECENT_PANE.id))
#if

; RWin + LAlt + <key>
;
; Used keys:    _ 1 2 3 4 5 6 7 8 9 _ - _ _
;               _  _ w _ _ _ _ _ _ _ _ _ _ \ 
;                   _ _ _ _ _ h j k l _ _            up 
;                    _ _ _ _ _ _ _ _ _ _       left down right
;                          space

; Go to pane by direction.
#if (IsActionImplemented(__PANES_ID__, ACTION_GO_PANE_RIGHT.id) && (!altTabLaunched))
  >#<!l::  
  >#<!right:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_GO_PANE_RIGHT.id)
  >#<!h::  
  >#<!left::  RunInterfaceActionIsolated(__PANES_ID__, ACTION_GO_PANE_LEFT.id)
  >#<!k::
  >#<!up::    RunInterfaceActionIsolated(__PANES_ID__, ACTION_GO_PANE_UP.id)
  >#<!j::
  >#<!down::  RunInterfaceActionIsolated(__PANES_ID__, ACTION_GO_PANE_DOWN.id)
#if
; Go to pane by number.
#if (IsActionImplemented(__PANES_ID__, ACTION_GO_PANE.id) && (!altTabLaunched))
  >#<!1:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_GO_PANE.id, 1) 
  >#<!2:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_GO_PANE.id, 2) 
  >#<!3:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_GO_PANE.id, 3) 
  >#<!4:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_GO_PANE.id, 4) 
  >#<!5:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_GO_PANE.id, 5) 
  >#<!6:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_GO_PANE.id, 6) 
  >#<!7:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_GO_PANE.id, 7) 
  >#<!8:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_GO_PANE.id, 8) 
  >#<!9:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_GO_PANE.id, 9) 
#if
; Maximize/restore pane.
#if (IsActionImplemented(__PANES_ID__, ACTION_MAX_RESTORE_PANE.id) && (!altTabLaunched))
  >#<!space:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_MAX_RESTORE_PANE.id) 
#if
; Split horizontal/vertical.
#if (IsActionImplemented(__PANES_ID__, ACTION_VSPLIT_PANE.id) && (!altTabLaunched))
  >#<!\:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_VSPLIT_PANE.id)
  >#<!-:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_HSPLIT_PANE.id)   
#if
; Close pane
#if (IsActionImplemented(__PANES_ID__, ACTION_CLOSE_PANE.id) && (!altTabLaunched))
  >#<!w:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_CLOSE_PANE.id)  
#if

; RWin + LAlt + Shift + <key>
;
; Used keys:    _ _ _ _ _ _ _ _ _ _ _ _ _ _
;               _  _ _ _ _ _ _ _ _ _ _ _ _ _ 
;                   _ _ _ _ _ h j k l _ _            up 
;                    _ _ _ _ _ _ _ _ _ _       left down right

; Move pane.
#if (IsActionImplemented(__PANES_ID__, ACTION_MOVE_PANE_RIGHT.id) && (!altTabLaunched))
  >#<!+l:: 
  >#<!+right:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_MOVE_PANE_RIGHT.id)
  >#<!+h::
  >#<!+left::  RunInterfaceActionIsolated(__PANES_ID__, ACTION_MOVE_PANE_LEFT.id)
  >#<!+j:: 
  >#<!+down:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_MOVE_PANE_DOWN.id)
  >#<!+k::
  >#<!+up::  RunInterfaceActionIsolated(__PANES_ID__, ACTION_MOVE_PANE_UP.id)
#if

; RWin + LAlt + RAlt + <key>
;
; Used keys:    _ _ _ _ _ _ _ _ _ _ _ _ _ _
;               _  _ _ _ _ _ _ _ _ _ _ _ _ _ 
;                   _ _ _ _ _ h j k l _ _            up 
;                    _ _ _ _ _ _ _ _ _ _       left down right
;                                           

; Resize pane.
#if (IsActionImplemented(__PANES_ID__, ACTION_RESIZE_PANE_RIGHT.id) && (!altTabLaunched))
  >#<!>!l::
  >#<!>!right:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_RESIZE_PANE_RIGHT.id)
  >#<!>!h::
  >#<!>!left::  RunInterfaceActionIsolated(__PANES_ID__, ACTION_RESIZE_PANE_LEFT.id)
  >#<!>!k::
  >#<!>!up::    RunInterfaceActionIsolated(__PANES_ID__, ACTION_RESIZE_PANE_UP.id)
  >#<!>!j::
  >#<!>!down::  RunInterfaceActionIsolated(__PANES_ID__, ACTION_RESIZE_PANE_DOWN.id)
#if

; RWin + LAlt + RCtrl + <key>
;
; Used keys:    _ _ _ _ _ _ _ _ _ _ _ _ _ _
;               _  _ _ _ _ _ _ _ _ _ _ _ _ _ 
;                   _ _ _ _ _ h j k l _ _            up 
;                    _ _ _ _ _ _ _ _ _ _       left down right

; Swap pane.
#if (IsActionImplemented(__PANES_ID__, ACTION_SWAP_PANE_RIGHT.id) && (!altTabLaunched))
  >#<!>^l::
  >#<!>^right:: RunInterfaceActionIsolated(__PANES_ID__, ACTION_SWAP_PANE_RIGHT.id)
  >#<!>^h::
  >#<!>^left::  RunInterfaceActionIsolated(__PANES_ID__, ACTION_SWAP_PANE_LEFT.id)
  >#<!>^k::
  >#<!>^up::    RunInterfaceActionIsolated(__PANES_ID__, ACTION_SWAP_PANE_UP.id)
  >#<!>^j::
  >#<!>^down::  RunInterfaceActionIsolated(__PANES_ID__, ACTION_SWAP_PANE_DOWN.id)
#if


;----------------------------------------------------------------------  
;------------------------ HELPER FUNCTIONS ----------------------------  
;----------------------------------------------------------------------  

/*
  Call this function to implement the interface. 
  appsId -- (String or Array of strings) Name of app/apps that will implement
            this interface. The name of the app could be:
              1) The process name (as the one get by "WinGet, ..., ProcessName, A")
              2) The class name (as the one get by "WinGetClass, ..., A")
              3) ANY_APP_ID constant that will behave as a wildcard for any app.
  actions -- After appsId param, there will be 1 or more params that must be 
             supplied to implement the interface. Each param represents a 
             bound hotkey that when issued and action will be run. Each of 
             these params expects an action to be run. The value of these 
             params could be one of these:
              1) String -- Action will be: SendInput <string>
              2) Function -- Action will be: Function.Call() (Some actions 
                             have parameters so the function to pass must 
                             receive parameters).
              3) DEFAULT_IMPLEMENTATION -- Action will be a string/function 
                                           predefined.
              4) NOT_IMPLEMENTED -- No action will be run.
*/
ImplementPanesInterface(appsId
  , recentPane               ; Recent pane
  , goPane                   ; Go pane by number
  , goPaneLeft               ; Go left pane
  , goPaneRight              ; Go right pane
  , goPaneDown               ; Go down pane
  , goPaneUp                 ; Go up pane
  , movePaneLeft             ; Move left pane   
  , movePaneRight            ; Move right pane
  , movePaneDown             ; Move down pane   
  , movePaneUp               ; Move up pane
  , resizePaneLeft           ; Resize left pane 
  , resizePaneRight          ; Resize right pane
  , resizePaneDown           ; Resize down pane 
  , resizePaneUp             ; Resize up pane   
  , swapPaneLeft             ; Swap left pane   
  , swapPaneRight            ; Swap right pane
  , swapPaneDown             ; Swap down pane 
  , swapPaneUp               ; Swap up pane   
  , maxRestorePane           ; Max/Restore pane
  , hSplitPane               ; Horizontal pane split.
  , vSplitPane               ; Vertical pane split.
  , closePane) {             ; Close pane.

  app := {}

  app[ACTION_RECENT_PANE.id]
    := (recentPane != DEFAULT_IMPLEMENTATION) ?  recentPane : ACTION_RECENT_PANE.default
  app[ACTION_GO_PANE.id]
    := (goPane != DEFAULT_IMPLEMENTATION) ?  goPane : ACTION_GO_PANE.default
  app[ACTION_GO_PANE_LEFT.id]
    := (goPaneLeft != DEFAULT_IMPLEMENTATION) ?  goPaneLeft : ACTION_GO_PANE_LEFT.default
  app[ACTION_GO_PANE_RIGHT.id]
    := (goPaneRight != DEFAULT_IMPLEMENTATION) ?  goPaneRight : ACTION_GO_PANE_RIGHT.default
  app[ACTION_GO_PANE_DOWN.id]
    := (goPaneDown != DEFAULT_IMPLEMENTATION) ?  goPaneDown : ACTION_GO_PANE_DOWN.default
  app[ACTION_GO_PANE_UP.id]
    := (goPaneUp != DEFAULT_IMPLEMENTATION) ?  goPaneUp : ACTION_GO_PANE_UP.default
  app[ACTION_MOVE_PANE_LEFT.id]
    := (movePaneLeft != DEFAULT_IMPLEMENTATION) ?  movePaneLeft : ACTION_MOVE_PANE_LEFT.default
  app[ACTION_MOVE_PANE_RIGHT.id]
    := (movePaneRight != DEFAULT_IMPLEMENTATION) ?  movePaneRight : ACTION_MOVE_PANE_RIGHT.default
  app[ACTION_MOVE_PANE_DOWN.id]
    := (movePaneDown != DEFAULT_IMPLEMENTATION) ?  movePaneDown :     ACTION_MOVE_PANE_DOWN.default
  app[ACTION_MOVE_PANE_UP.id]
    := (movePaneUp != DEFAULT_IMPLEMENTATION) ?  movePaneUp :     ACTION_MOVE_PANE_UP.default
  app[ACTION_RESIZE_PANE_LEFT.id]
    := (resizePaneLeft != DEFAULT_IMPLEMENTATION) ?  resizePaneLeft : ACTION_RESIZE_PANE_LEFT.default
  app[ACTION_RESIZE_PANE_RIGHT.id]
    := (resizePaneRight != DEFAULT_IMPLEMENTATION) ?  resizePaneRight : ACTION_RESIZE_PANE_RIGHT.default
  app[ACTION_RESIZE_PANE_DOWN.id]
    := (resizePaneDown != DEFAULT_IMPLEMENTATION) ?  resizePaneDown : ACTION_RESIZE_PANE_DOWN.default
  app[ACTION_RESIZE_PANE_UP.id]
    := (resizePaneUp != DEFAULT_IMPLEMENTATION) ?  resizePaneUp : ACTION_RESIZE_PANE_UP.default
  app[ACTION_SWAP_PANE_LEFT.id]
    := (swapPaneLeft != DEFAULT_IMPLEMENTATION) ?  swapPaneLeft : ACTION_SWAP_PANE_LEFT.default
  app[ACTION_SWAP_PANE_RIGHT.id]
    := (swapPaneRight != DEFAULT_IMPLEMENTATION) ?  swapPaneRight : ACTION_SWAP_PANE_RIGHT.default
  app[ACTION_SWAP_PANE_DOWN.id]
    := (swapPaneDown != DEFAULT_IMPLEMENTATION) ?  swapPaneDown : ACTION_SWAP_PANE_DOWN.default
  app[ACTION_SWAP_PANE_UP.id]
    := (swapPaneUp != DEFAULT_IMPLEMENTATION) ?  swapPaneUp : ACTION_SWAP_PANE_UP.default
  app[ACTION_MAX_RESTORE_PANE.id]
    := (maxRestorePane != DEFAULT_IMPLEMENTATION) ?  maxRestorePane : ACTION_MAX_RESTORE_PANE.default
  app[ACTION_HSPLIT_PANE.id]
    := (hSplitPane != DEFAULT_IMPLEMENTATION) ?  hSplitPane : ACTION_HSPLIT_PANE.default
  app[ACTION_VSPLIT_PANE.id]
    := (vSplitPane != DEFAULT_IMPLEMENTATION) ?  vSplitPane : ACTION_VSPLIT_PANE.default
  app[ACTION_CLOSE_PANE.id]
    := (closePane != DEFAULT_IMPLEMENTATION) ?  closePane : ACTION_CLOSE_PANE.default

  ImplementInterface(__PANES_ID__, appsId, app)
}
