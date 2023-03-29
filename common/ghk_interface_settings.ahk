/*
  This interface enables some key combos to manage accessing app's settings. 

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\interface.ahk

SettingsInterfaceAutoExec:
  ; Name of interface.
  global __SETTINGS_ID__ := "SETTINGS_INTERFACE"

  ; Interface's actions.
  global ACTION_OPEN_SETTINGS := {id: "__openSettings()__", default: "^,"} 
return

;----------------------------------------------------------------------  
;------------------------ ACTIONS' HOTKEYS ----------------------------  
;----------------------------------------------------------------------  

; Capslock + <key>
;
; Used keys:    _ _ _ _ _ _ _ _ _ _ _ _ _ _
;               _  _ _ _ _ _ _ _ _ _ _ _ _ _ 
;                   _ _ _ _ _ _ _ _ _ _ _  
;                    _ _ _ _ _ _ _ , _ _    
;                                           

; Open settings.
#if (IsActionImplemented(__SETTINGS_ID__, ACTION_OPEN_SETTINGS.id) && (!altTabLaunched))
  SC055 & ,:: RunInterfaceActionIsolated(__SETTINGS_ID__, ACTION_OPEN_SETTINGS.id) 
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
ImplementSettingsInterface(appsId
  , openSettings) {                   ; Open settings.

  app := {}
  app[ACTION_OPEN_SETTINGS.id]
    := (openSettings != DEFAULT_IMPLEMENTATION) ? openSettings : ACTION_OPEN_SETTINGS.default

  ImplementInterface(__SETTINGS_ID__, appsId, app)
}

/*
  Default implementation for the interface. See Implement<...>Interface function.
*/
DefaultImplementationSettingsInterface(appsId) {
  ImplementSettingsInterface(appsId, DEFAULT_IMPLEMENTATION)
}

