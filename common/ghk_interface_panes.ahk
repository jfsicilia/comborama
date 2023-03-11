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

; Go to recent used pane.
#if (IsActionImplemented(__PANES_ID__, ACTION_RECENT_PANE.id) && (!altTabLaunched))
  SC055 & LAlt:: RunPanesActionFree(ACTION_RECENT_PANE.id)
  LAlt up:: NTimesPressed("LAlt up", 3,, bind("RunPanesActionFree", ACTION_RECENT_PANE.id))
  ; NOTE Ended up removing ~ before LAlt because LAlt pressed 3 times didn't
  ; execute correctly the action.
  ;~LAlt up:: NTimesPressed("LAlt up", 3,, bind("RunPanesActionFree", ACTION_RECENT_PANE.id))
#if
; Go to pane by direction.
#if (IsActionImplemented(__PANES_ID__, ACTION_GO_PANE_RIGHT.id) && (!altTabLaunched))
  >#<!l::  
  >#<!right:: RunPanesActionIsolated(ACTION_GO_PANE_RIGHT.id)
  >#<!h::  
  >#<!left::  RunPanesActionIsolated(ACTION_GO_PANE_LEFT.id)
  >#<!k::
  >#<!up::    RunPanesActionIsolated(ACTION_GO_PANE_UP.id)
  >#<!j::
  >#<!down::  RunPanesActionIsolated(ACTION_GO_PANE_DOWN.id)
#if
; Go to pane by number.
#if (IsActionImplemented(__PANES_ID__, ACTION_GO_PANE.id) && (!altTabLaunched))
  >#<!1:: RunPanesActionIsolated(ACTION_GO_PANE.id, 1) 
  >#<!2:: RunPanesActionIsolated(ACTION_GO_PANE.id, 2) 
  >#<!3:: RunPanesActionIsolated(ACTION_GO_PANE.id, 3) 
  >#<!4:: RunPanesActionIsolated(ACTION_GO_PANE.id, 4) 
  >#<!5:: RunPanesActionIsolated(ACTION_GO_PANE.id, 5) 
  >#<!6:: RunPanesActionIsolated(ACTION_GO_PANE.id, 6) 
  >#<!7:: RunPanesActionIsolated(ACTION_GO_PANE.id, 7) 
  >#<!8:: RunPanesActionIsolated(ACTION_GO_PANE.id, 8) 
  >#<!9:: RunPanesActionIsolated(ACTION_GO_PANE.id, 9) 
#if
; Resize pane.
#if (IsActionImplemented(__PANES_ID__, ACTION_RESIZE_PANE_RIGHT.id) && (!altTabLaunched))
  >#<!>!l::
  >#<!>!right:: RunPanesActionIsolated(ACTION_RESIZE_PANE_RIGHT.id)
  >#<!>!h::
  >#<!>!left::  RunPanesActionIsolated(ACTION_RESIZE_PANE_LEFT.id)
  >#<!>!k::
  >#<!>!up::    RunPanesActionIsolated(ACTION_RESIZE_PANE_UP.id)
  >#<!>!j::
  >#<!>!down::  RunPanesActionIsolated(ACTION_RESIZE_PANE_DOWN.id)
#if
; Swap pane.
#if (IsActionImplemented(__PANES_ID__, ACTION_SWAP_PANE_RIGHT.id) && (!altTabLaunched))
  >#<!>^l::
  >#<!>^right:: RunPanesActionIsolated(ACTION_SWAP_PANE_RIGHT.id)
  >#<!>^h::
  >#<!>^left::  RunPanesActionIsolated(ACTION_SWAP_PANE_LEFT.id)
  >#<!>^k::
  >#<!>^up::    RunPanesActionIsolated(ACTION_SWAP_PANE_UP.id)
  >#<!>^j::
  >#<!>^down::  RunPanesActionIsolated(ACTION_SWAP_PANE_DOWN.id)
#if
#if (IsActionImplemented(__PANES_ID__, ACTION_MOVE_PANE_RIGHT.id) && (!altTabLaunched))
  ; Move pane.
  >#<!+l:: 
  >#<!+right:: RunPanesActionIsolated(ACTION_MOVE_PANE_RIGHT.id)
  >#<!+h::
  >#<!+left::  RunPanesActionIsolated(ACTION_MOVE_PANE_LEFT.id)
  >#<!+j:: 
  >#<!+down:: RunPanesActionIsolated(ACTION_MOVE_PANE_DOWN.id)
  >#<!+k::
  >#<!+up::  RunPanesActionIsolated(ACTION_MOVE_PANE_UP.id)
#if
; Maximize/restore pane.
#if (IsActionImplemented(__PANES_ID__, ACTION_MAX_RESTORE_PANE.id) && (!altTabLaunched))
  >#<!space:: RunPanesActionIsolated(ACTION_MAX_RESTORE_PANE.id) 
#if
; Split horizontal/vertical.
#if (IsActionImplemented(__PANES_ID__, ACTION_VSPLIT_PANE.id) && (!altTabLaunched))
  >#<!\:: RunPanesActionIsolated(ACTION_VSPLIT_PANE.id)
  >#<!-:: RunPanesActionIsolated(ACTION_HSPLIT_PANE.id)   
#if
; Close pane
#if (IsActionImplemented(__PANES_ID__, ACTION_CLOSE_PANE.id) && (!altTabLaunched))
  >#<!w:: RunPanesActionIsolated(ACTION_CLOSE_PANE.id)  
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

/*
  Run action.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunPanesAction(action, params*) {
  RunInterfaceAction(__PANES_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunPanesActionFree(action, params*) {
  RunInterfaceActionFree(__PANES_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it and setting them back after 
  running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunPanesActionIsolated(action, params*) {
  RunInterfaceActionIsolated(__PANES_ID__, action, params*)
}

