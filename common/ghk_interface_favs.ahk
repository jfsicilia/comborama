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
  <+<!space:: RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "_")
  >+<!space:: RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "-")
  <+<!a::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "a")
  >+<!a::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "A")
  <+<!b::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "b")
  >+<!b::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "B")
  <+<!c::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "c")
  >+<!c::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "C")
  <+<!d::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "d")
  >+<!d::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "D")
  <+<!e::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "e")
  >+<!e::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "E")
  <+<!f::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "f")
  >+<!f::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "F")
  <+<!g::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "g") 
  >+<!g::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "G") 
  <+<!h::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "h")
  >+<!h::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "H")
  <+<!i::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "i")
  >+<!i::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "I")
  <+<!j::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "j")
  >+<!j::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "J")
  <+<!k::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "k")
  >+<!k::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "k")
  <+<!l::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "l")
  >+<!l::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "L")
  <+<!m::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "m")
  >+<!m::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "M")
  <+<!n::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "n")
  >+<!n::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "N")
  <+<!o::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "o")
  >+<!o::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "O")
  <+<!p::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "p")
  >+<!p::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "P")
  <+<!q::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "q")
  >+<!q::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "Q")
  <+<!r::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "r")
  >+<!r::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "R")
  <+<!s::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "s")
  >+<!s::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "S")
  <+<!t::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "t")
  >+<!t::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "T")
  <+<!u::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "u")
  >+<!u::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "U")
  <+<!v::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "v")
  >+<!v::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "V")
  <+<!w::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "w")
  >+<!w::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "W")
  <+<!x::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "x")
  >+<!x::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "X")
  <+<!y::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "y")
  >+<!y::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "Y")
  <+<!z::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "z")
  >+<!z::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "Z")
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

