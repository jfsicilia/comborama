/*
  This interface enables some key combos to fast access bookmarks, files,
  history, etc.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\interface.ahk

SeekAndSelInterfaceAutoExec:
  ; Name of interface.
  global __SEEK_N_SEL_ID__ := "SEEK_N_SEL_INTERFACE"

  ; Interface's actions.
  global ACTION_CTRL_SPACE :=            {id: "__CtrlSpace()__", default: NOT_IMPLEMENTED}
  global ACTION_CTRL_SHIFT_SPACE :=      {id: "__CtrlShiftSpace()__", default: NOT_IMPLEMENTED}
  global ACTION_ALT_SPACE :=             {id: "__AltSpace()__", default: NOT_IMPLEMENTED}
  global ACTION_ALT_SHIFT_SPACE :=       {id: "__AltShiftSpace()__", default: NOT_IMPLEMENTED}
  global ACTION_WIN_SPACE :=             {id: "__WinSpace()__", default: NOT_IMPLEMENTED}
  global ACTION_WIN_SHIFT_SPACE :=       {id: "__WinShiftSpace()__", default: NOT_IMPLEMENTED}
return

;----------------------------------------------------------------------  
;------------------------ ACTIONS' HOTKEYS ----------------------------  
;----------------------------------------------------------------------  

; Ctrl + Space
#if (IsActionImplemented(__SEEK_N_SEL_ID__, ACTION_CTRL_SPACE.id) && (!altTabLaunched))
  <^space::       RunSeekAndSelActionIsolated(ACTION_CTRL_SPACE.id)
#if

; Ctrl + Shift + Space
#if (IsActionImplemented(__SEEK_N_SEL_ID__, ACTION_CTRL_SHIFT_SPACE.id) && (!altTabLaunched))
  <^+space::      RunSeekAndSelActionIsolated(ACTION_CTRL_SHIFT_SPACE.id)
#if

; Alt + Space
#if (IsActionImplemented(__SEEK_N_SEL_ID__, ACTION_ALT_SPACE.id) && (!altTabLaunched))
  <!space::       RunSeekAndSelActionIsolated(ACTION_ALT_SPACE.id)
#if

; Alt + Shift + Space
#if (IsActionImplemented(__SEEK_N_SEL_ID__, ACTION_ALT_SHIFT_SPACE.id) && (!altTabLaunched))
  <!+space::      RunSeekAndSelActionIsolated(ACTION_ALT_SHIFT_SPACE.id)
#if

; Win + Space
#if (IsActionImplemented(__SEEK_N_SEL_ID__, ACTION_WIN_SPACE.id) && (!altTabLaunched))
  <#space::       RunSeekAndSelActionIsolated(ACTION_WIN_SPACE.id)
#if

; Win + Shift + Space
#if (IsActionImplemented(__SEEK_N_SEL_ID__, ACTION_WIN_SHIFT_SPACE.id) && (!altTabLaunched))
  <#+space::      RunSeekAndSelActionIsolated(ACTION_WIN_SHIFT_SPACE.id)
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
ImplementSeekAndSelInterface(appsId
  , CtrlSpace               ; Ctrl + Space
  , CtrlShiftSpace          ; Ctrl + Shift + Space
  , AltSpace                ; Alt + Space
  , AltShiftSpace           ; Alt + Shift + Space
  , WinSpace                ; Win + Space
  , WinShiftSpace) {        ; Win + Shift + Space

  app := {}
    app[ACTION_CTRL_SPACE.id]
      := (CtrlSpace != DEFAULT_IMPLEMENTATION) ? CtrlSpace : ACTION_CTRL_SPACE.default
  app[ACTION_CTRL_SHIFT_SPACE.id]
    := (CtrlShiftSpace != DEFAULT_IMPLEMENTATION) ? CtrlShiftSpace : ACTION_CTRL_SHIFT_SPACE.default
  app[ACTION_ALT_SPACE.id]
    := (AltSpace != DEFAULT_IMPLEMENTATION) ? AltSpace : ACTION_ALT_SPACE.default
  app[ACTION_ALT_SHIFT_SPACE.id]
    := (AltShiftSpace != DEFAULT_IMPLEMENTATION) ? AltShiftSpace : ACTION_ALT_SHIFT_SPACE.default
  app[ACTION_WIN_SPACE.id]
    := (WinSpace != DEFAULT_IMPLEMENTATION) ? WinSpace : ACTION_WIN_SPACE.default
  app[ACTION_WIN_SHIFT_SPACE.id]
    := (WinShiftSpace != DEFAULT_IMPLEMENTATION) ? WinShiftSpace : ACTION_WIN_SHIFT_SPACE.default

  ImplementInterface(__SEEK_N_SEL_ID__, appsId, app)
}

/*
  Run action.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunSeekAndSelAction(action, params*) {
  RunInterfaceAction(__SEEK_N_SEL_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunSeekAndSelActionFree(action, params*) {
  RunInterfaceActionFree(__SEEK_N_SEL_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it and setting them back after 
  running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunSeekAndSelActionIsolated(action, params*) {
  RunInterfaceActionIsolated(__SEEK_N_SEL_ID__, action, params*)
}

 

