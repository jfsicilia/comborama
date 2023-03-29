/*
  This interface enables some key combos to access favourites.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\interface.ahk

FindAndReplaceInterfaceAutoExec:
  ; Name of interface.
  global __SEARCH_ID__ := "SEARCH_INTERFACE"

  ; Interface's actions.
  global ACTION_SEARCH := {id: "__search()__", default: NOT_IMPLEMENTED}
return

;----------------------------------------------------------------------  
;------------------------ ACTIONS' HOTKEYS ----------------------------  
;----------------------------------------------------------------------  

; Capslock + GreatLessKey 
;
; Used keys:    _ _ _ _ _ _ _ _ _ _ _ _ _ _
;               _  _ _ _ _ _ _ _ _ _ _ _ _ _ 
;                   _ _ _ _ _ _ _ _ _ _ _  
;                 <> _ _ _ _ _ _ _ _ _ _    
; 

; Hotkeys to go search
#if (IsActionImplemented(__SEARCH_ID__, ACTION_SEARCH.id) && (!altTabLaunched))
  ; Use up to avoid SC056 (RWin) from poping up Windows Start Menu.
  SC055 & SC056 up::  RunInterfaceActionIsolated(__SEARCH_ID__, ACTION_SEARCH.id)
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
ImplementFindAndReplaceInterface(appsId
  , search) {                        ; Search
  app := {}
  app[ACTION_SEARCH.id]  
    := (search != DEFAULT_IMPLEMENTATION) ? search : ACTION_SEARCH.default    
  
  ImplementInterface(__SEARCH_ID__, appsId, app)
}

