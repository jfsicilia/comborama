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

; AppKey + <key>
;
; Used keys:    _ _ _ _ _ _ _ _ _ _ _'_'_ _
;                  q w e r t y u i o p _ _ _ 
;                   a s d f g h j k l _ _ 
;                    z x c v b n m _ _ _
;                          


; Hotkeys to go to favourite.
#if (IsActionImplemented(__FAVS_ID__, ACTION_GO_TO_FAV.id) && (!altTabLaunched))
  SC15D & space:: FavShiftSwitch("_")
  SC15D & a::     FavShiftSwitch("a")
  SC15D & b::     FavShiftSwitch("b")
  SC15D & c::     FavShiftSwitch("c")
  SC15D & d::     FavShiftSwitch("d")
  SC15D & e::     FavShiftSwitch("e")
  SC15D & f::     FavShiftSwitch("f")
  SC15D & g::     FavShiftSwitch("g")
  SC15D & h::     FavShiftSwitch("h")
  SC15D & i::     FavShiftSwitch("i")
  SC15D & j::     FavShiftSwitch("j")
  SC15D & k::     FavShiftSwitch("k")
  SC15D & l::     FavShiftSwitch("l")
  SC15D & m::     FavShiftSwitch("m")
  SC15D & n::     FavShiftSwitch("n")
  SC15D & o::     FavShiftSwitch("o")
  SC15D & p::     FavShiftSwitch("p")
  SC15D & q::     FavShiftSwitch("q")
  SC15D & r::     FavShiftSwitch("r")
  SC15D & s::     FavShiftSwitch("s")
  SC15D & t::     FavShiftSwitch("t")
  SC15D & u::     FavShiftSwitch("u")
  SC15D & v::     FavShiftSwitch("v")
  SC15D & w::     FavShiftSwitch("w")
  SC15D & x::     FavShiftSwitch("x")
  SC15D & y::     FavShiftSwitch("y")
  SC15D & z::     FavShiftSwitch("z")
#if

;----------------------------------------------------------------------  
;------------------------ HELPER FUNCTIONS ----------------------------  
;----------------------------------------------------------------------  
/*
*/
FavShiftSwitch(key) {                       
  ShiftSwitch(bind("RunFavsActionIsolated", ACTION_GO_TO_FAV.id, key)
            , bind("RunFavsActionIsolated", ACTION_GO_TO_FAV.id, "<+" . key)
            , bind("RunFavsActionIsolated", ACTION_GO_TO_FAV.id, ">+" . key))
}

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

