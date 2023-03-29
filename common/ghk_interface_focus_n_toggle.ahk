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

  >#<!a::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "a")
  >#<!b::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "b")
  >#<!c::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "c")
  >#<!d::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "d")
  >#<!e::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "e")
  >#<!f::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "f")
  >#<!g::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "g")
  >#<!i::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "i")
  >#<!m::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "m")
  >#<!n::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "n")
  >#<!o::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "o")
  >#<!p::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "p")
  >#<!q::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "q")
  >#<!r::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "r")
  >#<!s::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "s")
  >#<!t::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "t")
  >#<!u::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "u")
  >#<!v::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "v")
  >#<!w::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "w")
  >#<!x::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "x")
  >#<!y::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "y")
  >#<!z::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_FOCUS.id, "z")
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

  >#<!+a::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "a")
  >#<!+b::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "b")
  >#<!+c::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "c")
  >#<!+d::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "d")
  >#<!+e::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "e")
  >#<!+f::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "f")
  >#<!+g::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "g")
  >#<!+i::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "i")
  >#<!+m::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "m")
  >#<!+n::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "n")
  >#<!+o::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "o")
  >#<!+p::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "p")
  >#<!+q::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "q")
  >#<!+r::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "r")
  >#<!+s::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "s")
  >#<!+t::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "t")
  >#<!+u::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "u")
  >#<!+v::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "v")
  >#<!+w::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "w")
  >#<!+x::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "x")
  >#<!+y::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "y")
  >#<!+z::     RunInterfaceActionIsolated(__FOCUS_N_TOGGLE_ID__, ACTION_TOGGLE.id, "z")
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

