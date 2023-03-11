/*
  This interface enables some key combos to do basic edit operations (copy,
  cut, paste, undo/redo, delete).

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\interface.ahk

EditInterfaceAutoExec:
  ; Name of interface.
  global __EDIT_ID__ := "EDIT_INTERFACE"

  ; Interface actions.
  global ACTION_COPY :=      {id: "__copy()__",     default: "^c"}
  global ACTION_CUT :=       {id: "__cut()__",      default: "^x"}
  global ACTION_PASTE 
    := {id: "__paste()__", default: bind("ShiftSwitch", "^v", "#v")}
  global ACTION_UNDO :=      {id: "__undo()__",     default: "^z"}
  global ACTION_REDO :=      {id: "__redo()__",     default: "^+z"}
  global ACTION_DELETE :=    {id: "__delete()__",   default: "{del}"}
return

;----------------------------------------------------------------------  
;------------------------ ACTIONS' HOTKEYS ----------------------------  
;----------------------------------------------------------------------  

; Copy
#if (IsActionImplemented(__EDIT_ID__, ACTION_COPY.id) && (!altTabLaunched))
  SC055 & c:: RunEditActionIsolated(ACTION_COPY.id)
#if
; Cut
#if (IsActionImplemented(__EDIT_ID__, ACTION_CUT.id) && (!altTabLaunched))
  SC055 & x:: RunEditActionIsolated(ACTION_CUT.id)
#if
; Paste  
#if (IsActionImplemented(__EDIT_ID__, ACTION_PASTE.id) && (!altTabLaunched))
  SC055 & v:: RunEditActionIsolated(ACTION_PASTE.id)
#if
; Undo/Redo
#if (IsActionImplemented(__EDIT_ID__, ACTION_UNDO.id) && (!altTabLaunched))
  SC055 & z:: ShiftSwitch(bind("RunEditActionIsolated", ACTION_UNDO.id)
                           , bind("RunEditActionIsolated", ACTION_REDO.id))
#if
; Delete
#if (IsActionImplemented(__EDIT_ID__, ACTION_DELETE.id) && (!altTabLaunched))
  <^backspace::
  SC055 & backspace:: RunEditActionIsolated(ACTION_DELETE.id)
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
ImplementEditInterface(appsId
  , copy                       ; Copy 
  , cut                        ; Cut 
  , paste                      ; Paste     
  , undo                       ; Undo 
  , redo                       ; Redo
  , delete) {                  ; Delete

  app := {}
  app[ACTION_COPY.id]           
    := (copy != DEFAULT_IMPLEMENTATION) ? copy :     ACTION_COPY.default
  app[ACTION_CUT.id]       
    := (cut != DEFAULT_IMPLEMENTATION) ? cut :       ACTION_CUT.default
  app[ACTION_PASTE.id]            
    := (paste != DEFAULT_IMPLEMENTATION) ? paste :   ACTION_PASTE.default
  app[ACTION_UNDO.id]     
    := (undo != DEFAULT_IMPLEMENTATION) ? undo :     ACTION_UNDO.default
  app[ACTION_REDO.id]       
    := (redo != DEFAULT_IMPLEMENTATION) ? redo :     ACTION_REDO.default
  app[ACTION_DELETE.id]       
    := (delete != DEFAULT_IMPLEMENTATION) ? delete : ACTION_DELETE.default
  
  ImplementInterface(__EDIT_ID__, appsId, app)
}

/*
  Default implementation for the interface. See Implement<...>Interface function.
*/
DefaultImplementationEditInterface(appsId) {
  ImplementEditInterface(appsId
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION) 
}

/*
  Run action.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunEditAction(action, params*) {
  RunInterfaceAction(__EDIT_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunEditActionFree(action, params*) {
  RunInterfaceActionFree(__EDIT_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it and setting them back after 
  running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunEditActionIsolated(action, params*) {
  RunInterfaceActionIsolated(__EDIT_ID__, action, params*)
}
 

