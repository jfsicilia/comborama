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
  <+<!space up:: RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "_")
  >+<!space up:: RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "-")
  <+<!a up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "a")
  >+<!a up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "A")
  <+<!b up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "b")
  >+<!b up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "B")
  <+<!c up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "c")
  >+<!c up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "C")
  <+<!d up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "d")
  >+<!d up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "D")
  <+<!e up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "e")
  >+<!e up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "E")
  <+<!f up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "f")
  >+<!f up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "F")
  <+<!g up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "g") 
  >+<!g up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "G") 
  <+<!h up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "h")
  >+<!h up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "H")
  <+<!i up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "i")
  >+<!i up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "I")
  <+<!j up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "j")
  >+<!j up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "J")
  <+<!k up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "k")
  >+<!k up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "k")
  <+<!l up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "l")
  >+<!l up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "L")
  <+<!m up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "m")
  >+<!m up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "M")
  <+<!n up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "n")
  >+<!n up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "N")
  <+<!o up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "o")
  >+<!o up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "O")
  <+<!p up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "p")
  >+<!p up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "P")
  <+<!q up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "q")
  >+<!q up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "Q")
  <+<!r up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "r")
  >+<!r up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "R")
  <+<!s up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "s")
  >+<!s up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "S")
  <+<!t up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "t")
  >+<!t up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "T")
  <+<!u up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "u")
  >+<!u up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "U")
  <+<!v up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "v")
  >+<!v up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "V")
  <+<!w up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "w")
  >+<!w up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "W")
  <+<!x up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "x")
  >+<!x up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "X")
  <+<!y up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "y")
  >+<!y up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "Y")
  <+<!z up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "z")
  >+<!z up::     RunFavsActionIsolated(ACTION_GO_TO_FAV.id, "Z")
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

