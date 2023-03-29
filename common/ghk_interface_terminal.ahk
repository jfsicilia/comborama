/*
  This interface enables some key combos to manage terminals. 

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\interface.ahk

TerminalInterfaceAutoExec:
  ; Name of interface.
  global __TERMINAL_ID__ := "TERMINAL_INTERFACE"

  ; Interface's actions.
  global ACTION_SCROLL_1_LINE_UP :=   {id: "__scroll1LineUp()__",   default:NOT_IMPLEMENTED}
  global ACTION_SCROLL_1_LINE_DOWN := {id: "__scroll1LineDown()__", default:NOT_IMPLEMENTED}
  global ACTION_SCROLL_1_PAGE_UP :=   {id: "__scroll1PageUp()__",   default:NOT_IMPLEMENTED}
  global ACTION_SCROLL_1_PAGE_DOWN := {id: "__scroll1PageDown()__", default:NOT_IMPLEMENTED}
  global ACTION_TERMINAL_COPY :=      {id: "__terminalCopy()__",    default:NOT_IMPLEMENTED}
  global ACTION_TERMINAL_PASTE :=     {id: "__terminalPaste()__",   default:NOT_IMPLEMENTED}
return

;----------------------------------------------------------------------  
;------------------------ ACTIONS' HOTKEYS ----------------------------  
;----------------------------------------------------------------------  

; LCtrl + <key>
;
; Used keys:    _ _ _ _ _ _ _ _ _ _ _ _ _ _
;               _  _ _ _ _ _ _ _ _ _ _ _ _ _ 
;                   _ _ _ _ _ _ _ _ _ _ _            up 
;                    _ _ c v _ _ _ _ _ _       left down right
;                                           

; Scroll terminal one line down/up.
#if (IsActionImplemented(__TERMINAL_ID__, ACTION_SCROLL_1_LINE_DOWN.id) && (!altTabLaunched))
  <^down::  RunTerminalActionIsolated(ACTION_SCROLL_1_LINE_DOWN.id)
  <^up::    RunTerminalActionIsolated(ACTION_SCROLL_1_LINE_UP.id)
#if
  
; Scroll terminal one page down/up.
#if (IsActionImplemented(__TERMINAL_ID__, ACTION_SCROLL_1_PAGE_DOWN.id) && (!altTabLaunched))
  <^right::
  <^+down:: RunTerminalActionIsolated(ACTION_SCROLL_1_PAGE_DOWN.id)
  <^left::
  <^+up::   RunTerminalActionIsolated(ACTION_SCROLL_1_PAGE_UP.id)
#if

; Copy
#if (IsActionImplemented(__TERMINAL_ID__, ACTION_TERMINAL_COPY.id) && (!altTabLaunched))
  <^c::     RunTerminalActionIsolated(ACTION_TERMINAL_COPY.id)
#if

; Paste
#if (IsActionImplemented(__TERMINAL_ID__, ACTION_TERMINAL_PASTE.id) && (!altTabLaunched))
  <^v::     RunTerminalActionIsolated(ACTION_TERMINAL_PASTE.id)
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
ImplementTerminalInterface(appsId
  , scroll1LineUp                   ; Scroll 1 line up
  , scroll1LineDown                 ; Scroll 1 line down
  , scroll1PageUp                   ; Scroll 1 page up 
  , scroll1PageDown                 ; Scroll 1 page down 
  , terminalCopy                    ; Terminal copy
  , terminalPaste) {                ; Terminal paste

  app := {}
  app[ACTION_SCROLL_1_LINE_UP.id]
    := (scroll1LineUp != DEFAULT_IMPLEMENTATION) ? scroll1LineUp : ACTION_SCROLL_1_LINE_UP.default
  app[ACTION_SCROLL_1_LINE_DOWN.id]
    := (scroll1LineDown != DEFAULT_IMPLEMENTATION) ? scroll1LineDown : ACTION_SCROLL_1_LINE_DOWN.default
  app[ACTION_SCROLL_1_PAGE_UP.id]
    := (scroll1PageUp != DEFAULT_IMPLEMENTATION) ? scroll1PageUp : ACTION_SCROLL_1_PAGE_UP.default
  app[ACTION_SCROLL_1_PAGE_DOWN.id]
    := (scroll1PageDown != DEFAULT_IMPLEMENTATION) ? scroll1PageDown : ACTION_SCROLL_1_PAGE_DOWN.default
  app[ACTION_TERMINAL_COPY.id]
    := (terminalCopy != DEFAULT_IMPLEMENTATION) ? terminalCopy : ACTION_TERMINAL_COPY.default
  app[ACTION_TERMINAL_PASTE.id]
    := (terminalPaste != DEFAULT_IMPLEMENTATION) ? terminalPaste : ACTION_TERMINAL_PASTE.default

  ImplementInterface(__TERMINAL_ID__, appsId, app)
}

/*
  Default implementation for the interface. See Implement<...>Interface function.
*/
DefaultImplementationTerminalInterface(appsId) {
  ImplementTerminalInterface(appsId
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
RunTerminalAction(action, params*) {
  RunInterfaceAction(__TERMINAL_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunTerminalActionFree(action, params*) {
  RunInterfaceActionFree(__TERMINAL_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it and setting them back after 
  running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunTerminalActionIsolated(action, params*) {
  RunInterfaceActionIsolated(__TERMINAL_ID__, action, params*)
}
 

