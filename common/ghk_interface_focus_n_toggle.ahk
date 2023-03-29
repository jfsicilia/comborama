/*
  This interface enables some key combos to access favourites.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\interface.ahk

FocusAndToggleInterfaceAutoExec:
  ; Name of interface.
  global __FOCUS_N_TOGGLE_ID__ := "FOCUS_N_TOGGLE_INTERFACE"

  ; Interface's actions.
  global ACTION_FOCUS := {id: "__focus(key)__", default: NOT_IMPLEMENTED}
  global ACTION_TOGGLE := {id: "__toggle(key)__", default: NOT_IMPLEMENTED}
return

;----------------------------------------------------------------------  
;------------------------ ACTIONS' HOTKEYS ----------------------------  
;----------------------------------------------------------------------  

; RWin + LAlt + <key>
;
; Used keys:    _ _ _ _ _ _ _ _ _ _ _ _ _ _
;                  q w e r t y u i o p _ _ _ 
;                   a s d f g _ _ _ _ _ _ 
;                    z x c v b n m _ _ _
;                          

; Hotkeys to go to favourite.
#if (IsActionImplemented(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id) && (!altTabLaunched))
  ; This combos are used in panes interface, they are not available.
  ; >#<!space:: 
  ; >#<!h::     
  ; >#<!j::     
  ; >#<!k::     
  ; >#<!l::     

  >#<!a::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "a")
  >#<!b::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "b")
  >#<!c::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "c")
  >#<!d::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "d")
  >#<!e::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "e")
  >#<!f::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "f")
  >#<!g::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "g")
  >#<!i::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "i")
  >#<!m::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "m")
  >#<!n::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "n")
  >#<!o::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "o")
  >#<!p::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "p")
  >#<!q::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "q")
  >#<!r::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "r")
  >#<!s::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "s")
  >#<!t::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "t")
  >#<!u::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "u")
  >#<!v::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "v")
  >#<!w::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "w")
  >#<!x::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "x")
  >#<!y::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "y")
  >#<!z::     RunFocusNToggleActionIsolated(ACTION_FOCUS.id, "z")
#if

; RWin + LAlt + Shift + <key>
;
; Used keys:    _ _ _ _ _ _ _ _ _ _ _ _ _ _
;                  q w e r t y u i o p _ _ _ 
;                   a s d f g _ _ _ _ _ _ 
;                    z x c v b n m _ _ _

#if (IsActionImplemented(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id) && (!altTabLaunched))
  ; This combos are used in panes interface, they are not available.
  ; >#<!+space:: 
  ; >#<!+h::     
  ; >#<!+j::     
  ; >#<!+k::     
  ; >#<!+l::     

  >#<!+a::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "a")
  >#<!+b::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "b")
  >#<!+c::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "c")
  >#<!+d::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "d")
  >#<!+e::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "e")
  >#<!+f::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "f")
  >#<!+g::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "g")
  >#<!+i::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "i")
  >#<!+m::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "m")
  >#<!+n::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "n")
  >#<!+o::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "o")
  >#<!+p::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "p")
  >#<!+q::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "q")
  >#<!+r::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "r")
  >#<!+s::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "s")
  >#<!+t::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "t")
  >#<!+u::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "u")
  >#<!+v::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "v")
  >#<!+w::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "w")
  >#<!+x::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "x")
  >#<!+y::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "y")
  >#<!+z::     RunFocusNToggleActionIsolated(ACTION_TOGGLE.id, "z")
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
ImplementFocusAndToggleInterface(appsId
  , focus                        ; Focus
  , toggle) {
  app := {}
  app[ACTION_FOCUS.id]  
    := (focus != DEFAULT_IMPLEMENTATION) ? focus : ACTION_FOCUS.default    
  app[ACTION_TOGGLE.id]  
    := (toggle != DEFAULT_IMPLEMENTATION) ? toggle : ACTION_TOGGLE.default    
  
  ImplementInterface(__FOCUS_N_TOGGLE_ID__, appsId, app)
}

/*
  Run action.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunFocusNToggleAction(action, params*) {
  RunInterfaceAction(__FOCUS_N_TOGGLE_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunFocusNToggleActionFree(action, params*) {
  RunInterfaceActionFree(__FOCUS_N_TOGGLE_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it and setting them back after 
  running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunFocusNToggleActionIsolated(action, params*) {
  RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, action, params*)
}

