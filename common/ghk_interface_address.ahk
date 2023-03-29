/*
  This interface enables some key combos to get to the app's address bar.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\interface.ahk

AddressInterfaceAutoExec:
  ; Name of interface.
  global __ADDRESS_ID__ := "ADDRESS_INTERFACE"

  ; Interface's actions.
  global ACTION_FOCUS_ADDRESS_BAR := {id: "__focusAddressBar()__", default: "^l"} 
return

;----------------------------------------------------------------------  
;------------------------ ACTIONS' HOTKEYS ----------------------------  
;----------------------------------------------------------------------  

; Capslock + <key>
;
; Used keys:    _ _ _ _ _ _ _ _ _ _ _ _ _ _
;               _  _ _ _ _ _ _ _ _ _ _ _ _ _ 
;                   _ _ _ _ g _ _ _ _ _ _  
;                    _ _ _ _ _ _ _ _ _ _    
;                                           

; Go to. 
#if (IsActionImplemented(__ADDRESS_ID__, ACTION_FOCUS_ADDRESS_BAR.id) && (!altTabLaunched))
  SC055 & g:: RunAddressActionIsolated(ACTION_FOCUS_ADDRESS_BAR.id) 
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
ImplementAddressInterface(appsId
  , focusAddressBar) {                   ; Focus address bar

  app := {}
  app[ACTION_FOCUS_ADDRESS_BAR.id]  
    := (focusAddressBar != DEFAULT_IMPLEMENTATION) ? focusAddressBar : ACTION_FOCUS_ADDRESS_BAR.default    

  ImplementInterface(__ADDRESS_ID__, appsId, app)
}

/*
  Default implementation for the interface. See Implement<...>Interface function.
*/
DefaultImplementationAddressInterface(appsId) {
  ImplementAddressInterface(appsId, DEFAULT_IMPLEMENTATION)
}

/*
  Run action.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunAddressAction(action, params*) {
  RunInterfaceAction(__ADDRESS_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunAddressActionFree(action, params*) {
  RunInterfaceActionFree(__ADDRESS_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it and setting them back after 
  running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunAddressActionIsolated(action, params*) {
  RunInterfaceActionIsolated(__ADDRESS_ID__, action, params*)
}

