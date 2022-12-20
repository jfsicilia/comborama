/*
  This interface enables some key combos to manage tabs.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\interface.ahk

TabsInterfaceAutoExec:
  ; Name of interface.
  global __TABS_ID__ := "TABS_INTERFACE"

  ; Interface actions.
  global ACTION_NEXT_TAB :=       {id: "__nextTab()__", default: "^{pgdn}"}
  global ACTION_PREV_TAB :=       {id: "__prevTab()__", default: "^{pgup}"}
  global ACTION_RECENT_TAB :=     {id: "__recentTab()__", default: NOT_IMPLEMENTED}
  global ACTION_GO_TAB :=         {id: "__goTab(n)__", default: Func("GoToTab")}
  global ACTION_MOVE_TAB_RIGHT := {id: "__moveTabRight()__", default: NOT_IMPLEMENTED}
  global ACTION_MOVE_TAB_LEFT :=  {id: "__moveTabLeft()__", default: NOT_IMPLEMENTED}
  global ACTION_MOVE_TAB_FIRST := {id: "__moveTabFirst()__", default: NOT_IMPLEMENTED}  
  global ACTION_MOVE_TAB_LAST :=  {id: "__moveTabLast()__", default: NOT_IMPLEMENTED} 
  global ACTION_NEW_TAB :=        {id: "__newTab()__", default: "^t"}
  global ACTION_CLOSE_TAB :=      {id: "__closeTab()__", default: "^w"}
  global ACTION_UNDO_CLOSE_TAB := {id: "__undoCloseTab()__", default: "^+t"}
return

;----------------------------------------------------------------------  
;------------------------ ACTIONS' HOTKEYS ----------------------------  
;----------------------------------------------------------------------  

; Go to prev tab.
#if (IsActionImplemented(__TABS_ID__, ACTION_PREV_TAB.id) && (!altTabLaunched))
  >#<^h::
  >#<^left:: 
  RShift & LShift:: RunTabsActionIsolated(ACTION_PREV_TAB.id)
  ~LShift up:: NTimesPressed("LShift up", 3,, bind("RunTabsActionIsolated", ACTION_PREV_TAB.id))
  ; The next combo is shared between tabs interface (no shift pressed) and panes 
  ; interface (shift pressed).
  SC055 & m:: ShiftSwitch(bind("RunTabsActionIsolated", ACTION_PREV_TAB.id)
                        , bind("RunPanesActionIsolated", ACTION_GO_PANE_LEFT.id))
#if
; Go to next tab.
#if (IsActionImplemented(__TABS_ID__, ACTION_NEXT_TAB.id) && (!altTabLaunched))
  >#<^l::
  >#<^right:: 
  LShift & RShift:: RunTabsActionIsolated(ACTION_NEXT_TAB.id)
  ~RShift up:: NTimesPressed("RShift up", 3,, bind("RunTabsActionIsolated", ACTION_NEXT_TAB.id))
  ; The next combo is shared between tabs interface (no shift pressed) and panes 
  ; interface (shift pressed).
  SC055 & .:: ShiftSwitch(bind("RunTabsActionIsolated", ACTION_NEXT_TAB.id)
                        , bind("RunPanesActionIsolated", ACTION_GO_PANE_RIGHT.id))
#if
; Go to prev/next tab.
#if (IsActionImplemented(__TABS_ID__, ACTION_NEXT_TAB.id) && (!altTabLaunched))
  LWin & Tab:: ShiftSwitch(bind("RunTabsActionFree", ACTION_NEXT_TAB.id)
                         , bind("RunTabsActionFree", ACTION_PREV_TAB.id))
#if
; Go to recent used tab.
#if (IsActionImplemented(__TABS_ID__, ACTION_RECENT_TAB.id) && (!altTabLaunched))
  SC055 & LCtrl:: RunTabsActionIsolated(ACTION_RECENT_TAB.id)
  ~LCtrl up:: NTimesPressed("LCtrl up", 3,, bind("RunTabsActionIsolated", ACTION_RECENT_TAB.id))
#if
#if (IsActionImplemented(__TABS_ID__, ACTION_GO_TAB.id) && (!altTabLaunched))
  ; Go to tab by number.
  >#<^k::
  >#<^up:: 
  >#<^1::
  <^1::
  SC055 & 1:: RunTabsActionIsolated(ACTION_GO_TAB.id, 1)
  >#<^2::
  <^2::
  SC055 & 2:: RunTabsActionIsolated(ACTION_GO_TAB.id, 2)
  >#<^3::
  <^3::
  SC055 & 3:: RunTabsActionIsolated(ACTION_GO_TAB.id, 3)
  >#<^4::
  <^4::
  SC055 & 4:: RunTabsActionIsolated(ACTION_GO_TAB.id, 4)
  >#<^5::
  <^5::
  SC055 & 5:: RunTabsActionIsolated(ACTION_GO_TAB.id, 5)
  >#<^6::
  <^6::
  SC055 & 6:: RunTabsActionIsolated(ACTION_GO_TAB.id, 6)
  >#<^7::
  <^7::
  SC055 & 7:: RunTabsActionIsolated(ACTION_GO_TAB.id, 7)
  >#<^8::
  <^8::
  SC055 & 8:: RunTabsActionIsolated(ACTION_GO_TAB.id, 8)
  >#<^j::
  >#<^down:: 
  >#<^9::
  <^9::
  SC055 & 9:: RunTabsActionIsolated(ACTION_GO_TAB.id, 9)
  >#<^0::
  <^0::
  SC055 & 0:: RunTabsActionIsolated(ACTION_GO_TAB.id, 0)
#if
; Move tab left/right.
#if (IsActionImplemented(__TABS_ID__, ACTION_MOVE_TAB_RIGHT.id) && (!altTabLaunched))
  >#<^+l::
  >#<^+right:: RunTabsActionIsolated(ACTION_MOVE_TAB_RIGHT.id)
  >#<^+h::
  >#<^+left:: RunTabsActionIsolated(ACTION_MOVE_TAB_LEFT.id)
#if
; Move tab first/last.
#if (IsActionImplemented(__TABS_ID__, ACTION_MOVE_TAB_LAST.id) && (!altTabLaunched))
  >#<^+j::
  >#<^+down:: RunTabsActionIsolated(ACTION_MOVE_TAB_LAST.id)
  >#<^+k::
  >#<^+up:: RunTabsActionIsolated(ACTION_MOVE_TAB_FIRST.id)
#if
; New tab / Undo close tab.
#if (IsActionImplemented(__TABS_ID__, ACTION_NEW_TAB.id) && (!altTabLaunched))
  >#<^t::
  <^t::
  SC055 & t:: ShiftSwitch(bind("RunTabsActionIsolated", ACTION_NEW_TAB.id)
                           , bind("RunTabsActionIsolated", ACTION_UNDO_CLOSE_TAB.id))
#if
; Close tab.
#if (IsActionImplemented(__TABS_ID__, ACTION_CLOSE_TAB.id) && (!altTabLaunched))
  >#<^w::
  <^w::
  SC055 & w:: RunTabsActionIsolated(ACTION_CLOSE_TAB.id)
#if

/*
  Action to get to a tab by it's number.
  n -- Tab number.
*/
GoToTab(n) {
  SendInput("^" . n)
}

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
ImplementTabsInterface(appsId
  , nextTab                       ; Next tab
  , prevTab                       ; Prev tab
  , recentTab                     ; Recently used tab
  , goTab                         ; Go to tab by number.
  , moveTabRight                  ; Move tab right.
  , moveTabLeft                   ; Move tab left.
  , moveTabFirst                  ; Move tab first.
  , moveTabLast                   ; Move tab last.
  , newTab                        ; New tab.
  , closeTab                      ; Close tab.
  , undoCloseTab) {               ; Undo close tab.

  app := {}
  app[ACTION_NEXT_TAB.id]       
    := (nextTab != DEFAULT_IMPLEMENTATION) ? nextTab :     ACTION_NEXT_TAB.default
  app[ACTION_PREV_TAB.id]      
    := (prevTab != DEFAULT_IMPLEMENTATION) ? prevTab :     ACTION_PREV_TAB.default
  app[ACTION_RECENT_TAB.id]     
    := (recentTab != DEFAULT_IMPLEMENTATION) ? recentTab : ACTION_RECENT_TAB.default
  app[ACTION_GO_TAB.id]       
    := (goTab != DEFAULT_IMPLEMENTATION) ? goTab :         ACTION_GO_TAB.default
  app[ACTION_MOVE_TAB_RIGHT.id] 
    := (moveTabRight != DEFAULT_IMPLEMENTATION) ? moveTabRight : ACTION_MOVE_TAB_RIGHT.default
  app[ACTION_MOVE_TAB_LEFT.id] 
    := (moveTabLeft != DEFAULT_IMPLEMENTATION) ? moveTabLeft :   ACTION_MOVE_TAB_LEFT.default
  app[ACTION_MOVE_TAB_FIRST.id] 
    := (moveTabFirst != DEFAULT_IMPLEMENTATION) ? moveTabFirst : ACTION_MOVE_TAB_FIRST.default
  app[ACTION_MOVE_TAB_LAST.id] 
    := (moveTabLast != DEFAULT_IMPLEMENTATION) ? moveTabLast :   ACTION_MOVE_TAB_LAST.default
  app[ACTION_NEW_TAB.id]  
    := (newTab != DEFAULT_IMPLEMENTATION) ? newTab :       ACTION_NEW_TAB.default
  app[ACTION_CLOSE_TAB.id] 
    := (closeTab != DEFAULT_IMPLEMENTATION) ? closeTab :   ACTION_CLOSE_TAB.default
  app[ACTION_UNDO_CLOSE_TAB.id]
    := (undoCloseTab != DEFAULT_IMPLEMENTATION) ? undoCloseTab : ACTION_UNDO_CLOSE_TAB.default

  ImplementInterface(__TABS_ID__, appsId, app)
}

/*
  Run action.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunTabsAction(action, params*) {
  RunInterfaceAction(__TABS_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunTabsActionFree(action, params*) {
  RunInterfaceActionFree(__TABS_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it and setting them back after 
  running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunTabsActionIsolated(action, params*) {
  RunInterfaceActionIsolated(__TABS_ID__, action, params*)
}

