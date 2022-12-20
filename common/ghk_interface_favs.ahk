/*
  This interface enables some key combos to access favourites.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\interface.ahk

FavsInterfaceAutoExec:
  ; Name of interface.
  global __FAVS_ID__ := "FAVS_INTERFACE"

  ; Interface's actions.
  global ACTION_GO_TO_FAV := {id: "__goToFav(key)__", default: NOT_IMPLEMENTED}
return

;----------------------------------------------------------------------  
;------------------------ ACTIONS' HOTKEYS ----------------------------  
;----------------------------------------------------------------------  

; Hotkeys to go to favourite.
#if (IsActionImplemented(__FAVS_ID__, ACTION_GO_TO_FAV.id) && (!altTabLaunched))
  +<!space:: RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "_")
  +<!a::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "a")
  +<!b::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "b")
  +<!c::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "c")
  +<!d::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "d")
  +<!e::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "e")
  +<!f::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "f")
  +<!g::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "g") 
  +<!h::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "h")
  +<!i::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "i")
  +<!j::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "j")
  +<!k::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "k")
  +<!l::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "l")
  +<!m::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "m")
  +<!n::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "n")
  +<!o::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "o")
  +<!p::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "p")
  +<!q::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "q")
  +<!r::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "r")
  +<!s::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "s")
  +<!t::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "t")
  +<!u::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "u")
  +<!v::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "v")
  +<!w::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "w")
  +<!x::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "x")
  +<!y::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "y")
  +<!z::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "z")
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
ImplementFavsInterface(appsId
  , goToFav) {                        ; Go to fav.

  app := {}
  app[ACTION_GO_TO_FAV.id]  
    := (goToFav != DEFAULT_IMPLEMENTATION) ? goToFav : ACTION_GO_TO_FAV.default    
  
  ImplementInterface(__FAVS_ID__, appsId, app)
}

/*
  Run action.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunFavsAction(action, params*) {
  RunInterfaceAction(__FAVS_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunFavsActionFree(action, params*) {
  RunInterfaceActionFree(__FAVS_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it and setting them back after 
  running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunFavsActionIsolated(action, params*) {
  RunInterfaceActionIsolated(__FAVS_ID__, action, params*)
}

