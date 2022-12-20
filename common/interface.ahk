/*
  This module is the base script for implementing interfaces. An interface
  uses the global variables and functions in this module, in it's own script
  to specify and interface that later can be implemented by one or many apps.

  @jfsicilia 2022.
*/
InterfaceAutoExec:
  ; Global variable that holds the info of apps and actions bound.
  ; The first level ditionary will have a string as a key with the name of
  ; an interface. The value will be another dictionary.
  ; The second level dictionary will have a string as a key with the name of
  ; an app (or the ANY_APP_ID wildcard). The value will be another dictionary
  ; with the interface implementation. 
  ; This last level dictionary will hold the name of an combo as a string
  ; (for example "__nextTab()__") an the action to issue when the combo is
  ; triggered. The action could be one of these values:
  ;
  ;  1) String -- Action will be: SendInput <string>
  ;  2) Function -- Action will be: Function.Call() (Some actions 
  ;                 have parameters so the function to pass must 
  ;                 receive parameters).
  ;  3) DEFAULT_IMPLEMENTATION -- Action will be a string/function 
  ;                               predefined.
  ;  4) NOT_IMPLEMENTED -- No action will be run.
  __interfaces__ := {}

  ; An action that shows a message box with a "No bound Action" message.
  global NO_BOUND_ACTION_MSGBOX := Func("__NoBoundActionMsgBox__")
  ; Action not implemented.
  global NOT_IMPLEMENTED := "__NOT_IMPLEMENTED__"
  ; Use predefined action.
  global DEFAULT_IMPLEMENTATION := "__DEFAULT_IMPLEMENTATION__"
  ; Any application wildcard.
  global ANY_APP_ID := "*"
return

/*
  Show a message box with a "No bound action" message.
*/
__NoBoundActionMsgBox__() {
  msgbox, No bound action to this key combo!
}

/*
  When an app wants to implement an interface, call this function with
  and implementation.
  interface -- (String) Name of the interface.
  appsId -- (String/Array of Strings) Name/s of the app/s implementing the
            interface.
  appImplementation -- A dictionary that holds the name of a combo as a string
        (for example "__nextTab()__") an the action to issue when the combo is
        triggered. The action could be one of these values:
       
         1) String -- Action will be: SendInput <string>
         2) Function -- Action will be: Function.Call() (Some actions 
                        have parameters so the function to pass must 
                        receive parameters).
         3) DEFAULT_IMPLEMENTATION -- Action will be a string/function 
                                      predefined.
         4) NOT_IMPLEMENTED -- No action will be run.
*/
ImplementInterface(interface, appsId, appImplementation) {
  global __interfaces__
  ; Check if interface has been previously initialized.
  if (!IsObject(__interfaces__[interface])) 
    __interfaces__[interface] := {}
  
  ; If appsId is a single string, wrap it in an array.
  if (!IsObject(appsId))
    appsId := [appsId]
  ; Add implementation to interface/app
  for _, appId in appsId 
    __interfaces__[interface][appId] := appImplementation
}

/*
  Checks if interface is implemented by current running app. Internally
  "WinGet, ..., ProcessName, A" and "WinGetClass, ..., A" will be used
  to get the id of the running app, and then it will check if the indicated 
  interface has been implemented by the app.
  interface -- Name of the interface.
  return -- True if implements it, false otherwise.
*/
IsInterfaceImplemented(interface) {
  global __interfaces__
  WinGet, currentAppName, ProcessName, A
  ; Does current app implement interface? Process name and class are checked! 
  implementation := __interfaces__[interface][currentAppName]
  if (IsObject(implementation))
    return true
  WinGetClass, currentClassName, A
  implementation := __interfaces__[interface][currentClassName]
  if (IsObject(implementation))
    return true

  ; Is the interface implemented by default (any app wildcard)?
  implementation := __interfaces__[interface][ANY_APP_ID]
  if (IsObject(implementation))
    return true

  ; Interface is not implemented!
  return false
}

/*
  Checks if the action associated to the interface's combo is implemented by 
  current running app. Internally "WinGet, ..., ProcessName, A" and 
  "WinGetClass, ..., A" will be used to get the id of the running app, and 
  then it will check if the indicated interface and combo has been 
  implemented by the app.
  interface -- Name of the interface.
  combo -- Name of the combo. 
  return -- True if the is an implemented action, false otherwise.
*/
IsActionImplemented(interface, combo) {
  return (GetAction(interface, combo) != NOT_IMPLEMENTED)
}

/*
  Get the bound action associated to the interface's combo.
  Internally "WinGet, ..., ProcessName, A" and "WinGetClass, ..., A" will be 
  used to get the id of the running app,then it will check if the indicated 
  interface and combo has been implemented by the app.
  return -- Bound Action. If no action has been implemented, NOT_IMPLEMENTED
            will be returned.
*/
GetAction(interface, combo) {
  global __interfaces__
  WinGet, appName, ProcessName, A
  WinGetClass, className, A

  ; Check if current app doesn't not implement interface (it will check 
  ; window process name and class name). In that case try
  ; to find if the interface has been implemented by ANY_APP_ID.
  implementation := __interfaces__[interface][appName]
  if (!IsObject(implementation)) 
    implementation := __interfaces__[interface][className]
  if (!IsObject(implementation)) 
    implementation := __interfaces__[interface][ANY_APP_ID]

  ; If not implemented return accordingly.
  if (!IsObject(implementation))
    return NOT_IMPLEMENTED
  return implementation[combo]
}

/*
  Runs the bound action associated to the interface and combo indicated, if
  implemented by the current running app. 
  Internally "WinGet, ..., ProcessName, A" and "WinGetClass, ..., A" will be 
  used to get the id of the current running app.
  freeModifiers -- If true, modifiers will be release before running the action.
  setModifiers -- If true, modifiers will be set back after running the action. 
  interface -- Name of the interface to look for the combo.
  combo -- Combo that was triggered.
  params -- (Optional) If present, they will be passed to the action (if
            the action is a function).
*/
__RunInterfaceAction__(freeModifiers, setModifiers, interface, combo, params*) {

  action := GetAction(interface, combo)
  
  if (freeModifiers)
    FreeModifiers()

;  msgbox, %action%
  if (action != NOT_IMPLEMENTED)
    if (IsObject(action))
      action.Call(params*)
    else 
      sendInput(action)

  if (setModifiers)
    SetModifiers()
}

/*
  See __RunInterfaceAction__
  freeModifiers and setModifiers are false.
  interface -- Name of the interface to look for the combo.
  combo -- Combo that was triggered.
  params -- (Optional) If present, they will be passed to the action (if
            the action is a function).
*/
RunInterfaceAction(interface, combo, params*) {
  __RunInterfaceAction__(false, false, interface, combo, params*)
}

/*
  See __RunInterfaceAction__
  freeModifiers is true and setModifiers is false.
  interface -- Name of the interface to look for the combo.
  combo -- Combo that was triggered.
  params -- (Optional) If present, they will be passed to the action (if
            the action is a function).
*/
RunInterfaceActionFree(interface, combo, params*) {
  __RunInterfaceAction__(true, false, interface, combo, params*)
}

/*
  See __RunInterfaceAction__
  freeModifiers and setModifiers are true.
  interface -- Name of the interface to look for the combo.
  combo -- Combo that was triggered.
  params -- (Optional) If present, they will be passed to the action (if
            the action is a function).
*/
RunInterfaceActionIsolated(interface, combo, params*) {
  __RunInterfaceAction__(true, true, interface, combo, params*)
}
